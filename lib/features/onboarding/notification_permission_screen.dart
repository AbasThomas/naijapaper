import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_button.dart';

/// NotificationPermissionScreen — Request push notification opt-in
class NotificationPermissionScreen extends StatelessWidget {
  const NotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_active,
                size: 120,
                color: AppColors.primary,
              ),
              const SizedBox(height: 32),
              Text(
                'Stay on track with smart reminders',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '• Daily drills\n• Exam deadlines\n• Streak alerts',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              AppButton(
                text: 'Allow Notifications',
                onPressed: () {
                  // TODO: Request notification permission
                  context.go('/dashboard');
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Maybe later'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
