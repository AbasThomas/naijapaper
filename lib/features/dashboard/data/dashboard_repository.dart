import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/constants/api_constants.dart';
import '../domain/dashboard_summary.dart';

// Repository provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

// Dashboard summary provider
final dashboardSummaryProvider = FutureProvider<DashboardSummary>((ref) async {
  final repository = ref.read(dashboardRepositoryProvider);
  return await repository.getDashboardSummary();
});

class DashboardRepository {
  final DioClient _dioClient;

  DashboardRepository({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient.instance;

  /// Get dashboard summary
  Future<DashboardSummary> getDashboardSummary() async {
    try {
      final response = await _dioClient.get(ApiConstants.dashboardSummary);
      return DashboardSummary.fromJson(response.data);
    } catch (e) {
      // Return mock data for development
      return _getMockDashboardSummary();
    }
  }

  /// Mock data for development
  DashboardSummary _getMockDashboardSummary() {
    return DashboardSummary(
      level: 5,
      currentXp: 1250,
      xpToNextLevel: 1500,
      currentStreak: 7,
      longestStreak: 15,
      todayQuestionsAnswered: 25,
      todayTimeSpentMinutes: 45,
      todayXpEarned: 150,
      weakTopics: [
        WeakTopic(
          topicId: 'algebra',
          topicName: 'Algebra',
          accuracy: 45.5,
          questionsAttempted: 20,
        ),
        WeakTopic(
          topicId: 'geometry',
          topicName: 'Geometry',
          accuracy: 52.3,
          questionsAttempted: 15,
        ),
        WeakTopic(
          topicId: 'calculus',
          topicName: 'Calculus',
          accuracy: 38.7,
          questionsAttempted: 12,
        ),
      ],
      dailyDrillCompleted: false,
      userRank: 42,
      recentActivity: [
        ActivityItem(
          type: 'exam',
          title: 'Completed Mock Exam',
          description: 'JAMB Mathematics - 85% score',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        ActivityItem(
          type: 'drill',
          title: 'Daily Drill Completed',
          description: '5/5 questions correct',
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        ),
        ActivityItem(
          type: 'achievement',
          title: 'Achievement Unlocked',
          description: '7-day streak milestone',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
    );
  }
}
