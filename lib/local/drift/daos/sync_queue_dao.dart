import 'package:drift/drift.dart';
import '../app_database.dart';

part 'sync_queue_dao.g.dart';

@DriftAccessor(tables: [SyncQueue])
class SyncQueueDao extends DatabaseAccessor<AppDatabase> with _$SyncQueueDaoMixin {
  SyncQueueDao(AppDatabase db) : super(db);

  // Add item to sync queue
  Future<int> addToSyncQueue(String action, String payloadJson) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        action: action,
        payloadJson: payloadJson,
        createdAt: DateTime.now(),
      ),
    );
  }

  // Add answer to sync queue
  Future<void> queueAnswer({
    required String questionId,
    required String selectedAnswer,
    required bool isCorrect,
    required int timeTakenSeconds,
  }) async {
    final payload = {
      'questionId': questionId,
      'selectedAnswer': selectedAnswer,
      'isCorrect': isCorrect,
      'timeTakenSeconds': timeTakenSeconds,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await addToSyncQueue('ANSWER', _encodeJson(payload));
  }

  // Add progress update to sync queue
  Future<void> queueProgressUpdate({
    required String topicId,
    required double accuracyPct,
    required int attemptsCount,
  }) async {
    final payload = {
      'topicId': topicId,
      'accuracyPct': accuracyPct,
      'attemptsCount': attemptsCount,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await addToSyncQueue('PROGRESS', _encodeJson(payload));
  }

  // Add drill completion to sync queue
  Future<void> queueDrillComplete({
    required String drillId,
    required int score,
    required List<Map<String, dynamic>> answers,
  }) async {
    final payload = {
      'drillId': drillId,
      'score': score,
      'answers': answers,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await addToSyncQueue('DRILL_COMPLETE', _encodeJson(payload));
  }

  // Add flashcard review to sync queue
  Future<void> queueFlashcardReview({
    required String cardId,
    required String rating,
  }) async {
    final payload = {
      'cardId': cardId,
      'rating': rating,
      'timestamp': DateTime.now().toIso8601String(),
    };

    await addToSyncQueue('FLASHCARD_REVIEW', _encodeJson(payload));
  }

  // Get all unsynced items
  Future<List<SyncQueueData>> getUnsyncedQueue() {
    return (select(syncQueue)
          ..where((q) => q.synced.equals(false))
          ..orderBy([(q) => OrderingTerm.asc(q.createdAt)]))
        .get();
  }

  // Get unsynced count
  Future<int> getUnsyncedCount() async {
    final count = countAll();
    final query = selectOnly(syncQueue)
      ..addColumns([count])
      ..where(syncQueue.synced.equals(false));
    
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // Mark sync queue items as synced
  Future<void> markQueueSynced(List<int> ids) async {
    await batch((batch) {
      for (final id in ids) {
        batch.update(
          syncQueue,
          const SyncQueueCompanion(synced: Value(true)),
          where: (q) => q.id.equals(id),
        );
      }
    });
  }

  // Mark all as synced
  Future<void> markAllSynced() {
    return (update(syncQueue)..where((q) => q.synced.equals(false)))
        .write(const SyncQueueCompanion(synced: Value(true)));
  }

  // Clear synced items older than 7 days
  Future<void> clearOldSyncedItems() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return (delete(syncQueue)
          ..where((q) =>
              q.synced.equals(true) & q.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }

  // Clear all synced items
  Future<void> clearAllSynced() {
    return (delete(syncQueue)..where((q) => q.synced.equals(true))).go();
  }

  // Get queue items by action type
  Future<List<SyncQueueData>> getQueueByAction(String action) {
    return (select(syncQueue)
          ..where((q) => q.action.equals(action) & q.synced.equals(false)))
        .get();
  }

  // Delete queue item
  Future<void> deleteQueueItem(int id) {
    return (delete(syncQueue)..where((q) => q.id.equals(id))).go();
  }

  // Clear all queue items (use with caution)
  Future<void> clearAllQueue() {
    return delete(syncQueue).go();
  }

  // Helper to encode JSON
  String _encodeJson(Map<String, dynamic> data) {
    // In production, use dart:convert
    return data.toString(); // Simplified for now
  }
}
