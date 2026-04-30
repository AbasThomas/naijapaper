import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  String _examType = 'JAMB';
  String _targetYear = DateTime.now().year.toString();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _schoolController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Indicator
              Row(
                children: [
                  _buildProgressDot(true),
                  _buildProgressLine(),
                  _buildProgressDot(false),
                  _buildProgressLine(),
                  _buildProgressDot(false),
                ],
              ),

              const SizedBox(height: 32),

              // Header
              const Text(
                'Tell us about yourself',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This helps us personalize your experience',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 32),

              // Full Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // School
              TextFormField(
                controller: _schoolController,
                decoration: const InputDecoration(
                  labelText: 'School (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.school_outlined),
                ),
              ),

              const SizedBox(height: 20),

              // Exam Type
              DropdownButtonFormField<String>(
                value: _examType,
                decoration: const InputDecoration(
                  labelText: 'Target Exam',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.assignment_outlined),
                ),
                items: ['JAMB', 'WAEC', 'NECO', 'POST-UTME']
                    .map((exam) => DropdownMenuItem(
                          value: exam,
                          child: Text(exam),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _examType = value);
                  }
                },
              ),

              const SizedBox(height: 20),

              // Target Year
              DropdownButtonFormField<String>(
                value: _targetYear,
                decoration: const InputDecoration(
                  labelText: 'Target Year',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                items: List.generate(5, (i) => DateTime.now().year + i)
                    .map((year) => DropdownMenuItem(
                          value: year.toString(),
                          child: Text(year.toString()),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _targetYear = value);
                  }
                },
              ),

              const SizedBox(height: 32),

              // Continue Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _continue,
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

              const SizedBox(height: 16),

              // Skip Button
              TextButton(
                onPressed: () => context.go('/onboarding/subjects'),
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
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

  Future<void> _continue() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      // TODO: Save profile data to API
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      context.go('/onboarding/subjects');
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
