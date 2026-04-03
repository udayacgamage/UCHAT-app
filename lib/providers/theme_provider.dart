import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeNotifier extends StateNotifier<bool> {
  final FlutterSecureStorage _storage;

  ThemeNotifier(this._storage) : super(false) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final isDarkMode = await _storage.read(key: 'dark_mode_enabled');
      state = isDarkMode == 'true';
    } catch (e) {
      state = false;
    }
  }

  Future<void> toggleTheme() async {
    try {
      state = !state;
      await _storage.write(key: 'dark_mode_enabled', value: state.toString());
    } catch (e) {
      state = !state; // Revert on error
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>((ref) {
  const storage = FlutterSecureStorage();
  return ThemeNotifier(storage);
});

