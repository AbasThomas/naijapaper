import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class AITutorHomeScreen extends ConsumerWidget {
  const AITutorHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('AI Tutor'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.info,
                      AppColors.info.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.psychology,
                        size: 64,
                        color: AppColors.textOnPrimary.withOpacity(0.9),
                      ).animate().scale(
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Personal Study Assistant',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textOnPrimary.withOpacity(0.9),
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Main CTA
                  _buildMainCTA(context).animate().fadeIn().slideY(
                    begin: 0.2,
                    end: 0,
                    duration: 400.ms,
                  ),

                  const SizedBox(height: 24),

                  // Features Grid
                  Text(
                    'What I Can Help With',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn(delay: 200.ms),

                  const SizedBox(height: 16),

                  _buildFeaturesGrid(context),

                  const SizedBox(height: 24),

                  // Language Support
                  Text(
                    'Language Support',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 16),

                  _buildLanguageCard().animate().fadeIn(delay: 500.ms),

                  const SizedBox(height: 24),

                  // Quick Prompts
                  Text(
                    'Try Asking',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ).animate().fadeIn(delay: 600.ms),

                  const SizedBox(height: 16),

                  _buildQuickPrompts(context),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCTA(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.info,
            AppColors.info.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.info.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.chat_bubble,
            size: 48,
            color: AppColors.textOnPrimary,
          ),
          const SizedBox(height: 12),
          const Text(
            'Start Chatting',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textOnPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get instant help with any topic',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textOnPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/ai-tutor/chat'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.textOnPrimary,
              foregroundColor: AppColors.info,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Open Chat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesGrid(BuildContext context) {
    final features = [
      {
        'title': 'Explain Concepts',
        'subtitle': 'Break down complex topics',
        'icon': Icons.lightbulb_outline,
        'color': AppColors.warning,
      },
      {
        'title': 'Solve Problems',
        'subtitle': 'Step-by-step solutions',
        'icon': Icons.calculate,
        'color': AppColors.primary,
      },
      {
        'title': 'Practice Questions',
        'subtitle': 'Generate custom questions',
        'icon': Icons.quiz,
        'color': AppColors.success,
      },
      {
        'title': 'Study Tips',
        'subtitle': 'Improve your learning',
        'icon': Icons.tips_and_updates,
        'color': AppColors.error,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (feature['color'] as Color).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    feature['icon'] as IconData,
                    size: 32,
                    color: feature['color'] as Color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  feature['title'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  feature['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (300 + index * 100).ms).scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1, 1),
        );
      },
    );
  }

  Widget _buildLanguageCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.language,
                size: 32,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bilingual Support',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Chat in English or Pidgin\nSwitch anytime during conversation',
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
      ),
    );
  }

  Widget _buildQuickPrompts(BuildContext context) {
    final prompts = [
      'Explain quadratic equations',
      'How do I solve this problem?',
      'What is photosynthesis?',
      'Help me with essay writing',
      'Explain Newton\'s laws',
      'What are chemical bonds?',
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: prompts.map((prompt) {
        return ActionChip(
          label: Text(prompt),
          onPressed: () {
            context.go('/ai-tutor/chat', extra: {'initialMessage': prompt});
          },
          backgroundColor: AppColors.surfaceVariant,
          side: BorderSide(color: AppColors.border),
        );
      }).toList(),
    ).animate().fadeIn(delay: 700.ms);
  }
}
