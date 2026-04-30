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
