import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PracticeHistoryScreen extends StatelessWidget {
  const PracticeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data (replace with GET /exams/recent + drill history)
    final recent = List.generate(
      12,
      (i) => _HistoryRow(
        id: 'sess_${i + 1}',
        type: i.isEven ? 'Mock Exam' : 'Daily Drill',
        score: i.isEven ? '${70 - i * 3}%' : '${(3 + (i % 3))}/5',
        when: '${i + 1} day(s) ago',
        route: i.isEven ? '/practice/mock/results/sess_${i + 1}' : '/practice/drill',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Practice History')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: recent
            .map(
              (h) => Card(
                child: ListTile(
                  leading: Icon(h.type == 'Mock Exam' ? Icons.fact_check_outlined : Icons.flash_on_outlined),
                  title: Text(h.type),
                  subtitle: Text('${h.score} • ${h.when}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go(h.route),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _HistoryRow {
  final String id;
  final String type;
  final String score;
  final String when;
  final String route;
  const _HistoryRow({required this.id, required this.type, required this.score, required this.when, required this.route});
}

