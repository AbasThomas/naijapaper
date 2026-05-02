import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class OfflineManagerScreen extends StatefulWidget {
  const OfflineManagerScreen({super.key});

  @override
  State<OfflineManagerScreen> createState() => _OfflineManagerScreenState();
}

class _OfflineManagerScreenState extends State<OfflineManagerScreen> {
  bool _wifiOnly = true;

  final List<_OfflineSubject> _subjects = [
    const _OfflineSubject(id: 'eng', name: 'English', sizeMb: 120, status: _OfflineStatus.ready),
    const _OfflineSubject(id: 'math', name: 'Mathematics', sizeMb: 98, status: _OfflineStatus.updateAvailable),
    const _OfflineSubject(id: 'bio', name: 'Biology', sizeMb: 140, status: _OfflineStatus.notDownloaded),
    const _OfflineSubject(id: 'chem', name: 'Chemistry', sizeMb: 132, status: _OfflineStatus.downloading, progress: 0.42),
    const _OfflineSubject(id: 'phy', name: 'Physics', sizeMb: 110, status: _OfflineStatus.notDownloaded),
  ];

  @override
  Widget build(BuildContext context) {
    final used = _subjects
        .where((s) => s.status == _OfflineStatus.ready || s.status == _OfflineStatus.updateAvailable || s.status == _OfflineStatus.downloading)
        .fold<double>(0, (p, s) => p + s.sizeMb);
    final total = 1024.0; // mock device budget
    final ratio = (used / total).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(title: const Text('Offline Content')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.wifi_outlined),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Wi‑Fi only downloads (recommended)',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Switch(value: _wifiOnly, onChanged: (v) => setState(() => _wifiOnly = v)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text('Storage used: ${used.toStringAsFixed(0)} MB of ${total.toStringAsFixed(0)} MB'),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: ratio, minHeight: 10),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tip: Download your subjects before NEPA does their thing.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Subjects', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Batch download all - wire to backend later.')),
                  );
                },
                icon: const Icon(Icons.download_outlined),
                label: const Text('Download all'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ..._subjects.map(_SubjectRow.new),
          const SizedBox(height: 12),
          Text(
            'Last synced: today (mock)',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SubjectRow extends StatelessWidget {
  final _OfflineSubject subject;
  const _SubjectRow(this.subject);

  @override
  Widget build(BuildContext context) {
    final statusText = switch (subject.status) {
      _OfflineStatus.notDownloaded => 'Not Downloaded',
      _OfflineStatus.downloading => 'Downloading ${(subject.progress * 100).round()}%',
      _OfflineStatus.ready => 'Ready',
      _OfflineStatus.updateAvailable => 'Update available',
    };

    Widget trailing;
    if (subject.status == _OfflineStatus.downloading) {
      trailing = SizedBox(
        width: 70,
        child: LinearProgressIndicator(value: subject.progress, minHeight: 8),
      );
    } else if (subject.status == _OfflineStatus.notDownloaded) {
      trailing = OutlinedButton(onPressed: () {}, child: const Text('Download'));
    } else if (subject.status == _OfflineStatus.updateAvailable) {
      trailing = FilledButton(onPressed: () {}, child: const Text('Update'));
    } else {
      trailing = OutlinedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Delete bundle - wire later.')));
        },
        child: const Text('Delete'),
      );
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: Text(subject.name.substring(0, 1), style: const TextStyle(color: AppColors.primary)),
        ),
        title: Text(subject.name),
        subtitle: Text('${subject.sizeMb.toStringAsFixed(0)} MB • $statusText'),
        trailing: trailing,
      ),
    );
  }
}

enum _OfflineStatus { notDownloaded, downloading, ready, updateAvailable }

class _OfflineSubject {
  final String id;
  final String name;
  final double sizeMb;
  final _OfflineStatus status;
  final double progress;

  const _OfflineSubject({
    required this.id,
    required this.name,
    required this.sizeMb,
    required this.status,
    this.progress = 0,
  });
}
