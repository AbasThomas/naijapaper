import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data (replace with GET /bookmarks)
    final items = List.generate(
      10,
      (i) => _BookmarkRow(
        id: 'q_${i + 1}',
        title: 'Bookmarked Question ${i + 1}',
        subtitle: 'Topic: Algebra • Year: 2020',
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: items
            .map(
              (b) => Card(
                child: ListTile(
                  leading: const Icon(Icons.bookmark_outline),
                  title: Text(b.title),
                  subtitle: Text(b.subtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // In the PRD this could open a bottom sheet question viewer.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Open question viewer (mock).')),
                    );
                  },
                ),
              ),
            )
            .toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/practice/questions'),
        icon: const Icon(Icons.search),
        label: const Text('Browse Questions'),
      ),
    );
  }
}

class _BookmarkRow {
  final String id;
  final String title;
  final String subtitle;
  const _BookmarkRow({required this.id, required this.title, required this.subtitle});
}

