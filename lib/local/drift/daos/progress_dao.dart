import 'package:drift/drift.dart';
import '../app_database.dart';

part 'progress_dao.g.dart';

@DriftAccessor(tables: [ProgressTable])
class ProgressDao extends DatabaseAccessor<AppDatabase> with _$ProgressDaoMixin {
  ProgressDao(AppDatabase db) : super(db);

  // Get progress for a topic
  Future<ProgressTableData?> getProgressByTopic(String topicId) {
    return (select(progressTable)..where((p) => p.topicId.equals(topicId)))
        .getSingleOrNull();
  }

  // Get all progress records
  Future<List<ProgressTableData>> getAllProgress() {
    return select(progressTable).get();
  }

  // Get progress for multiple topics
  Future<List<ProgressTableData>> getProgressByTopics(List<String> topicIds) {
    return (select(progressTable)..where((p) => p.topicId.isIn(topicIds))).get();
  }

  // Upsert progress
  Future<void> upsertProgress(ProgressTableCompanion progressData) {
    return into(progressTable).insert(progressData, mode: InsertMode.insertOrReplace);
  }

  // Update progress after answering questions
  Future<void> updateProgressAfterAnswer({
    required String topicId,
    required bool isCorrect,
  }) async {
    final existing = await getProgressByTopic(topicId);

    if (existing == null) {
      // Create new progress record
      await upsertProgress(
        ProgressTableCompanion.insert(
          id: topicId,
          topicId: topicId,
          accuracyPct: isCorrect ? 100.0 : 0.0,
          attemptsCount: 1,
          lastAttemptedAt: DateTime.now(),
          synced: const Value(false),
        ),
      );
    } else {
      // Update existing progress
      final totalAttempts = existing.attemptsCount + 1;
      final correctAnswers = (existing.accuracyPct / 100 * existing.attemptsCount) + (isCorrect ? 1 : 0);
      final newAccuracy = (correctAnswers / totalAttempts) * 100;

      await upsertProgress(
        ProgressTableCompanion(
          id: Value(existing.id),
          topicId: Value(existing.topicId),
          accuracyPct: Value(newAccuracy),
          attemptsCount: Value(totalAttempts),
          lastAttemptedAt: Value(DateTime.now()),
          synced: const Value(false),
        ),
      );
    }
  }

  // Get unsynced progress records
  Future<List<ProgressTableData>> getUnsyncedProgress() {
    return (select(progressTable)..where((p) => p.synced.equals(false))).get();
  }

  // Mark progress as synced
  Future<void> markProgressSynced(String id) {
    return (update(progressTable)..where((p) => p.id.equals(id)))
        .write(const ProgressTableCompanion(synced: Value(true)));
  }

  // Mark multiple progress records as synced
  Future<void> markMultipleProgressSynced(List<String> ids) async {
    await batch((batch) {
      for (final id in ids) {
        batch.update(
          progressTable,
          const ProgressTableCompanion(synced: Value(true)),
          where: (p) => p.id.equals(id),
        );
      }
    });
  }

  // Get weak topics (accuracy < 40%)
  Future<List<ProgressTableData>> getWeakTopics({int limit = 10}) {
    return (select(progressTable)
          ..where((p) => p.accuracyPct.isSmallerThanValue(40.0))
          ..orderBy([(p) => OrderingTerm.asc(p.accuracyPct)])
          ..limit(limit))
        .get();
  }

  // Get strong topics (accuracy >= 70%)
  Future<List<ProgressTableData>> getStrongTopics({int limit = 10}) {
    return (select(progressTable)
          ..where((p) => p.accuracyPct.isBiggerOrEqualValue(70.0))
          ..orderBy([(p) => OrderingTerm.desc(p.accuracyPct)])
          ..limit(limit))
        .get();
  }

  // Get overall accuracy
  Future<double> getOverallAccuracy() async {
    final allProgress = await getAllProgress();
    if (allProgress.isEmpty) return 0.0;

    final totalAccuracy = allProgress.fold<double>(
      0.0,
      (sum, p) => sum + p.accuracyPct,
    );

    return totalAccuracy / allProgress.length;
  }

  // Get total attempts
  Future<int> getTotalAttempts() async {
    final allProgress = await getAllProgress();
    return allProgress.fold<int>(
      0,
      (sum, p) => sum + p.attemptsCount,
    );
  }

  // Delete all progress (for reset)
  Future<void> deleteAllProgress() {
    return delete(progressTable).go();
  }

  // Update progress from server (during sync)
  Future<void> updateFromServer(Map<String, dynamic> serverProgress) async {
    final topicId = serverProgress['topicId'] as String;
    final accuracyPct = (serverProgress['accuracyPct'] as num).toDouble();
    final attemptsCount = serverProgress['attemptsCount'] as int;
    final lastAttemptedAt = DateTime.parse(serverProgress['lastAttemptedAt'] as String);

    await upsertProgress(
      ProgressTableCompanion(
        id: Value(topicId),
        topicId: Value(topicId),
        accuracyPct: Value(accuracyPct),
        attemptsCount: Value(attemptsCount),
        lastAttemptedAt: Value(lastAttemptedAt),
        synced: const Value(true),
      ),
    );
  }
}
