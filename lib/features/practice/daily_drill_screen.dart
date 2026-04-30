import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'domain/question.dart';

// Daily drill provider
final dailyDrillProvider = FutureProvider<DailyDrill>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  // TODO: Replace with actual API call
  return _getMockDailyDrill();
});

class DailyDrill {
  final String id;
  final List<Question> questions;
  final bool isCompleted;
  final int? score;

  DailyDrill({
    required this.id,
    required this.questions,
    required this.isCompleted,
    this.score,
  });
}

class DailyDrillScreen extends ConsumerStatefulWidget {
  const DailyDrillScreen({super.key});

  @override
  ConsumerState<DailyDrillScreen> createState() => _DailyDrillScreenState();
}

class _DailyDrillScreenState extends ConsumerState<DailyDrillScreen> {
  int _currentQuestionIndex = 0;
  final Map<int, String> _answers = {};
  bool _isSubmitted = false;
  int? _score;

  @override
  Widget build(BuildContext context) {
    final drillAsync = ref.watch(dailyDrillProvider);

    return drillAsync.when(
      data: (drill) {
        if (drill.isCompleted && !_isSubmitted) {
          return _buildCompletedState(drill);
        }

        if (_isSubmitted) {
          return _buildResultsState(drill);
        }

        return _buildDrillInterface(drill);
      },
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Daily Drill')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrillInterface(DailyDrill drill) {
    final question = drill.questions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / drill.questions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1}/${drill.questions.length}'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Streak Motivation
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.warning.withOpacity(0.2),
                          AppColors.warning.withOpacity(0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bolt, color: AppColors.warning, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Daily Drill',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Keep your streak alive!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn().slideY(begin: -0.2, end: 0),

                  const SizedBox(height: 24),

                  // Question Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  question.topicName,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getDifficultyColor(question.difficulty)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  question.difficulty,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getDifficultyColor(question.difficulty),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            question.questionText,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ).animate().fadeIn(delay: 100.ms),

                  const SizedBox(height: 16),

                  // Options
                  ...['A', 'B', 'C', 'D'].map((option) {
                    final isSelected = _answers[_currentQuestionIndex] == option;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(option),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surface,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.border,
                              width: isSelected ? 2 : 1,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? AppColors.textOnPrimary
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  question.optionsMap[option] ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(delay: (200 + option.codeUnitAt(0) * 50).ms);
                  }).toList(),
                ],
              ),
            ),
          ),

          // Bottom Navigation
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                if (_currentQuestionIndex > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousQuestion,
                      child: const Text('Previous'),
                    ),
                  ),
                if (_currentQuestionIndex > 0) const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: _answers.containsKey(_currentQuestionIndex)
                        ? _nextOrSubmit
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _currentQuestionIndex == drill.questions.length - 1
                          ? AppColors.success
                          : AppColors.primary,
                    ),
                    child: Text(
                      _currentQuestionIndex == drill.questions.length - 1
                          ? 'Submit'
                          : 'Next',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState(DailyDrill drill) {
    final correctCount = _calculateScore(drill);
    final percentage = (correctCount / drill.questions.length * 100).toInt();
    final xpEarned = correctCount * 10;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Drill Complete!'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Success Animation
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.success.withOpacity(0.2),
                    AppColors.success.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppColors.success,
                  ).animate().scale(
                    duration: 600.ms,
                    curve: Curves.elasticOut,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$correctCount/${drill.questions.length}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.success,
                    ),
                  ).animate().fadeIn(delay: 300.ms),
                  const SizedBox(height: 8),
                  Text(
                    '$percentage% Correct',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fadeIn(delay: 400.ms),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // XP Earned
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.warning,
                    AppColors.warning.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.stars, color: AppColors.textOnPrimary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '+$xpEarned XP Earned!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).scale(),

            const SizedBox(height: 24),

            // Streak Message
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.bolt, color: AppColors.warning, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Streak Maintained!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Come back tomorrow to keep it going',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 600.ms),

            const SizedBox(height: 32),

            // Actions
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text(
                'Back to Dashboard',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton(
              onPressed: () => context.go('/practice'),
              child: const Text('Continue Practicing'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedState(DailyDrill drill) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Drill'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              const Text(
                'Already Completed!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'You\'ve completed today\'s drill.\nCome back tomorrow for more!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Back to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
    }
  }

  void _nextOrSubmit() {
    final drill = ref.read(dailyDrillProvider).value!;

    if (_currentQuestionIndex < drill.questions.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      // Submit
      setState(() {
        _isSubmitted = true;
        _score = _calculateScore(drill);
      });
    }
  }

  int _calculateScore(DailyDrill drill) {
    int correct = 0;
    for (int i = 0; i < drill.questions.length; i++) {
      if (_answers[i] == drill.questions[i].correctAnswer) {
        correct++;
      }
    }
    return correct;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toUpperCase()) {
      case 'EASY':
        return AppColors.difficultyEasy;
      case 'HARD':
        return AppColors.difficultyHard;
      default:
        return AppColors.difficultyMedium;
    }
  }
}

// Mock data generator
DailyDrill _getMockDailyDrill() {
  return DailyDrill(
    id: 'drill_${DateTime.now().day}',
    isCompleted: false,
    questions: List.generate(5, (index) {
      return Question(
        id: 'q_drill_${index + 1}',
        subjectId: 'math',
        subjectName: 'Mathematics',
        topicId: 'algebra',
        topicName: ['Algebra', 'Geometry', 'Calculus', 'Statistics', 'Trigonometry'][index],
        year: 2024,
        difficulty: ['EASY', 'EASY', 'MEDIUM', 'MEDIUM', 'HARD'][index],
        questionText: 'Sample question ${index + 1} for daily drill practice.',
        optionA: 'Option A',
        optionB: 'Option B',
        optionC: 'Option C',
        optionD: 'Option D',
        correctAnswer: ['A', 'B', 'C', 'A', 'D'][index],
        explanationEn: 'This is the explanation for question ${index + 1}.',
        explanationPidgin: null,
        type: 'MCQ',
        examType: 'JAMB',
      );
    }),
  );
}
