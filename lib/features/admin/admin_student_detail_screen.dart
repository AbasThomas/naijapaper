import 'package:flutter/material.dart';

class AdminStudentDetailScreen extends StatelessWidget {
  final String studentId;
  const AdminStudentDetailScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    // Mock detail (replace with GET /admin/students/{id})
    return Scaffold(
      appBar: AppBar(title: const Text('Student Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
              title: Text('Student $studentId'),
              subtitle: const Text('Read-only admin view'),
            ),
          ),
          const SizedBox(height: 12),
          const _SectionTitle('Heatmap (Preview)'),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                children: List.generate(
                  36,
                  (i) => Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color.lerp(Colors.red, Colors.green, (i % 9) / 8)!,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _SectionTitle('Mock History'),
          const SizedBox(height: 8),
          ...List.generate(
            5,
            (i) => Card(
              child: ListTile(
                leading: const Icon(Icons.fact_check_outlined),
                title: Text('Mock Exam • ${70 - i * 7}%'),
                subtitle: Text('${i + 1} week(s) ago'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
            ),
          ),
          const SizedBox(height: 12),
          const _SectionTitle('Actions'),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Remove student - wire to backend later.')),
              );
            },
            icon: const Icon(Icons.person_remove_outlined),
            label: const Text('Remove Student From Institution'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold));
  }
}

