import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import 'domain/exam_session.dart';
import 'domain/question.dart';
import 'presentation/exam_notifier.dart';

class ActiveMockScreen extends ConsumerStatefulWidget {
  final String sessionId;
  const ActiveMockScreen({super.key, required this.sessionId});

  @override
  ConsumerState<ActiveMockScreen> createState() => _ActiveMockScreenState();
}

class _ActiveMockScreenState extends ConsumerState<ActiveMockScreen> {
  int _currentQuestionIndex = 0;
  Map<int, String> _answers = {};
  Set<int> _flaggedQuestions = {};
  Timer? _timer;
  int _remainingSeconds = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadExamSession();
  }

  Future<void> _loadExamSession() async {
    final notifier = ref.read(examNotifierProvider(widget.sessionId).notifier);
    await notifier.loadSession();
    
    final session = ref.read(examNotifierProvider(widget.sessionId)).value;
    if (session != null && session.isTimed) {
      _remainingSeconds = session.remainingSeconds;
      _startTimer();
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _timer?.cancel();
        _autoSubmit();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _submitExam() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Exam?'),
        content: Text(
          '${_answers.length} of ${ref.read(examNotifierProvider(widget.sessionId)).value?.totalQuestions ?? 0} questions answered.\n\nSubmit anyway?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(examNotifierProvider(widget.sessionId).notifier);
      await notifier.submitExam(_answers);
      
      if (!mounted) return;
      context.go('/practice/mock/results/${widget.sessionId}');
    }
  }

  Future<void> _autoSubmit() async {
    final notifier = ref.read(examNotifierProvider(widget.sessionId).notifier);
    await notifier.submitExam(_answers);
    
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Time\'s up! Exam auto-submitted.')),
    );
    context.go('/practice/mock/results/${widget.sessionId}');
  }

  void _selectAnswer(String answer) {
    setState(() {
      _answers[_currentQuestionIndex] = answer;
    });
    
    // Save to local storage
    ref.read(examNotifierProvider(widget.sessionId).notifier)
        .saveAnswerLocally(_currentQuestionIndex, answer);
  }

  void _toggleFlag() {
    setState(() {
      if (_flaggedQuestions.contains(_currentQuestionIndex)) {
        _flaggedQuestions.remove(_currentQuestionIndex);
      } else {
        _flaggedQuestions.add(_currentQuestionIndex);
      }
    });
  }

  void _goToQuestion(int index) {
    setState(() => _currentQuestionIndex = index);
    Navigator.pop(context); // Close drawer
  }

  void _nextQuestion() {
    final session = ref.read(examNotifierProvider(widget.sessionId)).value;
    if (session != null && _currentQuestionIndex < session.totalQuestions - 1) {
      setState(() => _currentQuestionIndex++);
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() => _currentQuestionIndex--);
    }
  }

  @override
  Widget build(BuildContext context) {
    final examAsync = ref.watch(examNotifierProvider(widget.sessionId));

    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Exam?'),
            content: const Text('Your progress will be saved.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Question ${_currentQuestionIndex + 1}'),
          actions: [
            if (examAsync.value?.isTimed == true)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  AppDateUtils.formatTimerLong(_remainingSeconds),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _remainingSeconds < 300 ? AppColors.error : AppColors.textOnPrimary,
                  ),
                ),
              ),
            IconButton(
              icon: Icon(
                _flaggedQuestions.contains(_currentQuestionIndex)
                    ? Icons.flag
                    : Icons.flag_outlined,
                color: _flaggedQuestions.contains(_currentQuestionIndex)
                    ? AppColors.warning
                    : null,
              ),
              onPressed: _toggleFlag,
            ),
          ],
        ),
        drawer: _buildNavigationDrawer(examAsync.value),
        body: examAsync.when(
          data: (session) => _buildExamInterface(session),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
        bottomNavigationBar: _buildBottomBar(examAsync.value),
      ),
    );
  }

  Widget _buildExamInterface(ExamSession? session) {
    if (session == null || session.questions.isEmpty) {
      return const Center(child: Text('No questions available'));
    }

    final question = session.questions[_currentQuestionIndex];
    final selectedAnswer = _answers[_currentQuestionIndex];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Question text
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      const Spacer(),
                      Text(
                        '${question.year}',
                        style: Theme.of(context).textTheme.bodySmall,
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
          ),
          
          const SizedBox(height: 16),
          
          // Options
          ...['A', 'B', 'C', 'D'].map((option) {
            final isSelected = selectedAnswer == option;
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
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
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
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNavigationDrawer(ExamSession? session) {
    if (session == null) return const SizedBox();

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Question Navigator',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildLegendItem(AppColors.success, 'Answered'),
                      const SizedBox(width: 16),
                      _buildLegendItem(AppColors.warning, 'Flagged'),
                      const SizedBox(width: 16),
                      _buildLegendItem(AppColors.border, 'Skipped'),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: session.totalQuestions,
                itemBuilder: (context, index) {
                  final isAnswered = _answers.containsKey(index);
                  final isFlagged = _flaggedQuestions.contains(index);
                  final isCurrent = index == _currentQuestionIndex;

                  Color backgroundColor;
                  if (isCurrent) {
                    backgroundColor = AppColors.primary;
                  } else if (isFlagged) {
                    backgroundColor = AppColors.warning;
                  } else if (isAnswered) {
                    backgroundColor = AppColors.success;
                  } else {
                    backgroundColor = AppColors.surfaceVariant;
                  }

                  return InkWell(
                    onTap: () => _goToQuestion(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: (isCurrent || isAnswered || isFlagged)
                                ? AppColors.textOnPrimary
                                : AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildBottomBar(ExamSession? session) {
    if (session == null) return const SizedBox();

    final canSubmit = _answers.length >= (session.totalQuestions * 0.5).ceil() ||
        (session.isTimed && _remainingSeconds < session.durationMinutes * 60 * 0.5);

    return Container(
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
          Expanded(
            child: OutlinedButton(
              onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
              child: const Text('Previous'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: canSubmit ? _submitExam : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              child: const Text('Submit'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: _currentQuestionIndex < session.totalQuestions - 1
                  ? _nextQuestion
                  : null,
              child: const Text('Next'),
            ),
          ),
        ],
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
