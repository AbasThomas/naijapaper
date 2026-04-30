// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $QuestionsTable extends Questions
    with TableInfo<$QuestionsTable, Question> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _subjectIdMeta =
      const VerificationMeta('subjectId');
  @override
  late final GeneratedColumn<String> subjectId = GeneratedColumn<String>(
      'subject_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
      'year', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _difficultyMeta =
      const VerificationMeta('difficulty');
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
      'difficulty', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionTextMeta =
      const VerificationMeta('questionText');
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
      'question_text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionAMeta =
      const VerificationMeta('optionA');
  @override
  late final GeneratedColumn<String> optionA = GeneratedColumn<String>(
      'option_a', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionBMeta =
      const VerificationMeta('optionB');
  @override
  late final GeneratedColumn<String> optionB = GeneratedColumn<String>(
      'option_b', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionCMeta =
      const VerificationMeta('optionC');
  @override
  late final GeneratedColumn<String> optionC = GeneratedColumn<String>(
      'option_c', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _optionDMeta =
      const VerificationMeta('optionD');
  @override
  late final GeneratedColumn<String> optionD = GeneratedColumn<String>(
      'option_d', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _correctAnswerMeta =
      const VerificationMeta('correctAnswer');
  @override
  late final GeneratedColumn<String> correctAnswer = GeneratedColumn<String>(
      'correct_answer', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationEnMeta =
      const VerificationMeta('explanationEn');
  @override
  late final GeneratedColumn<String> explanationEn = GeneratedColumn<String>(
      'explanation_en', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _explanationPidginMeta =
      const VerificationMeta('explanationPidgin');
  @override
  late final GeneratedColumn<String> explanationPidgin =
      GeneratedColumn<String>('explanation_pidgin', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _downloadedAtMeta =
      const VerificationMeta('downloadedAt');
  @override
  late final GeneratedColumn<DateTime> downloadedAt = GeneratedColumn<DateTime>(
      'downloaded_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        subjectId,
        topicId,
        year,
        difficulty,
        questionText,
        optionA,
        optionB,
        optionC,
        optionD,
        correctAnswer,
        explanationEn,
        explanationPidgin,
        type,
        downloadedAt
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'questions';
  @override
  VerificationContext validateIntegrity(Insertable<Question> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('subject_id')) {
      context.handle(_subjectIdMeta,
          subjectId.isAcceptableOrUnknown(data['subject_id']!, _subjectIdMeta));
    } else if (isInserting) {
      context.missing(_subjectIdMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
          _yearMeta, year.isAcceptableOrUnknown(data['year']!, _yearMeta));
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
          _difficultyMeta,
          difficulty.isAcceptableOrUnknown(
              data['difficulty']!, _difficultyMeta));
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
          _questionTextMeta,
          questionText.isAcceptableOrUnknown(
              data['question_text']!, _questionTextMeta));
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('option_a')) {
      context.handle(_optionAMeta,
          optionA.isAcceptableOrUnknown(data['option_a']!, _optionAMeta));
    } else if (isInserting) {
      context.missing(_optionAMeta);
    }
    if (data.containsKey('option_b')) {
      context.handle(_optionBMeta,
          optionB.isAcceptableOrUnknown(data['option_b']!, _optionBMeta));
    } else if (isInserting) {
      context.missing(_optionBMeta);
    }
    if (data.containsKey('option_c')) {
      context.handle(_optionCMeta,
          optionC.isAcceptableOrUnknown(data['option_c']!, _optionCMeta));
    } else if (isInserting) {
      context.missing(_optionCMeta);
    }
    if (data.containsKey('option_d')) {
      context.handle(_optionDMeta,
          optionD.isAcceptableOrUnknown(data['option_d']!, _optionDMeta));
    } else if (isInserting) {
      context.missing(_optionDMeta);
    }
    if (data.containsKey('correct_answer')) {
      context.handle(
          _correctAnswerMeta,
          correctAnswer.isAcceptableOrUnknown(
              data['correct_answer']!, _correctAnswerMeta));
    } else if (isInserting) {
      context.missing(_correctAnswerMeta);
    }
    if (data.containsKey('explanation_en')) {
      context.handle(
          _explanationEnMeta,
          explanationEn.isAcceptableOrUnknown(
              data['explanation_en']!, _explanationEnMeta));
    }
    if (data.containsKey('explanation_pidgin')) {
      context.handle(
          _explanationPidginMeta,
          explanationPidgin.isAcceptableOrUnknown(
              data['explanation_pidgin']!, _explanationPidginMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('downloaded_at')) {
      context.handle(
          _downloadedAtMeta,
          downloadedAt.isAcceptableOrUnknown(
              data['downloaded_at']!, _downloadedAtMeta));
    } else if (isInserting) {
      context.missing(_downloadedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Question map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Question(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      subjectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}subject_id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      year: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}year'])!,
      difficulty: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}difficulty'])!,
      questionText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_text'])!,
      optionA: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_a'])!,
      optionB: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_b'])!,
      optionC: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_c'])!,
      optionD: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}option_d'])!,
      correctAnswer: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}correct_answer'])!,
      explanationEn: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation_en']),
      explanationPidgin: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}explanation_pidgin']),
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      downloadedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}downloaded_at'])!,
    );
  }

  @override
  $QuestionsTable createAlias(String alias) {
    return $QuestionsTable(attachedDatabase, alias);
  }
}

class Question extends DataClass implements Insertable<Question> {
  final String id;
  final String subjectId;
  final String topicId;
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
  final DateTime downloadedAt;
  const Question(
      {required this.id,
      required this.subjectId,
      required this.topicId,
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
      required this.downloadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['subject_id'] = Variable<String>(subjectId);
    map['topic_id'] = Variable<String>(topicId);
    map['year'] = Variable<int>(year);
    map['difficulty'] = Variable<String>(difficulty);
    map['question_text'] = Variable<String>(questionText);
    map['option_a'] = Variable<String>(optionA);
    map['option_b'] = Variable<String>(optionB);
    map['option_c'] = Variable<String>(optionC);
    map['option_d'] = Variable<String>(optionD);
    map['correct_answer'] = Variable<String>(correctAnswer);
    if (!nullToAbsent || explanationEn != null) {
      map['explanation_en'] = Variable<String>(explanationEn);
    }
    if (!nullToAbsent || explanationPidgin != null) {
      map['explanation_pidgin'] = Variable<String>(explanationPidgin);
    }
    map['type'] = Variable<String>(type);
    map['downloaded_at'] = Variable<DateTime>(downloadedAt);
    return map;
  }

  QuestionsCompanion toCompanion(bool nullToAbsent) {
    return QuestionsCompanion(
      id: Value(id),
      subjectId: Value(subjectId),
      topicId: Value(topicId),
      year: Value(year),
      difficulty: Value(difficulty),
      questionText: Value(questionText),
      optionA: Value(optionA),
      optionB: Value(optionB),
      optionC: Value(optionC),
      optionD: Value(optionD),
      correctAnswer: Value(correctAnswer),
      explanationEn: explanationEn == null && nullToAbsent
          ? const Value.absent()
          : Value(explanationEn),
      explanationPidgin: explanationPidgin == null && nullToAbsent
          ? const Value.absent()
          : Value(explanationPidgin),
      type: Value(type),
      downloadedAt: Value(downloadedAt),
    );
  }

  factory Question.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Question(
      id: serializer.fromJson<String>(json['id']),
      subjectId: serializer.fromJson<String>(json['subjectId']),
      topicId: serializer.fromJson<String>(json['topicId']),
      year: serializer.fromJson<int>(json['year']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      questionText: serializer.fromJson<String>(json['questionText']),
      optionA: serializer.fromJson<String>(json['optionA']),
      optionB: serializer.fromJson<String>(json['optionB']),
      optionC: serializer.fromJson<String>(json['optionC']),
      optionD: serializer.fromJson<String>(json['optionD']),
      correctAnswer: serializer.fromJson<String>(json['correctAnswer']),
      explanationEn: serializer.fromJson<String?>(json['explanationEn']),
      explanationPidgin:
          serializer.fromJson<String?>(json['explanationPidgin']),
      type: serializer.fromJson<String>(json['type']),
      downloadedAt: serializer.fromJson<DateTime>(json['downloadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'subjectId': serializer.toJson<String>(subjectId),
      'topicId': serializer.toJson<String>(topicId),
      'year': serializer.toJson<int>(year),
      'difficulty': serializer.toJson<String>(difficulty),
      'questionText': serializer.toJson<String>(questionText),
      'optionA': serializer.toJson<String>(optionA),
      'optionB': serializer.toJson<String>(optionB),
      'optionC': serializer.toJson<String>(optionC),
      'optionD': serializer.toJson<String>(optionD),
      'correctAnswer': serializer.toJson<String>(correctAnswer),
      'explanationEn': serializer.toJson<String?>(explanationEn),
      'explanationPidgin': serializer.toJson<String?>(explanationPidgin),
      'type': serializer.toJson<String>(type),
      'downloadedAt': serializer.toJson<DateTime>(downloadedAt),
    };
  }

  Question copyWith(
          {String? id,
          String? subjectId,
          String? topicId,
          int? year,
          String? difficulty,
          String? questionText,
          String? optionA,
          String? optionB,
          String? optionC,
          String? optionD,
          String? correctAnswer,
          Value<String?> explanationEn = const Value.absent(),
          Value<String?> explanationPidgin = const Value.absent(),
          String? type,
          DateTime? downloadedAt}) =>
      Question(
        id: id ?? this.id,
        subjectId: subjectId ?? this.subjectId,
        topicId: topicId ?? this.topicId,
        year: year ?? this.year,
        difficulty: difficulty ?? this.difficulty,
        questionText: questionText ?? this.questionText,
        optionA: optionA ?? this.optionA,
        optionB: optionB ?? this.optionB,
        optionC: optionC ?? this.optionC,
        optionD: optionD ?? this.optionD,
        correctAnswer: correctAnswer ?? this.correctAnswer,
        explanationEn:
            explanationEn.present ? explanationEn.value : this.explanationEn,
        explanationPidgin: explanationPidgin.present
            ? explanationPidgin.value
            : this.explanationPidgin,
        type: type ?? this.type,
        downloadedAt: downloadedAt ?? this.downloadedAt,
      );
  Question copyWithCompanion(QuestionsCompanion data) {
    return Question(
      id: data.id.present ? data.id.value : this.id,
      subjectId: data.subjectId.present ? data.subjectId.value : this.subjectId,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      year: data.year.present ? data.year.value : this.year,
      difficulty:
          data.difficulty.present ? data.difficulty.value : this.difficulty,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      optionA: data.optionA.present ? data.optionA.value : this.optionA,
      optionB: data.optionB.present ? data.optionB.value : this.optionB,
      optionC: data.optionC.present ? data.optionC.value : this.optionC,
      optionD: data.optionD.present ? data.optionD.value : this.optionD,
      correctAnswer: data.correctAnswer.present
          ? data.correctAnswer.value
          : this.correctAnswer,
      explanationEn: data.explanationEn.present
          ? data.explanationEn.value
          : this.explanationEn,
      explanationPidgin: data.explanationPidgin.present
          ? data.explanationPidgin.value
          : this.explanationPidgin,
      type: data.type.present ? data.type.value : this.type,
      downloadedAt: data.downloadedAt.present
          ? data.downloadedAt.value
          : this.downloadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Question(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('year: $year, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionText: $questionText, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationPidgin: $explanationPidgin, ')
          ..write('type: $type, ')
          ..write('downloadedAt: $downloadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      subjectId,
      topicId,
      year,
      difficulty,
      questionText,
      optionA,
      optionB,
      optionC,
      optionD,
      correctAnswer,
      explanationEn,
      explanationPidgin,
      type,
      downloadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Question &&
          other.id == this.id &&
          other.subjectId == this.subjectId &&
          other.topicId == this.topicId &&
          other.year == this.year &&
          other.difficulty == this.difficulty &&
          other.questionText == this.questionText &&
          other.optionA == this.optionA &&
          other.optionB == this.optionB &&
          other.optionC == this.optionC &&
          other.optionD == this.optionD &&
          other.correctAnswer == this.correctAnswer &&
          other.explanationEn == this.explanationEn &&
          other.explanationPidgin == this.explanationPidgin &&
          other.type == this.type &&
          other.downloadedAt == this.downloadedAt);
}

class QuestionsCompanion extends UpdateCompanion<Question> {
  final Value<String> id;
  final Value<String> subjectId;
  final Value<String> topicId;
  final Value<int> year;
  final Value<String> difficulty;
  final Value<String> questionText;
  final Value<String> optionA;
  final Value<String> optionB;
  final Value<String> optionC;
  final Value<String> optionD;
  final Value<String> correctAnswer;
  final Value<String?> explanationEn;
  final Value<String?> explanationPidgin;
  final Value<String> type;
  final Value<DateTime> downloadedAt;
  final Value<int> rowid;
  const QuestionsCompanion({
    this.id = const Value.absent(),
    this.subjectId = const Value.absent(),
    this.topicId = const Value.absent(),
    this.year = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.questionText = const Value.absent(),
    this.optionA = const Value.absent(),
    this.optionB = const Value.absent(),
    this.optionC = const Value.absent(),
    this.optionD = const Value.absent(),
    this.correctAnswer = const Value.absent(),
    this.explanationEn = const Value.absent(),
    this.explanationPidgin = const Value.absent(),
    this.type = const Value.absent(),
    this.downloadedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  QuestionsCompanion.insert({
    required String id,
    required String subjectId,
    required String topicId,
    required int year,
    required String difficulty,
    required String questionText,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctAnswer,
    this.explanationEn = const Value.absent(),
    this.explanationPidgin = const Value.absent(),
    required String type,
    required DateTime downloadedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        subjectId = Value(subjectId),
        topicId = Value(topicId),
        year = Value(year),
        difficulty = Value(difficulty),
        questionText = Value(questionText),
        optionA = Value(optionA),
        optionB = Value(optionB),
        optionC = Value(optionC),
        optionD = Value(optionD),
        correctAnswer = Value(correctAnswer),
        type = Value(type),
        downloadedAt = Value(downloadedAt);
  static Insertable<Question> custom({
    Expression<String>? id,
    Expression<String>? subjectId,
    Expression<String>? topicId,
    Expression<int>? year,
    Expression<String>? difficulty,
    Expression<String>? questionText,
    Expression<String>? optionA,
    Expression<String>? optionB,
    Expression<String>? optionC,
    Expression<String>? optionD,
    Expression<String>? correctAnswer,
    Expression<String>? explanationEn,
    Expression<String>? explanationPidgin,
    Expression<String>? type,
    Expression<DateTime>? downloadedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (subjectId != null) 'subject_id': subjectId,
      if (topicId != null) 'topic_id': topicId,
      if (year != null) 'year': year,
      if (difficulty != null) 'difficulty': difficulty,
      if (questionText != null) 'question_text': questionText,
      if (optionA != null) 'option_a': optionA,
      if (optionB != null) 'option_b': optionB,
      if (optionC != null) 'option_c': optionC,
      if (optionD != null) 'option_d': optionD,
      if (correctAnswer != null) 'correct_answer': correctAnswer,
      if (explanationEn != null) 'explanation_en': explanationEn,
      if (explanationPidgin != null) 'explanation_pidgin': explanationPidgin,
      if (type != null) 'type': type,
      if (downloadedAt != null) 'downloaded_at': downloadedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  QuestionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? subjectId,
      Value<String>? topicId,
      Value<int>? year,
      Value<String>? difficulty,
      Value<String>? questionText,
      Value<String>? optionA,
      Value<String>? optionB,
      Value<String>? optionC,
      Value<String>? optionD,
      Value<String>? correctAnswer,
      Value<String?>? explanationEn,
      Value<String?>? explanationPidgin,
      Value<String>? type,
      Value<DateTime>? downloadedAt,
      Value<int>? rowid}) {
    return QuestionsCompanion(
      id: id ?? this.id,
      subjectId: subjectId ?? this.subjectId,
      topicId: topicId ?? this.topicId,
      year: year ?? this.year,
      difficulty: difficulty ?? this.difficulty,
      questionText: questionText ?? this.questionText,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      optionC: optionC ?? this.optionC,
      optionD: optionD ?? this.optionD,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanationEn: explanationEn ?? this.explanationEn,
      explanationPidgin: explanationPidgin ?? this.explanationPidgin,
      type: type ?? this.type,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (subjectId.present) {
      map['subject_id'] = Variable<String>(subjectId.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (optionA.present) {
      map['option_a'] = Variable<String>(optionA.value);
    }
    if (optionB.present) {
      map['option_b'] = Variable<String>(optionB.value);
    }
    if (optionC.present) {
      map['option_c'] = Variable<String>(optionC.value);
    }
    if (optionD.present) {
      map['option_d'] = Variable<String>(optionD.value);
    }
    if (correctAnswer.present) {
      map['correct_answer'] = Variable<String>(correctAnswer.value);
    }
    if (explanationEn.present) {
      map['explanation_en'] = Variable<String>(explanationEn.value);
    }
    if (explanationPidgin.present) {
      map['explanation_pidgin'] = Variable<String>(explanationPidgin.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (downloadedAt.present) {
      map['downloaded_at'] = Variable<DateTime>(downloadedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionsCompanion(')
          ..write('id: $id, ')
          ..write('subjectId: $subjectId, ')
          ..write('topicId: $topicId, ')
          ..write('year: $year, ')
          ..write('difficulty: $difficulty, ')
          ..write('questionText: $questionText, ')
          ..write('optionA: $optionA, ')
          ..write('optionB: $optionB, ')
          ..write('optionC: $optionC, ')
          ..write('optionD: $optionD, ')
          ..write('correctAnswer: $correctAnswer, ')
          ..write('explanationEn: $explanationEn, ')
          ..write('explanationPidgin: $explanationPidgin, ')
          ..write('type: $type, ')
          ..write('downloadedAt: $downloadedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgressTableTable extends ProgressTable
    with TableInfo<$ProgressTableTable, ProgressTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _topicIdMeta =
      const VerificationMeta('topicId');
  @override
  late final GeneratedColumn<String> topicId = GeneratedColumn<String>(
      'topic_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accuracyPctMeta =
      const VerificationMeta('accuracyPct');
  @override
  late final GeneratedColumn<double> accuracyPct = GeneratedColumn<double>(
      'accuracy_pct', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _attemptsCountMeta =
      const VerificationMeta('attemptsCount');
  @override
  late final GeneratedColumn<int> attemptsCount = GeneratedColumn<int>(
      'attempts_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _lastAttemptedAtMeta =
      const VerificationMeta('lastAttemptedAt');
  @override
  late final GeneratedColumn<DateTime> lastAttemptedAt =
      GeneratedColumn<DateTime>('last_attempted_at', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, topicId, accuracyPct, attemptsCount, lastAttemptedAt, synced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'progress';
  @override
  VerificationContext validateIntegrity(Insertable<ProgressTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('topic_id')) {
      context.handle(_topicIdMeta,
          topicId.isAcceptableOrUnknown(data['topic_id']!, _topicIdMeta));
    } else if (isInserting) {
      context.missing(_topicIdMeta);
    }
    if (data.containsKey('accuracy_pct')) {
      context.handle(
          _accuracyPctMeta,
          accuracyPct.isAcceptableOrUnknown(
              data['accuracy_pct']!, _accuracyPctMeta));
    } else if (isInserting) {
      context.missing(_accuracyPctMeta);
    }
    if (data.containsKey('attempts_count')) {
      context.handle(
          _attemptsCountMeta,
          attemptsCount.isAcceptableOrUnknown(
              data['attempts_count']!, _attemptsCountMeta));
    } else if (isInserting) {
      context.missing(_attemptsCountMeta);
    }
    if (data.containsKey('last_attempted_at')) {
      context.handle(
          _lastAttemptedAtMeta,
          lastAttemptedAt.isAcceptableOrUnknown(
              data['last_attempted_at']!, _lastAttemptedAtMeta));
    } else if (isInserting) {
      context.missing(_lastAttemptedAtMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgressTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgressTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      topicId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}topic_id'])!,
      accuracyPct: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}accuracy_pct'])!,
      attemptsCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}attempts_count'])!,
      lastAttemptedAt: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_attempted_at'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ProgressTableTable createAlias(String alias) {
    return $ProgressTableTable(attachedDatabase, alias);
  }
}

class ProgressTableData extends DataClass
    implements Insertable<ProgressTableData> {
  final String id;
  final String topicId;
  final double accuracyPct;
  final int attemptsCount;
  final DateTime lastAttemptedAt;
  final bool synced;
  const ProgressTableData(
      {required this.id,
      required this.topicId,
      required this.accuracyPct,
      required this.attemptsCount,
      required this.lastAttemptedAt,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['topic_id'] = Variable<String>(topicId);
    map['accuracy_pct'] = Variable<double>(accuracyPct);
    map['attempts_count'] = Variable<int>(attemptsCount);
    map['last_attempted_at'] = Variable<DateTime>(lastAttemptedAt);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ProgressTableCompanion toCompanion(bool nullToAbsent) {
    return ProgressTableCompanion(
      id: Value(id),
      topicId: Value(topicId),
      accuracyPct: Value(accuracyPct),
      attemptsCount: Value(attemptsCount),
      lastAttemptedAt: Value(lastAttemptedAt),
      synced: Value(synced),
    );
  }

  factory ProgressTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgressTableData(
      id: serializer.fromJson<String>(json['id']),
      topicId: serializer.fromJson<String>(json['topicId']),
      accuracyPct: serializer.fromJson<double>(json['accuracyPct']),
      attemptsCount: serializer.fromJson<int>(json['attemptsCount']),
      lastAttemptedAt: serializer.fromJson<DateTime>(json['lastAttemptedAt']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'topicId': serializer.toJson<String>(topicId),
      'accuracyPct': serializer.toJson<double>(accuracyPct),
      'attemptsCount': serializer.toJson<int>(attemptsCount),
      'lastAttemptedAt': serializer.toJson<DateTime>(lastAttemptedAt),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ProgressTableData copyWith(
          {String? id,
          String? topicId,
          double? accuracyPct,
          int? attemptsCount,
          DateTime? lastAttemptedAt,
          bool? synced}) =>
      ProgressTableData(
        id: id ?? this.id,
        topicId: topicId ?? this.topicId,
        accuracyPct: accuracyPct ?? this.accuracyPct,
        attemptsCount: attemptsCount ?? this.attemptsCount,
        lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
        synced: synced ?? this.synced,
      );
  ProgressTableData copyWithCompanion(ProgressTableCompanion data) {
    return ProgressTableData(
      id: data.id.present ? data.id.value : this.id,
      topicId: data.topicId.present ? data.topicId.value : this.topicId,
      accuracyPct:
          data.accuracyPct.present ? data.accuracyPct.value : this.accuracyPct,
      attemptsCount: data.attemptsCount.present
          ? data.attemptsCount.value
          : this.attemptsCount,
      lastAttemptedAt: data.lastAttemptedAt.present
          ? data.lastAttemptedAt.value
          : this.lastAttemptedAt,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgressTableData(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('accuracyPct: $accuracyPct, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, topicId, accuracyPct, attemptsCount, lastAttemptedAt, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgressTableData &&
          other.id == this.id &&
          other.topicId == this.topicId &&
          other.accuracyPct == this.accuracyPct &&
          other.attemptsCount == this.attemptsCount &&
          other.lastAttemptedAt == this.lastAttemptedAt &&
          other.synced == this.synced);
}

class ProgressTableCompanion extends UpdateCompanion<ProgressTableData> {
  final Value<String> id;
  final Value<String> topicId;
  final Value<double> accuracyPct;
  final Value<int> attemptsCount;
  final Value<DateTime> lastAttemptedAt;
  final Value<bool> synced;
  final Value<int> rowid;
  const ProgressTableCompanion({
    this.id = const Value.absent(),
    this.topicId = const Value.absent(),
    this.accuracyPct = const Value.absent(),
    this.attemptsCount = const Value.absent(),
    this.lastAttemptedAt = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgressTableCompanion.insert({
    required String id,
    required String topicId,
    required double accuracyPct,
    required int attemptsCount,
    required DateTime lastAttemptedAt,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        topicId = Value(topicId),
        accuracyPct = Value(accuracyPct),
        attemptsCount = Value(attemptsCount),
        lastAttemptedAt = Value(lastAttemptedAt);
  static Insertable<ProgressTableData> custom({
    Expression<String>? id,
    Expression<String>? topicId,
    Expression<double>? accuracyPct,
    Expression<int>? attemptsCount,
    Expression<DateTime>? lastAttemptedAt,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (topicId != null) 'topic_id': topicId,
      if (accuracyPct != null) 'accuracy_pct': accuracyPct,
      if (attemptsCount != null) 'attempts_count': attemptsCount,
      if (lastAttemptedAt != null) 'last_attempted_at': lastAttemptedAt,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgressTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? topicId,
      Value<double>? accuracyPct,
      Value<int>? attemptsCount,
      Value<DateTime>? lastAttemptedAt,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return ProgressTableCompanion(
      id: id ?? this.id,
      topicId: topicId ?? this.topicId,
      accuracyPct: accuracyPct ?? this.accuracyPct,
      attemptsCount: attemptsCount ?? this.attemptsCount,
      lastAttemptedAt: lastAttemptedAt ?? this.lastAttemptedAt,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (topicId.present) {
      map['topic_id'] = Variable<String>(topicId.value);
    }
    if (accuracyPct.present) {
      map['accuracy_pct'] = Variable<double>(accuracyPct.value);
    }
    if (attemptsCount.present) {
      map['attempts_count'] = Variable<int>(attemptsCount.value);
    }
    if (lastAttemptedAt.present) {
      map['last_attempted_at'] = Variable<DateTime>(lastAttemptedAt.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('topicId: $topicId, ')
          ..write('accuracyPct: $accuracyPct, ')
          ..write('attemptsCount: $attemptsCount, ')
          ..write('lastAttemptedAt: $lastAttemptedAt, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
      'action', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _payloadJsonMeta =
      const VerificationMeta('payloadJson');
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
      'payload_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, action, payloadJson, synced, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(Insertable<SyncQueueData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('action')) {
      context.handle(_actionMeta,
          action.isAcceptableOrUnknown(data['action']!, _actionMeta));
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
          _payloadJsonMeta,
          payloadJson.isAcceptableOrUnknown(
              data['payload_json']!, _payloadJsonMeta));
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      action: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}action'])!,
      payloadJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}payload_json'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String action;
  final String payloadJson;
  final bool synced;
  final DateTime createdAt;
  const SyncQueueData(
      {required this.id,
      required this.action,
      required this.payloadJson,
      required this.synced,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['action'] = Variable<String>(action);
    map['payload_json'] = Variable<String>(payloadJson);
    map['synced'] = Variable<bool>(synced);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      action: Value(action),
      payloadJson: Value(payloadJson),
      synced: Value(synced),
      createdAt: Value(createdAt),
    );
  }

  factory SyncQueueData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      action: serializer.fromJson<String>(json['action']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      synced: serializer.fromJson<bool>(json['synced']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'action': serializer.toJson<String>(action),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'synced': serializer.toJson<bool>(synced),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncQueueData copyWith(
          {int? id,
          String? action,
          String? payloadJson,
          bool? synced,
          DateTime? createdAt}) =>
      SyncQueueData(
        id: id ?? this.id,
        action: action ?? this.action,
        payloadJson: payloadJson ?? this.payloadJson,
        synced: synced ?? this.synced,
        createdAt: createdAt ?? this.createdAt,
      );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      action: data.action.present ? data.action.value : this.action,
      payloadJson:
          data.payloadJson.present ? data.payloadJson.value : this.payloadJson,
      synced: data.synced.present ? data.synced.value : this.synced,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, action, payloadJson, synced, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.action == this.action &&
          other.payloadJson == this.payloadJson &&
          other.synced == this.synced &&
          other.createdAt == this.createdAt);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> action;
  final Value<String> payloadJson;
  final Value<bool> synced;
  final Value<DateTime> createdAt;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.action = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.synced = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String action,
    required String payloadJson,
    this.synced = const Value.absent(),
    required DateTime createdAt,
  })  : action = Value(action),
        payloadJson = Value(payloadJson),
        createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? action,
    Expression<String>? payloadJson,
    Expression<bool>? synced,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (action != null) 'action': action,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (synced != null) 'synced': synced,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SyncQueueCompanion copyWith(
      {Value<int>? id,
      Value<String>? action,
      Value<String>? payloadJson,
      Value<bool>? synced,
      Value<DateTime>? createdAt}) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      action: action ?? this.action,
      payloadJson: payloadJson ?? this.payloadJson,
      synced: synced ?? this.synced,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('action: $action, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('synced: $synced, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExamSessionsTable extends ExamSessions
    with TableInfo<$ExamSessionsTable, ExamSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _examConfigJsonMeta =
      const VerificationMeta('examConfigJson');
  @override
  late final GeneratedColumn<String> examConfigJson = GeneratedColumn<String>(
      'exam_config_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionsJsonMeta =
      const VerificationMeta('questionsJson');
  @override
  late final GeneratedColumn<String> questionsJson = GeneratedColumn<String>(
      'questions_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _answersJsonMeta =
      const VerificationMeta('answersJson');
  @override
  late final GeneratedColumn<String> answersJson = GeneratedColumn<String>(
      'answers_json', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _startedAtMeta =
      const VerificationMeta('startedAt');
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
      'started_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _submittedAtMeta =
      const VerificationMeta('submittedAt');
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
      'submitted_at', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<int> score = GeneratedColumn<int>(
      'score', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        examConfigJson,
        questionsJson,
        answersJson,
        startedAt,
        submittedAt,
        score,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_sessions';
  @override
  VerificationContext validateIntegrity(Insertable<ExamSession> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exam_config_json')) {
      context.handle(
          _examConfigJsonMeta,
          examConfigJson.isAcceptableOrUnknown(
              data['exam_config_json']!, _examConfigJsonMeta));
    } else if (isInserting) {
      context.missing(_examConfigJsonMeta);
    }
    if (data.containsKey('questions_json')) {
      context.handle(
          _questionsJsonMeta,
          questionsJson.isAcceptableOrUnknown(
              data['questions_json']!, _questionsJsonMeta));
    } else if (isInserting) {
      context.missing(_questionsJsonMeta);
    }
    if (data.containsKey('answers_json')) {
      context.handle(
          _answersJsonMeta,
          answersJson.isAcceptableOrUnknown(
              data['answers_json']!, _answersJsonMeta));
    }
    if (data.containsKey('started_at')) {
      context.handle(_startedAtMeta,
          startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta));
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
          _submittedAtMeta,
          submittedAt.isAcceptableOrUnknown(
              data['submitted_at']!, _submittedAtMeta));
    }
    if (data.containsKey('score')) {
      context.handle(
          _scoreMeta, score.isAcceptableOrUnknown(data['score']!, _scoreMeta));
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamSession(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      examConfigJson: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}exam_config_json'])!,
      questionsJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}questions_json'])!,
      answersJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}answers_json']),
      startedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}started_at'])!,
      submittedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}submitted_at']),
      score: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}score']),
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $ExamSessionsTable createAlias(String alias) {
    return $ExamSessionsTable(attachedDatabase, alias);
  }
}

class ExamSession extends DataClass implements Insertable<ExamSession> {
  final String id;
  final String examConfigJson;
  final String questionsJson;
  final String? answersJson;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final int? score;
  final bool synced;
  const ExamSession(
      {required this.id,
      required this.examConfigJson,
      required this.questionsJson,
      this.answersJson,
      required this.startedAt,
      this.submittedAt,
      this.score,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exam_config_json'] = Variable<String>(examConfigJson);
    map['questions_json'] = Variable<String>(questionsJson);
    if (!nullToAbsent || answersJson != null) {
      map['answers_json'] = Variable<String>(answersJson);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<int>(score);
    }
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  ExamSessionsCompanion toCompanion(bool nullToAbsent) {
    return ExamSessionsCompanion(
      id: Value(id),
      examConfigJson: Value(examConfigJson),
      questionsJson: Value(questionsJson),
      answersJson: answersJson == null && nullToAbsent
          ? const Value.absent()
          : Value(answersJson),
      startedAt: Value(startedAt),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
      score:
          score == null && nullToAbsent ? const Value.absent() : Value(score),
      synced: Value(synced),
    );
  }

  factory ExamSession.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamSession(
      id: serializer.fromJson<String>(json['id']),
      examConfigJson: serializer.fromJson<String>(json['examConfigJson']),
      questionsJson: serializer.fromJson<String>(json['questionsJson']),
      answersJson: serializer.fromJson<String?>(json['answersJson']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
      score: serializer.fromJson<int?>(json['score']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'examConfigJson': serializer.toJson<String>(examConfigJson),
      'questionsJson': serializer.toJson<String>(questionsJson),
      'answersJson': serializer.toJson<String?>(answersJson),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
      'score': serializer.toJson<int?>(score),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  ExamSession copyWith(
          {String? id,
          String? examConfigJson,
          String? questionsJson,
          Value<String?> answersJson = const Value.absent(),
          DateTime? startedAt,
          Value<DateTime?> submittedAt = const Value.absent(),
          Value<int?> score = const Value.absent(),
          bool? synced}) =>
      ExamSession(
        id: id ?? this.id,
        examConfigJson: examConfigJson ?? this.examConfigJson,
        questionsJson: questionsJson ?? this.questionsJson,
        answersJson: answersJson.present ? answersJson.value : this.answersJson,
        startedAt: startedAt ?? this.startedAt,
        submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
        score: score.present ? score.value : this.score,
        synced: synced ?? this.synced,
      );
  ExamSession copyWithCompanion(ExamSessionsCompanion data) {
    return ExamSession(
      id: data.id.present ? data.id.value : this.id,
      examConfigJson: data.examConfigJson.present
          ? data.examConfigJson.value
          : this.examConfigJson,
      questionsJson: data.questionsJson.present
          ? data.questionsJson.value
          : this.questionsJson,
      answersJson:
          data.answersJson.present ? data.answersJson.value : this.answersJson,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      submittedAt:
          data.submittedAt.present ? data.submittedAt.value : this.submittedAt,
      score: data.score.present ? data.score.value : this.score,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamSession(')
          ..write('id: $id, ')
          ..write('examConfigJson: $examConfigJson, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('answersJson: $answersJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('score: $score, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, examConfigJson, questionsJson,
      answersJson, startedAt, submittedAt, score, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamSession &&
          other.id == this.id &&
          other.examConfigJson == this.examConfigJson &&
          other.questionsJson == this.questionsJson &&
          other.answersJson == this.answersJson &&
          other.startedAt == this.startedAt &&
          other.submittedAt == this.submittedAt &&
          other.score == this.score &&
          other.synced == this.synced);
}

class ExamSessionsCompanion extends UpdateCompanion<ExamSession> {
  final Value<String> id;
  final Value<String> examConfigJson;
  final Value<String> questionsJson;
  final Value<String?> answersJson;
  final Value<DateTime> startedAt;
  final Value<DateTime?> submittedAt;
  final Value<int?> score;
  final Value<bool> synced;
  final Value<int> rowid;
  const ExamSessionsCompanion({
    this.id = const Value.absent(),
    this.examConfigJson = const Value.absent(),
    this.questionsJson = const Value.absent(),
    this.answersJson = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExamSessionsCompanion.insert({
    required String id,
    required String examConfigJson,
    required String questionsJson,
    this.answersJson = const Value.absent(),
    required DateTime startedAt,
    this.submittedAt = const Value.absent(),
    this.score = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        examConfigJson = Value(examConfigJson),
        questionsJson = Value(questionsJson),
        startedAt = Value(startedAt);
  static Insertable<ExamSession> custom({
    Expression<String>? id,
    Expression<String>? examConfigJson,
    Expression<String>? questionsJson,
    Expression<String>? answersJson,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? submittedAt,
    Expression<int>? score,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examConfigJson != null) 'exam_config_json': examConfigJson,
      if (questionsJson != null) 'questions_json': questionsJson,
      if (answersJson != null) 'answers_json': answersJson,
      if (startedAt != null) 'started_at': startedAt,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (score != null) 'score': score,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExamSessionsCompanion copyWith(
      {Value<String>? id,
      Value<String>? examConfigJson,
      Value<String>? questionsJson,
      Value<String?>? answersJson,
      Value<DateTime>? startedAt,
      Value<DateTime?>? submittedAt,
      Value<int?>? score,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return ExamSessionsCompanion(
      id: id ?? this.id,
      examConfigJson: examConfigJson ?? this.examConfigJson,
      questionsJson: questionsJson ?? this.questionsJson,
      answersJson: answersJson ?? this.answersJson,
      startedAt: startedAt ?? this.startedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      score: score ?? this.score,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (examConfigJson.present) {
      map['exam_config_json'] = Variable<String>(examConfigJson.value);
    }
    if (questionsJson.present) {
      map['questions_json'] = Variable<String>(questionsJson.value);
    }
    if (answersJson.present) {
      map['answers_json'] = Variable<String>(answersJson.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (score.present) {
      map['score'] = Variable<int>(score.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamSessionsCompanion(')
          ..write('id: $id, ')
          ..write('examConfigJson: $examConfigJson, ')
          ..write('questionsJson: $questionsJson, ')
          ..write('answersJson: $answersJson, ')
          ..write('startedAt: $startedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('score: $score, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AiExplanationCacheTable extends AiExplanationCache
    with TableInfo<$AiExplanationCacheTable, AiExplanationCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AiExplanationCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _languageMeta =
      const VerificationMeta('language');
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
      'language', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _explanationMeta =
      const VerificationMeta('explanation');
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
      'explanation', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _generatedAtMeta =
      const VerificationMeta('generatedAt');
  @override
  late final GeneratedColumn<DateTime> generatedAt = GeneratedColumn<DateTime>(
      'generated_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, questionId, language, explanation, generatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_explanation_cache';
  @override
  VerificationContext validateIntegrity(
      Insertable<AiExplanationCacheData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(_languageMeta,
          language.isAcceptableOrUnknown(data['language']!, _languageMeta));
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
          _explanationMeta,
          explanation.isAcceptableOrUnknown(
              data['explanation']!, _explanationMeta));
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    if (data.containsKey('generated_at')) {
      context.handle(
          _generatedAtMeta,
          generatedAt.isAcceptableOrUnknown(
              data['generated_at']!, _generatedAtMeta));
    } else if (isInserting) {
      context.missing(_generatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiExplanationCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiExplanationCacheData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      language: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}language'])!,
      explanation: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}explanation'])!,
      generatedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}generated_at'])!,
    );
  }

  @override
  $AiExplanationCacheTable createAlias(String alias) {
    return $AiExplanationCacheTable(attachedDatabase, alias);
  }
}

class AiExplanationCacheData extends DataClass
    implements Insertable<AiExplanationCacheData> {
  final String id;
  final String questionId;
  final String language;
  final String explanation;
  final DateTime generatedAt;
  const AiExplanationCacheData(
      {required this.id,
      required this.questionId,
      required this.language,
      required this.explanation,
      required this.generatedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['question_id'] = Variable<String>(questionId);
    map['language'] = Variable<String>(language);
    map['explanation'] = Variable<String>(explanation);
    map['generated_at'] = Variable<DateTime>(generatedAt);
    return map;
  }

  AiExplanationCacheCompanion toCompanion(bool nullToAbsent) {
    return AiExplanationCacheCompanion(
      id: Value(id),
      questionId: Value(questionId),
      language: Value(language),
      explanation: Value(explanation),
      generatedAt: Value(generatedAt),
    );
  }

  factory AiExplanationCacheData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiExplanationCacheData(
      id: serializer.fromJson<String>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      language: serializer.fromJson<String>(json['language']),
      explanation: serializer.fromJson<String>(json['explanation']),
      generatedAt: serializer.fromJson<DateTime>(json['generatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'questionId': serializer.toJson<String>(questionId),
      'language': serializer.toJson<String>(language),
      'explanation': serializer.toJson<String>(explanation),
      'generatedAt': serializer.toJson<DateTime>(generatedAt),
    };
  }

  AiExplanationCacheData copyWith(
          {String? id,
          String? questionId,
          String? language,
          String? explanation,
          DateTime? generatedAt}) =>
      AiExplanationCacheData(
        id: id ?? this.id,
        questionId: questionId ?? this.questionId,
        language: language ?? this.language,
        explanation: explanation ?? this.explanation,
        generatedAt: generatedAt ?? this.generatedAt,
      );
  AiExplanationCacheData copyWithCompanion(AiExplanationCacheCompanion data) {
    return AiExplanationCacheData(
      id: data.id.present ? data.id.value : this.id,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      language: data.language.present ? data.language.value : this.language,
      explanation:
          data.explanation.present ? data.explanation.value : this.explanation,
      generatedAt:
          data.generatedAt.present ? data.generatedAt.value : this.generatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiExplanationCacheData(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('language: $language, ')
          ..write('explanation: $explanation, ')
          ..write('generatedAt: $generatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questionId, language, explanation, generatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiExplanationCacheData &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.language == this.language &&
          other.explanation == this.explanation &&
          other.generatedAt == this.generatedAt);
}

class AiExplanationCacheCompanion
    extends UpdateCompanion<AiExplanationCacheData> {
  final Value<String> id;
  final Value<String> questionId;
  final Value<String> language;
  final Value<String> explanation;
  final Value<DateTime> generatedAt;
  final Value<int> rowid;
  const AiExplanationCacheCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.language = const Value.absent(),
    this.explanation = const Value.absent(),
    this.generatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AiExplanationCacheCompanion.insert({
    required String id,
    required String questionId,
    required String language,
    required String explanation,
    required DateTime generatedAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        questionId = Value(questionId),
        language = Value(language),
        explanation = Value(explanation),
        generatedAt = Value(generatedAt);
  static Insertable<AiExplanationCacheData> custom({
    Expression<String>? id,
    Expression<String>? questionId,
    Expression<String>? language,
    Expression<String>? explanation,
    Expression<DateTime>? generatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (language != null) 'language': language,
      if (explanation != null) 'explanation': explanation,
      if (generatedAt != null) 'generated_at': generatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AiExplanationCacheCompanion copyWith(
      {Value<String>? id,
      Value<String>? questionId,
      Value<String>? language,
      Value<String>? explanation,
      Value<DateTime>? generatedAt,
      Value<int>? rowid}) {
    return AiExplanationCacheCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      language: language ?? this.language,
      explanation: explanation ?? this.explanation,
      generatedAt: generatedAt ?? this.generatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (generatedAt.present) {
      map['generated_at'] = Variable<DateTime>(generatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiExplanationCacheCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('language: $language, ')
          ..write('explanation: $explanation, ')
          ..write('generatedAt: $generatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FlashcardCardsTable extends FlashcardCards
    with TableInfo<$FlashcardCardsTable, FlashcardCard> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FlashcardCardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
      'deck_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionIdMeta =
      const VerificationMeta('questionId');
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
      'question_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _intervalDaysMeta =
      const VerificationMeta('intervalDays');
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
      'interval_days', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _easeFactorMeta =
      const VerificationMeta('easeFactor');
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
      'ease_factor', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dueDateMeta =
      const VerificationMeta('dueDate');
  @override
  late final GeneratedColumn<DateTime> dueDate = GeneratedColumn<DateTime>(
      'due_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _repetitionsMeta =
      const VerificationMeta('repetitions');
  @override
  late final GeneratedColumn<int> repetitions = GeneratedColumn<int>(
      'repetitions', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _syncedMeta = const VerificationMeta('synced');
  @override
  late final GeneratedColumn<bool> synced = GeneratedColumn<bool>(
      'synced', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("synced" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        deckId,
        questionId,
        intervalDays,
        easeFactor,
        dueDate,
        repetitions,
        synced
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'flashcard_cards';
  @override
  VerificationContext validateIntegrity(Insertable<FlashcardCard> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(_deckIdMeta,
          deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta));
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
          _questionIdMeta,
          questionId.isAcceptableOrUnknown(
              data['question_id']!, _questionIdMeta));
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('interval_days')) {
      context.handle(
          _intervalDaysMeta,
          intervalDays.isAcceptableOrUnknown(
              data['interval_days']!, _intervalDaysMeta));
    } else if (isInserting) {
      context.missing(_intervalDaysMeta);
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
          _easeFactorMeta,
          easeFactor.isAcceptableOrUnknown(
              data['ease_factor']!, _easeFactorMeta));
    } else if (isInserting) {
      context.missing(_easeFactorMeta);
    }
    if (data.containsKey('due_date')) {
      context.handle(_dueDateMeta,
          dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta));
    } else if (isInserting) {
      context.missing(_dueDateMeta);
    }
    if (data.containsKey('repetitions')) {
      context.handle(
          _repetitionsMeta,
          repetitions.isAcceptableOrUnknown(
              data['repetitions']!, _repetitionsMeta));
    } else if (isInserting) {
      context.missing(_repetitionsMeta);
    }
    if (data.containsKey('synced')) {
      context.handle(_syncedMeta,
          synced.isAcceptableOrUnknown(data['synced']!, _syncedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FlashcardCard map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FlashcardCard(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      deckId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}deck_id'])!,
      questionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}question_id'])!,
      intervalDays: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}interval_days'])!,
      easeFactor: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}ease_factor'])!,
      dueDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}due_date'])!,
      repetitions: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}repetitions'])!,
      synced: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}synced'])!,
    );
  }

  @override
  $FlashcardCardsTable createAlias(String alias) {
    return $FlashcardCardsTable(attachedDatabase, alias);
  }
}

class FlashcardCard extends DataClass implements Insertable<FlashcardCard> {
  final String id;
  final String deckId;
  final String questionId;
  final int intervalDays;
  final double easeFactor;
  final DateTime dueDate;
  final int repetitions;
  final bool synced;
  const FlashcardCard(
      {required this.id,
      required this.deckId,
      required this.questionId,
      required this.intervalDays,
      required this.easeFactor,
      required this.dueDate,
      required this.repetitions,
      required this.synced});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['question_id'] = Variable<String>(questionId);
    map['interval_days'] = Variable<int>(intervalDays);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['due_date'] = Variable<DateTime>(dueDate);
    map['repetitions'] = Variable<int>(repetitions);
    map['synced'] = Variable<bool>(synced);
    return map;
  }

  FlashcardCardsCompanion toCompanion(bool nullToAbsent) {
    return FlashcardCardsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      questionId: Value(questionId),
      intervalDays: Value(intervalDays),
      easeFactor: Value(easeFactor),
      dueDate: Value(dueDate),
      repetitions: Value(repetitions),
      synced: Value(synced),
    );
  }

  factory FlashcardCard.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FlashcardCard(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      dueDate: serializer.fromJson<DateTime>(json['dueDate']),
      repetitions: serializer.fromJson<int>(json['repetitions']),
      synced: serializer.fromJson<bool>(json['synced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'questionId': serializer.toJson<String>(questionId),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'dueDate': serializer.toJson<DateTime>(dueDate),
      'repetitions': serializer.toJson<int>(repetitions),
      'synced': serializer.toJson<bool>(synced),
    };
  }

  FlashcardCard copyWith(
          {String? id,
          String? deckId,
          String? questionId,
          int? intervalDays,
          double? easeFactor,
          DateTime? dueDate,
          int? repetitions,
          bool? synced}) =>
      FlashcardCard(
        id: id ?? this.id,
        deckId: deckId ?? this.deckId,
        questionId: questionId ?? this.questionId,
        intervalDays: intervalDays ?? this.intervalDays,
        easeFactor: easeFactor ?? this.easeFactor,
        dueDate: dueDate ?? this.dueDate,
        repetitions: repetitions ?? this.repetitions,
        synced: synced ?? this.synced,
      );
  FlashcardCard copyWithCompanion(FlashcardCardsCompanion data) {
    return FlashcardCard(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      questionId:
          data.questionId.present ? data.questionId.value : this.questionId,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      easeFactor:
          data.easeFactor.present ? data.easeFactor.value : this.easeFactor,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      repetitions:
          data.repetitions.present ? data.repetitions.value : this.repetitions,
      synced: data.synced.present ? data.synced.value : this.synced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardCard(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('questionId: $questionId, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('dueDate: $dueDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('synced: $synced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, deckId, questionId, intervalDays,
      easeFactor, dueDate, repetitions, synced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FlashcardCard &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.questionId == this.questionId &&
          other.intervalDays == this.intervalDays &&
          other.easeFactor == this.easeFactor &&
          other.dueDate == this.dueDate &&
          other.repetitions == this.repetitions &&
          other.synced == this.synced);
}

class FlashcardCardsCompanion extends UpdateCompanion<FlashcardCard> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> questionId;
  final Value<int> intervalDays;
  final Value<double> easeFactor;
  final Value<DateTime> dueDate;
  final Value<int> repetitions;
  final Value<bool> synced;
  final Value<int> rowid;
  const FlashcardCardsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.repetitions = const Value.absent(),
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FlashcardCardsCompanion.insert({
    required String id,
    required String deckId,
    required String questionId,
    required int intervalDays,
    required double easeFactor,
    required DateTime dueDate,
    required int repetitions,
    this.synced = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        deckId = Value(deckId),
        questionId = Value(questionId),
        intervalDays = Value(intervalDays),
        easeFactor = Value(easeFactor),
        dueDate = Value(dueDate),
        repetitions = Value(repetitions);
  static Insertable<FlashcardCard> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? questionId,
    Expression<int>? intervalDays,
    Expression<double>? easeFactor,
    Expression<DateTime>? dueDate,
    Expression<int>? repetitions,
    Expression<bool>? synced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (questionId != null) 'question_id': questionId,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (dueDate != null) 'due_date': dueDate,
      if (repetitions != null) 'repetitions': repetitions,
      if (synced != null) 'synced': synced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FlashcardCardsCompanion copyWith(
      {Value<String>? id,
      Value<String>? deckId,
      Value<String>? questionId,
      Value<int>? intervalDays,
      Value<double>? easeFactor,
      Value<DateTime>? dueDate,
      Value<int>? repetitions,
      Value<bool>? synced,
      Value<int>? rowid}) {
    return FlashcardCardsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      questionId: questionId ?? this.questionId,
      intervalDays: intervalDays ?? this.intervalDays,
      easeFactor: easeFactor ?? this.easeFactor,
      dueDate: dueDate ?? this.dueDate,
      repetitions: repetitions ?? this.repetitions,
      synced: synced ?? this.synced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<DateTime>(dueDate.value);
    }
    if (repetitions.present) {
      map['repetitions'] = Variable<int>(repetitions.value);
    }
    if (synced.present) {
      map['synced'] = Variable<bool>(synced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FlashcardCardsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('questionId: $questionId, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('dueDate: $dueDate, ')
          ..write('repetitions: $repetitions, ')
          ..write('synced: $synced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubjectsTable extends Subjects with TableInfo<$SubjectsTable, Subject> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _examTypeMeta =
      const VerificationMeta('examType');
  @override
  late final GeneratedColumn<String> examType = GeneratedColumn<String>(
      'exam_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _questionCountMeta =
      const VerificationMeta('questionCount');
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
      'question_count', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _downloadSizeMbMeta =
      const VerificationMeta('downloadSizeMb');
  @override
  late final GeneratedColumn<int> downloadSizeMb = GeneratedColumn<int>(
      'download_size_mb', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versionHashMeta =
      const VerificationMeta('versionHash');
  @override
  late final GeneratedColumn<String> versionHash = GeneratedColumn<String>(
      'version_hash', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDownloadedMeta =
      const VerificationMeta('isDownloaded');
  @override
  late final GeneratedColumn<bool> isDownloaded = GeneratedColumn<bool>(
      'is_downloaded', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_downloaded" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastUpdatedMeta =
      const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
      'last_updated', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        examType,
        questionCount,
        downloadSizeMb,
        versionHash,
        isDownloaded,
        lastUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subjects';
  @override
  VerificationContext validateIntegrity(Insertable<Subject> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('exam_type')) {
      context.handle(_examTypeMeta,
          examType.isAcceptableOrUnknown(data['exam_type']!, _examTypeMeta));
    } else if (isInserting) {
      context.missing(_examTypeMeta);
    }
    if (data.containsKey('question_count')) {
      context.handle(
          _questionCountMeta,
          questionCount.isAcceptableOrUnknown(
              data['question_count']!, _questionCountMeta));
    } else if (isInserting) {
      context.missing(_questionCountMeta);
    }
    if (data.containsKey('download_size_mb')) {
      context.handle(
          _downloadSizeMbMeta,
          downloadSizeMb.isAcceptableOrUnknown(
              data['download_size_mb']!, _downloadSizeMbMeta));
    } else if (isInserting) {
      context.missing(_downloadSizeMbMeta);
    }
    if (data.containsKey('version_hash')) {
      context.handle(
          _versionHashMeta,
          versionHash.isAcceptableOrUnknown(
              data['version_hash']!, _versionHashMeta));
    } else if (isInserting) {
      context.missing(_versionHashMeta);
    }
    if (data.containsKey('is_downloaded')) {
      context.handle(
          _isDownloadedMeta,
          isDownloaded.isAcceptableOrUnknown(
              data['is_downloaded']!, _isDownloadedMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(
          _lastUpdatedMeta,
          lastUpdated.isAcceptableOrUnknown(
              data['last_updated']!, _lastUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Subject map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Subject(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      examType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}exam_type'])!,
      questionCount: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}question_count'])!,
      downloadSizeMb: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}download_size_mb'])!,
      versionHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version_hash'])!,
      isDownloaded: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_downloaded'])!,
      lastUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated']),
    );
  }

  @override
  $SubjectsTable createAlias(String alias) {
    return $SubjectsTable(attachedDatabase, alias);
  }
}

class Subject extends DataClass implements Insertable<Subject> {
  final String id;
  final String name;
  final String examType;
  final int questionCount;
  final int downloadSizeMb;
  final String versionHash;
  final bool isDownloaded;
  final DateTime? lastUpdated;
  const Subject(
      {required this.id,
      required this.name,
      required this.examType,
      required this.questionCount,
      required this.downloadSizeMb,
      required this.versionHash,
      required this.isDownloaded,
      this.lastUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['exam_type'] = Variable<String>(examType);
    map['question_count'] = Variable<int>(questionCount);
    map['download_size_mb'] = Variable<int>(downloadSizeMb);
    map['version_hash'] = Variable<String>(versionHash);
    map['is_downloaded'] = Variable<bool>(isDownloaded);
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    return map;
  }

  SubjectsCompanion toCompanion(bool nullToAbsent) {
    return SubjectsCompanion(
      id: Value(id),
      name: Value(name),
      examType: Value(examType),
      questionCount: Value(questionCount),
      downloadSizeMb: Value(downloadSizeMb),
      versionHash: Value(versionHash),
      isDownloaded: Value(isDownloaded),
      lastUpdated: lastUpdated == null && nullToAbsent
          ? const Value.absent()
          : Value(lastUpdated),
    );
  }

  factory Subject.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Subject(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      examType: serializer.fromJson<String>(json['examType']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
      downloadSizeMb: serializer.fromJson<int>(json['downloadSizeMb']),
      versionHash: serializer.fromJson<String>(json['versionHash']),
      isDownloaded: serializer.fromJson<bool>(json['isDownloaded']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'examType': serializer.toJson<String>(examType),
      'questionCount': serializer.toJson<int>(questionCount),
      'downloadSizeMb': serializer.toJson<int>(downloadSizeMb),
      'versionHash': serializer.toJson<String>(versionHash),
      'isDownloaded': serializer.toJson<bool>(isDownloaded),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
    };
  }

  Subject copyWith(
          {String? id,
          String? name,
          String? examType,
          int? questionCount,
          int? downloadSizeMb,
          String? versionHash,
          bool? isDownloaded,
          Value<DateTime?> lastUpdated = const Value.absent()}) =>
      Subject(
        id: id ?? this.id,
        name: name ?? this.name,
        examType: examType ?? this.examType,
        questionCount: questionCount ?? this.questionCount,
        downloadSizeMb: downloadSizeMb ?? this.downloadSizeMb,
        versionHash: versionHash ?? this.versionHash,
        isDownloaded: isDownloaded ?? this.isDownloaded,
        lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
      );
  Subject copyWithCompanion(SubjectsCompanion data) {
    return Subject(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      examType: data.examType.present ? data.examType.value : this.examType,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      downloadSizeMb: data.downloadSizeMb.present
          ? data.downloadSizeMb.value
          : this.downloadSizeMb,
      versionHash:
          data.versionHash.present ? data.versionHash.value : this.versionHash,
      isDownloaded: data.isDownloaded.present
          ? data.isDownloaded.value
          : this.isDownloaded,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Subject(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('examType: $examType, ')
          ..write('questionCount: $questionCount, ')
          ..write('downloadSizeMb: $downloadSizeMb, ')
          ..write('versionHash: $versionHash, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('lastUpdated: $lastUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, examType, questionCount,
      downloadSizeMb, versionHash, isDownloaded, lastUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Subject &&
          other.id == this.id &&
          other.name == this.name &&
          other.examType == this.examType &&
          other.questionCount == this.questionCount &&
          other.downloadSizeMb == this.downloadSizeMb &&
          other.versionHash == this.versionHash &&
          other.isDownloaded == this.isDownloaded &&
          other.lastUpdated == this.lastUpdated);
}

class SubjectsCompanion extends UpdateCompanion<Subject> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> examType;
  final Value<int> questionCount;
  final Value<int> downloadSizeMb;
  final Value<String> versionHash;
  final Value<bool> isDownloaded;
  final Value<DateTime?> lastUpdated;
  final Value<int> rowid;
  const SubjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.examType = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.downloadSizeMb = const Value.absent(),
    this.versionHash = const Value.absent(),
    this.isDownloaded = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubjectsCompanion.insert({
    required String id,
    required String name,
    required String examType,
    required int questionCount,
    required int downloadSizeMb,
    required String versionHash,
    this.isDownloaded = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        examType = Value(examType),
        questionCount = Value(questionCount),
        downloadSizeMb = Value(downloadSizeMb),
        versionHash = Value(versionHash);
  static Insertable<Subject> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? examType,
    Expression<int>? questionCount,
    Expression<int>? downloadSizeMb,
    Expression<String>? versionHash,
    Expression<bool>? isDownloaded,
    Expression<DateTime>? lastUpdated,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (examType != null) 'exam_type': examType,
      if (questionCount != null) 'question_count': questionCount,
      if (downloadSizeMb != null) 'download_size_mb': downloadSizeMb,
      if (versionHash != null) 'version_hash': versionHash,
      if (isDownloaded != null) 'is_downloaded': isDownloaded,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? examType,
      Value<int>? questionCount,
      Value<int>? downloadSizeMb,
      Value<String>? versionHash,
      Value<bool>? isDownloaded,
      Value<DateTime?>? lastUpdated,
      Value<int>? rowid}) {
    return SubjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      examType: examType ?? this.examType,
      questionCount: questionCount ?? this.questionCount,
      downloadSizeMb: downloadSizeMb ?? this.downloadSizeMb,
      versionHash: versionHash ?? this.versionHash,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (examType.present) {
      map['exam_type'] = Variable<String>(examType.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (downloadSizeMb.present) {
      map['download_size_mb'] = Variable<int>(downloadSizeMb.value);
    }
    if (versionHash.present) {
      map['version_hash'] = Variable<String>(versionHash.value);
    }
    if (isDownloaded.present) {
      map['is_downloaded'] = Variable<bool>(isDownloaded.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('examType: $examType, ')
          ..write('questionCount: $questionCount, ')
          ..write('downloadSizeMb: $downloadSizeMb, ')
          ..write('versionHash: $versionHash, ')
          ..write('isDownloaded: $isDownloaded, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $QuestionsTable questions = $QuestionsTable(this);
  late final $ProgressTableTable progressTable = $ProgressTableTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final $ExamSessionsTable examSessions = $ExamSessionsTable(this);
  late final $AiExplanationCacheTable aiExplanationCache =
      $AiExplanationCacheTable(this);
  late final $FlashcardCardsTable flashcardCards = $FlashcardCardsTable(this);
  late final $SubjectsTable subjects = $SubjectsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        questions,
        progressTable,
        syncQueue,
        examSessions,
        aiExplanationCache,
        flashcardCards,
        subjects
      ];
}

typedef $$QuestionsTableCreateCompanionBuilder = QuestionsCompanion Function({
  required String id,
  required String subjectId,
  required String topicId,
  required int year,
  required String difficulty,
  required String questionText,
  required String optionA,
  required String optionB,
  required String optionC,
  required String optionD,
  required String correctAnswer,
  Value<String?> explanationEn,
  Value<String?> explanationPidgin,
  required String type,
  required DateTime downloadedAt,
  Value<int> rowid,
});
typedef $$QuestionsTableUpdateCompanionBuilder = QuestionsCompanion Function({
  Value<String> id,
  Value<String> subjectId,
  Value<String> topicId,
  Value<int> year,
  Value<String> difficulty,
  Value<String> questionText,
  Value<String> optionA,
  Value<String> optionB,
  Value<String> optionC,
  Value<String> optionD,
  Value<String> correctAnswer,
  Value<String?> explanationEn,
  Value<String?> explanationPidgin,
  Value<String> type,
  Value<DateTime> downloadedAt,
  Value<int> rowid,
});

class $$QuestionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $QuestionsTable,
    Question,
    $$QuestionsTableFilterComposer,
    $$QuestionsTableOrderingComposer,
    $$QuestionsTableCreateCompanionBuilder,
    $$QuestionsTableUpdateCompanionBuilder> {
  $$QuestionsTableTableManager(_$AppDatabase db, $QuestionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$QuestionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$QuestionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> subjectId = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<int> year = const Value.absent(),
            Value<String> difficulty = const Value.absent(),
            Value<String> questionText = const Value.absent(),
            Value<String> optionA = const Value.absent(),
            Value<String> optionB = const Value.absent(),
            Value<String> optionC = const Value.absent(),
            Value<String> optionD = const Value.absent(),
            Value<String> correctAnswer = const Value.absent(),
            Value<String?> explanationEn = const Value.absent(),
            Value<String?> explanationPidgin = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> downloadedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion(
            id: id,
            subjectId: subjectId,
            topicId: topicId,
            year: year,
            difficulty: difficulty,
            questionText: questionText,
            optionA: optionA,
            optionB: optionB,
            optionC: optionC,
            optionD: optionD,
            correctAnswer: correctAnswer,
            explanationEn: explanationEn,
            explanationPidgin: explanationPidgin,
            type: type,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String subjectId,
            required String topicId,
            required int year,
            required String difficulty,
            required String questionText,
            required String optionA,
            required String optionB,
            required String optionC,
            required String optionD,
            required String correctAnswer,
            Value<String?> explanationEn = const Value.absent(),
            Value<String?> explanationPidgin = const Value.absent(),
            required String type,
            required DateTime downloadedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              QuestionsCompanion.insert(
            id: id,
            subjectId: subjectId,
            topicId: topicId,
            year: year,
            difficulty: difficulty,
            questionText: questionText,
            optionA: optionA,
            optionB: optionB,
            optionC: optionC,
            optionD: optionD,
            correctAnswer: correctAnswer,
            explanationEn: explanationEn,
            explanationPidgin: explanationPidgin,
            type: type,
            downloadedAt: downloadedAt,
            rowid: rowid,
          ),
        ));
}

class $$QuestionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get subjectId => $state.composableBuilder(
      column: $state.table.subjectId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get topicId => $state.composableBuilder(
      column: $state.table.topicId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get year => $state.composableBuilder(
      column: $state.table.year,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get questionText => $state.composableBuilder(
      column: $state.table.questionText,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get optionA => $state.composableBuilder(
      column: $state.table.optionA,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get optionB => $state.composableBuilder(
      column: $state.table.optionB,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get optionC => $state.composableBuilder(
      column: $state.table.optionC,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get optionD => $state.composableBuilder(
      column: $state.table.optionD,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get correctAnswer => $state.composableBuilder(
      column: $state.table.correctAnswer,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get explanationEn => $state.composableBuilder(
      column: $state.table.explanationEn,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get explanationPidgin => $state.composableBuilder(
      column: $state.table.explanationPidgin,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get downloadedAt => $state.composableBuilder(
      column: $state.table.downloadedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$QuestionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $QuestionsTable> {
  $$QuestionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get subjectId => $state.composableBuilder(
      column: $state.table.subjectId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get topicId => $state.composableBuilder(
      column: $state.table.topicId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get year => $state.composableBuilder(
      column: $state.table.year,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get difficulty => $state.composableBuilder(
      column: $state.table.difficulty,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get questionText => $state.composableBuilder(
      column: $state.table.questionText,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get optionA => $state.composableBuilder(
      column: $state.table.optionA,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get optionB => $state.composableBuilder(
      column: $state.table.optionB,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get optionC => $state.composableBuilder(
      column: $state.table.optionC,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get optionD => $state.composableBuilder(
      column: $state.table.optionD,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get correctAnswer => $state.composableBuilder(
      column: $state.table.correctAnswer,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get explanationEn => $state.composableBuilder(
      column: $state.table.explanationEn,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get explanationPidgin => $state.composableBuilder(
      column: $state.table.explanationPidgin,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get downloadedAt => $state.composableBuilder(
      column: $state.table.downloadedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ProgressTableTableCreateCompanionBuilder = ProgressTableCompanion
    Function({
  required String id,
  required String topicId,
  required double accuracyPct,
  required int attemptsCount,
  required DateTime lastAttemptedAt,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$ProgressTableTableUpdateCompanionBuilder = ProgressTableCompanion
    Function({
  Value<String> id,
  Value<String> topicId,
  Value<double> accuracyPct,
  Value<int> attemptsCount,
  Value<DateTime> lastAttemptedAt,
  Value<bool> synced,
  Value<int> rowid,
});

class $$ProgressTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProgressTableTable,
    ProgressTableData,
    $$ProgressTableTableFilterComposer,
    $$ProgressTableTableOrderingComposer,
    $$ProgressTableTableCreateCompanionBuilder,
    $$ProgressTableTableUpdateCompanionBuilder> {
  $$ProgressTableTableTableManager(_$AppDatabase db, $ProgressTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ProgressTableTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ProgressTableTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> topicId = const Value.absent(),
            Value<double> accuracyPct = const Value.absent(),
            Value<int> attemptsCount = const Value.absent(),
            Value<DateTime> lastAttemptedAt = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressTableCompanion(
            id: id,
            topicId: topicId,
            accuracyPct: accuracyPct,
            attemptsCount: attemptsCount,
            lastAttemptedAt: lastAttemptedAt,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String topicId,
            required double accuracyPct,
            required int attemptsCount,
            required DateTime lastAttemptedAt,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProgressTableCompanion.insert(
            id: id,
            topicId: topicId,
            accuracyPct: accuracyPct,
            attemptsCount: attemptsCount,
            lastAttemptedAt: lastAttemptedAt,
            synced: synced,
            rowid: rowid,
          ),
        ));
}

class $$ProgressTableTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ProgressTableTable> {
  $$ProgressTableTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get topicId => $state.composableBuilder(
      column: $state.table.topicId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get accuracyPct => $state.composableBuilder(
      column: $state.table.accuracyPct,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get attemptsCount => $state.composableBuilder(
      column: $state.table.attemptsCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastAttemptedAt => $state.composableBuilder(
      column: $state.table.lastAttemptedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ProgressTableTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ProgressTableTable> {
  $$ProgressTableTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get topicId => $state.composableBuilder(
      column: $state.table.topicId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get accuracyPct => $state.composableBuilder(
      column: $state.table.accuracyPct,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get attemptsCount => $state.composableBuilder(
      column: $state.table.attemptsCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastAttemptedAt => $state.composableBuilder(
      column: $state.table.lastAttemptedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SyncQueueTableCreateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  required String action,
  required String payloadJson,
  Value<bool> synced,
  required DateTime createdAt,
});
typedef $$SyncQueueTableUpdateCompanionBuilder = SyncQueueCompanion Function({
  Value<int> id,
  Value<String> action,
  Value<String> payloadJson,
  Value<bool> synced,
  Value<DateTime> createdAt,
});

class $$SyncQueueTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SyncQueueTable,
    SyncQueueData,
    $$SyncQueueTableFilterComposer,
    $$SyncQueueTableOrderingComposer,
    $$SyncQueueTableCreateCompanionBuilder,
    $$SyncQueueTableUpdateCompanionBuilder> {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SyncQueueTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SyncQueueTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> action = const Value.absent(),
            Value<String> payloadJson = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              SyncQueueCompanion(
            id: id,
            action: action,
            payloadJson: payloadJson,
            synced: synced,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String action,
            required String payloadJson,
            Value<bool> synced = const Value.absent(),
            required DateTime createdAt,
          }) =>
              SyncQueueCompanion.insert(
            id: id,
            action: action,
            payloadJson: payloadJson,
            synced: synced,
            createdAt: createdAt,
          ),
        ));
}

class $$SyncQueueTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer(super.$state);
  ColumnFilters<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SyncQueueTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer(super.$state);
  ColumnOrderings<int> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get action => $state.composableBuilder(
      column: $state.table.action,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get payloadJson => $state.composableBuilder(
      column: $state.table.payloadJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$ExamSessionsTableCreateCompanionBuilder = ExamSessionsCompanion
    Function({
  required String id,
  required String examConfigJson,
  required String questionsJson,
  Value<String?> answersJson,
  required DateTime startedAt,
  Value<DateTime?> submittedAt,
  Value<int?> score,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$ExamSessionsTableUpdateCompanionBuilder = ExamSessionsCompanion
    Function({
  Value<String> id,
  Value<String> examConfigJson,
  Value<String> questionsJson,
  Value<String?> answersJson,
  Value<DateTime> startedAt,
  Value<DateTime?> submittedAt,
  Value<int?> score,
  Value<bool> synced,
  Value<int> rowid,
});

class $$ExamSessionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ExamSessionsTable,
    ExamSession,
    $$ExamSessionsTableFilterComposer,
    $$ExamSessionsTableOrderingComposer,
    $$ExamSessionsTableCreateCompanionBuilder,
    $$ExamSessionsTableUpdateCompanionBuilder> {
  $$ExamSessionsTableTableManager(_$AppDatabase db, $ExamSessionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$ExamSessionsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$ExamSessionsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> examConfigJson = const Value.absent(),
            Value<String> questionsJson = const Value.absent(),
            Value<String?> answersJson = const Value.absent(),
            Value<DateTime> startedAt = const Value.absent(),
            Value<DateTime?> submittedAt = const Value.absent(),
            Value<int?> score = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamSessionsCompanion(
            id: id,
            examConfigJson: examConfigJson,
            questionsJson: questionsJson,
            answersJson: answersJson,
            startedAt: startedAt,
            submittedAt: submittedAt,
            score: score,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String examConfigJson,
            required String questionsJson,
            Value<String?> answersJson = const Value.absent(),
            required DateTime startedAt,
            Value<DateTime?> submittedAt = const Value.absent(),
            Value<int?> score = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ExamSessionsCompanion.insert(
            id: id,
            examConfigJson: examConfigJson,
            questionsJson: questionsJson,
            answersJson: answersJson,
            startedAt: startedAt,
            submittedAt: submittedAt,
            score: score,
            synced: synced,
            rowid: rowid,
          ),
        ));
}

class $$ExamSessionsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get examConfigJson => $state.composableBuilder(
      column: $state.table.examConfigJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get questionsJson => $state.composableBuilder(
      column: $state.table.questionsJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get answersJson => $state.composableBuilder(
      column: $state.table.answersJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get submittedAt => $state.composableBuilder(
      column: $state.table.submittedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$ExamSessionsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $ExamSessionsTable> {
  $$ExamSessionsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get examConfigJson => $state.composableBuilder(
      column: $state.table.examConfigJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get questionsJson => $state.composableBuilder(
      column: $state.table.questionsJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get answersJson => $state.composableBuilder(
      column: $state.table.answersJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get startedAt => $state.composableBuilder(
      column: $state.table.startedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get submittedAt => $state.composableBuilder(
      column: $state.table.submittedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get score => $state.composableBuilder(
      column: $state.table.score,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AiExplanationCacheTableCreateCompanionBuilder
    = AiExplanationCacheCompanion Function({
  required String id,
  required String questionId,
  required String language,
  required String explanation,
  required DateTime generatedAt,
  Value<int> rowid,
});
typedef $$AiExplanationCacheTableUpdateCompanionBuilder
    = AiExplanationCacheCompanion Function({
  Value<String> id,
  Value<String> questionId,
  Value<String> language,
  Value<String> explanation,
  Value<DateTime> generatedAt,
  Value<int> rowid,
});

class $$AiExplanationCacheTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AiExplanationCacheTable,
    AiExplanationCacheData,
    $$AiExplanationCacheTableFilterComposer,
    $$AiExplanationCacheTableOrderingComposer,
    $$AiExplanationCacheTableCreateCompanionBuilder,
    $$AiExplanationCacheTableUpdateCompanionBuilder> {
  $$AiExplanationCacheTableTableManager(
      _$AppDatabase db, $AiExplanationCacheTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AiExplanationCacheTableFilterComposer(ComposerState(db, table)),
          orderingComposer: $$AiExplanationCacheTableOrderingComposer(
              ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<String> language = const Value.absent(),
            Value<String> explanation = const Value.absent(),
            Value<DateTime> generatedAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AiExplanationCacheCompanion(
            id: id,
            questionId: questionId,
            language: language,
            explanation: explanation,
            generatedAt: generatedAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String questionId,
            required String language,
            required String explanation,
            required DateTime generatedAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              AiExplanationCacheCompanion.insert(
            id: id,
            questionId: questionId,
            language: language,
            explanation: explanation,
            generatedAt: generatedAt,
            rowid: rowid,
          ),
        ));
}

class $$AiExplanationCacheTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AiExplanationCacheTable> {
  $$AiExplanationCacheTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get questionId => $state.composableBuilder(
      column: $state.table.questionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get explanation => $state.composableBuilder(
      column: $state.table.explanation,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get generatedAt => $state.composableBuilder(
      column: $state.table.generatedAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AiExplanationCacheTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AiExplanationCacheTable> {
  $$AiExplanationCacheTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get questionId => $state.composableBuilder(
      column: $state.table.questionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get language => $state.composableBuilder(
      column: $state.table.language,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get explanation => $state.composableBuilder(
      column: $state.table.explanation,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get generatedAt => $state.composableBuilder(
      column: $state.table.generatedAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$FlashcardCardsTableCreateCompanionBuilder = FlashcardCardsCompanion
    Function({
  required String id,
  required String deckId,
  required String questionId,
  required int intervalDays,
  required double easeFactor,
  required DateTime dueDate,
  required int repetitions,
  Value<bool> synced,
  Value<int> rowid,
});
typedef $$FlashcardCardsTableUpdateCompanionBuilder = FlashcardCardsCompanion
    Function({
  Value<String> id,
  Value<String> deckId,
  Value<String> questionId,
  Value<int> intervalDays,
  Value<double> easeFactor,
  Value<DateTime> dueDate,
  Value<int> repetitions,
  Value<bool> synced,
  Value<int> rowid,
});

class $$FlashcardCardsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FlashcardCardsTable,
    FlashcardCard,
    $$FlashcardCardsTableFilterComposer,
    $$FlashcardCardsTableOrderingComposer,
    $$FlashcardCardsTableCreateCompanionBuilder,
    $$FlashcardCardsTableUpdateCompanionBuilder> {
  $$FlashcardCardsTableTableManager(
      _$AppDatabase db, $FlashcardCardsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$FlashcardCardsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$FlashcardCardsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> deckId = const Value.absent(),
            Value<String> questionId = const Value.absent(),
            Value<int> intervalDays = const Value.absent(),
            Value<double> easeFactor = const Value.absent(),
            Value<DateTime> dueDate = const Value.absent(),
            Value<int> repetitions = const Value.absent(),
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FlashcardCardsCompanion(
            id: id,
            deckId: deckId,
            questionId: questionId,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            dueDate: dueDate,
            repetitions: repetitions,
            synced: synced,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String deckId,
            required String questionId,
            required int intervalDays,
            required double easeFactor,
            required DateTime dueDate,
            required int repetitions,
            Value<bool> synced = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              FlashcardCardsCompanion.insert(
            id: id,
            deckId: deckId,
            questionId: questionId,
            intervalDays: intervalDays,
            easeFactor: easeFactor,
            dueDate: dueDate,
            repetitions: repetitions,
            synced: synced,
            rowid: rowid,
          ),
        ));
}

class $$FlashcardCardsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $FlashcardCardsTable> {
  $$FlashcardCardsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get deckId => $state.composableBuilder(
      column: $state.table.deckId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get questionId => $state.composableBuilder(
      column: $state.table.questionId,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get easeFactor => $state.composableBuilder(
      column: $state.table.easeFactor,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get repetitions => $state.composableBuilder(
      column: $state.table.repetitions,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$FlashcardCardsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $FlashcardCardsTable> {
  $$FlashcardCardsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get deckId => $state.composableBuilder(
      column: $state.table.deckId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get questionId => $state.composableBuilder(
      column: $state.table.questionId,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get intervalDays => $state.composableBuilder(
      column: $state.table.intervalDays,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get easeFactor => $state.composableBuilder(
      column: $state.table.easeFactor,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get dueDate => $state.composableBuilder(
      column: $state.table.dueDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get repetitions => $state.composableBuilder(
      column: $state.table.repetitions,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get synced => $state.composableBuilder(
      column: $state.table.synced,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$SubjectsTableCreateCompanionBuilder = SubjectsCompanion Function({
  required String id,
  required String name,
  required String examType,
  required int questionCount,
  required int downloadSizeMb,
  required String versionHash,
  Value<bool> isDownloaded,
  Value<DateTime?> lastUpdated,
  Value<int> rowid,
});
typedef $$SubjectsTableUpdateCompanionBuilder = SubjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> examType,
  Value<int> questionCount,
  Value<int> downloadSizeMb,
  Value<String> versionHash,
  Value<bool> isDownloaded,
  Value<DateTime?> lastUpdated,
  Value<int> rowid,
});

class $$SubjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SubjectsTable,
    Subject,
    $$SubjectsTableFilterComposer,
    $$SubjectsTableOrderingComposer,
    $$SubjectsTableCreateCompanionBuilder,
    $$SubjectsTableUpdateCompanionBuilder> {
  $$SubjectsTableTableManager(_$AppDatabase db, $SubjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$SubjectsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$SubjectsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> examType = const Value.absent(),
            Value<int> questionCount = const Value.absent(),
            Value<int> downloadSizeMb = const Value.absent(),
            Value<String> versionHash = const Value.absent(),
            Value<bool> isDownloaded = const Value.absent(),
            Value<DateTime?> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion(
            id: id,
            name: name,
            examType: examType,
            questionCount: questionCount,
            downloadSizeMb: downloadSizeMb,
            versionHash: versionHash,
            isDownloaded: isDownloaded,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String examType,
            required int questionCount,
            required int downloadSizeMb,
            required String versionHash,
            Value<bool> isDownloaded = const Value.absent(),
            Value<DateTime?> lastUpdated = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SubjectsCompanion.insert(
            id: id,
            name: name,
            examType: examType,
            questionCount: questionCount,
            downloadSizeMb: downloadSizeMb,
            versionHash: versionHash,
            isDownloaded: isDownloaded,
            lastUpdated: lastUpdated,
            rowid: rowid,
          ),
        ));
}

class $$SubjectsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get examType => $state.composableBuilder(
      column: $state.table.examType,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get questionCount => $state.composableBuilder(
      column: $state.table.questionCount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get downloadSizeMb => $state.composableBuilder(
      column: $state.table.downloadSizeMb,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get versionHash => $state.composableBuilder(
      column: $state.table.versionHash,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<bool> get isDownloaded => $state.composableBuilder(
      column: $state.table.isDownloaded,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$SubjectsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $SubjectsTable> {
  $$SubjectsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get examType => $state.composableBuilder(
      column: $state.table.examType,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get questionCount => $state.composableBuilder(
      column: $state.table.questionCount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get downloadSizeMb => $state.composableBuilder(
      column: $state.table.downloadSizeMb,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get versionHash => $state.composableBuilder(
      column: $state.table.versionHash,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<bool> get isDownloaded => $state.composableBuilder(
      column: $state.table.isDownloaded,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get lastUpdated => $state.composableBuilder(
      column: $state.table.lastUpdated,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$QuestionsTableTableManager get questions =>
      $$QuestionsTableTableManager(_db, _db.questions);
  $$ProgressTableTableTableManager get progressTable =>
      $$ProgressTableTableTableManager(_db, _db.progressTable);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
  $$ExamSessionsTableTableManager get examSessions =>
      $$ExamSessionsTableTableManager(_db, _db.examSessions);
  $$AiExplanationCacheTableTableManager get aiExplanationCache =>
      $$AiExplanationCacheTableTableManager(_db, _db.aiExplanationCache);
  $$FlashcardCardsTableTableManager get flashcardCards =>
      $$FlashcardCardsTableTableManager(_db, _db.flashcardCards);
  $$SubjectsTableTableManager get subjects =>
      $$SubjectsTableTableManager(_db, _db.subjects);
}
