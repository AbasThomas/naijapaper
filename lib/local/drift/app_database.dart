import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'app_database.g.dart';

// ─── Riverpod Provider ────────────────────────────────────────────────────

/// Global database provider
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(() => database.close());
  return database;
});

// ─── Table Definitions ────────────────────────────────────────────────────

/// Questions table — offline question bank
class Questions extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text()();
  TextColumn get topicId => text()();
  IntColumn get year => integer()();
  TextColumn get difficulty => text()(); // EASY | MEDIUM | HARD
  TextColumn get questionText => text()();
  TextColumn get optionA => text()();
  TextColumn get optionB => text()();
  TextColumn get optionC => text()();
  TextColumn get optionD => text()();
  TextColumn get correctAnswer => text()(); // A | B | C | D
  TextColumn get explanationEn => text().nullable()();
  TextColumn get explanationPidgin => text().nullable()();
  TextColumn get type => text()(); // MCQ | THEORY
  DateTimeColumn get downloadedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User progress table — topic mastery tracking
class Progress extends Table {
  TextColumn get id => text()();
  TextColumn get topicId => text()();
  RealColumn get accuracyPct => real()();
  IntColumn get attemptsCount => integer()();
  DateTimeColumn get lastAttemptedAt => dateTime()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Sync queue table — pending operations to sync with server
class SyncQueue extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get action => text()(); // ANSWER | PROGRESS | FLASHCARD_REVIEW | DRILL_COMPLETE
  TextColumn get payloadJson => text()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
}

/// Exam sessions table — offline mock exam state
class ExamSessions extends Table {
  TextColumn get id => text()();
  TextColumn get examConfigJson => text()();
  TextColumn get questionsJson => text()();
  TextColumn get answersJson => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  IntColumn get score => integer().nullable()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// AI explanation cache table — cached AI responses
class AiExplanationCache extends Table {
  TextColumn get id => text()();
  TextColumn get questionId => text()();
  TextColumn get language => text()(); // en | pidgin
  TextColumn get explanation => text()();
  DateTimeColumn get generatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Flashcard cards table — offline flashcard data
class FlashcardCards extends Table {
  TextColumn get id => text()();
  TextColumn get deckId => text()();
  TextColumn get questionId => text()();
  IntColumn get intervalDays => integer()();
  RealColumn get easeFactor => real()();
  DateTimeColumn get dueDate => dateTime()();
  IntColumn get repetitions => integer()();
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Subjects table — offline subject metadata
class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get examType => text()();
  IntColumn get questionCount => integer()();
  IntColumn get downloadSizeMb => integer()();
  TextColumn get versionHash => text()();
  BoolColumn get isDownloaded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastUpdated => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Database Class ───────────────────────────────────────────────────────

@DriftDatabase(tables: [
  Questions,
  Progress,
  SyncQueue,
  ExamSessions,
  AiExplanationCache,
  FlashcardCards,
  Subjects,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          // Handle future schema migrations here
        },
      );

  // ─── Questions DAO ────────────────────────────────────────────────────────

  /// Get all questions for a subject
  Future<List<Question>> getQuestionsBySubject(String subjectId) {
    return (select(questions)..where((q) => q.subjectId.equals(subjectId)))
        .get();
  }

  /// Get questions by topic
  Future<List<Question>> getQuestionsByTopic(String topicId) {
    return (select(questions)..where((q) => q.topicId.equals(topicId))).get();
  }

  /// Get a single question by ID
  Future<Question?> getQuestionById(String id) {
    return (select(questions)..where((q) => q.id.equals(id))).getSingleOrNull();
  }

  /// Insert or update questions (bulk)
  Future<void> upsertQuestions(List<QuestionsCompanion> questionList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(questions, questionList);
    });
  }

  /// Delete all questions for a subject (for re-download)
  Future<void> deleteQuestionsBySubject(String subjectId) {
    return (delete(questions)..where((q) => q.subjectId.equals(subjectId))).go();
  }

  // ─── Progress DAO ─────────────────────────────────────────────────────────

  /// Get progress for a topic
  Future<Progres?> getProgressByTopic(String topicId) {
    return (select(progress)..where((p) => p.topicId.equals(topicId)))
        .getSingleOrNull();
  }

  /// Get all progress records
  Future<List<Progres>> getAllProgress() {
    return select(progress).get();
  }

  /// Upsert progress
  Future<void> upsertProgress(ProgressCompanion progressData) {
    return into(progress).insertOnConflictUpdate(progressData);
  }

  /// Get unsynced progress records
  Future<List<Progres>> getUnsyncedProgress() {
    return (select(progress)..where((p) => p.synced.equals(false))).get();
  }

  /// Mark progress as synced
  Future<void> markProgressSynced(String id) {
    return (update(progress)..where((p) => p.id.equals(id)))
        .write(const ProgressCompanion(synced: Value(true)));
  }

  // ─── Sync Queue DAO ───────────────────────────────────────────────────────

  /// Add item to sync queue
  Future<int> addToSyncQueue(String action, String payloadJson) {
    return into(syncQueue).insert(
      SyncQueueCompanion.insert(
        action: action,
        payloadJson: payloadJson,
        createdAt: DateTime.now(),
      ),
    );
  }

  /// Get all unsynced items
  Future<List<SyncQueueData>> getUnsyncedQueue() {
    return (select(syncQueue)..where((q) => q.synced.equals(false))).get();
  }

  /// Mark sync queue items as synced
  Future<void> markQueueSynced(List<int> ids) async {
    await batch((batch) {
      for (final id in ids) {
        batch.update(
          syncQueue,
          SyncQueueCompanion(synced: const Value(true)),
          where: (q) => q.id.equals(id),
        );
      }
    });
  }

  /// Clear synced items older than 7 days
  Future<void> clearOldSyncedItems() {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    return (delete(syncQueue)
          ..where((q) =>
              q.synced.equals(true) & q.createdAt.isSmallerThanValue(cutoff)))
        .go();
  }

  // ─── Exam Sessions DAO ────────────────────────────────────────────────────

  /// Save exam session
  Future<void> saveExamSession(ExamSessionsCompanion session) {
    return into(examSessions).insertOnConflictUpdate(session);
  }

  /// Get exam session by ID
  Future<ExamSession?> getExamSession(String id) {
    return (select(examSessions)..where((e) => e.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get recent exam sessions
  Future<List<ExamSession>> getRecentExamSessions({int limit = 10}) {
    return (select(examSessions)
          ..orderBy([(e) => OrderingTerm.desc(e.startedAt)])
          ..limit(limit))
        .get();
  }

  // ─── AI Cache DAO ─────────────────────────────────────────────────────────

  /// Get cached AI explanation
  Future<AiExplanationCacheData?> getCachedExplanation(
    String questionId,
    String language,
  ) {
    return (select(aiExplanationCache)
          ..where((a) =>
              a.questionId.equals(questionId) & a.language.equals(language)))
        .getSingleOrNull();
  }

  /// Cache AI explanation
  Future<void> cacheExplanation(AiExplanationCacheCompanion explanation) {
    return into(aiExplanationCache).insertOnConflictUpdate(explanation);
  }

  // ─── Subjects DAO ─────────────────────────────────────────────────────────

  /// Get all subjects
  Future<List<Subject>> getAllSubjects() {
    return select(subjects).get();
  }

  /// Get downloaded subjects
  Future<List<Subject>> getDownloadedSubjects() {
    return (select(subjects)..where((s) => s.isDownloaded.equals(true))).get();
  }

  /// Upsert subject
  Future<void> upsertSubject(SubjectsCompanion subject) {
    return into(subjects).insertOnConflictUpdate(subject);
  }

  /// Mark subject as downloaded
  Future<void> markSubjectDownloaded(String id, bool downloaded) {
    return (update(subjects)..where((s) => s.id.equals(id))).write(
      SubjectsCompanion(
        isDownloaded: Value(downloaded),
        lastUpdated: Value(DateTime.now()),
      ),
    );
  }
}

// ─── Database Connection ──────────────────────────────────────────────────

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'naijapaper.db'));
    return NativeDatabase(file);
  });
}
