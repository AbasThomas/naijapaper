import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ParentDashboardScreen extends StatelessWidget {
  final String studentId;
  const ParentDashboardScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    // Mock data (replace with GET /parents/students/{id}/summary + heatmap + activity)
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Notifications prefs',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Parent notification prefs - wire later.')),
              );
            },
            icon: const Icon(Icons.notifications_active_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.school_outlined)),
              title: Text('Student $studentId'),
              subtitle: const Text('Exam: JAMB • 21 days to exam (mock)'),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _SummaryCard(title: 'Today\'s Streak', value: '5', icon: Icons.local_fire_department_outlined)),
              SizedBox(width: 12),
              Expanded(child: _SummaryCard(title: 'Mock Avg (Week)', value: '62%', icon: Icons.analytics_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          const _SummaryCard(title: 'Weakest Topic', value: 'Algebra', icon: Icons.warning_amber_outlined),
          const SizedBox(height: 16),
          Text('Heatmap (Read-only)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(
                  42,
                  (i) => Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.lerp(Colors.red, Colors.green, (i % 7) / 6)!,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Activity Log (7 days)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...List.generate(
            7,
            (i) => Card(
              child: ListTile(
                leading: const Icon(Icons.history_outlined),
                title: Text('Day ${7 - i}'),
                subtitle: Text('${15 + i * 4} mins • ${18 + i * 2} questions'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generate PDF report - wire to backend later.')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Share Progress Report (PDF)'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/subscription'),
            child: const Text('View Full Report (Premium)'),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
