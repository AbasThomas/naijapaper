class Question {
  final String id;
  final String subjectId;
  final String subjectName;
  final String topicId;
  final String topicName;
  final int year;
  final String difficulty;
  final String questionText;
  final String optionA;
  final String optionB;
  final String optionC;
  final String optionD;
  final String correctAnswer;
  final String? explanationEn;
  final String? explanationPidgin;
  final String type;
  final String examType;

  Question({
    required this.id,
    required this.subjectId,
    required this.subjectName,
    required this.topicId,
    required this.topicName,
    required this.year,
    required this.difficulty,
    required this.questionText,
    required this.optionA,
    required this.optionB,
    required this.optionC,
    required this.optionD,
    required this.correctAnswer,
    this.explanationEn,
    this.explanationPidgin,
    required this.type,
    required this.examType,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      subjectName: json['subjectName'] as String? ?? '',
      topicId: json['topicId'] as String,
      topicName: json['topicName'] as String? ?? '',
      year: json['year'] as int,
      difficulty: json['difficulty'] as String,
      questionText: json['questionText'] as String,
      optionA: json['optionA'] as String,
      optionB: json['optionB'] as String,
      optionC: json['optionC'] as String,
      optionD: json['optionD'] as String,
      correctAnswer: json['correctAnswer'] as String,
      explanationEn: json['explanationEn'] as String?,
      explanationPidgin: json['explanationPidgin'] as String?,
      type: json['type'] as String? ?? 'MCQ',
      examType: json['examType'] as String? ?? 'JAMB',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'subjectName': subjectName,
      'topicId': topicId,
      'topicName': topicName,
      'year': year,
      'difficulty': difficulty,
      'questionText': questionText,
      'optionA': optionA,
      'optionB': optionB,
      'optionC': optionC,
      'optionD': optionD,
      'correctAnswer': correctAnswer,
      'explanationEn': explanationEn,
      'explanationPidgin': explanationPidgin,
      'type': type,
      'examType': examType,
    };
  }

  List<String> get options => [optionA, optionB, optionC, optionD];
  
  Map<String, String> get optionsMap => {
    'A': optionA,
    'B': optionB,
    'C': optionC,
    'D': optionD,
  };

  bool isCorrect(String answer) => answer.toUpperCase() == correctAnswer.toUpperCase();
}
