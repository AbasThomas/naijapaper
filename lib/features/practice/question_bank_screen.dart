import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/shimmer_loader.dart';
import 'domain/question.dart';

// Mock questions provider (replace with real API)
final questionBankProvider = FutureProvider.family<List<Question>, QuestionBankFilters>(
  (ref, filters) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Replace with actual API call
    return _getMockQuestions(filters);
  },
);

class QuestionBankFilters {
  final String? subjectId;
  final String? topicId;
  final String? difficulty;
  final int? year;

  QuestionBankFilters({
    this.subjectId,
    this.topicId,
    this.difficulty,
    this.year,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestionBankFilters &&
          subjectId == other.subjectId &&
          topicId == other.topicId &&
          difficulty == other.difficulty &&
          year == other.year;

  @override
  int get hashCode =>
      subjectId.hashCode ^ topicId.hashCode ^ difficulty.hashCode ^ year.hashCode;
}

class QuestionBankScreen extends ConsumerStatefulWidget {
  final String? subjectId;
  final String? topicId;

  const QuestionBankScreen({
    super.key,
    this.subjectId,
    this.topicId,
  });

  @override
  ConsumerState<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends ConsumerState<QuestionBankScreen> {
  String? _selectedDifficulty;
  int? _selectedYear;
  final Set<String> _bookmarkedQuestions = {};

  @override
  Widget build(BuildContext context) {
    final filters = QuestionBankFilters(
      subjectId: widget.subjectId,
      topicId: widget.topicId,
      difficulty: _selectedDifficulty,
      year: _selectedYear,
    );

    final questionsAsync = ref.watch(questionBankProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Question Bank'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline),
            onPressed: () => context.go('/practice/bookmarks'),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          _buildFilterChips(),

          const Divider(height: 1),

          // Questions List
          Expanded(
            child: questionsAsync.when(
              data: (questions) => _buildQuestionsList(questions),
              loading: () => _buildLoadingState(),
              error: (error, stack) => _buildErrorState(error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            // Difficulty Filter
            if (_selectedDifficulty != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_selectedDifficulty!),
                  selected: true,
                  onSelected: (_) {
                    setState(() => _selectedDifficulty = null);
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => _selectedDifficulty = null);
                  },
                  selectedColor: _getDifficultyColor(_selectedDifficulty!).withOpacity(0.2),
                ),
              ),

            // Year Filter
            if (_selectedYear != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilterChip(
                  label: Text(_selectedYear.toString()),
                  selected: true,
                  onSelected: (_) {
                    setState(() => _selectedYear = null);
                  },
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() => _selectedYear = null);
                  },
                  selectedColor: AppColors.primary.withOpacity(0.2),
                ),
              ),

            // Clear All
            if (_selectedDifficulty != null || _selectedYear != null)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _selectedDifficulty = null;
                    _selectedYear = null;
                  });
                },
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear All'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsList(List<Question> questions) {
    if (questions.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        final question = questions[index];
        return _buildQuestionCard(question, index)
            .animate()
            .fadeIn(delay: (index * 50).ms)
            .slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildQuestionCard(Question question, int index) {
    final isBookmarked = _bookmarkedQuestions.contains(question.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => _showQuestionDetail(question),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Q${index + 1}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(question.difficulty).withOpacity(0.2),
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
                  const SizedBox(width: 8),
                  Text(
                    '${question.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
                      color: isBookmarked ? AppColors.warning : AppColors.textSecondary,
                    ),
                    onPressed: () => _toggleBookmark(question.id),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Question Text
              Text(
                question.questionText,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Topic
              Row(
                children: [
                  Icon(
                    Icons.topic,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    question.topicName,
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
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ShimmerLoader(
            width: double.infinity,
            height: 150,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No questions found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
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

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to load questions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
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
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.invalidate(questionBankProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Filter Questions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Difficulty
                const Text('Difficulty', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['EASY', 'MEDIUM', 'HARD'].map((diff) {
                    final isSelected = _selectedDifficulty == diff;
                    return ChoiceChip(
                      label: Text(diff),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedDifficulty = selected ? diff : null;
                        });
                      },
                      selectedColor: _getDifficultyColor(diff).withOpacity(0.2),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Year
                const Text('Year', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [2024, 2023, 2022, 2021, 2020].map((year) {
                    final isSelected = _selectedYear == year;
                    return ChoiceChip(
                      label: Text(year.toString()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedYear = selected ? year : null;
                        });
                      },
                      selectedColor: AppColors.primary.withOpacity(0.2),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Apply Button
                ElevatedButton(
                  onPressed: () {
                    setState(() {}); // Trigger rebuild with new filters
                    Navigator.pop(context);
                  },
                  child: const Text('Apply Filters'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showQuestionDetail(Question question) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      question.topicName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Question
                Text(
                  question.questionText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: 24),

                // Options
                ...['A', 'B', 'C', 'D'].map((option) {
                  final isCorrect = question.correctAnswer == option;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.surface,
                        border: Border.all(
                          color: isCorrect ? AppColors.success : AppColors.border,
                          width: isCorrect ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: isCorrect ? AppColors.success : Colors.transparent,
                              border: Border.all(
                                color: isCorrect ? AppColors.success : AppColors.border,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                option,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isCorrect
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
                          if (isCorrect)
                            const Icon(Icons.check_circle, color: AppColors.success),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: 24),

                // Explanation
                if (question.explanationEn != null) ...[
                  const Text(
                    'Explanation',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(question.explanationEn!),
                  ),
                ],

                const SizedBox(height: 24),

                // Actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // TODO: Add to flashcards
                        },
                        icon: const Icon(Icons.style),
                        label: const Text('Add to Flashcards'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          context.go('/ai-tutor/chat');
                        },
                        icon: const Icon(Icons.psychology),
                        label: const Text('Ask AI'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _toggleBookmark(String questionId) {
    setState(() {
      if (_bookmarkedQuestions.contains(questionId)) {
        _bookmarkedQuestions.remove(questionId);
      } else {
        _bookmarkedQuestions.add(questionId);
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _bookmarkedQuestions.contains(questionId)
              ? 'Question bookmarked'
              : 'Bookmark removed',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
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
List<Question> _getMockQuestions(QuestionBankFilters filters) {
  return List.generate(10, (index) {
    return Question(
      id: 'q_${index + 1}',
      subjectId: filters.subjectId ?? 'math',
      subjectName: 'Mathematics',
      topicId: filters.topicId ?? 'algebra',
      topicName: 'Algebra',
      year: filters.year ?? 2024 - (index % 5),
      difficulty: filters.difficulty ?? ['EASY', 'MEDIUM', 'HARD'][index % 3],
      questionText: 'What is the value of x in the equation 2x + 5 = 15?',
      optionA: 'x = 5',
      optionB: 'x = 10',
      optionC: 'x = 15',
      optionD: 'x = 20',
      correctAnswer: 'A',
      explanationEn: 'To solve for x, subtract 5 from both sides: 2x = 10, then divide by 2: x = 5',
      explanationPidgin: null,
      type: 'MCQ',
      examType: 'JAMB',
    );
  });
}
