import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../local/drift/app_database.dart';
import '../../../local/drift/daos/questions_dao.dart';
import '../../../local/drift/daos/progress_dao.dart';
import '../../../shared/providers/connectivity_provider.dart';
import '../data/exam_repository.dart';
import '../domain/exam_session.dart';
import '../domain/exam_result.dart';

// Repository provider
final examRepositoryProvider = Provider<ExamRepository>((ref) {
  return ExamRepository();
});

// Exam notifier provider (family - one per session)
final examNotifierProvider = AsyncNotifierProvider.family<ExamNotifier, ExamSession?, String>(
  ExamNotifier.new,
);

class ExamNotifier extends FamilyAsyncNotifier<ExamSession?, String> {
  late final ExamRepository _repository;
  late final QuestionsDao _questionsDao;
  late final ProgressDao _progressDao;

  @override
  Future<ExamSession?> build(String arg) async {
    _repository = ref.read(examRepositoryProvider);
    final database = ref.read(appDatabaseProvider);
    _questionsDao = QuestionsDao(database);
    _progressDao = ProgressDao(database);
    
    return null;
  }

  /// Load exam session from API or local storage
  Future<void> loadSession() async {
    state = const AsyncValue.loading();
    
    try {
      final isOnline = ref.read(connectivityProvider).value ?? false;
      
      ExamSession session;
      
      if (isOnline) {
        // Fetch from API
        session = await _repository.getExamSession(arg);
        
        // Save questions to local storage
        await _saveQuestionsLocally(session);
      } else {
        // Load from local storage
        session = await _loadSessionLocally(arg);
      }
      
      state = AsyncValue.data(session);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Save answer locally (for offline support)
  Future<void> saveAnswerLocally(int questionIndex, String answer) async {
    final session = state.value;
    if (session == null) return;
    
    try {
      final question = session.questions[questionIndex];
      
      // Save to progress table
      await _progressDao.recordAnswer(
        questionId: question.id,
        userAnswer: answer,
        isCorrect: false, // We don't know yet
        timeSpent: 0, // Track this separately if needed
      );
    } catch (e) {
      // Silent fail - don't interrupt user experience
      print('Error saving answer locally: $e');
    }
  }

  /// Submit exam (online or queue for sync)
  Future<ExamResult?> submitExam(Map<int, String> answers) async {
    final session = state.value;
    if (session == null) return null;
    
    try {
      final isOnline = ref.read(connectivityProvider).value ?? false;
      
      if (isOnline) {
        // Submit to API
        final result = await _repository.submitExam(arg, answers);
        
        // Update local progress with correct answers
        await _updateLocalProgress(session, answers, result);
        
        return result;
      } else {
        // Queue for sync
        await _queueSubmissionForSync(session, answers);
        
        // Calculate local result
        return _calculateLocalResult(session, answers);
      }
    } catch (e) {
      // If online submission fails, queue for sync
      await _queueSubmissionForSync(session, answers);
      return _calculateLocalResult(session, answers);
    }
  }

  /// Save questions to local storage
  Future<void> _saveQuestionsLocally(ExamSession session) async {
    for (final question in session.questions) {
      await _questionsDao.insertQuestion(
        QuestionsCompanion.insert(
          id: question.id,
          subjectId: question.subjectId,
          topicId: question.topicId,
          questionText: question.questionText,
          optionA: question.optionA,
          optionB: question.optionB,
          optionC: question.optionC,
          optionD: question.optionD,
          correctAnswer: question.correctAnswer,
          explanationEn: Value(question.explanationEn),
          explanationPidgin: Value(question.explanationPidgin),
          difficulty: question.difficulty,
          year: question.year,
          type: question.type,
          downloadedAt: DateTime.now(),
        ),
      );
    }
  }

  /// Load session from local storage
  Future<ExamSession> _loadSessionLocally(String sessionId) async {
    // In a real implementation, you'd store session metadata
    // For now, throw an error to indicate offline mode isn't fully ready
    throw Exception('Offline exam loading not yet implemented');
  }

  /// Update local progress with correct answers
  Future<void> _updateLocalProgress(
    ExamSession session,
    Map<int, String> answers,
    ExamResult result,
  ) async {
    for (final entry in answers.entries) {
      final questionIndex = entry.key;
      final userAnswer = entry.value;
      final question = session.questions[questionIndex];
      
      final isCorrect = userAnswer == question.correctAnswer;
      
      await _progressDao.recordAnswer(
        questionId: question.id,
        userAnswer: userAnswer,
        isCorrect: isCorrect,
        timeSpent: 0, // Could track this per question
      );
    }
  }

  /// Queue submission for sync when back online
  Future<void> _queueSubmissionForSync(
    ExamSession session,
    Map<int, String> answers,
  ) async {
    // This would use the sync_queue_dao
    // For now, just save the answers locally
    for (final entry in answers.entries) {
      await saveAnswerLocally(entry.key, entry.value);
    }
  }

  /// Calculate result locally (for offline mode)
  ExamResult _calculateLocalResult(
    ExamSession session,
    Map<int, String> answers,
  ) {
    int correctCount = 0;
    int wrongCount = 0;
    int skippedCount = session.totalQuestions - answers.length;
    
    final subjectBreakdown = <String, SubjectBreakdown>{};
    
    for (final entry in answers.entries) {
      final questionIndex = entry.key;
      final userAnswer = entry.value;
      final question = session.questions[questionIndex];
      
      final isCorrect = userAnswer == question.correctAnswer;
      
      if (isCorrect) {
        correctCount++;
      } else {
        wrongCount++;
      }
      
      // Update subject breakdown
      final subjectName = question.subjectName;
      if (!subjectBreakdown.containsKey(subjectName)) {
        subjectBreakdown[subjectName] = SubjectBreakdown(
          subjectName: subjectName,
          correct: 0,
          wrong: 0,
          skipped: 0,
          total: 0,
          percentage: 0,
        );
      }
      
      final current = subjectBreakdown[subjectName]!;
      subjectBreakdown[subjectName] = SubjectBreakdown(
        subjectName: subjectName,
        correct: current.correct + (isCorrect ? 1 : 0),
        wrong: current.wrong + (isCorrect ? 0 : 1),
        skipped: current.skipped,
        total: current.total + 1,
        percentage: 0, // Will calculate below
      );
    }
    
    // Calculate percentages
    for (final key in subjectBreakdown.keys) {
      final score = subjectBreakdown[key]!;
      subjectBreakdown[key] = SubjectBreakdown(
        subjectName: score.subjectName,
        correct: score.correct,
        wrong: score.wrong,
        skipped: score.skipped,
        total: score.total,
        percentage: score.total > 0 ? (score.correct / score.total * 100) : 0,
      );
    }
    
    final percentage = session.totalQuestions > 0
        ? (correctCount / session.totalQuestions * 100)
        : 0;
    
    // Simple grade calculation
    String grade;
    if (percentage >= 90) {
      grade = 'A+';
    } else if (percentage >= 80) {
      grade = 'A';
    } else if (percentage >= 70) {
      grade = 'B';
    } else if (percentage >= 60) {
      grade = 'C';
    } else if (percentage >= 50) {
      grade = 'D';
    } else {
      grade = 'F';
    }
    
    return ExamResult(
      sessionId: session.id,
      score: correctCount,
      totalQuestions: session.totalQuestions,
      percentage: percentage,
      grade: grade,
      percentile: 50, // Would need server data for real percentile
      timeTakenSeconds: session.durationMinutes * 60,
      avgSecondsPerQuestion: session.totalQuestions > 0
          ? (session.durationMinutes * 60 / session.totalQuestions)
          : 0,
      subjectBreakdown: subjectBreakdown,
      weakTopics: [], // Would need more logic
      xpEarned: correctCount * 10, // Simple XP calculation
    );
  }
}

// Provider for creating a new exam
final createExamProvider = FutureProvider.family<ExamSession, CreateExamParams>(
  (ref, params) async {
    final repository = ref.read(examRepositoryProvider);
    
    return await repository.createExam(
      examType: params.examType,
      subjectIds: params.subjectIds,
      questionCount: params.questionCount,
      isTimed: params.isTimed,
      aiProctorEnabled: params.aiProctorEnabled,
      yearFrom: params.yearFrom,
      yearTo: params.yearTo,
    );
  },
);

// Parameters for creating an exam
class CreateExamParams {
  final String examType;
  final List<String> subjectIds;
  final int questionCount;
  final bool isTimed;
  final bool aiProctorEnabled;
  final int? yearFrom;
  final int? yearTo;

  CreateExamParams({
    required this.examType,
    required this.subjectIds,
    required this.questionCount,
    required this.isTimed,
    this.aiProctorEnabled = false,
    this.yearFrom,
    this.yearTo,
  });
}

// Provider for recent exams
final recentExamsProvider = FutureProvider<List<ExamSession>>((ref) async {
  final repository = ref.read(examRepositoryProvider);
  return await repository.getRecentExams(limit: 10);
});
