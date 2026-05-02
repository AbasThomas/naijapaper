import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class AiProctorResultsScreen extends StatelessWidget {
  final String sessionId;
  const AiProctorResultsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    // Mock content (replace with GET /ai/proctor-analysis/{sessionId})
    const summary =
        'You started strong but lost time on Algebra and Comprehension questions. Your accuracy dropped after question 25, likely from rushing. Focus on: (1) Algebraic manipulation, (2) Reading speed, (3) Time budgeting.';

    final priorities = const [
      _PriorityCardData(level: 'Critical', topic: 'Algebra', accuracy: 34, action: 'Do 20 drills + review mistakes'),
      _PriorityCardData(level: 'Needs Work', topic: 'Comprehension', accuracy: 52, action: 'Practice 10 passages with timer'),
      _PriorityCardData(level: 'Strong', topic: 'Geometry', accuracy: 78, action: 'Maintain with spaced repetition'),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('AI Proctor Report')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.assignment_turned_in_outlined),
              title: const Text('Exam Session'),
              subtitle: Text(sessionId),
              trailing: IconButton(
                tooltip: 'TTS (mock)',
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('TTS playback wiring later.')));
                },
                icon: const Icon(Icons.volume_up_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('What went wrong', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const Text(summary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('Priority Areas', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...priorities.map((p) => _PriorityCard(p)),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Build recovery plan - wire to PATCH /study-plans/me later.')),
              );
              context.go('/dashboard/study-plan');
            },
            icon: const Icon(Icons.auto_fix_high_outlined),
            label: const Text('Build Recovery Plan'),
          ),
        ],
      ),
    );
  }
}

class _PriorityCardData {
  final String level;
  final String topic;
  final int accuracy;
  final String action;
  const _PriorityCardData({required this.level, required this.topic, required this.accuracy, required this.action});
}

class _PriorityCard extends StatelessWidget {
  final _PriorityCardData data;
  const _PriorityCard(this.data);

  @override
  Widget build(BuildContext context) {
    final (Color c, IconData icon) = switch (data.level) {
      'Critical' => (Colors.red, Icons.error_outline),
      'Needs Work' => (Colors.orange, Icons.warning_amber_outlined),
      _ => (Colors.green, Icons.check_circle_outline),
    };
    return Card(
      child: ListTile(
        leading: Icon(icon, color: c),
        title: Text('${data.topic} • ${data.accuracy}%'),
        subtitle: Text(data.action),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: c.withOpacity(0.12),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: c.withOpacity(0.25)),
          ),
          child: Text(data.level, style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        ),
      ),
    );
  }
}
