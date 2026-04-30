import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/subject_chip.dart';
import 'presentation/exam_notifier.dart';

// Mock subjects provider (replace with real API call)
final subjectsProvider = FutureProvider<List<Subject>>((ref) async {
  // TODO: Replace with actual API call
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    Subject(id: 'math', name: 'Mathematics', examType: 'JAMB'),
    Subject(id: 'eng', name: 'English', examType: 'JAMB'),
    Subject(id: 'phy', name: 'Physics', examType: 'JAMB'),
    Subject(id: 'chem', name: 'Chemistry', examType: 'JAMB'),
    Subject(id: 'bio', name: 'Biology', examType: 'JAMB'),
    Subject(id: 'econ', name: 'Economics', examType: 'JAMB'),
    Subject(id: 'geo', name: 'Geography', examType: 'JAMB'),
    Subject(id: 'lit', name: 'Literature', examType: 'JAMB'),
  ];
});

class Subject {
  final String id;
  final String name;
  final String examType;

  Subject({
    required this.id,
    required this.name,
    required this.examType,
  });
}

class MockSetupScreen extends ConsumerStatefulWidget {
  const MockSetupScreen({super.key});

  @override
  ConsumerState<MockSetupScreen> createState() => _MockSetupScreenState();
}

class _MockSetupScreenState extends ConsumerState<MockSetupScreen> {
  String _examType = 'JAMB';
  final Set<String> _selectedSubjects = {};
  double _questionCount = 40;
  bool _isTimed = true;
  int _durationMinutes = 60;
  bool _aiProctorEnabled = false;
  int _yearFrom = 2015;
  int _yearTo = 2024;
  String _difficulty = 'ALL';
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(subjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configure Mock Exam'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Exam Type Selection
            _buildSectionTitle('Exam Type'),
            const SizedBox(height: 12),
            _buildExamTypeSelector(),

            const SizedBox(height: 24),

            // Subject Selection
            _buildSectionTitle('Select Subjects'),
            const SizedBox(height: 8),
            Text(
              'Choose ${_getMaxSubjects()} subjects for $_examType',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            subjectsAsync.when(
              data: (subjects) => _buildSubjectSelection(subjects),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),

            const SizedBox(height: 24),

            // Question Count
            _buildSectionTitle('Number of Questions'),
            const SizedBox(height: 12),
            _buildQuestionCountSlider(),

            const SizedBox(height: 24),

            // Time Limit
            _buildSectionTitle('Time Limit'),
            const SizedBox(height: 12),
            _buildTimeLimitToggle(),
            if (_isTimed) ...[
              const SizedBox(height: 12),
              _buildDurationSlider(),
            ],

            const SizedBox(height: 24),

            // Year Range
            _buildSectionTitle('Year Range'),
            const SizedBox(height: 12),
            _buildYearRangeSelector(),

            const SizedBox(height: 24),

            // Difficulty Filter
            _buildSectionTitle('Difficulty'),
            const SizedBox(height: 12),
            _buildDifficultySelector(),

            const SizedBox(height: 24),

            // AI Proctor
            _buildSectionTitle('AI Proctor'),
            const SizedBox(height: 12),
            _buildAIProctorToggle(),

            const SizedBox(height: 32),

            // Summary Card
            _buildSummaryCard(),

            const SizedBox(height: 24),

            // Start Button
            ElevatedButton(
              onPressed: _canStartExam() ? _startExam : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.border,
              ),
              child: _isCreating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(AppColors.textOnPrimary),
                      ),
                    )
                  : const Text(
                      'Start Exam',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildExamTypeSelector() {
    final types = ['JAMB', 'WAEC', 'NECO', 'POST-UTME'];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) {
        final isSelected = _examType == type;
        return ChoiceChip(
          label: Text(type),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              _examType = type;
              _selectedSubjects.clear();
              _questionCount = _getDefaultQuestionCount();
            });
          },
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.textOnPrimary : AppColors.textPrimary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSubjectSelection(List<Subject> subjects) {
    final filteredSubjects = subjects
        .where((s) => s.examType == _examType)
        .toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: filteredSubjects.map((subject) {
        final isSelected = _selectedSubjects.contains(subject.id);
        final canSelect = _selectedSubjects.length < _getMaxSubjects() || isSelected;

        return SubjectChip(
          label: subject.name,
          isSelected: isSelected,
          onTap: canSelect
              ? () {
                  setState(() {
                    if (isSelected) {
                      _selectedSubjects.remove(subject.id);
                    } else {
                      _selectedSubjects.add(subject.id);
                    }
                  });
                }
              : null,
        );
      }).toList(),
    );
  }

  Widget _buildQuestionCountSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_questionCount.toInt()} questions',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              '~${_estimateTime()} mins',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Slider(
          value: _questionCount,
          min: 10,
          max: 100,
          divisions: 18,
          label: _questionCount.toInt().toString(),
          onChanged: (value) {
            setState(() => _questionCount = value);
          },
        ),
      ],
    );
  }

  Widget _buildTimeLimitToggle() {
    return SwitchListTile(
      title: const Text('Enable Time Limit'),
      subtitle: Text(
        _isTimed ? 'Exam will auto-submit when time expires' : 'Take as long as you need',
      ),
      value: _isTimed,
      onChanged: (value) {
        setState(() => _isTimed = value);
      },
      activeColor: AppColors.primary,
    );
  }

  Widget _buildDurationSlider() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$_durationMinutes minutes',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            Text(
              '${(_durationMinutes / _questionCount).toStringAsFixed(1)} min/question',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Slider(
          value: _durationMinutes.toDouble(),
          min: 15,
          max: 180,
          divisions: 33,
          label: '$_durationMinutes min',
          onChanged: (value) {
            setState(() => _durationMinutes = value.toInt());
          },
        ),
      ],
    );
  }

  Widget _buildYearRangeSelector() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('From', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              DropdownButtonFormField<int>(
                value: _yearFrom,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(15, (i) => 2010 + i)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _yearFrom = value);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('To', style: TextStyle(fontSize: 12)),
              const SizedBox(height: 4),
              DropdownButtonFormField<int>(
                value: _yearTo,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: List.generate(15, (i) => 2010 + i)
                    .map((year) => DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _yearTo = value);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultySelector() {
    final difficulties = ['ALL', 'EASY', 'MEDIUM', 'HARD'];

    return SegmentedButton<String>(
      segments: difficulties.map((diff) {
        return ButtonSegment(
          value: diff,
          label: Text(diff),
        );
      }).toList(),
      selected: {_difficulty},
      onSelectionChanged: (Set<String> newSelection) {
        setState(() => _difficulty = newSelection.first);
      },
    );
  }

  Widget _buildAIProctorToggle() {
    return SwitchListTile(
      title: const Text('Enable AI Proctor'),
      subtitle: const Text('AI will monitor your exam session'),
      value: _aiProctorEnabled,
      onChanged: (value) {
        setState(() => _aiProctorEnabled = value);
      },
      activeColor: AppColors.primary,
      secondary: const Icon(Icons.psychology),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: AppColors.primaryLight.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Exam Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(Icons.school, 'Exam Type', _examType),
            _buildSummaryRow(
              Icons.subject,
              'Subjects',
              _selectedSubjects.isEmpty
                  ? 'None selected'
                  : '${_selectedSubjects.length} selected',
            ),
            _buildSummaryRow(
              Icons.quiz,
              'Questions',
              '${_questionCount.toInt()} questions',
            ),
            _buildSummaryRow(
              Icons.timer,
              'Duration',
              _isTimed ? '$_durationMinutes minutes' : 'Untimed',
            ),
            _buildSummaryRow(
              Icons.calendar_today,
              'Years',
              '$_yearFrom - $_yearTo',
            ),
            if (_aiProctorEnabled)
              _buildSummaryRow(
                Icons.psychology,
                'AI Proctor',
                'Enabled',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  int _getMaxSubjects() {
    switch (_examType) {
      case 'JAMB':
        return 4;
      case 'WAEC':
        return 9;
      case 'NECO':
        return 9;
      case 'POST-UTME':
        return 4;
      default:
        return 4;
    }
  }

  double _getDefaultQuestionCount() {
    switch (_examType) {
      case 'JAMB':
        return 40;
      case 'WAEC':
        return 50;
      case 'NECO':
        return 50;
      case 'POST-UTME':
        return 40;
      default:
        return 40;
    }
  }

  int _estimateTime() {
    return (_questionCount * 1.5).toInt();
  }

  bool _canStartExam() {
    return _selectedSubjects.isNotEmpty && !_isCreating;
  }

  Future<void> _startExam() async {
    if (!_canStartExam()) return;

    setState(() => _isCreating = true);

    try {
      // Create exam using the provider
      final examSession = await ref.read(
        createExamProvider(CreateExamParams(
          examType: _examType,
          subjectIds: _selectedSubjects.toList(),
          questionCount: _questionCount.toInt(),
          isTimed: _isTimed,
          aiProctorEnabled: _aiProctorEnabled,
          yearFrom: _yearFrom,
          yearTo: _yearTo,
        )).future,
      );

      if (!mounted) return;

      // Navigate to active exam screen
      context.go('/practice/mock/active/${examSession.id}');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create exam: $e'),
          backgroundColor: AppColors.error,
        ),
      );

      setState(() => _isCreating = false);
    }
  }
}
