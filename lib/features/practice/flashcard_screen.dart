import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flip_card/flip_card.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

// Flashcard provider
final flashcardsProvider = FutureProvider<List<Flashcard>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  // TODO: Replace with actual API call
  return _getMockFlashcards();
});

class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String topicName;
  final DateTime dueDate;
  final int repetitions;
  final double easeFactor;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.topicName,
    required this.dueDate,
    required this.repetitions,
    required this.easeFactor,
  });

  bool get isDue => DateTime.now().isAfter(dueDate);
}

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  int _currentIndex = 0;
  final List<String> _reviewedCards = [];
  bool _showingAnswer = false;

  @override
  Widget build(BuildContext context) {
    final flashcardsAsync = ref.watch(flashcardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFlashcardDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(),
          ),
        ],
      ),
      body: flashcardsAsync.when(
        data: (flashcards) {
          if (flashcards.isEmpty) {
            return _buildEmptyState();
          }

          final dueCards = flashcards.where((c) => c.isDue).toList();

          if (dueCards.isEmpty) {
            return _buildAllReviewedState();
          }

          if (_currentIndex >= dueCards.length) {
            return _buildSessionCompleteState(dueCards.length);
          }

          return _buildFlashcardInterface(dueCards);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
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

  Widget _buildFlashcardInterface(List<Flashcard> cards) {
    final card = cards[_currentIndex];
    final progress = (_currentIndex + 1) / cards.length;

    return Column(
      children: [
        // Progress Bar
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.surfaceVariant,
          valueColor: const AlwaysStoppedAnimation(AppColors.primary),
        ),

        // Stats
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${_currentIndex + 1} of ${cards.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  card.topicName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Flashcard
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: FlipCard(
                direction: FlipDirection.HORIZONTAL,
                front: _buildCardFace(
                  card.question,
                  'Tap to reveal answer',
                  AppColors.primary,
                  Icons.help_outline,
                ),
                back: _buildCardFace(
                  card.answer,
                  'Tap to see question',
                  AppColors.success,
                  Icons.lightbulb_outline,
                ),
                onFlip: () {
                  setState(() => _showingAnswer = !_showingAnswer);
                },
              ).animate().scale(
                duration: 400.ms,
                curve: Curves.easeOut,
              ),
            ),
          ),
        ),

        // Rating Buttons
        if (_showingAnswer)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'How well did you know this?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildRatingButton(
                        'Again',
                        AppColors.error,
                        Icons.close,
                        () => _rateCard(1),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRatingButton(
                        'Hard',
                        AppColors.warning,
                        Icons.sentiment_dissatisfied,
                        () => _rateCard(2),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRatingButton(
                        'Good',
                        AppColors.info,
                        Icons.sentiment_satisfied,
                        () => _rateCard(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildRatingButton(
                        'Easy',
                        AppColors.success,
                        Icons.sentiment_very_satisfied,
                        () => _rateCard(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().slideY(begin: 0.3, end: 0),
      ],
    );
  }

  Widget _buildCardFace(String text, String hint, Color color, IconData icon) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
            const SizedBox(height: 24),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnPrimary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              hint,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textOnPrimary.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingButton(
    String label,
    Color color,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: AppColors.textOnPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
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
              Icons.style_outlined,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              'No Flashcards Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Add flashcards from questions or create your own',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddFlashcardDialog(),
              icon: const Icon(Icons.add),
              label: const Text('Create Flashcard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllReviewedState() {
    return Center(
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
              'All Caught Up!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'No cards due for review right now.\nCome back later!',
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
    );
  }

  Widget _buildSessionCompleteState(int cardsReviewed) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.celebration,
              size: 80,
              color: AppColors.success,
            ).animate().scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            ),
            const SizedBox(height: 24),
            const Text(
              'Session Complete!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 12),
            Text(
              'You reviewed $cardsReviewed cards',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ).animate().fadeIn(delay: 400.ms),
            const SizedBox(height: 32),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.stars, color: AppColors.textOnPrimary, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    '+${cardsReviewed * 5} XP Earned!',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).scale(),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  void _rateCard(int rating) {
    final flashcards = ref.read(flashcardsProvider).value!;
    final dueCards = flashcards.where((c) => c.isDue).toList();
    final card = dueCards[_currentIndex];

    _reviewedCards.add(card.id);

    // TODO: Update card schedule based on rating (Leitner system)
    // rating: 1 = Again, 2 = Hard, 3 = Good, 4 = Easy

    setState(() {
      _currentIndex++;
      _showingAnswer = false;
    });

    // Show feedback
    String message;
    switch (rating) {
      case 1:
        message = 'Card will be shown again soon';
        break;
      case 2:
        message = 'Card scheduled for tomorrow';
        break;
      case 3:
        message = 'Card scheduled for 3 days';
        break;
      case 4:
        message = 'Card scheduled for 7 days';
        break;
      default:
        message = 'Card reviewed';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showAddFlashcardDialog() {
    final questionController = TextEditingController();
    final answerController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Flashcard'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: answerController,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Save flashcard
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Flashcard created!')),
              );
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Flashcard Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Spaced Repetition Schedule:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildSettingRow('Again', '10 minutes'),
            _buildSettingRow('Hard', '1 day'),
            _buildSettingRow('Good', '3 days'),
            _buildSettingRow('Easy', '7 days'),
            const SizedBox(height: 16),
            const Text(
              'Daily Goal: 20 cards',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// Mock data generator
List<Flashcard> _getMockFlashcards() {
  return List.generate(10, (index) {
    return Flashcard(
      id: 'card_${index + 1}',
      question: 'What is the formula for the area of a circle?',
      answer: 'A = πr²\n\nWhere:\n• A = Area\n• π ≈ 3.14159\n• r = radius',
      topicName: ['Algebra', 'Geometry', 'Calculus'][index % 3],
      dueDate: DateTime.now().subtract(Duration(hours: index)),
      repetitions: index,
      easeFactor: 2.5,
    );
  });
}
