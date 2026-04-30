import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';

// Challenge model
class Challenge {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int currentProgress;
  final int targetProgress;
  final DateTime startDate;
  final DateTime endDate;
  final int xpReward;
  final int coinsReward;
  final String difficulty;
  final bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.currentProgress,
    required this.targetProgress,
    required this.startDate,
    required this.endDate,
    required this.xpReward,
    required this.coinsReward,
    required this.difficulty,
    required this.isCompleted,
  });

  double get progressPercentage =>
      targetProgress > 0 ? (currentProgress / targetProgress).clamp(0.0, 1.0) : 0.0;

  Duration get timeRemaining => endDate.difference(DateTime.now());

  String get timeRemainingText {
    if (timeRemaining.isNegative) return 'Expired';
    if (timeRemaining.inDays > 0) return '${timeRemaining.inDays}d left';
    if (timeRemaining.inHours > 0) return '${timeRemaining.inHours}h left';
    return '${timeRemaining.inMinutes}m left';
  }
}

// Challenges provider
final activeChallengesProvider = FutureProvider<List<Challenge>>((ref) async {
  // TODO: Replace with actual API call
  await Future.delayed(const Duration(seconds: 1));
  return _getMockChallenges();
});

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(activeChallengesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Challenges'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
            Tab(text: 'All'),
          ],
        ),
      ),
      body: challengesAsync.when(
        data: (challenges) => _buildChallengesList(challenges),
        loading: () => _buildLoadingState(),
        error: (error, stack) => _buildErrorState(error),
      ),
    );
  }

  Widget _buildChallengesList(List<Challenge> challenges) {
    return TabBarView(
      controller: _tabController,
      children: [
        // Active challenges
        _buildChallengesTab(
          challenges.where((c) => !c.isCompleted && !c.timeRemaining.isNegative).toList(),
          'No active challenges',
          'Complete challenges to earn rewards!',
        ),

        // Completed challenges
        _buildChallengesTab(
          challenges.where((c) => c.isCompleted).toList(),
          'No completed challenges',
          'Start completing challenges to see them here.',
        ),

        // All challenges
        _buildChallengesTab(
          challenges,
          'No challenges available',
          'Check back later for new challenges!',
        ),
      ],
    );
  }

  Widget _buildChallengesTab(
    List<Challenge> challenges,
    String emptyTitle,
    String emptySubtitle,
  ) {
    if (challenges.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 80,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),
              Text(
                emptyTitle,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                emptySubtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(activeChallengesProvider);
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          return _buildChallengeCard(challenges[index])
              .animate()
              .fadeIn(delay: (index * 100).ms)
              .slideX(begin: 0.2, end: 0);
        },
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: challenge.isCompleted ? 1 : 3,
      child: InkWell(
        onTap: () => _showChallengeDetails(challenge),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Icon
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: challenge.isCompleted
                          ? AppColors.success.withOpacity(0.1)
                          : challenge.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      challenge.isCompleted ? Icons.check_circle : challenge.icon,
                      size: 28,
                      color: challenge.isCompleted ? AppColors.success : challenge.color,
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title and difficulty
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildDifficultyBadge(challenge.difficulty),
                            const SizedBox(width: 8),
                            Icon(
                              Icons.access_time,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              challenge.timeRemainingText,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Completed badge
                  if (challenge.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                challenge.description,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 16),

              // Progress
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${challenge.currentProgress}/${challenge.targetProgress}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: challenge.progressPercentage,
                            minHeight: 8,
                            backgroundColor: AppColors.surfaceVariant,
                            valueColor: AlwaysStoppedAnimation(
                              challenge.isCompleted ? AppColors.success : challenge.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Rewards
              Row(
                children: [
                  // XP Reward
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.stars, size: 16, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          '+${challenge.xpReward} XP',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Coins Reward
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.monetization_on, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 4),
                        Text(
                          '+${challenge.coinsReward} coins',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Action button
                  if (!challenge.isCompleted)
                    TextButton(
                      onPressed: () => _startChallenge(challenge),
                      child: const Text('Start'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    switch (difficulty.toLowerCase()) {
      case 'easy':
        color = AppColors.success;
        break;
      case 'hard':
        color = AppColors.error;
        break;
      default:
        color = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  void _showChallengeDetails(Challenge challenge) {
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Icon
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: challenge.isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : challenge.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  challenge.isCompleted ? Icons.check_circle : challenge.icon,
                  size: 40,
                  color: challenge.isCompleted ? AppColors.success : challenge.color,
                ),
              )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.3)),
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              challenge.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Difficulty and time
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDifficultyBadge(challenge.difficulty),
                const SizedBox(width: 12),
                Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  challenge.timeRemainingText,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              challenge.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 24),

            // Progress
            Container(
              padding: const EdgeInsets.all(16),
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
                        '${challenge.currentProgress}/${challenge.targetProgress}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: challenge.progressPercentage,
                      minHeight: 12,
                      backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation(
                        challenge.isCompleted ? AppColors.success : challenge.color,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Rewards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.stars, color: AppColors.warning, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '+${challenge.xpReward}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.warning,
                          ),
                        ),
                        const Text(
                          'XP',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.monetization_on, color: AppColors.secondary, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          '+${challenge.coinsReward}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                        const Text(
                          'Coins',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Action buttons
            if (challenge.isCompleted)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                ),
                child: const Text('Completed!'),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _startChallenge(challenge);
                      },
                      child: const Text('Start Challenge'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _startChallenge(Challenge challenge) {
    // Navigate to appropriate screen based on challenge type
    if (challenge.id.contains('exam')) {
      context.go('/practice/mock/setup');
    } else if (challenge.id.contains('drill')) {
      context.go('/practice/daily-drill');
    } else if (challenge.id.contains('flashcard')) {
      context.go('/practice/flashcards');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Challenge started!')),
      );
    }
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: List.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ShimmerLoader(
              width: double.infinity,
              height: 200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
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
              'Failed to load challenges',
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
              onPressed: () => ref.invalidate(activeChallengesProvider),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// Mock data
List<Challenge> _getMockChallenges() {
  final now = DateTime.now();
  return [
    Challenge(
      id: 'weekly_exam_master',
      title: 'Weekly Exam Master',
      description: 'Complete 5 mock exams this week',
      icon: Icons.assignment,
      color: AppColors.primary,
      currentProgress: 2,
      targetProgress: 5,
      startDate: now.subtract(const Duration(days: 2)),
      endDate: now.add(const Duration(days: 5)),
      xpReward: 300,
      coinsReward: 50,
      difficulty: 'Medium',
      isCompleted: false,
    ),
    Challenge(
      id: 'daily_drill_streak',
      title: 'Daily Drill Streak',
      description: 'Complete daily drills for 7 days straight',
      icon: Icons.bolt,
      color: AppColors.warning,
      currentProgress: 4,
      targetProgress: 7,
      startDate: now.subtract(const Duration(days: 4)),
      endDate: now.add(const Duration(days: 3)),
      xpReward: 250,
      coinsReward: 40,
      difficulty: 'Easy',
      isCompleted: false,
    ),
    Challenge(
      id: 'flashcard_champion',
      title: 'Flashcard Champion',
      description: 'Review 100 flashcards this week',
      icon: Icons.style,
      color: AppColors.info,
      currentProgress: 65,
      targetProgress: 100,
      startDate: now.subtract(const Duration(days: 3)),
      endDate: now.add(const Duration(days: 4)),
      xpReward: 200,
      coinsReward: 30,
      difficulty: 'Medium',
      isCompleted: false,
    ),
    Challenge(
      id: 'perfect_score_challenge',
      title: 'Perfect Score Challenge',
      description: 'Score 100% on any exam',
      icon: Icons.stars,
      color: AppColors.warning,
      currentProgress: 0,
      targetProgress: 1,
      startDate: now.subtract(const Duration(days: 1)),
      endDate: now.add(const Duration(days: 6)),
      xpReward: 500,
      coinsReward: 100,
      difficulty: 'Hard',
      isCompleted: false,
    ),
    Challenge(
      id: 'social_butterfly',
      title: 'Social Butterfly',
      description: 'Join 3 study groups',
      icon: Icons.groups,
      color: AppColors.success,
      currentProgress: 1,
      targetProgress: 3,
      startDate: now.subtract(const Duration(days: 2)),
      endDate: now.add(const Duration(days: 5)),
      xpReward: 150,
      coinsReward: 25,
      difficulty: 'Easy',
      isCompleted: false,
    ),
    Challenge(
      id: 'speed_demon_challenge',
      title: 'Speed Demon',
      description: 'Complete 3 exams in under 30 minutes each',
      icon: Icons.flash_on,
      color: AppColors.error,
      currentProgress: 3,
      targetProgress: 3,
      startDate: now.subtract(const Duration(days: 5)),
      endDate: now.subtract(const Duration(days: 1)),
      xpReward: 400,
      coinsReward: 75,
      difficulty: 'Hard',
      isCompleted: true,
    ),
  ];
}
