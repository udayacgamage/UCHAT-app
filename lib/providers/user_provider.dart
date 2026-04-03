import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

// Service provider
final userServiceProvider = Provider((ref) => UserService());

// Get user by ID
final userByIdProvider = FutureProvider.family<UserModel?, String>((ref, uid) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserById(uid);
});

// Watch user by ID for real-time updates
final watchUserProvider = StreamProvider.family<UserModel, String>((ref, uid) {
  final userService = ref.watch(userServiceProvider);
  return userService.watchUserById(uid);
});

// Get multiple users
final userListProvider = FutureProvider.family<List<UserModel>, List<String>>((ref, uids) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUsersList(uids);
});

// Search users
final searchUsersProvider = FutureProvider.family<List<UserModel>, String>((ref, query) async {
  final userService = ref.watch(userServiceProvider);
  return userService.searchUsers(query);
});

