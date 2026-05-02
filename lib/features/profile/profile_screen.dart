import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/auth_provider.dart';
import '../../core/theme/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final name = user?.name ?? 'Student';
    final examTarget = user?.examTarget ?? 'JAMB';
    final subscription = user?.subscriptionStatus ?? 'FREE';
    final xp = user?.xpTotal ?? 0;
    final streak = user?.streakCurrent ?? 0;
    final days = user?.daysUntilExam ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () => context.go('/settings'),
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      name.isNotEmpty ? name.trim().substring(0, 1).toUpperCase() : 'N',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text('$examTarget • ${days <= 0 ? 'No exam date set' : '$days days to exam'}'),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: subscription == 'FREE' ? Colors.grey.shade200 : Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      subscription,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: subscription == 'FREE' ? Colors.black87 : Colors.brown.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _StatTile(label: 'XP Total', value: '$xp', icon: Icons.bolt_outlined)),
              const SizedBox(width: 12),
              Expanded(child: _StatTile(label: 'Current Streak', value: '$streak', icon: Icons.local_fire_department_outlined)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _StatTile(label: 'National Rank', value: '—', icon: Icons.emoji_events_outlined)),
              SizedBox(width: 12),
              Expanded(child: _StatTile(label: 'Questions Answered', value: '—', icon: Icons.check_circle_outline)),
            ],
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Level Progress', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Text('Level 7'),
                      const Spacer(),
                      Text('${(1000 - (xp % 1000)).clamp(0, 1000)} XP to next level'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(value: (xp % 1000) / 1000, minHeight: 10),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Badges', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 64,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => Container(
                width: 64,
                decoration: BoxDecoration(
                  color: i.isEven ? Colors.green.shade50 : Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: const Icon(Icons.workspace_premium_outlined),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.go('/achievements'),
              child: const Text('View all badges'),
            ),
          ),
          const SizedBox(height: 8),
          Text('Actions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: const Text('Edit Profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/profile/edit'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.family_restroom_outlined),
                  title: const Text('Invite Parent'),
                  subtitle: const Text('Generate 6-digit code (mock)'),
                  onTap: () {
                    final pin = (100000 + (DateTime.now().millisecondsSinceEpoch % 900000)).toString();
                    final expiresAt = DateFormat('MMM d, h:mm a').format(DateTime.now().add(const Duration(hours: 24)));
                    showDialog<void>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Parent Invite PIN'),
                        content: Text('PIN: $pin\nExpires: $expiresAt'),
                        actions: [
                          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Close')),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.share_outlined),
                  title: const Text('Refer a Friend'),
                  subtitle: const Text('Share your referral link (mock)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Referral sharing wiring happens later.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(subscription == 'FREE' ? Icons.lock_outline : Icons.verified_outlined),
              title: Text(subscription == 'FREE' ? 'Free Plan' : 'Premium'),
              subtitle: Text(subscription == 'FREE' ? 'Upgrade to unlock all subjects' : 'Active subscription'),
              trailing: FilledButton(
                onPressed: () => context.go('/subscription'),
                child: Text(subscription == 'FREE' ? 'Upgrade' : 'Manage'),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.link_outlined),
              title: const Text('Public Profile Link'),
              subtitle: const Text('Shareable link + QR (mock)'),
              trailing: const Icon(Icons.qr_code_2_outlined),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deep link + QR generation wiring happens later.')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatTile({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
