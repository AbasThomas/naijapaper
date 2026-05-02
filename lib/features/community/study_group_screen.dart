import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class StudyGroupScreen extends StatefulWidget {
  final String groupId;
  const StudyGroupScreen({super.key, required this.groupId});

  @override
  State<StudyGroupScreen> createState() => _StudyGroupScreenState();
}

class _StudyGroupScreenState extends State<StudyGroupScreen> {
  final _controller = TextEditingController();
  final List<_ChatMessage> _messages = [
    const _ChatMessage(sender: 'AI Moderator', text: 'Welcome! Please keep answers accurate.', isBot: true),
    const _ChatMessage(sender: 'Chika', text: 'Who sabi this quadratic formula shortcut?'),
    const _ChatMessage(sender: 'Tunde', text: 'Use completing square, but formula fast pass.', isBot: false),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() => _messages.add(_ChatMessage(sender: 'You', text: text)));
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Study Group • ${widget.groupId}'),
        actions: [
          IconButton(
            tooltip: 'Ask AI',
            onPressed: () => context.go('/ai-tutor/chat'),
            icon: const Icon(Icons.psychology_outlined),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$v (mock)')));
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'Mute room', child: Text('Mute room')),
              PopupMenuItem(value: 'Report room', child: Text('Report room')),
              PopupMenuItem(value: 'Leave room', child: Text('Leave room')),
              PopupMenuItem(value: 'View members', child: Text('View members')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.primary.withOpacity(0.06),
            child: const Text('Pinned resources (mock) • Tap to expand'),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, i) {
                final m = _messages[i];
                final isMe = m.sender == 'You';
                final bubbleColor = m.isBot
                    ? AppColors.primary.withOpacity(0.08)
                    : isMe
                        ? AppColors.primary
                        : Colors.grey.shade200;
                final textColor = isMe ? AppColors.textOnPrimary : AppColors.textPrimary;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(12),
                    constraints: const BoxConstraints(maxWidth: 320),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.circular(14),
                      border: m.isBot ? Border.all(color: AppColors.primary.withOpacity(0.25)) : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          Text(
                            m.sender,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: m.isBot ? AppColors.primary : Colors.black54,
                            ),
                          ),
                        if (!isMe) const SizedBox(height: 4),
                        Text(m.text, style: TextStyle(color: textColor)),
                        if (m.isBot) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text('Fact Check', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Share past question (mock)',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share question card - wire later.')));
                    },
                    icon: const Icon(Icons.quiz_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _send(),
                      decoration: const InputDecoration(hintText: 'Message…'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _send,
                    child: const Text('Send'),
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

class _ChatMessage {
  final String sender;
  final String text;
  final bool isBot;
  const _ChatMessage({required this.sender, required this.text, this.isBot = false});
}
