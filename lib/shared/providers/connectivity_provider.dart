import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity stream provider
final connectivityStreamProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

/// Is online provider (derived from connectivity stream)
final isOnlineProvider = Provider<bool>((ref) {
  final connectivityAsync = ref.watch(connectivityStreamProvider);
  
  return connectivityAsync.when(
    data: (results) => results.isNotEmpty && !results.contains(ConnectivityResult.none),
    loading: () => true, // Assume online while loading
    error: (_, __) => true, // Assume online on error
  );
});
