import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../core/errors/app_exception.dart';
import '../core/utils/logger.dart';

/// User service for Firestore user document operations
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Create user document in Firestore
  Future<void> createUserDocument(UserModel user) async {
    try {
      AppLogger.info('Creating user document for ${user.uid}');
      await _firestore.collection('users').doc(user.uid).set(user.toMap());
      AppLogger.success('User document created');
    } catch (e, st) {
      AppLogger.error('Failed to create user document: $e', st);
      throw AppException(
        message: 'Failed to create user profile',
        originalException: e,
      );
    }
  }

  /// Get user by ID
  Future<UserModel?> getUserById(String uid) async {
    try {
      AppLogger.debug('Fetching user: $uid');
      final doc = await _firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        AppLogger.warn('User not found: $uid');
        return null;
      }
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    } catch (e, st) {
      AppLogger.error('Failed to get user: $e', st);
      throw AppException(
        message: 'Failed to load user profile',
        originalException: e,
      );
    }
  }

  /// Update user online status
  Future<void> updateUserOnlineStatus(String uid, bool isOnline) async {
    try {
      AppLogger.debug('Updating online status for $uid: $isOnline');
      await _firestore.collection('users').doc(uid).update({
        'isOnline': isOnline,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    } catch (e, st) {
      AppLogger.error('Failed to update online status: $e', st);
      // Don't throw, as this is not critical
    }
  }

  /// Update user settings
  Future<void> updateUserSettings(String uid, Map<String, dynamic> settings) async {
    try {
      AppLogger.info('Updating user settings for $uid');
      await _firestore.collection('users').doc(uid).update({
        'settings': settings,
      });
      AppLogger.success('Settings updated');
    } catch (e, st) {
      AppLogger.error('Failed to update settings: $e', st);
      throw AppException(
        message: 'Failed to save settings',
        originalException: e,
      );
    }
  }

  /// Update user profile (name, status, photo)
  Future<void> updateUserProfile(
    String uid, {
    String? name,
    String? status,
    File? newPhoto,
  }) async {
    try {
      AppLogger.info('Updating profile for $uid');

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (status != null) updates['status'] = status;

      // Upload new photo if provided
      if (newPhoto != null) {
        final photoUrl = await _uploadProfilePhoto(uid, newPhoto);
        updates['photoUrl'] = photoUrl;
      }

      if (updates.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updates);
        AppLogger.success('Profile updated');
      }
    } catch (e, st) {
      AppLogger.error('Failed to update profile: $e', st);
      throw AppException(
        message: 'Failed to update profile',
        originalException: e,
      );
    }
  }

  /// Get multiple users by ID list
  Future<List<UserModel>> getUsersList(List<String> uids) async {
    try {
      if (uids.isEmpty) return [];

      AppLogger.debug('Fetching ${uids.length} users');
      
      final users = <UserModel>[];
      for (final uid in uids) {
        final user = await getUserById(uid);
        if (user != null) {
          users.add(user);
        }
      }
      
      return users;
    } catch (e, st) {
      AppLogger.error('Failed to get users list: $e', st);
      throw AppException(
        message: 'Failed to load users',
        originalException: e,
      );
    }
  }

  /// Watch user by ID for real-time updates (online status, profile changes)
  Stream<UserModel> watchUserById(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        throw AppException(message: 'User not found');
      }
      return UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
    }).handleError((e) {
      AppLogger.error('Error watching user: $e');
      throw AppException(
        message: 'Failed to watch user',
        originalException: e,
      );
    });
  }

  /// Search users by name or email
  Future<List<UserModel>> searchUsers(String query) async {
    try {
      if (query.isEmpty) return [];

      AppLogger.debug('Searching users for: $query');

      final queryLower = query.toLowerCase();
      
      // Get all users and filter locally (Firebase has limited query capabilities)
      final allUsers = await _firestore
          .collection('users')
          .limit(100)
          .get();

      final users = <UserModel>[];
      for (final doc in allUsers.docs) {
        final user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        final nameLower = user.name.toLowerCase();
        final emailLower = user.email.toLowerCase();
        
        // Search by name or email (case-insensitive)
        if (nameLower.contains(queryLower) || emailLower.contains(queryLower)) {
          users.add(user);
        }
      }

      return users;
    } catch (e, st) {
      AppLogger.error('Search failed: $e', st);
      throw AppException(
        message: 'Search failed',
        originalException: e,
      );
    }
  }

  /// Upload profile photo
  Future<String> _uploadProfilePhoto(String uid, File photoFile) async {
    try {
      AppLogger.debug('Uploading profile photo for $uid');
      final ref = _storage.ref().child('profiles/$uid/avatar.jpg');
      await ref.putFile(photoFile);
      final url = await ref.getDownloadURL();
      AppLogger.success('Profile photo uploaded');
      return url;
    } catch (e, st) {
      AppLogger.error('Failed to upload profile photo: $e', st);
      throw AppException(
        message: 'Failed to upload photo',
        originalException: e,
      );
    }
  }
}

