class ExamResult {
  final String sessionId;
  final int score;
  final int totalQuestions;
  final double percentage;
  final String grade;
  final int percentile;
  final int timeTakenSeconds;
  final double avgSecondsPerQuestion;
  final Map<String, SubjectBreakdown> subjectBreakdown;
  final List<String> weakTopics;
  final int xpEarned;

  ExamResult({
    required this.sessionId,
    required this.score,
    required this.totalQuestions,
    required this.percentage,
    required this.grade,
    required this.percentile,
    required this.timeTakenSeconds,
    required this.avgSecondsPerQuestion,
    required this.subjectBreakdown,
    required this.weakTopics,
    required this.xpEarned,
  });

  factory ExamResult.fromJson(Map<String, dynamic> json) {
    return ExamResult(
      sessionId: json['sessionId'] as String,
      score: json['score'] as int,
      totalQuestions: json['totalQuestions'] as int,
      percentage: (json['percentage'] as num).toDouble(),
      grade: json['grade'] as String,
      percentile: json['percentile'] as int,
      timeTakenSeconds: json['timeTakenSeconds'] as int,
      avgSecondsPerQuestion: (json['avgSecondsPerQuestion'] as num).toDouble(),
      subjectBreakdown: (json['subjectBreakdown'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, SubjectBreakdown.fromJson(value)),
      ),
      weakTopics: (json['weakTopics'] as List).cast<String>(),
      xpEarned: json['xpEarned'] as int,
    );
  }

  int get correctAnswers => score;
  int get wrongAnswers => totalQuestions - score;
  bool get isPassed => percentage >= 50;
}

class SubjectBreakdown {
  final String subjectName;
  final int correct;
  final int wrong;
  final int skipped;
  final int total;
  final double percentage;

  SubjectBreakdown({
    required this.subjectName,
    required this.correct,
    required this.wrong,
    required this.skipped,
    required this.total,
    required this.percentage,
  });

  factory SubjectBreakdown.fromJson(Map<String, dynamic> json) {
    return SubjectBreakdown(
      subjectName: json['subjectName'] as String,
      correct: json['correct'] as int,
      wrong: json['wrong'] as int,
      skipped: json['skipped'] as int,
      total: json['total'] as int,
      percentage: (json['percentage'] as num).toDouble(),
    );
  }
}
