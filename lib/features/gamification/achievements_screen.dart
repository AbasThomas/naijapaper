import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

// Achievement model
class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int currentProgress;
  final int targetProgress;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String category;
  final int xpReward;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.isUnlocked,
    this.unlockedAt,
    required this.category,
    required this.xpReward,
  });

  double get progressPercentage => 
      targetProgress > 0 ? (currentProgress / targetProgress).clamp(0.0, 1.0) : 0.0;
}

// Achievements provider
final achievementsProvider = FutureProvider<List<Achievement>>((ref) async {
  // TODO: Replace with actual API call
  await Future.delayed(const Duration(seconds: 1));
  return _getMockAchievements();
});

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final achievementsAsync = ref.watch(achievementsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          onTap: (index) {
            setState(() {
              _selectedCategory = [
                'all',
                'practice',
                'streak',
                'social',
                'special'
              ][index];
            });
          },
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Practice'),
            Tab(text: 'Streak'),
            Tab(text: 'Social'),
            Tab(text: 'Special'),
          ],
        ),
      ),
      body: achievementsAsync.when(
        data: (achievements) => _buildAchievementsList(achievements),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildAchievementsList(List<Achievement> achievements) {
    // Filter by category
    final filtered = _selectedCategory == 'all'
        ? achievements
        : achievements.where((a) => a.category == _selectedCategory).toList();

    // Separate unlocked and locked
    final unlocked = filtered.where((a) => a.isUnlocked).toList();
    final locked = filtered.where((a) => !a.isUnlocked).toList();

    // Calculate stats
    final totalUnlocked = achievements.where((a) => a.isUnlocked).length;
    final totalAchievements = achievements.length;
    final completionPercentage = (totalUnlocked / totalAchievements * 100).toInt();

    return CustomScrollView(
      slivers: [
        // Stats Header
        SliverToBoxAdapter(
          child: _buildStatsHeader(totalUnlocked, totalAchievements, completionPercentage)
              .animate()
              .fadeIn()
              .slideY(begin: -0.2, end: 0),
        ),

        // Unlocked Section
        if (unlocked.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.warning),
                  const SizedBox(width: 8),
                  Text(
                    'Unlocked (${unlocked.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildAchievementCard(unlocked[index], index)
                      .animate()
                      .fadeIn(delay: (300 + index * 50).ms)
                      .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
                },
                childCount: unlocked.length,
              ),
            ),
          ),
        ],

        // Locked Section
        if (locked.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  const SizedBox(width: 8),
                  Text(
                    'Locked (${locked.length})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 400.ms),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildAchievementCard(locked[index], index)
                      .animate()
                      .fadeIn(delay: (500 + index * 50).ms);
                },
                childCount: locked.length,
              ),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildStatsHeader(int unlocked, int total, int percentage) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                color: AppColors.textOnPrimary,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                '$unlocked / $total',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$percentage% Complete',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: AppColors.textOnPrimary.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(AppColors.textOnPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int index) {
    return Card(
      elevation: achievement.isUnlocked ? 4 : 1,
      color: achievement.isUnlocked ? AppColors.surface : AppColors.surfaceVariant,
      child: InkWell(
        onTap: () => _showAchievementDetails(achievement),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withOpacity(0.2)
                      : AppColors.textDisabled.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  achievement.icon,
                  size: 32,
                  color: achievement.isUnlocked
                      ? achievement.color
                      : AppColors.textDisabled,
                ),
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                achievement.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: achievement.isUnlocked
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 8),

              // Progress or Unlocked Badge
              if (achievement.isUnlocked)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Unlocked',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                )
              else ...[
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: achievement.progressPercentage,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                    valueColor: AlwaysStoppedAnimation(achievement.color),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${achievement.currentProgress}/${achievement.targetProgress}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showAchievementDetails(Achievement achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? achievement.color.withOpacity(0.2)
                    : AppColors.textDisabled.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                achievement.icon,
                size: 50,
                color: achievement.isUnlocked
                    ? achievement.color
                    : AppColors.textDisabled,
              ),
            )
                .animate(onPlay: (controller) => controller.repeat())
                .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3))
                .then()
                .shake(hz: 2, curve: Curves.easeInOut),

            const SizedBox(height: 16),

            // Title
            Text(
              achievement.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Description
            Text(
              achievement.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 16),

            // XP Reward
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '+${achievement.xpReward} XP',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Status
            if (achievement.isUnlocked) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    const SizedBox(width: 8),
                    Text(
                      'Unlocked ${_formatDate(achievement.unlockedAt!)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '${achievement.currentProgress}/${achievement.targetProgress}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: achievement.progressPercentage,
                        minHeight: 8,
                        backgroundColor: AppColors.border,
                        valueColor: AlwaysStoppedAnimation(achievement.color),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Close button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ShimmerLoader(width: double.infinity, height: 120, borderRadius: BorderRadius.circular(16)),
          const SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.85,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return ShimmerLoader(
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(12),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Failed to load achievements',
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
              onPressed: () => ref.invalidate(achievementsProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'today';
    } else if (difference.inDays == 1) {
      return 'yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return 'on ${date.day}/${date.month}/${date.year}';
    }
  }
}

// Mock data
List<Achievement> _getMockAchievements() {
  return [
    // Practice achievements
    Achievement(
      id: 'first_exam',
      title: 'First Steps',
      description: 'Complete your first mock exam',
      icon: Icons.assignment_turned_in,
      color: AppColors.primary,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 5)),
      category: 'practice',
      xpReward: 50,
    ),
    Achievement(
      id: 'exam_master',
      title: 'Exam Master',
      description: 'Complete 50 mock exams',
      icon: Icons.school,
      color: AppColors.primary,
      currentProgress: 23,
      targetProgress: 50,
      isUnlocked: false,
      category: 'practice',
      xpReward: 500,
    ),
    Achievement(
      id: 'perfect_score',
      title: 'Perfect Score',
      description: 'Score 100% on any exam',
      icon: Icons.stars,
      color: AppColors.warning,
      currentProgress: 0,
      targetProgress: 1,
      isUnlocked: false,
      category: 'practice',
      xpReward: 200,
    ),
    Achievement(
      id: 'speed_demon',
      title: 'Speed Demon',
      description: 'Complete an exam in under 30 minutes',
      icon: Icons.flash_on,
      color: AppColors.warning,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 2)),
      category: 'practice',
      xpReward: 100,
    ),

    // Streak achievements
    Achievement(
      id: 'week_warrior',
      title: 'Week Warrior',
      description: 'Maintain a 7-day streak',
      icon: Icons.local_fire_department,
      color: AppColors.error,
      currentProgress: 7,
      targetProgress: 7,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'streak',
      xpReward: 150,
    ),
    Achievement(
      id: 'month_master',
      title: 'Month Master',
      description: 'Maintain a 30-day streak',
      icon: Icons.whatshot,
      color: AppColors.error,
      currentProgress: 12,
      targetProgress: 30,
      isUnlocked: false,
      category: 'streak',
      xpReward: 500,
    ),
    Achievement(
      id: 'unstoppable',
      title: 'Unstoppable',
      description: 'Maintain a 100-day streak',
      icon: Icons.emoji_events,
      color: AppColors.warning,
      currentProgress: 12,
      targetProgress: 100,
      isUnlocked: false,
      category: 'streak',
      xpReward: 1000,
    ),

    // Social achievements
    Achievement(
      id: 'team_player',
      title: 'Team Player',
      description: 'Join your first study group',
      icon: Icons.groups,
      color: AppColors.info,
      currentProgress: 0,
      targetProgress: 1,
      isUnlocked: false,
      category: 'social',
      xpReward: 50,
    ),
    Achievement(
      id: 'helpful_hand',
      title: 'Helpful Hand',
      description: 'Answer 10 forum questions',
      icon: Icons.help_outline,
      color: AppColors.info,
      currentProgress: 3,
      targetProgress: 10,
      isUnlocked: false,
      category: 'social',
      xpReward: 200,
    ),
    Achievement(
      id: 'top_contributor',
      title: 'Top Contributor',
      description: 'Get 50 upvotes on your answers',
      icon: Icons.thumb_up,
      color: AppColors.success,
      currentProgress: 8,
      targetProgress: 50,
      isUnlocked: false,
      category: 'social',
      xpReward: 300,
    ),

    // Special achievements
    Achievement(
      id: 'early_bird',
      title: 'Early Bird',
      description: 'Complete a drill before 8 AM',
      icon: Icons.wb_sunny,
      color: AppColors.warning,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 3)),
      category: 'special',
      xpReward: 100,
    ),
    Achievement(
      id: 'night_owl',
      title: 'Night Owl',
      description: 'Complete a drill after 10 PM',
      icon: Icons.nightlight_round,
      color: AppColors.primaryDark,
      currentProgress: 0,
      targetProgress: 1,
      isUnlocked: false,
      category: 'special',
      xpReward: 100,
    ),
    Achievement(
      id: 'weekend_warrior',
      title: 'Weekend Warrior',
      description: 'Study on both Saturday and Sunday',
      icon: Icons.weekend,
      color: AppColors.primary,
      currentProgress: 1,
      targetProgress: 1,
      isUnlocked: true,
      unlockedAt: DateTime.now().subtract(const Duration(days: 1)),
      category: 'special',
      xpReward: 150,
    ),
  ];
}
