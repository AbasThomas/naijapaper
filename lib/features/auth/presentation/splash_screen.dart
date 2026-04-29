import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

/// SplashScreen — App launch screen with routing logic
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    // TODO: Check authentication status
    // For now, navigate to welcome screen
    context.go('/onboarding/welcome');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // TODO: Add NaijaPaper logo
            Icon(
              Icons.school,
              size: 100,
              color: AppColors.textOnPrimary,
            ),
            const SizedBox(height: 24),
            Text(
              'NaijaPaper',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textOnPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pass Your Exam, Naija Style',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textOnPrimary.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
