import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ForumQuestionScreen extends StatefulWidget {
  final String questionId;
  const ForumQuestionScreen({super.key, required this.questionId});

  @override
  State<ForumQuestionScreen> createState() => _ForumQuestionScreenState();
}

class _ForumQuestionScreenState extends State<ForumQuestionScreen> {
  final _answer = TextEditingController();

  @override
  void dispose() {
    _answer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final answers = List.generate(
      6,
      (i) => _AnswerRow(
        author: i == 0 ? 'AI Suggested' : 'User $i',
        body: i == 0
            ? 'Try breaking it down step-by-step. First, identify… (mock)'
            : 'My approach: start with… (mock)',
        votes: 14 - i * 2,
        verified: i == 0,
        accepted: i == 1,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Forum Thread')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Question ${widget.questionId}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        const Text('How do I solve this quickly, and how do I know which method to use? (mock)'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 6,
                          children: const [
                            Chip(label: Text('Math'), visualDensity: VisualDensity.compact),
                            Chip(label: Text('JAMB'), visualDensity: VisualDensity.compact),
                            Chip(label: Text('Algebra'), visualDensity: VisualDensity.compact),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_up_outlined)),
                            const Text('124'),
                            const SizedBox(width: 10),
                            IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_down_outlined)),
                            const Spacer(),
                            Text('Asked 3h ago', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text('Answers', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...answers.map(
                  (a) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(a.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              if (a.verified)
                                const Row(
                                  children: [
                                    Icon(Icons.verified, size: 16, color: AppColors.primary),
                                    SizedBox(width: 4),
                                    Text('AI‑verified', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12)),
                                  ],
                                ),
                              const Spacer(),
                              if (a.accepted)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Text('Accepted', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.green)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(a.body),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_up_outlined)),
                              Text('${a.votes}'),
                              const SizedBox(width: 10),
                              IconButton(onPressed: () {}, icon: const Icon(Icons.thumb_down_outlined)),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply threading - wire later.')));
                                },
                                child: const Text('Reply'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _answer,
                      decoration: const InputDecoration(hintText: 'Write an answer…'),
                      minLines: 1,
                      maxLines: 4,
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {
                      final text = _answer.text.trim();
                      if (text.isEmpty) return;
                      _answer.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Posted answer (mock). Wire to POST /forums/questions/:id/answers later.')),
                      );
                    },
                    child: const Text('Post'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerRow {
  final String author;
  final String body;
  final int votes;
  final bool verified;
  final bool accepted;
  const _AnswerRow({required this.author, required this.body, required this.votes, required this.verified, required this.accepted});
}
