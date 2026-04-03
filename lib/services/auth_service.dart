import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/logger.dart';
import 'encryption_service.dart';

/// Authentication service
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final EncryptionService _encryptionService = EncryptionService();

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign up with email and password
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    File? photoFile,
  }) async {
    try {
      AppLogger.info('Signing up with email: $email');

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;
      String? photoUrl;

      // Upload profile photo if provided
      if (photoFile != null) {
        photoUrl = await _uploadProfilePhoto(uid, photoFile);
      }

      // Get FCM token
      final fcmToken = await _messaging.getToken();

      // Create user document
      final user = UserModel(
        uid: uid,
        name: fullName,
        email: email,
        photoUrl: photoUrl,
        isOnline: true,
        lastSeen: DateTime.now(),
        fcmToken: fcmToken,
        createdAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(uid).set(user.toMap());

      AppLogger.success('User created: $uid');
      return user;
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('Auth error: ${e.code}', st);
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e, st) {
      AppLogger.error('Signup failed: $e', st);
      throw AppException(
        message: 'Failed to create account',
        originalException: e,
      );
    }
  }

  /// Login with email and password
  Future<UserModel> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Logging in with email: $email');

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // Get FCM token
      final fcmToken = await _messaging.getToken();

      // Update user online status and FCM token
      await _firestore.collection('users').doc(uid).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
        'fcmToken': fcmToken,
      });

      // Fetch and return user
      final doc = await _firestore.collection('users').doc(uid).get();
      final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);

      AppLogger.success('Logged in: $uid');
      return user;
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('Auth error: ${e.code}', st);
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e, st) {
      AppLogger.error('Login failed: $e', st);
      throw AppException(
        message: 'Failed to sign in',
        originalException: e,
      );
    }
  }

  /// Sign in with Google
  Future<UserModel> loginWithGoogle() async {
    try {
      AppLogger.info('Starting Google Sign-In');

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AppException(message: 'Google Sign-In cancelled');
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final uid = userCredential.user!.uid;

      // Get FCM token
      final fcmToken = await _messaging.getToken();

      // Check if user already exists
      final userDoc = await _firestore.collection('users').doc(uid).get();

      if (!userDoc.exists) {
        // Create new user from Google account
        final user = UserModel(
          uid: uid,
          name: userCredential.user!.displayName ?? 'User',
          email: userCredential.user!.email ?? '',
          photoUrl: userCredential.user!.photoURL,
          isOnline: true,
          lastSeen: DateTime.now(),
          fcmToken: fcmToken,
          createdAt: DateTime.now(),
        );

        await _firestore.collection('users').doc(uid).set(user.toMap());
        AppLogger.success('New Google user created: $uid');
        return user;
      } else {
        // Update existing user
        await _firestore.collection('users').doc(uid).update({
          'isOnline': true,
          'lastSeen': FieldValue.serverTimestamp(),
          'fcmToken': fcmToken,
        });

        final user = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
        AppLogger.success('Google login successful: $uid');
        return user;
      }
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('Google auth error: ${e.code}', st);
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e, st) {
      AppLogger.error('Google login failed: $e', st);
      throw AppException(
        message: 'Google Sign-In failed',
        originalException: e,
      );
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.success('Password reset email sent');
    } on FirebaseAuthException catch (e, st) {
      AppLogger.error('Password reset error: ${e.code}', st);
      throw AuthException(
        message: _getAuthErrorMessage(e.code),
        code: e.code,
        originalException: e,
      );
    } catch (e, st) {
      AppLogger.error('Password reset failed: $e', st);
      throw AppException(
        message: 'Failed to send reset email',
        originalException: e,
      );
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out');

      final uid = currentUser?.uid;
      if (uid != null) {
        // Mark user as offline
        await _firestore.collection('users').doc(uid).update({
          'isOnline': false,
          'lastSeen': FieldValue.serverTimestamp(),
        });

        // Clear encryption keys
        await _encryptionService.clearAllKeys();
      }

      // Sign out from Google if signed in
      await _googleSignIn.signOut();

      // Sign out from Firebase
      await _auth.signOut();

      AppLogger.success('Logged out successfully');
    } catch (e, st) {
      AppLogger.error('Logout failed: $e', st);
      throw AppException(
        message: 'Failed to logout',
        originalException: e,
      );
    }
  }

  /// Get current user model
  Future<UserModel?> getCurrentUser() async {
    try {
      final uid = currentUser?.uid;
      if (uid == null) return null;

      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e, st) {
      AppLogger.error('Failed to get current user: $e', st);
      return null;
    }
  }

  /// Upload profile photo to Firebase Storage
  Future<String> _uploadProfilePhoto(String uid, File photoFile) async {
    try {
      final ref = _storage.ref().child('profiles/$uid/avatar.jpg');
      final uploadTask = ref.putFile(photoFile);
      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      AppLogger.success('Profile photo uploaded');
      return url;
    } catch (e, st) {
      AppLogger.error('Profile photo upload failed: $e', st);
      throw AppException(
        message: 'Failed to upload profile photo',
        originalException: e,
      );
    }
  }

  /// Get user-friendly error message from Firebase auth code
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'invalid-email':
        return 'Invalid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'User not found. Please create an account';
      case 'wrong-password':
        return 'Wrong password. Please try again';
      case 'email-already-in-use':
        return 'Email already registered. Please login or use another email';
      case 'operation-not-allowed':
        return 'This operation is not allowed';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Please check your connection';
      default:
        return 'Authentication failed. Please try again';
    }
  }
}

