import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/biometric_service.dart';

final biometricServiceProvider = Provider((ref) => BiometricService());

class BiometricSettings extends StateNotifier<AsyncValue<bool>> {
  final FlutterSecureStorage _storage;
  final BiometricService _biometricService;
  
  BiometricSettings(this._storage, this._biometricService) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final val = await _storage.read(key: 'biometric_enabled');
      state = AsyncValue.data(val == 'true');
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleBiometric(bool enabled) async {
    try {
      if (enabled) {
        // Verify biometric is available and user can authenticate before enabling
        final available = await _biometricService.isBiometricAvailable();
        if (!available) throw Exception('Biometrics not available on device');
        
        final authenticated = await _biometricService.authenticate();
        if (!authenticated) return; // Don't enable if auth failed
      }
      
      await _storage.write(key: 'biometric_enabled', value: enabled.toString());
      state = AsyncValue.data(enabled);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final biometricSettingsProvider = StateNotifierProvider<BiometricSettings, AsyncValue<bool>>((ref) {
  const storage = FlutterSecureStorage();
  final service = ref.watch(biometricServiceProvider);
  return BiometricSettings(storage, service);
});

