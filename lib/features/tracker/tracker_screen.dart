import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exams = const [
      _TrackerItem(type: 'exam', id: 'jamb_reg', title: 'JAMB Registration', subtitle: 'Registration window', countdown: '12 days'),
      _TrackerItem(type: 'exam', id: 'waec_day', title: 'WAEC Exam Day', subtitle: 'Main exam date', countdown: '41 days'),
      _TrackerItem(type: 'exam', id: 'neco_res', title: 'NECO Results', subtitle: 'Results expected', countdown: '84 days'),
    ];

    final scholarships = const [
      _TrackerItem(type: 'scholarship', id: 'lagos_stem', title: 'Lagos STEM Scholarship', subtitle: 'Undergrad • STEM', countdown: '9 days'),
      _TrackerItem(type: 'scholarship', id: 'nysc_abroad', title: 'Study Abroad Grant', subtitle: 'International', countdown: '27 days'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam & Scholarship Tracker'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Exams'),
            Tab(text: 'Scholarships'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Calendar export',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generate .ics and share (mock).')),
              );
            },
            icon: const Icon(Icons.calendar_month_outlined),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          _TrackerList(items: exams),
          _TrackerList(items: scholarships),
        ],
      ),
    );
  }
}

class _TrackerList extends StatelessWidget {
  final List<_TrackerItem> items;
  const _TrackerList({required this.items});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.push_pin_outlined),
            title: const Text('Pinned Items'),
            subtitle: const Text('Pin your important deadlines (mock)'),
            trailing: TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pinning wiring later.')));
              },
              child: const Text('Manage'),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (i) => Card(
            child: ListTile(
              leading: Icon(i.type == 'exam' ? Icons.event_outlined : Icons.school_outlined),
              title: Text(i.title),
              subtitle: Text(i.subtitle),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(i.countdown, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  const Text('left', style: TextStyle(fontSize: 12)),
                ],
              ),
              onTap: () => context.go('/tracker/${i.type}/${i.id}'),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackerItem {
  final String type; // exam|scholarship
  final String id;
  final String title;
  final String subtitle;
  final String countdown;
  const _TrackerItem({required this.type, required this.id, required this.title, required this.subtitle, required this.countdown});
}
