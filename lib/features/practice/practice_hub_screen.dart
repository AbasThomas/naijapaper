import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/app_card.dart';
import '../../shared/widgets/score_circle.dart';
import '../../shared/widgets/shimmer_loader.dart';
import 'presentation/exam_notifier.dart';
import 'domain/exam_session.dart' as domain;

class PracticeHubScreen extends ConsumerWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentExamsAsync = ref.watch(recentExamsProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Practice Hub'),
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.school,
                        size: 64,
                        color: AppColors.textOnPrimary.withOpacity(0.9),
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Master Your Exams',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.textOnPrimary.withOpacity(0.9),
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero CTA
                  _buildHeroCTA(context).animate().fadeIn().slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                  ),

                  const SizedBox(height: 24),

                  // Practice Modes Grid
                  Text(
                    'Practice Modes',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  _buildPracticeModesGrid(context),

                  const SizedBox(height: 32),

                  // Recent Exams
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Exams',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      TextButton(
                        onPressed: () => context.go('/practice/history'),
                        child: const Text('View All'),
                      ),
                    ],
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 16),

                  recentExamsAsync.when(
                    data: (exams) => _buildRecentExams(context, exams),
                    loading: () => _buildRecentExamsLoading(),
                    error: (error, stack) => _buildErrorState(error),
                  ),

                  const SizedBox(height: 32),

                  // Quick Stats
                  _buildQuickStats(context).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary,
            AppColors.primaryLight,
          ],
        ),
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
          const Icon(
            Icons.play_circle_filled,
            size: 48,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Start Mock Exam',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Test yourself with timed practice exams',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/practice/mock/setup'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textOnPrimary,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Configure Exam',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPracticeModesGrid(BuildContext context) {
    final modes = [
      {
        'title': 'Question Bank',
        'subtitle': 'Browse by topic',
        'icon': Icons.library_books,
        'color': AppColors.info,
        'route': '/practice/question-bank',
      },
      {
        'title': 'Flashcards',
        'subtitle': 'Spaced repetition',
        'icon': Icons.style,
        'color': AppColors.warning,
        'route': '/practice/flashcards',
      },
      {
        'title': 'Daily Drill',
        'subtitle': '5 quick questions',
        'icon': Icons.bolt,
        'color': AppColors.error,
        'route': '/practice/daily-drill',
      },
      {
        'title': 'Past Questions',
        'subtitle': 'Year by year',
        'icon': Icons.history_edu,
        'color': AppColors.success,
        'route': '/practice/past-questions',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: modes.length,
      itemBuilder: (context, index) {
        final mode = modes[index];
        return _buildModeCard(
          context,
          title: mode['title'] as String,
          subtitle: mode['subtitle'] as String,
          icon: mode['icon'] as IconData,
          color: mode['color'] as Color,
          route: mode['route'] as String,
        ).animate().fadeIn(delay: (300 + index * 100).ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
      },
    );
  }

  Widget _buildModeCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => context.go(route),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentExams(BuildContext context, List<domain.ExamSession> exams) {
    if (exams.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: exams.map((exam) {
        final index = exams.indexOf(exam);
        return _buildRecentExamCard(context, exam)
            .animate()
            .fadeIn(delay: (500 + index * 100).ms)
            .slideX(begin: -0.2, end: 0);
      }).toList(),
    );
  }

  Widget _buildRecentExamCard(BuildContext context, domain.ExamSession exam) {
    final isCompleted = exam.status == 'submitted';
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          if (isCompleted) {
            context.go('/practice/mock/results/${exam.id}');
          } else {
            context.go('/practice/mock/active/${exam.id}');
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Score or Status Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 32,
                        )
                      : const Icon(
                          Icons.pending,
                          color: AppColors.warning,
                          size: 32,
                        ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Exam Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.examType,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${exam.totalQuestions} questions',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(exam.startedAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentExamsLoading() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerLoader(
            width: double.infinity,
            height: 92,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No exams yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first mock exam to see it here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: AppColors.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load exams',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Exams',
            '12',
            Icons.assignment,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Score',
            '78%',
            Icons.trending_up,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Time Spent',
            '8.5h',
            Icons.timer,
            AppColors.info,
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
            Icon(icon, color: color, size: 24),
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
