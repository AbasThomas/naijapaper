import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data (replace with GET /admin/overview + GET /admin/students)
    const totalSeats = 120;
    const usedSeats = 86;
    final students = List.generate(
      12,
      (i) => _AdminStudentRow(
        id: 'stu_${i + 1}',
        name: 'Student ${i + 1}',
        streak: 2 + (i % 9),
        lastActive: i == 0 ? 'Today' : '${i + 1}d ago',
        mockAvg: 42 + (i * 3) % 55,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Institution Admin'),
        actions: [
          IconButton(
            tooltip: 'Setup',
            onPressed: () => context.go('/admin/setup'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SeatCard(usedSeats: usedSeats, totalSeats: totalSeats),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(
                child: _StatCard(
                  title: 'Avg Mock Score',
                  value: '58%',
                  icon: Icons.analytics_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  title: 'Active Today',
                  value: '34',
                  icon: Icons.local_fire_department_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _StatCard(
            title: 'Most Common Weak Topic',
            value: 'Algebra',
            icon: Icons.warning_amber_outlined,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Students',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('CSV import / enrolment code - wire to backend later.')),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text('Add Students'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...students.map(
            (s) => Card(
              child: ListTile(
                leading: CircleAvatar(child: Text(s.name.split(' ').last)),
                title: Text(s.name),
                subtitle: Text('Streak ${s.streak} • Last active: ${s.lastActive}'),
                trailing: Text('${s.mockAvg}%'),
                onTap: () => context.go('/admin/students/${s.id}'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Broadcast messaging - wire to backend later.')),
              );
            },
            icon: const Icon(Icons.campaign_outlined),
            label: const Text('Broadcast Notification'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Export cohort report PDF - wire to backend later.')),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_outlined),
            label: const Text('Export Cohort Report (PDF)'),
          ),
        ],
      ),
    );
  }
}

class _AdminStudentRow {
  final String id;
  final String name;
  final int streak;
  final String lastActive;
  final int mockAvg;

  const _AdminStudentRow({
    required this.id,
    required this.name,
    required this.streak,
    required this.lastActive,
    required this.mockAvg,
  });
}

class _SeatCard extends StatelessWidget {
  final int usedSeats;
  final int totalSeats;

  const _SeatCard({required this.usedSeats, required this.totalSeats});

  @override
  Widget build(BuildContext context) {
    final ratio = totalSeats == 0 ? 0.0 : (usedSeats / totalSeats).clamp(0.0, 1.0);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.badge_outlined, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Seat Licence Overview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('$usedSeats of $totalSeats seats used', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(value: ratio, minHeight: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _StatCard({required this.title, required this.value, required this.icon});

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
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

