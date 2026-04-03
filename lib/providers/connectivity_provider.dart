import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Connectivity provider
final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

// Check if connected
final isConnectedProvider = StreamProvider<bool>((ref) {
  return ref.watch(connectivityProvider).when(
    data: (results) => Stream.value(!results.contains(ConnectivityResult.none)),
    loading: () => Stream.value(true),
    error: (_, __) => Stream.value(false),
  );
});

