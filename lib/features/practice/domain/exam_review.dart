import 'question.dart';

class ExamReview {
  final String sessionId;
  final List<ReviewQuestion> questions;
  final int correctCount;
  final int wrongCount;
  final int skippedCount;

  ExamReview({
    required this.sessionId,
    required this.questions,
    required this.correctCount,
    required this.wrongCount,
    required this.skippedCount,
  });

  factory ExamReview.fromJson(Map<String, dynamic> json) {
    return ExamReview(
      sessionId: json['sessionId'] as String,
      questions: (json['questions'] as List)
          .map((q) => ReviewQuestion.fromJson(q))
          .toList(),
      correctCount: json['correctCount'] as int,
      wrongCount: json['wrongCount'] as int,
      skippedCount: json['skippedCount'] as int,
    );
  }

  int get totalQuestions => questions.length;
}

class ReviewQuestion {
  final Question question;
  final String? userAnswer;
  final bool isCorrect;
  final int timeSpentSeconds;

  ReviewQuestion({
    required this.question,
    this.userAnswer,
    required this.isCorrect,
    required this.timeSpentSeconds,
  });

  factory ReviewQuestion.fromJson(Map<String, dynamic> json) {
    return ReviewQuestion(
      question: Question.fromJson(json['question']),
      userAnswer: json['userAnswer'] as String?,
      isCorrect: json['isCorrect'] as bool,
      timeSpentSeconds: json['timeSpentSeconds'] as int? ?? 0,
    );
  }

  bool get wasSkipped => userAnswer == null;
}
