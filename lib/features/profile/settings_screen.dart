import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/providers/auth_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _language = 'BOTH';
  bool _darkMode = false;
  bool _highContrast = false;
  double _fontScale = 1.0;

  bool _notifDaily = true;
  bool _notifExam = true;
  bool _notifCommunity = true;
  bool _notifStreaks = true;
  bool _notifMarketing = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    _language = user?.languagePref ?? _language;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Preferences'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language'),
                  subtitle: const Text('English / Pidgin'),
                  trailing: DropdownButton<String>(
                    value: _language,
                    items: const [
                      DropdownMenuItem(value: 'ENGLISH', child: Text('English')),
                      DropdownMenuItem(value: 'PIDGIN', child: Text('Pidgin')),
                      DropdownMenuItem(value: 'BOTH', child: Text('Both')),
                    ],
                    onChanged: (v) => setState(() => _language = v ?? _language),
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: _darkMode,
                  onChanged: (v) => setState(() => _darkMode = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('High Contrast Mode'),
                  value: _highContrast,
                  onChanged: (v) => setState(() => _highContrast = v),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Font Size'),
                  subtitle: Slider(
                    value: _fontScale,
                    min: 0.9,
                    max: 1.2,
                    divisions: 6,
                    label: _fontScale.toStringAsFixed(2),
                    onChanged: (v) => setState(() => _fontScale = v),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Daily Drills'),
                  value: _notifDaily,
                  onChanged: (v) => setState(() => _notifDaily = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Exam Reminders'),
                  value: _notifExam,
                  onChanged: (v) => setState(() => _notifExam = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Community'),
                  value: _notifCommunity,
                  onChanged: (v) => setState(() => _notifCommunity = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Streak Alerts'),
                  value: _notifStreaks,
                  onChanged: (v) => setState(() => _notifStreaks = v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('Marketing'),
                  value: _notifMarketing,
                  onChanged: (v) => setState(() => _notifMarketing = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Offline'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.download_for_offline_outlined),
              title: const Text('Offline Content'),
              subtitle: const Text('Download and manage subject bundles'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/settings/offline'),
            ),
          ),
          const SizedBox(height: 16),
          const _SectionTitle('Account'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.workspace_premium_outlined),
                  title: const Text('Subscription'),
                  subtitle: Text(user?.subscriptionStatus ?? 'FREE'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/subscription'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.school_outlined),
                  title: const Text('Institution Admin'),
                  subtitle: const Text('Seat management and cohort analytics'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/admin'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy & Data Controls'),
                  subtitle: const Text('Export data, delete account (mock)'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export / delete wiring happens later.')),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.support_agent_outlined),
                  title: const Text('Help & Support / Report a Bug'),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Support chat wiring happens later.')),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (!context.mounted) return;
              context.go('/auth/login');
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}
