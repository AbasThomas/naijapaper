import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/subject_chip.dart';

// Mock subjects provider
final availableSubjectsProvider = FutureProvider<List<Subject>>((ref) async {
  await Future.delayed(const Duration(milliseconds: 500));
  return [
    Subject(id: 'math', name: 'Mathematics', icon: Icons.calculate),
    Subject(id: 'eng', name: 'English', icon: Icons.book),
    Subject(id: 'phy', name: 'Physics', icon: Icons.science),
    Subject(id: 'chem', name: 'Chemistry', icon: Icons.biotech),
    Subject(id: 'bio', name: 'Biology', icon: Icons.eco),
    Subject(id: 'econ', name: 'Economics', icon: Icons.trending_up),
    Subject(id: 'geo', name: 'Geography', icon: Icons.public),
    Subject(id: 'lit', name: 'Literature', icon: Icons.menu_book),
    Subject(id: 'gov', name: 'Government', icon: Icons.account_balance),
    Subject(id: 'crk', name: 'CRK', icon: Icons.church),
    Subject(id: 'agric', name: 'Agriculture', icon: Icons.agriculture),
    Subject(id: 'comm', name: 'Commerce', icon: Icons.business),
  ];
});

class Subject {
  final String id;
  final String name;
  final IconData icon;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
  });
}

class SubjectSelectionScreen extends ConsumerStatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  ConsumerState<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends ConsumerState<SubjectSelectionScreen> {
  final Set<String> _selectedSubjects = {};
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final subjectsAsync = ref.watch(availableSubjectsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subjects'),
      ),
      body: Column(
        children: [
          // Progress Indicator
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                _buildProgressDot(true),
                _buildProgressLine(),
                _buildProgressDot(true),
                _buildProgressLine(),
                _buildProgressDot(false),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Header
                  const Text(
                    'Choose your subjects',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select at least 4 subjects you want to focus on',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Selected Count
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _selectedSubjects.length >= 4
                          ? AppColors.success.withOpacity(0.1)
                          : AppColors.warning.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedSubjects.length >= 4
                            ? AppColors.success
                            : AppColors.warning,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _selectedSubjects.length >= 4
                              ? Icons.check_circle
                              : Icons.info_outline,
                          color: _selectedSubjects.length >= 4
                              ? AppColors.success
                              : AppColors.warning,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_selectedSubjects.length} subjects selected',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _selectedSubjects.length >= 4
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Subjects Grid
                  subjectsAsync.when(
                    data: (subjects) => _buildSubjectsGrid(subjects),
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => Center(
                      child: Text('Error: $error'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(24),
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
                ElevatedButton(
                  onPressed: _selectedSubjects.length >= 4 && !_isSubmitting
                      ? _continue
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.go('/onboarding/notifications'),
                  child: const Text('Skip for now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectsGrid(List<Subject> subjects) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        final isSelected = _selectedSubjects.contains(subject.id);

        return InkWell(
          onTap: () => _toggleSubject(subject.id),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    subject.icon,
                    size: 32,
                    color: isSelected
                        ? AppColors.textOnPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subject.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isSelected)
                  const Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Icon(
                      Icons.check_circle,
                      size: 20,
                      color: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (index * 50).ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
      },
    );
  }

  Widget _buildProgressDot(bool isActive) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildProgressLine() {
    return Expanded(
      child: Container(
        height: 2,
        color: AppColors.border,
      ),
    );
  }

  void _toggleSubject(String subjectId) {
    setState(() {
      if (_selectedSubjects.contains(subjectId)) {
        _selectedSubjects.remove(subjectId);
      } else {
        _selectedSubjects.add(subjectId);
      }
    });
  }

  Future<void> _continue() async {
    if (_selectedSubjects.length < 4) return;

    setState(() => _isSubmitting = true);

    try {
      // TODO: Save selected subjects to API
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      context.go('/onboarding/notifications');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}
