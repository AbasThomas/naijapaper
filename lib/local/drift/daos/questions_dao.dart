import 'package:drift/drift.dart';
import '../app_database.dart';

part 'questions_dao.g.dart';

@DriftAccessor(tables: [Questions])
class QuestionsDao extends DatabaseAccessor<AppDatabase> with _$QuestionsDaoMixin {
  QuestionsDao(AppDatabase db) : super(db);

  // Get all questions for a subject
  Future<List<Question>> getQuestionsBySubject(String subjectId) {
    return (select(questions)..where((q) => q.subjectId.equals(subjectId))).get();
  }

  // Get questions by topic
  Future<List<Question>> getQuestionsByTopic(String topicId) {
    return (select(questions)..where((q) => q.topicId.equals(topicId))).get();
  }

  // Get questions with filters
  Future<List<Question>> getQuestionsFiltered({
    String? subjectId,
    String? topicId,
    int? year,
    String? difficulty,
    String? type,
    int limit = 50,
    int offset = 0,
  }) {
    final query = select(questions);

    if (subjectId != null) {
      query.where((q) => q.subjectId.equals(subjectId));
    }
    if (topicId != null) {
      query.where((q) => q.topicId.equals(topicId));
    }
    if (year != null) {
      query.where((q) => q.year.equals(year));
    }
    if (difficulty != null) {
      query.where((q) => q.difficulty.equals(difficulty));
    }
    if (type != null) {
      query.where((q) => q.type.equals(type));
    }

    query
      ..limit(limit, offset: offset)
      ..orderBy([(q) => OrderingTerm.desc(q.year)]);

    return query.get();
  }

  // Get a single question by ID
  Future<Question?> getQuestionById(String id) {
    return (select(questions)..where((q) => q.id.equals(id))).getSingleOrNull();
  }

  // Search questions by text
  Future<List<Question>> searchQuestions(String searchText, {int limit = 50}) {
    return (select(questions)
          ..where((q) => q.questionText.contains(searchText))
          ..limit(limit))
        .get();
  }

  // Insert or update questions (bulk)
  Future<void> upsertQuestions(List<QuestionsCompanion> questionList) async {
    await batch((batch) {
      batch.insertAllOnConflictUpdate(questions, questionList);
    });
  }

  // Insert single question
  Future<void> insertQuestion(QuestionsCompanion question) {
    return into(questions).insert(question, mode: InsertMode.insertOrReplace);
  }

  // Delete all questions for a subject (for re-download)
  Future<void> deleteQuestionsBySubject(String subjectId) {
    return (delete(questions)..where((q) => q.subjectId.equals(subjectId))).go();
  }

  // Get question count by subject
  Future<int> getQuestionCountBySubject(String subjectId) async {
    final count = countAll();
    final query = selectOnly(questions)
      ..addColumns([count])
      ..where(questions.subjectId.equals(subjectId));
    
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }

  // Get random questions for drill
  Future<List<Question>> getRandomQuestions({
    required String subjectId,
    String? topicId,
    int count = 5,
  }) async {
    final query = select(questions)..where((q) => q.subjectId.equals(subjectId));
    
    if (topicId != null) {
      query.where((q) => q.topicId.equals(topicId));
    }

    final allQuestions = await query.get();
    allQuestions.shuffle();
    return allQuestions.take(count).toList();
  }

  // Check if subject is downloaded
  Future<bool> isSubjectDownloaded(String subjectId) async {
    final count = await getQuestionCountBySubject(subjectId);
    return count > 0;
  }
}
