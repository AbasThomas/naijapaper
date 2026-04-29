import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Connectivity stream provider
final connectivityProvider = StreamProvider<ConnectivityResult>((ref) {
  return Connectivity().onConnectivityChanged;
});

// Is online provider
final isOnlineProvider = Provider<bool>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) => result != ConnectivityResult.none,
    loading: () => true,
    error: (_, __) => false,
  );
});

// Connectivity status provider
final connectivityStatusProvider = Provider<ConnectivityStatus>((ref) {
  final connectivity = ref.watch(connectivityProvider);
  return connectivity.when(
    data: (result) {
      switch (result) {
        case ConnectivityResult.wifi:
          return ConnectivityStatus.wifi;
        case ConnectivityResult.mobile:
          return ConnectivityStatus.mobile;
        case ConnectivityResult.ethernet:
          return ConnectivityStatus.ethernet;
        default:
          return ConnectivityStatus.offline;
      }
    },
    loading: () => ConnectivityStatus.unknown,
    error: (_, __) => ConnectivityStatus.offline,
  );
});

enum ConnectivityStatus {
  wifi,
  mobile,
  ethernet,
  offline,
  unknown,
}
