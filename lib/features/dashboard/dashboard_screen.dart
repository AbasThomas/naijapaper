import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/streak_ring.dart';
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
                title: Text(
                  'Good morning, ${user?.name ?? "Student"}!',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
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
                  onPressed: () => context.go('/settings'),
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
          // Offline Banner
          if (summary.showOfflineBanner)
            _buildOfflineBanner(context).animate().slideY(begin: -1, end: 0),

          // Streak Ring
          Center(
            child: StreakRing(
              currentStreak: summary.currentStreak,
              size: 160,
            ),
          ).animate().scale(
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),

          const SizedBox(height: 16),

          // AI Coach Greeting Bubble
          if (summary.aiCoachMessage != null)
            _buildAICoachBubble(context, summary.aiCoachMessage!)
                .animate()
                .fadeIn(delay: 200.ms)
                .slideX(begin: -0.1, end: 0),

          const SizedBox(height: 24),

          // XP Progress
          _buildXPProgress(summary).animate().fadeIn(delay: 300.ms),

          const SizedBox(height: 24),

          // Core Cards Grid (Drill & Deadline)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildDailyDrillCard(context, summary)
                    .animate()
                    .fadeIn(delay: 400.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildUpcomingDeadlineCard(context, summary.upcomingDeadline)
                    .animate()
                    .fadeIn(delay: 500.ms)
                    .slideY(begin: 0.1, end: 0),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Mock Score
          if (summary.lastMockScore != null)
            _buildRecentMockCard(context, summary.lastMockScore!)
                .animate()
                .fadeIn(delay: 600.ms),

          const SizedBox(height: 24),

          // Today's Stats
          Text(
            'Today\'s Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 700.ms),

          const SizedBox(height: 12),

          _buildTodayStats(summary).animate().fadeIn(delay: 800.ms),

          const SizedBox(height: 24),

          // Weak Topics
          if (summary.weakTopics.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weak Topics',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.go('/dashboard/heatmap'),
                  child: const Text('View Heatmap'),
                ),
              ],
            ).animate().fadeIn(delay: 900.ms),

            const SizedBox(height: 12),

            _buildWeakTopics(context, summary.weakTopics)
                .animate()
                .fadeIn(delay: 1000.ms),

            const SizedBox(height: 24),
          ],

          // Leaderboard Peek
          _buildLeaderboardPeek(context, summary)
              .animate()
              .fadeIn(delay: 1100.ms),

          const SizedBox(height: 24),

          // Quick Actions
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 1200.ms),

          const SizedBox(height: 12),

          _buildQuickActions(context).animate().fadeIn(delay: 1300.ms),

          const SizedBox(height: 24),

          // Recent Activity
          Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ).animate().fadeIn(delay: 1400.ms),

          const SizedBox(height: 12),

          _buildRecentActivity(summary.recentActivity)
              .animate()
              .fadeIn(delay: 1500.ms),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildOfflineBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.download_for_offline, color: AppColors.primary),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Prepare for offline study. Download subject bundles now.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          TextButton(
            onPressed: () => context.go('/settings/offline'),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  Widget _buildAICoachBubble(BuildContext context, String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: const Icon(Icons.psychology, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ),
      ],
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
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      '${summary.currentXp} / ${summary.xpToNextLevel} XP to Level ${summary.level + 1}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.stars,
                  color: AppColors.warning,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyDrillCard(BuildContext context, DashboardSummary summary) {
    final isCompleted = summary.dailyDrillCompleted;

    return Card(
      elevation: 0,
      color: isCompleted
          ? AppColors.success.withOpacity(0.05)
          : AppColors.warning.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: (isCompleted ? AppColors.success : AppColors.warning).withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: isCompleted ? null : () => context.go('/practice/drill'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.bolt,
                    color: isCompleted ? AppColors.success : AppColors.warning,
                  ),
                  if (!isCompleted)
                    const Text(
                      'READY',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Daily Drill',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                isCompleted ? 'All caught up!' : '5 quick questions',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingDeadlineCard(BuildContext context, UpcomingDeadline? deadline) {
    if (deadline == null) return const SizedBox.shrink();

    final daysRemaining = deadline.date.difference(DateTime.now()).inDays;

    return Card(
      elevation: 0,
      color: AppColors.error.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.error.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => context.go('/tracker'),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.event_note, color: AppColors.error),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '$daysRemaining d',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                deadline.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upcoming Exam',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentMockCard(BuildContext context, RecentMockScore mock) {
    return Card(
      child: InkWell(
        onTap: () => context.go('/practice/mock/results/last'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    mock.grade,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recent Mock Score',
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    Text(
                      mock.subject,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(mock.date),
                      style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Text(
                '${mock.score.toInt()}%',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
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
            'XP Gained',
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
                fontSize: 11,
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
        'route': '/practice/drill',
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
        'route': '/community',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return InkWell(
          onTap: () => context.go(action['route'] as String),
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  action['icon'] as IconData,
                  size: 24,
                  color: action['color'] as Color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                action['title'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
            onTap: () => context.go('/practice/questions?topic=${topic.topicId}'),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.trending_down,
                        color: AppColors.error,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          topic.topicName,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${topic.accuracy.toInt()}% accuracy • ${topic.questionsAttempted} attempts',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildLeaderboardPeek(BuildContext context, DashboardSummary summary) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Leaderboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.go('/leaderboard'),
                  child: const Text('Full Standings'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.warning, size: 40),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ranked #${summary.userRank}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const Text(
                        'Top 5% in Lagos State',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/leaderboard'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('CHALLENGE'),
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
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text(
              'No activity yet. Start your first drill!',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
        ),
      );
    }

    return Column(
      children: activities.take(3).map((activity) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            dense: true,
            leading: CircleAvatar(
              radius: 16,
              backgroundColor: _getActivityColor(activity.type).withOpacity(0.1),
              child: Icon(
                _getActivityIcon(activity.type),
                color: _getActivityColor(activity.type),
                size: 16,
              ),
            ),
            title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(activity.description, style: const TextStyle(fontSize: 11)),
            trailing: Text(
              _formatActivityTime(activity.timestamp),
              style: TextStyle(
                fontSize: 10,
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
          ShimmerLoader(width: 160, height: 160, borderRadius: BorderRadius.circular(80)),
          const SizedBox(height: 24),
          ShimmerLoader(width: double.infinity, height: 80, borderRadius: BorderRadius.circular(12)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(16))),
              const SizedBox(width: 12),
              Expanded(child: ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(16))),
            ],
          ),
          const SizedBox(height: 24),
          ShimmerLoader(width: double.infinity, height: 100, borderRadius: BorderRadius.circular(12)),
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
              'Oops! Something went wrong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We couldn\'t load your dashboard summary. Please check your connection.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
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
