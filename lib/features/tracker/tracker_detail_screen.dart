import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TrackerDetailScreen extends StatelessWidget {
  final String type;
  final String itemId;
  const TrackerDetailScreen({super.key, required this.type, required this.itemId});

  @override
  Widget build(BuildContext context) {
    final title = type == 'exam' ? 'Exam Item' : 'Scholarship Item';
    final officialUrl = Uri.parse('https://example.com/$type/$itemId');

    return Scaffold(
      appBar: AppBar(title: const Text('Tracker Item')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(type == 'exam' ? Icons.event_outlined : Icons.school_outlined),
              title: Text('$title • $itemId'),
              subtitle: const Text('Countdown: 12 days (mock)'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Key Dates', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  const _DateRow('Registration Open', 'May 10'),
                  const _DateRow('Registration Close', 'June 2'),
                  const _DateRow('Main Date', 'June 20'),
                  const _DateRow('Results', 'July 15'),
                ],
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
                  Text('Eligibility / Requirements', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  ...List.generate(
                    5,
                    (i) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: i == 0,
                      onChanged: (_) {},
                      title: Text('Requirement ${i + 1} (mock)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              final ok = await launchUrl(officialUrl, mode: LaunchMode.externalApplication);
              if (!ok && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Could not open link.')));
              }
            },
            icon: const Icon(Icons.open_in_new),
            label: const Text('Official Website'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add to calendar (.ics) - wire later.')));
            },
            icon: const Icon(Icons.calendar_month_outlined),
            label: const Text('Add to Calendar'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share item - wire later.')));
            },
            icon: const Icon(Icons.share_outlined),
            label: const Text('Share'),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  final String label;
  final String value;
  const _DateRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}
