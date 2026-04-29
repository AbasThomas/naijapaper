import 'question.dart';

class ExamReview {
  final String sessionId;
  final List<ReviewQuestion> questions;

  ExamReview({
    required this.sessionId,
    required this.questions,
  });

  factory ExamReview.fromJson(Map<String, dynamic> json) {
    return ExamReview(
      sessionId: json['sessionId'] as String,
      questions: (json['questions'] as List)
          .map((q) => ReviewQuestion.fromJson(q))
          .toList(),
    );
  }

  List<ReviewQuestion> get correctQuestions =>
      questions.where((q) => q.isCorrect).toList();
  
  List<ReviewQuestion> get wrongQuestions =>
      questions.where((q) => !q.isCorrect && q.userAnswer != null).toList();
  
  List<ReviewQuestion> get skippedQuestions =>
      questions.where((q) => q.userAnswer == null).toList();
  
  List<ReviewQuestion> get flaggedQuestions =>
      questions.where((q) => q.isFlagged).toList();
}

class ReviewQuestion {
  final Question question;
  final String? userAnswer;
  final bool isCorrect;
  final bool isFlagged;
  final int timeTakenSeconds;
  final String? aiExplanation;

  ReviewQuestion({
    required this.question,
    this.userAnswer,
    required this.isCorrect,
    required this.isFlagged,
    required this.timeTakenSeconds,
    this.aiExplanation,
  });

  factory ReviewQuestion.fromJson(Map<String, dynamic> json) {
    return ReviewQuestion(
      question: Question.fromJson(json['question']),
      userAnswer: json['userAnswer'] as String?,
      isCorrect: json['isCorrect'] as bool,
      isFlagged: json['isFlagged'] as bool? ?? false,
      timeTakenSeconds: json['timeTakenSeconds'] as int? ?? 0,
      aiExplanation: json['aiExplanation'] as String?,
    );
  }

  bool get isSkipped => userAnswer == null;
  bool get isWrong => !isCorrect && userAnswer != null;
}
