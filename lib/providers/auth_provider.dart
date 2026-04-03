import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import 'user_provider.dart';

// Service provider
final authServiceProvider = Provider((ref) => AuthService());

// Auth state stream
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user stream
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      // Watch the user document from Firestore
      final userService = ref.watch(userServiceProvider);
      return userService.watchUserById(user.uid);
    },
    loading: () => Stream.value(null),
    error: (err, st) => Stream.value(null),
  );
});

// Login provider
class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

final loginProvider = FutureProvider.autoDispose.family<UserModel?, LoginParams>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.loginWithEmail(
    email: params.email,
    password: params.password,
  );
});

// Register provider
class RegisterParams {
  final String email;
  final String password;
  final String fullName;

  RegisterParams({
    required this.email,
    required this.password,
    required this.fullName,
  });
}

final registerProvider = FutureProvider.autoDispose.family<UserModel?, RegisterParams>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.signUpWithEmail(
    email: params.email,
    password: params.password,
    fullName: params.fullName,
  );
});

// Google login provider
final googleLoginProvider = FutureProvider.autoDispose<UserModel?>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.loginWithGoogle();
});

// Logout provider
final logoutProvider = FutureProvider<void>((ref) async {
  final authService = ref.watch(authServiceProvider);
  return authService.logout();
});

// Reset password provider
class ResetPasswordParams {
  final String email;

  ResetPasswordParams({required this.email});
}

final resetPasswordProvider = FutureProvider.family<void, ResetPasswordParams>((ref, params) async {
  final authService = ref.watch(authServiceProvider);
  return authService.resetPassword(params.email);
});
