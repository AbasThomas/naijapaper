import 'question.dart';

class ExamSession {
  final String id;
  final String examType;
  final List<Question> questions;
  final int durationMinutes;
  final bool isTimed;
  final bool aiProctorEnabled;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final ExamStatus status;

  ExamSession({
    required this.id,
    required this.examType,
    required this.questions,
    required this.durationMinutes,
    required this.isTimed,
    required this.aiProctorEnabled,
    required this.startedAt,
    this.submittedAt,
    required this.status,
  });

  factory ExamSession.fromJson(Map<String, dynamic> json) {
    return ExamSession(
      id: json['id'] as String,
      examType: json['examType'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      durationMinutes: json['durationMinutes'] as int,
      isTimed: json['isTimed'] as bool,
      aiProctorEnabled: json['aiProctorEnabled'] as bool? ?? false,
      startedAt: DateTime.parse(json['startedAt'] as String),
      submittedAt: json['submittedAt'] != null
          ? DateTime.parse(json['submittedAt'] as String)
          : null,
      status: ExamStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExamStatus.inProgress,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examType': examType,
      'questions': questions.map((q) => q.toJson()).toList(),
      'durationMinutes': durationMinutes,
      'isTimed': isTimed,
      'aiProctorEnabled': aiProctorEnabled,
      'startedAt': startedAt.toIso8601String(),
      'submittedAt': submittedAt?.toIso8601String(),
      'status': status.name,
    };
  }

  int get totalQuestions => questions.length;
  
  int get remainingSeconds {
    if (!isTimed) return 0;
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    final total = durationMinutes * 60;
    return (total - elapsed).clamp(0, total);
  }

  bool get isExpired => isTimed && remainingSeconds <= 0;
}

enum ExamStatus {
  inProgress,
  submitted,
  expired,
}
