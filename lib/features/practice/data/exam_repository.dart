import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/exam_session.dart';
import '../domain/exam_result.dart';
import '../domain/exam_review.dart';

class ExamRepository {
  final DioClient _dioClient;

  ExamRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Create a new exam session
  Future<ExamSession> createExam({
    required String examType,
    required List<String> subjectIds,
    required int questionCount,
    required bool isTimed,
    bool aiProctorEnabled = false,
    int? yearFrom,
    int? yearTo,
  }) async {
    final response = await _dioClient.post(
      ApiConstants.examsCreate,
      data: {
        'examType': examType,
        'subjectIds': subjectIds,
        'questionCount': questionCount,
        'isTimed': isTimed,
        'aiProctorEnabled': aiProctorEnabled,
        if (yearFrom != null) 'yearFrom': yearFrom,
        if (yearTo != null) 'yearTo': yearTo,
      },
    );

    return ExamSession.fromJson(response.data);
  }

  /// Get exam session by ID
  Future<ExamSession> getExamSession(String sessionId) async {
    final response = await _dioClient.get('${ApiConstants.examsCreate}/$sessionId');
    return ExamSession.fromJson(response.data);
  }

  /// Submit exam answers
  Future<ExamResult> submitExam(
    String sessionId,
    Map<int, String> answers,
  ) async {
    final response = await _dioClient.post(
      '${ApiConstants.examsCreate}/$sessionId/submit',
      data: {
        'answers': answers.map((key, value) => MapEntry(key.toString(), value)),
      },
    );

    return ExamResult.fromJson(response.data);
  }

  /// Get exam results
  Future<ExamResult> getExamResults(String sessionId) async {
    final response = await _dioClient.get(
      '${ApiConstants.examsCreate}/$sessionId/results',
    );

    return ExamResult.fromJson(response.data);
  }

  /// Get exam review (questions with answers)
  Future<ExamReview> getExamReview(String sessionId) async {
    final response = await _dioClient.get(
      '${ApiConstants.examsCreate}/$sessionId/review',
    );

    return ExamReview.fromJson(response.data);
  }

  /// Get recent exams
  Future<List<ExamSession>> getRecentExams({int limit = 10}) async {
    final response = await _dioClient.get(
      ApiConstants.examsRecent,
      queryParameters: {'limit': limit},
    );

    return (response.data as List)
        .map((json) => ExamSession.fromJson(json))
        .toList();
  }
}
