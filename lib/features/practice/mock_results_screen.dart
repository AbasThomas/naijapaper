import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/score_circle.dart';
import 'data/exam_repository.dart';
import 'domain/exam_result.dart';
import 'presentation/exam_notifier.dart';

class MockResultsScreen extends ConsumerWidget {
  final String sessionId;
  
  const MockResultsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Results'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResults(context, ref),
          ),
        ],
      ),
      body: FutureBuilder<ExamResult>(
        future: ref.read(examRepositoryProvider).getExamResults(sessionId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text('Error loading results: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/practice'),
                    child: const Text('Back to Practice'),
                  ),
                ],
              ),
            );
          }
          
          final result = snapshot.data!;
          return _buildResultsContent(context, result);
        },
      ),
    );
  }

  Widget _buildResultsContent(BuildContext context, ExamResult result) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Score Circle with Animation
          Center(
            child: ScoreCircle(
              score: result.percentage,
              size: 200,
            ),
          ).animate().scale(
            duration: 600.ms,
            curve: Curves.elasticOut,
          ),
          
          const SizedBox(height: 24),
          
          // Grade Badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: _getGradeColor(result.grade).withOpacity(0.2),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: _getGradeColor(result.grade),
                  width: 2,
                ),
              ),
              child: Text(
                'Grade: ${result.grade}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _getGradeColor(result.grade),
                ),
              ),
            ).animate().fadeIn(delay: 300.ms).slideY(
              begin: 0.3,
              end: 0,
              duration: 400.ms,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Correct',
                  result.correctAnswers.toString(),
                  AppColors.success,
                  Icons.check_circle,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: -0.3, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Wrong',
                  result.wrongAnswers.toString(),
                  AppColors.error,
                  Icons.cancel,
                ).animate().fadeIn(delay: 500.ms).slideX(begin: 0.3, end: 0),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Time',
                  _formatTime(result.timeTakenSeconds),
                  AppColors.primary,
                  Icons.timer,
                ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.3, end: 0),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Percentile',
                  '${result.percentile}th',
                  AppColors.warning,
                  Icons.trending_up,
                ).animate().fadeIn(delay: 700.ms).slideX(begin: 0.3, end: 0),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // XP Earned
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.stars,
                  color: AppColors.textOnPrimary,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  '+${result.xpEarned} XP Earned!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textOnPrimary,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 800.ms).scale(
            duration: 400.ms,
            curve: Curves.elasticOut,
          ),
          
          const SizedBox(height: 32),
          
          // Subject Breakdown
          Text(
            'Subject Breakdown',
            style: Theme.of(context).textTheme.headlineSmall,
          ).animate().fadeIn(delay: 900.ms),
          
          const SizedBox(height: 16),
          
          ...result.subjectBreakdown.entries.map((entry) {
            final index = result.subjectBreakdown.keys.toList().indexOf(entry.key);
            return _buildSubjectBreakdown(
              context,
              entry.value,
            ).animate().fadeIn(delay: (1000 + index * 100).ms).slideX(
              begin: -0.2,
              end: 0,
            );
          }).toList(),
          
          const SizedBox(height: 32),
          
          // Weak Topics
          if (result.weakTopics.isNotEmpty) ...[
            Text(
              'Topics to Review',
              style: Theme.of(context).textTheme.headlineSmall,
            ).animate().fadeIn(delay: 1200.ms),
            
            const SizedBox(height: 16),
            
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.weakTopics.map((topic) {
                return Chip(
                  label: Text(topic),
                  backgroundColor: AppColors.error.withOpacity(0.1),
                  side: BorderSide(color: AppColors.error.withOpacity(0.3)),
                );
              }).toList(),
            ).animate().fadeIn(delay: 1300.ms),
            
            const SizedBox(height: 32),
          ],
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.go('/practice/mock/review/$sessionId'),
                  icon: const Icon(Icons.rate_review),
                  label: const Text('Review Answers'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/practice'),
                  icon: const Icon(Icons.refresh),
                  label: const Text('New Exam'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                ),
              ),
            ],
          ).animate().fadeIn(delay: 1400.ms).slideY(begin: 0.3, end: 0),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectBreakdown(BuildContext context, SubjectBreakdown breakdown) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  breakdown.subjectName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '${breakdown.percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _getPercentageColor(breakdown.percentage),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: breakdown.percentage / 100,
                minHeight: 8,
                backgroundColor: AppColors.surfaceVariant,
                valueColor: AlwaysStoppedAnimation(
                  _getPercentageColor(breakdown.percentage),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat('✓', breakdown.correct, AppColors.success),
                _buildMiniStat('✗', breakdown.wrong, AppColors.error),
                _buildMiniStat('−', breakdown.skipped, AppColors.textSecondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String icon, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          icon,
          style: TextStyle(color: color, fontSize: 16),
        ),
        const SizedBox(width: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getGradeColor(String grade) {
    if (grade.startsWith('A')) return AppColors.success;
    if (grade.startsWith('B')) return AppColors.primary;
    if (grade.startsWith('C')) return AppColors.warning;
    return AppColors.error;
  }

  Color _getPercentageColor(double percentage) {
    if (percentage >= 80) return AppColors.success;
    if (percentage >= 60) return AppColors.primary;
    if (percentage >= 40) return AppColors.warning;
    return AppColors.error;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes}m ${secs}s';
  }

  Future<void> _shareResults(BuildContext context, WidgetRef ref) async {
    try {
      final result = await ref.read(examRepositoryProvider).getExamResults(sessionId);
      
      final text = '''
🎓 NaijaPaper Exam Results

Score: ${result.percentage.toStringAsFixed(1)}%
Grade: ${result.grade}
Correct: ${result.correctAnswers}/${result.totalQuestions}
Percentile: ${result.percentile}th
XP Earned: +${result.xpEarned}

Keep learning with NaijaPaper! 🚀
''';
      
      await Share.share(text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
  }
}
