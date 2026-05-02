import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForumScreen extends StatefulWidget {
  const ForumScreen({super.key});

  @override
  State<ForumScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumScreen> {
  int _tab = 0;
  String _subject = 'All';

  @override
  Widget build(BuildContext context) {
    final questions = List.generate(
      12,
      (i) => _ForumQuestionRow(
        id: 'q_${i + 1}',
        title: 'Question ${i + 1}: How do I solve this topic fast?',
        tags: ['Math', 'Algebra', if (i.isEven) 'WAEC' else 'JAMB'],
        votes: 10 + i * 4,
        answers: i % 5,
        time: '${i + 1}h ago',
        aiVerified: i == 0,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        actions: [
          IconButton(
            tooltip: 'Ask question',
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (ctx) => const _AskQuestionSheet(),
              );
            },
            icon: const Icon(Icons.add_comment_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 0, label: Text('All')),
                      ButtonSegment(value: 1, label: Text('Unanswered')),
                      ButtonSegment(value: 2, label: Text('My Questions')),
                      ButtonSegment(value: 3, label: Text('Hot')),
                    ],
                    selected: {_tab},
                    onSelectionChanged: (s) => setState(() => _tab = s.first),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.filter_alt_outlined, size: 18),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _subject,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Subjects')),
                    DropdownMenuItem(value: 'Math', child: Text('Mathematics')),
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Biology', child: Text('Biology')),
                    DropdownMenuItem(value: 'Chemistry', child: Text('Chemistry')),
                  ],
                  onChanged: (v) => setState(() => _subject = v ?? _subject),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              itemCount: questions.length,
              itemBuilder: (context, i) {
                final q = questions[i];
                if (_tab == 1 && q.answers > 0) return const SizedBox.shrink();
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        Expanded(child: Text(q.title, maxLines: 2, overflow: TextOverflow.ellipsis)),
                        if (q.aiVerified)
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Icon(Icons.verified, size: 18),
                          ),
                      ],
                    ),
                    subtitle: Wrap(
                      spacing: 6,
                      runSpacing: -8,
                      children: [
                        ...q.tags.map((t) => Chip(label: Text(t), visualDensity: VisualDensity.compact)),
                        Text('  • ${q.votes} votes • ${q.answers} answers • ${q.time}'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/community/forum/${q.id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ForumQuestionRow {
  final String id;
  final String title;
  final List<String> tags;
  final int votes;
  final int answers;
  final String time;
  final bool aiVerified;
  const _ForumQuestionRow({
    required this.id,
    required this.title,
    required this.tags,
    required this.votes,
    required this.answers,
    required this.time,
    required this.aiVerified,
  });
}

class _AskQuestionSheet extends StatefulWidget {
  const _AskQuestionSheet();

  @override
  State<_AskQuestionSheet> createState() => _AskQuestionSheetState();
}

class _AskQuestionSheetState extends State<_AskQuestionSheet> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Ask a Question', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Body'),
            maxLines: 4,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Posted (mock). Wire to POST /forums/questions later.')),
              );
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
