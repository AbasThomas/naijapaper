import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import 'data/exam_repository.dart';
import 'domain/exam_review.dart';
import 'domain/question.dart';

class AnswerReviewScreen extends ConsumerStatefulWidget {
  final String sessionId;
  
  const AnswerReviewScreen({super.key, required this.sessionId});

  @override
  ConsumerState<AnswerReviewScreen> createState() => _AnswerReviewScreenState();
}

class _AnswerReviewScreenState extends ConsumerState<AnswerReviewScreen> {
  String _filter = 'all'; // all, correct, wrong, skipped
  String _language = 'en'; // en, pidgin
  final Set<String> _expandedExplanations = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Answers'),
        actions: [
          PopupMenuButton<String>(
            initialValue: _filter,
            onSelected: (value) => setState(() => _filter = value),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('All Questions')),
              const PopupMenuItem(value: 'correct', child: Text('Correct Only')),
              const PopupMenuItem(value: 'wrong', child: Text('Wrong Only')),
              const PopupMenuItem(value: 'skipped', child: Text('Skipped Only')),
            ],
          ),
        ],
      ),
      body: FutureBuilder<ExamReview>(
        future: ref.read(examRepositoryProvider).getExamReview(widget.sessionId),
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
                  Text('Error loading review: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }
          
          final review = snapshot.data!;
          final filteredQuestions = _filterQuestions(review);
          
          return Column(
            children: [
              // Language Toggle
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surfaceVariant,
                child: Row(
                  children: [
                    const Text('Explanation Language:'),
                    const SizedBox(width: 16),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'en', label: Text('English')),
                        ButtonSegment(value: 'pidgin', label: Text('Pidgin')),
                      ],
                      selected: {_language},
                      onSelectionChanged: (Set<String> newSelection) {
                        setState(() => _language = newSelection.first);
                      },
                    ),
                  ],
                ),
              ),
              
              // Filter Summary
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFilterChip(
                      'All',
                      review.questions.length,
                      'all',
                      AppColors.primary,
                    ),
                    _buildFilterChip(
                      'Correct',
                      review.correctCount,
                      'correct',
                      AppColors.success,
                    ),
                    _buildFilterChip(
                      'Wrong',
                      review.wrongCount,
                      'wrong',
                      AppColors.error,
                    ),
                    _buildFilterChip(
                      'Skipped',
                      review.skippedCount,
                      'skipped',
                      AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
              
              const Divider(height: 1),
              
              // Questions List
              Expanded(
                child: filteredQuestions.isEmpty
                    ? Center(
                        child: Text(
                          'No ${_filter == 'all' ? '' : _filter} questions',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: filteredQuestions.length,
                        itemBuilder: (context, index) {
                          final item = filteredQuestions[index];
                          return _buildQuestionCard(item, index + 1);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<ReviewQuestion> _filterQuestions(ExamReview review) {
    switch (_filter) {
      case 'correct':
        return review.questions.where((q) => q.isCorrect).toList();
      case 'wrong':
        return review.questions.where((q) => !q.isCorrect && q.userAnswer != null).toList();
      case 'skipped':
        return review.questions.where((q) => q.userAnswer == null).toList();
      default:
        return review.questions;
    }
  }

  Widget _buildFilterChip(String label, int count, String value, Color color) {
    final isSelected = _filter == value;
    
    return FilterChip(
      label: Text('$label ($count)'),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _filter = value);
      },
      backgroundColor: color.withOpacity(0.1),
      selectedColor: color.withOpacity(0.2),
      checkmarkColor: color,
      labelStyle: TextStyle(
        color: isSelected ? color : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  Widget _buildQuestionCard(ReviewQuestion item, int number) {
    final question = item.question;
    final isExpanded = _expandedExplanations.contains(question.id);
    
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    if (item.userAnswer == null) {
      statusColor = AppColors.textSecondary;
      statusIcon = Icons.remove_circle_outline;
      statusText = 'Skipped';
    } else if (item.isCorrect) {
      statusColor = AppColors.success;
      statusIcon = Icons.check_circle;
      statusText = 'Correct';
    } else {
      statusColor = AppColors.error;
      statusIcon = Icons.cancel;
      statusText = 'Wrong';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$number',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                      Text(
                        '${question.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(statusIcon, color: statusColor),
                const SizedBox(width: 4),
                Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Question Text
            Text(
              question.questionText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            
            const SizedBox(height: 16),
            
            // Options
            ...['A', 'B', 'C', 'D'].map((option) {
              final isUserAnswer = item.userAnswer == option;
              final isCorrectAnswer = question.correctAnswer == option;
              
              Color? backgroundColor;
              Color? borderColor;
              
              if (isCorrectAnswer) {
                backgroundColor = AppColors.success.withOpacity(0.1);
                borderColor = AppColors.success;
              } else if (isUserAnswer && !isCorrectAnswer) {
                backgroundColor = AppColors.error.withOpacity(0.1);
                borderColor = AppColors.error;
              }
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor ?? AppColors.surface,
                    border: Border.all(
                      color: borderColor ?? AppColors.border,
                      width: borderColor != null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCorrectAnswer
                              ? AppColors.success
                              : (isUserAnswer ? AppColors.error : Colors.transparent),
                          border: Border.all(
                            color: borderColor ?? AppColors.border,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (isCorrectAnswer || isUserAnswer)
                                  ? AppColors.textOnPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(question.optionsMap[option] ?? ''),
                      ),
                      if (isCorrectAnswer)
                        const Icon(Icons.check, color: AppColors.success, size: 20),
                      if (isUserAnswer && !isCorrectAnswer)
                        const Icon(Icons.close, color: AppColors.error, size: 20),
                    ],
                  ),
                ),
              );
            }).toList(),
            
            const SizedBox(height: 16),
            
            // Explanation Section
            InkWell(
              onTap: () {
                setState(() {
                  if (isExpanded) {
                    _expandedExplanations.remove(question.id);
                  } else {
                    _expandedExplanations.add(question.id);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'View Explanation',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
            
            if (isExpanded) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getExplanation(question),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _addToFlashcards(question),
                      icon: const Icon(Icons.style, size: 18),
                      label: const Text('Add to Flashcards'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _askAI(question),
                      icon: const Icon(Icons.psychology, size: 18),
                      label: const Text('Ask AI'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getExplanation(Question question) {
    if (_language == 'pidgin' && question.explanationPidgin != null) {
      return question.explanationPidgin!;
    }
    return question.explanationEn ?? 'No explanation available.';
  }

  void _addToFlashcards(Question question) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Added to flashcards!'),
        action: SnackBarAction(
          label: 'View',
          onPressed: () => context.go('/practice/flashcards'),
        ),
      ),
    );
    
    // TODO: Implement actual flashcard addition
  }

  void _askAI(Question question) {
    context.go('/ai-tutor/chat', extra: {
      'initialMessage': 'Explain this question in detail: ${question.questionText}',
    });
  }
}
