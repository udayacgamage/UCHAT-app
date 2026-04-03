import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppLockState extends StateNotifier<bool> {
  AppLockState() : super(false);

  void lock() => state = true;
  void unlock() => state = false;
}

final appLockProvider = StateNotifierProvider<AppLockState, bool>((ref) {
  return AppLockState();
});

