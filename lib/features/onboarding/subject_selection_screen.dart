import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';

/// SubjectSelectionScreen — Choose initial subjects (up to 5 free)
class SubjectSelectionScreen extends StatelessWidget {
  const SubjectSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Subjects'),
        backgroundColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Choose your subjects',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Select up to 5 subjects (free tier)',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              
              // TODO: Add subject grid
              Expanded(
                child: Center(
                  child: Text(
                    'Subject selection grid goes here',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
              
              AppButton(
                text: 'Start Learning',
                onPressed: () => context.go('/onboarding/notifications'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
