import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/streak_ring.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/shimmer_loader.dart';
import '../../shared/providers/auth_provider.dart';
import 'data/dashboard_repository.dart';
import 'domain/dashboard_summary.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final dashboardAsync = ref.watch(dashboardSummaryProvider);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(dashboardSummaryProvider);
        },
        child: CustomScrollView(
          slivers: [
            // App Bar with User Info
            SliverAppBar(
              expandedHeight: 120,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Welcome, ${user?.name ?? "Student"}'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () => context.go('/notifications'),
                ),
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: () => context.go('/profile/settings'),
                ),
              ],
            ),

            // Content
            SliverToBoxAdapter(
              child: dashboardAsync.when(
                data: (summary) => _buildDashboardContent(context, ref, summary),
                loading: () => _buildLoadingState(),
                error: (error, stack) => _buildErrorState(context, error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(
    BuildContext context,
    WidgetRef ref,
    DashboardSummary summary,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Streak Ring
          Center(
            child: StreakRing(
              currentStreak: summary.currentStreak,
              size: 180,
            ),
          ).animate().scale(
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 24),

          // XP Progress
          _buildXPProgress(summary).animate().fadeIn(delay: 200.ms),

          const SizedBox(height: 24),

          // Today's Stats
          Text(
            'Today\'s Progress',
            style: Theme.of(context).textTheme.headlineSmall,
          ).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 12),

          _buildTodayStats(summary).animate().fadeIn(delay: 400.ms),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.headlineSmall,
          ).animate().fadeIn(delay: 500.ms),

          const SizedBox(height: 12),

          _buildQuickActions(context).animate().fadeIn(delay: 600.ms),

          const SizedBox(height: 24),

          // Weak Topics
          if (summary.weakTopics.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Topics to Review',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                TextButton(
                  onPressed: () => context.go('/dashboard/heatmap'),
                  child: const Text('View All'),
                ),
              ],
            ).animate().fadeIn(delay: 700.ms),

            const SizedBox(height: 12),

            _buildWeakTopics(context, summary.weakTopics)
                .animate()
                .fadeIn(delay: 800.ms),

            const SizedBox(height: 24),
          ],

          // Daily Drill Card
          _buildDailyDrillCard(context, summary)
              .animate()
              .fadeIn(delay: 900.ms)
              .slideY(begin: 0.2, end: 0),

          const SizedBox(height: 24),

          // Leaderboard Peek
          _buildLeaderboardPeek(context, summary)
              .animate()
              .fadeIn(delay: 1000.ms),

          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.headlineSmall,
          ).animate().fadeIn(delay: 1100.ms),

          const SizedBox(height: 12),

          _buildRecentActivity(summary.recentActivity)
              .animate()
              .fadeIn(delay: 1200.ms),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildXPProgress(DashboardSummary summary) {
    final progress = summary.xpToNextLevel > 0
        ? summary.currentXp / summary.xpToNextLevel
        : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${summary.level}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${summary.currentXp} / ${summary.xpToNextLevel} XP',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.stars,
                    color: AppColors.warning,
                    size: 32,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 12,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(DashboardSummary summary) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Questions',
            summary.todayQuestionsAnswered.toString(),
            Icons.quiz,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Time',
            '${summary.todayTimeSpentMinutes}m',
            Icons.timer,
            AppColors.info,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'XP Earned',
            '+${summary.todayXpEarned}',
            Icons.trending_up,
            AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'title': 'Mock Exam',
        'icon': Icons.assignment,
        'color': AppColors.primary,
        'route': '/practice/mock/setup',
      },
      {
        'title': 'Daily Drill',
        'icon': Icons.bolt,
        'color': AppColors.warning,
        'route': '/practice/daily-drill',
      },
      {
        'title': 'AI Tutor',
        'icon': Icons.psychology,
        'color': AppColors.info,
        'route': '/ai-tutor',
      },
      {
        'title': 'Study Group',
        'icon': Icons.groups,
        'color': AppColors.success,
        'route': '/community/groups',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          child: InkWell(
            onTap: () => context.go(action['route'] as String),
            borderRadius: BorderRadius.circular(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  action['icon'] as IconData,
                  size: 32,
                  color: action['color'] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  action['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWeakTopics(BuildContext context, List<WeakTopic> topics) {
    return Column(
      children: topics.take(3).map((topic) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => context.go('/practice/question-bank?topic=${topic.topicId}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.trending_down,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.topicName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${topic.accuracy.toStringAsFixed(1)}% accuracy • ${topic.questionsAttempted} questions',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 60,
                      height: 8,
                      child: LinearProgressIndicator(
                        value: topic.accuracy / 100,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation(
                          topic.accuracy < 50 ? AppColors.error : AppColors.warning,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDailyDrillCard(BuildContext context, DashboardSummary summary) {
    final isCompleted = summary.dailyDrillCompleted;

    return Card(
      color: isCompleted
          ? AppColors.success.withOpacity(0.1)
          : AppColors.primary.withOpacity(0.1),
      child: InkWell(
        onTap: isCompleted ? null : () => context.go('/practice/daily-drill'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isCompleted ? AppColors.success : AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check : Icons.bolt,
                  color: AppColors.textOnPrimary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCompleted ? 'Daily Drill Complete!' : 'Daily Drill',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isCompleted ? AppColors.success : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isCompleted
                          ? 'Come back tomorrow for more'
                          : '5 quick questions to keep your streak',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isCompleted)
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardPeek(BuildContext context, DashboardSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => context.go('/profile/leaderboard'),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: AppColors.warning, size: 32),
                const SizedBox(width: 8),
                Text(
                  'You\'re ranked #${summary.userRank}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(List<ActivityItem> activities) {
    if (activities.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'No recent activity',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return Column(
      children: activities.map((activity) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getActivityColor(activity.type).withOpacity(0.1),
              child: Icon(
                _getActivityIcon(activity.type),
                color: _getActivityColor(activity.type),
              ),
            ),
            title: Text(activity.title),
            subtitle: Text(activity.description),
            trailing: Text(
              _formatActivityTime(activity.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerLoader(width: 180, height: 180, borderRadius: BorderRadius.circular(90)),
          const SizedBox(height: 24),
          ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 12),
              Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12))),
              const SizedBox(width: 12),
              Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load dashboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/practice'),
              child: const Text('Go to Practice'),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'exam':
        return Icons.assignment;
      case 'drill':
        return Icons.bolt;
      case 'flashcard':
        return Icons.style;
      case 'achievement':
        return Icons.emoji_events;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type) {
      case 'exam':
        return AppColors.primary;
      case 'drill':
        return AppColors.warning;
      case 'flashcard':
        return AppColors.info;
      case 'achievement':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  String _formatActivityTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
