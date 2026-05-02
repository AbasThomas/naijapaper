import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class LiveRoomScreen extends StatefulWidget {
  final String roomId;
  const LiveRoomScreen({super.key, required this.roomId});

  @override
  State<LiveRoomScreen> createState() => _LiveRoomScreenState();
}

class _LiveRoomScreenState extends State<LiveRoomScreen> {
  bool _muted = false;
  bool _speaker = true;
  bool _host = true; // mock host
  bool _timerRunning = false;
  int _secondsLeft = 25 * 60;

  String get _timerText {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Room • ${widget.roomId}'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.timer_outlined),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Shared Pomodoro Timer', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text(_timerText, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  if (_host)
                    FilledButton(
                      onPressed: () => setState(() => _timerRunning = !_timerRunning),
                      child: Text(_timerRunning ? 'Pause' : 'Start'),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 64,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => CircleAvatar(
                backgroundColor: i == 0 ? AppColors.primary.withOpacity(0.12) : Colors.grey.shade200,
                child: Icon(i == 0 ? Icons.record_voice_over_outlined : Icons.person_outline, color: i == 0 ? AppColors.primary : Colors.black54),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.quiz_outlined),
                    title: const Text('Host pushed question'),
                    subtitle: const Text('What is the difference between… (mock)'),
                    trailing: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open question card (mock).')));
                      },
                      child: const Text('Open'),
                    ),
                  ),
                ),
                ...List.generate(
                  8,
                  (i) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.chat_bubble_outline),
                      title: Text('Message ${i + 1}'),
                      subtitle: const Text('Text chat sidebar content (mock).'),
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
                  IconButton(
                    tooltip: _muted ? 'Unmute' : 'Mute',
                    onPressed: () => setState(() => _muted = !_muted),
                    icon: Icon(_muted ? Icons.mic_off_outlined : Icons.mic_none_outlined),
                  ),
                  IconButton(
                    tooltip: _speaker ? 'Speaker off' : 'Speaker on',
                    onPressed: () => setState(() => _speaker = !_speaker),
                    icon: Icon(_speaker ? Icons.volume_up_outlined : Icons.volume_off_outlined),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.exit_to_app_outlined),
                    label: const Text('Leave'),
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
