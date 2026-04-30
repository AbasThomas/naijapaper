import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

// Study plan provider
final studyPlanProvider = FutureProvider<StudyPlan>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  // TODO: Replace with actual API call
  return _getMockStudyPlan();
});

class StudyPlan {
  final DateTime examDate;
  final Map<DateTime, List<StudyTask>> dailyTasks;
  final int totalDays;
  final int completedDays;

  StudyPlan({
    required this.examDate,
    required this.dailyTasks,
    required this.totalDays,
    required this.completedDays,
  });

  int get daysUntilExam => examDate.difference(DateTime.now()).inDays;
  double get progress => completedDays / totalDays;
}

class StudyTask {
  final String id;
  final String title;
  final String type; // practice, review, mock, rest
  final bool isCompleted;
  final int estimatedMinutes;

  StudyTask({
    required this.id,
    required this.title,
    required this.type,
    required this.isCompleted,
    required this.estimatedMinutes,
  });
}

class StudyPlanScreen extends ConsumerStatefulWidget {
  const StudyPlanScreen({super.key});

  @override
  ConsumerState<StudyPlanScreen> createState() => _StudyPlanScreenState();
}

class _StudyPlanScreenState extends ConsumerState<StudyPlanScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final studyPlanAsync = ref.watch(studyPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('30-Day Study Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_calendar),
            onPressed: () => _showEditPlanDialog(),
          ),
        ],
      ),
      body: studyPlanAsync.when(
        data: (plan) => _buildStudyPlanContent(plan),
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

  Widget _buildStudyPlanContent(StudyPlan plan) {
    final selectedTasks = plan.dailyTasks[_normalizeDate(_selectedDay!)] ?? [];

    return Column(
      children: [
        // Exam Countdown
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primaryLight,
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Exam Date',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                  Text(
                    _formatDate(plan.examDate),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.textOnPrimary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Column(
                  children: [
                    Text(
                      '${plan.daysUntilExam}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                    const Text(
                      'days left',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textOnPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ).animate().fadeIn().slideY(begin: -0.2, end: 0),

        // Progress Bar
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Overall Progress',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${(plan.progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: plan.progress,
                  minHeight: 12,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${plan.completedDays} of ${plan.totalDays} days completed',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms),

        // Calendar
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: TableCalendar(
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 60)),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: AppColors.warning,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              final tasks = plan.dailyTasks[_normalizeDate(day)] ?? [];
              return tasks;
            },
          ),
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        // Tasks for Selected Day
        Expanded(
          child: selectedTasks.isEmpty
              ? _buildNoTasksState()
              : _buildTasksList(selectedTasks),
        ),
      ],
    );
  }

  Widget _buildTasksList(List<StudyTask> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskCard(task)
            .animate()
            .fadeIn(delay: (400 + index * 100).ms)
            .slideX(begin: -0.1, end: 0);
      },
    );
  }

  Widget _buildTaskCard(StudyTask task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: CheckboxListTile(
        value: task.isCompleted,
        onChanged: (value) => _toggleTaskCompletion(task.id),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            color: task.isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              _getTaskIcon(task.type),
              size: 16,
              color: _getTaskColor(task.type),
            ),
            const SizedBox(width: 4),
            Text(
              task.type.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                color: _getTaskColor(task.type),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.timer_outlined,
              size: 16,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              '${task.estimatedMinutes} min',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNoTasksState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks for this day',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy your rest day!',
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

  void _toggleTaskCompletion(String taskId) {
    // TODO: Update task completion status
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task updated!'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showEditPlanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Study Plan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Exam Date',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 30)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                // TODO: Update exam date
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Study plan will be automatically adjusted based on your exam date.',
              style: TextStyle(fontSize: 12),
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
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Study plan updated!')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  IconData _getTaskIcon(String type) {
    switch (type) {
      case 'practice':
        return Icons.edit_note;
      case 'review':
        return Icons.rate_review;
      case 'mock':
        return Icons.assignment;
      case 'rest':
        return Icons.self_improvement;
      default:
        return Icons.task;
    }
  }

  Color _getTaskColor(String type) {
    switch (type) {
      case 'practice':
        return AppColors.primary;
      case 'review':
        return AppColors.info;
      case 'mock':
        return AppColors.warning;
      case 'rest':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }
}

// Mock data generator
StudyPlan _getMockStudyPlan() {
  final examDate = DateTime.now().add(const Duration(days: 30));
  final dailyTasks = <DateTime, List<StudyTask>>{};

  // Generate tasks for next 30 days
  for (int i = 0; i < 30; i++) {
    final date = DateTime.now().add(Duration(days: i));
    final normalizedDate = DateTime(date.year, date.month, date.day);

    if (i % 7 == 6) {
      // Rest day every 7th day
      dailyTasks[normalizedDate] = [
        StudyTask(
          id: 'rest_$i',
          title: 'Rest Day - Review notes',
          type: 'rest',
          isCompleted: i < 7,
          estimatedMinutes: 30,
        ),
      ];
    } else if (i % 5 == 0) {
      // Mock exam every 5 days
      dailyTasks[normalizedDate] = [
        StudyTask(
          id: 'mock_$i',
          title: 'Full Mock Exam',
          type: 'mock',
          isCompleted: i < 7,
          estimatedMinutes: 120,
        ),
      ];
    } else {
      // Regular practice days
      dailyTasks[normalizedDate] = [
        StudyTask(
          id: 'practice_${i}_1',
          title: 'Practice Mathematics',
          type: 'practice',
          isCompleted: i < 7,
          estimatedMinutes: 45,
        ),
        StudyTask(
          id: 'practice_${i}_2',
          title: 'Practice English',
          type: 'practice',
          isCompleted: i < 7,
          estimatedMinutes: 45,
        ),
        StudyTask(
          id: 'review_$i',
          title: 'Review weak topics',
          type: 'review',
          isCompleted: i < 7,
          estimatedMinutes: 30,
        ),
      ];
    }
  }

  return StudyPlan(
    examDate: examDate,
    dailyTasks: dailyTasks,
    totalDays: 30,
    completedDays: 7,
  );
}
