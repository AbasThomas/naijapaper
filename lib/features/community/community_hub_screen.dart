import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CommunityHubScreen extends StatefulWidget {
  const CommunityHubScreen({super.key});

  @override
  State<CommunityHubScreen> createState() => _CommunityHubScreenState();
}

class _CommunityHubScreenState extends State<CommunityHubScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groups = const [
      _GroupRow(id: 'grp_math', title: 'JAMB Mathematics', members: 1340),
      _GroupRow(id: 'grp_eng', title: 'WAEC English', members: 980),
      _GroupRow(id: 'grp_bio', title: 'Biology Drill Crew', members: 522),
    ];

    final trending = const [
      _ForumRow(id: 'q_1', title: 'Explain simultaneous equations like I be 5', votes: 122, answers: 18),
      _ForumRow(id: 'q_2', title: 'Difference between meiosis and mitosis?', votes: 88, answers: 10),
      _ForumRow(id: 'q_3', title: 'Organic chemistry: naming alkanes', votes: 64, answers: 7),
    ];

    final liveRooms = const [
      _LiveRow(id: 'room_1', title: 'Chemistry Co‑Study', time: 'Today 7:00 PM'),
      _LiveRow(id: 'room_2', title: 'English Essay Clinic', time: 'Tomorrow 5:30 PM'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Study Groups'),
            Tab(text: 'Forum'),
            Tab(text: 'Live Rooms'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create group (premium) - wire later.')),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Group'),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: groups
                .map(
                  (g) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.group_outlined),
                      title: Text(g.title),
                      subtitle: Text('${g.members} members'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.go('/community/groups/${g.id}'),
                    ),
                  ),
                )
                .toList(),
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...trending.map(
                (q) => Card(
                  child: ListTile(
                    leading: const Icon(Icons.forum_outlined),
                    title: Text(q.title),
                    subtitle: Text('${q.votes} votes • ${q.answers} answers'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/community/forum/${q.id}'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.go('/community/forum'),
                icon: const Icon(Icons.list_alt_outlined),
                label: const Text('Browse all forum questions'),
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(16),
            children: liveRooms
                .map(
                  (r) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.mic_none_outlined),
                      title: Text(r.title),
                      subtitle: Text(r.time),
                      trailing: FilledButton(
                        onPressed: () => context.go('/community/live/${r.id}'),
                        child: const Text('Join'),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _GroupRow {
  final String id;
  final String title;
  final int members;
  const _GroupRow({required this.id, required this.title, required this.members});
}

class _ForumRow {
  final String id;
  final String title;
  final int votes;
  final int answers;
  const _ForumRow({required this.id, required this.title, required this.votes, required this.answers});
}

class _LiveRow {
  final String id;
  final String title;
  final String time;
  const _LiveRow({required this.id, required this.title, required this.time});
}
