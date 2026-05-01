class DashboardSummary {
  final int level;
  final int currentXp;
  final int xpToNextLevel;
  final int currentStreak;
  final int longestStreak;
  final int todayQuestionsAnswered;
  final int todayTimeSpentMinutes;
  final int todayXpEarned;
  final List<WeakTopic> weakTopics;
  final bool dailyDrillCompleted;
  final int userRank;
  final List<ActivityItem> recentActivity;
  final String? aiCoachMessage;
  final UpcomingDeadline? upcomingDeadline;
  final RecentMockScore? lastMockScore;
  final bool showOfflineBanner;

  DashboardSummary({
    required this.level,
    required this.currentXp,
    required this.xpToNextLevel,
    required this.currentStreak,
    required this.longestStreak,
    required this.todayQuestionsAnswered,
    required this.todayTimeSpentMinutes,
    required this.todayXpEarned,
    required this.weakTopics,
    required this.dailyDrillCompleted,
    required this.userRank,
    required this.recentActivity,
    this.aiCoachMessage,
    this.upcomingDeadline,
    this.lastMockScore,
    this.showOfflineBanner = false,
  });

  factory DashboardSummary.fromJson(Map<String, dynamic> json) {
    return DashboardSummary(
      level: json['level'] as int,
      currentXp: json['currentXp'] as int,
      xpToNextLevel: json['xpToNextLevel'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      todayQuestionsAnswered: json['todayQuestionsAnswered'] as int,
      todayTimeSpentMinutes: json['todayTimeSpentMinutes'] as int,
      todayXpEarned: json['todayXpEarned'] as int,
      weakTopics: (json['weakTopics'] as List)
          .map((t) => WeakTopic.fromJson(t))
          .toList(),
      dailyDrillCompleted: json['dailyDrillCompleted'] as bool,
      userRank: json['userRank'] as int,
      recentActivity: (json['recentActivity'] as List)
          .map((a) => ActivityItem.fromJson(a))
          .toList(),
      aiCoachMessage: json['aiCoachMessage'] as String?,
      upcomingDeadline: json['upcomingDeadline'] != null
          ? UpcomingDeadline.fromJson(json['upcomingDeadline'])
          : null,
      lastMockScore: json['lastMockScore'] != null
          ? RecentMockScore.fromJson(json['lastMockScore'])
          : null,
      showOfflineBanner: json['showOfflineBanner'] as bool? ?? false,
    );
  }
}

class WeakTopic {
  final String topicId;
  final String topicName;
  final double accuracy;
  final int questionsAttempted;

  WeakTopic({
    required this.topicId,
    required this.topicName,
    required this.accuracy,
    required this.questionsAttempted,
  });

  factory WeakTopic.fromJson(Map<String, dynamic> json) {
    return WeakTopic(
      topicId: json['topicId'] as String,
      topicName: json['topicName'] as String,
      accuracy: (json['accuracy'] as num).toDouble(),
      questionsAttempted: json['questionsAttempted'] as int,
    );
  }
}

class ActivityItem {
  final String type;
  final String title;
  final String description;
  final DateTime timestamp;

  ActivityItem({
    required this.type,
    required this.title,
    required this.description,
    required this.timestamp,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}

class UpcomingDeadline {
  final String title;
  final DateTime date;
  final String type; // 'exam' or 'scholarship'

  UpcomingDeadline({
    required this.title,
    required this.date,
    required this.type,
  });

  factory UpcomingDeadline.fromJson(Map<String, dynamic> json) {
    return UpcomingDeadline(
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      type: json['type'] as String,
    );
  }
}

class RecentMockScore {
  final double score;
  final String grade;
  final String subject;
  final DateTime date;

  RecentMockScore({
    required this.score,
    required this.grade,
    required this.subject,
    required this.date,
  });

  factory RecentMockScore.fromJson(Map<String, dynamic> json) {
    return RecentMockScore(
      score: (json['score'] as num).toDouble(),
      grade: json['grade'] as String,
      subject: json['subject'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
}
