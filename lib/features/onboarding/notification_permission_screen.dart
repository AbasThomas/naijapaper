import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/theme/app_colors.dart';

class NotificationPermissionScreen extends ConsumerStatefulWidget {
  const NotificationPermissionScreen({super.key});

  @override
  ConsumerState<NotificationPermissionScreen> createState() =>
      _NotificationPermissionScreenState();
}

class _NotificationPermissionScreenState
    extends ConsumerState<NotificationPermissionScreen> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Progress Indicator
              Row(
                children: [
                  _buildProgressDot(true),
                  _buildProgressLine(),
                  _buildProgressDot(true),
                  _buildProgressLine(),
                  _buildProgressDot(true),
                ],
              ),

              const Spacer(),

              // Illustration
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active,
                  size: 100,
                  color: AppColors.primary,
                ),
              ).animate().scale(
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

              const SizedBox(height: 32),

              // Title
              const Text(
                'Stay on Track',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 300.ms),

              const SizedBox(height: 16),

              // Description
              Text(
                'Get reminders for your daily drills, study sessions, and exam dates',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 32),

              // Benefits List
              _buildBenefitItem(
                Icons.alarm,
                'Daily Drill Reminders',
                'Never miss your daily practice',
              ).animate().fadeIn(delay: 500.ms).slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              _buildBenefitItem(
                Icons.event,
                'Exam Countdown',
                'Stay prepared with timely alerts',
              ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2, end: 0),

              const SizedBox(height: 16),

              _buildBenefitItem(
                Icons.trending_up,
                'Progress Updates',
                'Celebrate your achievements',
              ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2, end: 0),

              const Spacer(),

              // Enable Button
              ElevatedButton(
                onPressed: _isRequesting ? null : _requestPermission,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isRequesting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Enable Notifications',
                        style: TextStyle(fontSize: 16),
                      ),
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 16),

              // Skip Button
              TextButton(
                onPressed: () => _completeOnboarding(),
                child: const Text('Maybe Later'),
              ).animate().fadeIn(delay: 900.ms),
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

  Widget _buildBenefitItem(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _requestPermission() async {
    setState(() => _isRequesting = true);

    try {
      final status = await Permission.notification.request();

      if (!mounted) return;

      if (status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications enabled!'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      _completeOnboarding();
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
        setState(() => _isRequesting = false);
      }
    }
  }

  void _completeOnboarding() {
    // TODO: Mark onboarding as complete in storage
    context.go('/dashboard');
  }
}
