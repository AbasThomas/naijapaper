import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/api_constants.dart';
import '../../local/drift/app_database.dart';

// Sync service provider
final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(
    DioClient.instance,
    ref.read(appDatabaseProvider),
  );
});

// App database provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

class SyncService {
  final DioClient _dioClient;
  final AppDatabase _database;

  SyncService(this._dioClient, this._database);

  /// Sync all unsynced data to server
  Future<SyncResult> syncAll() async {
    try {
      // Get all unsynced items
      final queue = await _database.getUnsyncedQueue();
      
      if (queue.isEmpty) {
        return SyncResult.success(syncedCount: 0);
      }

      // Prepare batch sync payload
      final records = queue.map((item) {
        return {
          'id': item.id,
          'action': item.action,
          'payload': _decodePayload(item.payloadJson),
          'createdAt': item.createdAt.toIso8601String(),
        };
      }).toList();

      // Send to server
      final response = await _dioClient.post(
        ApiConstants.syncBatch,
        data: {'records': records},
      );

      // Mark as synced
      final syncedIds = (response.data['syncedIds'] as List)
          .map((id) => id as int)
          .toList();
      
      await _database.markQueueSynced(syncedIds);

      // Update local state with server response
      if (response.data['serverProgress'] != null) {
        await _updateLocalProgress(response.data['serverProgress']);
      }

      // Update user data if provided
      if (response.data['userData'] != null) {
        await _updateUserData(response.data['userData']);
      }

      return SyncResult.success(syncedCount: syncedIds.length);
    } catch (e) {
      return SyncResult.failure(error: e.toString());
    }
  }

  /// Sync specific action type
  Future<SyncResult> syncByAction(String action) async {
    try {
      final queue = await _database.syncQueueDao.getQueueByAction(action);
      
      if (queue.isEmpty) {
        return SyncResult.success(syncedCount: 0);
      }

      final records = queue.map((item) {
        return {
          'id': item.id,
          'action': item.action,
          'payload': _decodePayload(item.payloadJson),
        };
      }).toList();

      final response = await _dioClient.post(
        ApiConstants.syncBatch,
        data: {'records': records},
      );

      final syncedIds = (response.data['syncedIds'] as List)
          .map((id) => id as int)
          .toList();
      
      await _database.markQueueSynced(syncedIds);

      return SyncResult.success(syncedCount: syncedIds.length);
    } catch (e) {
      return SyncResult.failure(error: e.toString());
    }
  }

  /// Get unsynced count
  Future<int> getUnsyncedCount() async {
    return await _database.syncQueueDao.getUnsyncedCount();
  }

  /// Clear old synced items
  Future<void> clearOldSyncedItems() async {
    await _database.clearOldSyncedItems();
  }

  /// Update local progress from server
  Future<void> _updateLocalProgress(Map<String, dynamic> serverProgress) async {
    if (serverProgress['topics'] != null) {
      final topics = serverProgress['topics'] as List;
      for (final topic in topics) {
        await _database.progressDao.updateFromServer(topic);
      }
    }

    if (serverProgress['xp'] != null) {
      // Update XP in local cache
      // This would update the user's XP in Hive or similar
    }

    if (serverProgress['streak'] != null) {
      // Update streak in local cache
    }
  }

  /// Update user data from server
  Future<void> _updateUserData(Map<String, dynamic> userData) async {
    // Update user data in local storage
    // This ensures server is authoritative
  }

  /// Decode payload JSON
  Map<String, dynamic> _decodePayload(String payloadJson) {
    try {
      return jsonDecode(payloadJson) as Map<String, dynamic>;
    } catch (e) {
      // Fallback for simplified toString format
      return {'raw': payloadJson};
    }
  }
}

// Sync result class
class SyncResult {
  final bool success;
  final int syncedCount;
  final String? error;

  SyncResult._({
    required this.success,
    required this.syncedCount,
    this.error,
  });

  factory SyncResult.success({required int syncedCount}) {
    return SyncResult._(
      success: true,
      syncedCount: syncedCount,
    );
  }

  factory SyncResult.failure({required String error}) {
    return SyncResult._(
      success: false,
      syncedCount: 0,
      error: error,
    );
  }
}

// Sync status provider
final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, SyncStatus>((ref) {
  return SyncStatusNotifier(ref.read(syncServiceProvider));
});

class SyncStatusNotifier extends StateNotifier<SyncStatus> {
  final SyncService _syncService;

  SyncStatusNotifier(this._syncService) : super(SyncStatus.idle()) {
    _checkUnsyncedCount();
  }

  Future<void> _checkUnsyncedCount() async {
    final count = await _syncService.getUnsyncedCount();
    state = SyncStatus.idle(unsyncedCount: count);
  }

  Future<void> sync() async {
    state = SyncStatus.syncing(unsyncedCount: state.unsyncedCount);
    
    final result = await _syncService.syncAll();
    
    if (result.success) {
      state = SyncStatus.success(syncedCount: result.syncedCount);
      // Reset to idle after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      await _checkUnsyncedCount();
    } else {
      state = SyncStatus.error(error: result.error ?? 'Sync failed');
      // Reset to idle after 3 seconds
      await Future.delayed(const Duration(seconds: 3));
      await _checkUnsyncedCount();
    }
  }
}

class SyncStatus {
  final SyncState state;
  final int unsyncedCount;
  final int? syncedCount;
  final String? error;

  SyncStatus._({
    required this.state,
    required this.unsyncedCount,
    this.syncedCount,
    this.error,
  });

  factory SyncStatus.idle({int unsyncedCount = 0}) {
    return SyncStatus._(
      state: SyncState.idle,
      unsyncedCount: unsyncedCount,
    );
  }

  factory SyncStatus.syncing({required int unsyncedCount}) {
    return SyncStatus._(
      state: SyncState.syncing,
      unsyncedCount: unsyncedCount,
    );
  }

  factory SyncStatus.success({required int syncedCount}) {
    return SyncStatus._(
      state: SyncState.success,
      unsyncedCount: 0,
      syncedCount: syncedCount,
    );
  }

  factory SyncStatus.error({required String error}) {
    return SyncStatus._(
      state: SyncState.error,
      unsyncedCount: 0,
      error: error,
    );
  }
}

enum SyncState {
  idle,
  syncing,
  success,
  error,
}
