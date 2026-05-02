import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../shared/providers/auth_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _school;
  DateTime? _examDate;
  String _state = 'Lagos';
  String _examTarget = 'JAMB';
  String _language = 'BOTH';

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _name = TextEditingController(text: user?.name ?? '');
    _school = TextEditingController(text: user?.school ?? '');
    _examDate = user?.examDate;
    _state = user?.state ?? _state;
    _examTarget = user?.examTarget ?? _examTarget;
    _language = user?.languagePref ?? _language;
  }

  @override
  void dispose() {
    _name.dispose();
    _school.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 26, child: Icon(Icons.person_outline)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Update your info to personalise drills, plans, and reminders.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Change avatar (mock)',
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Avatar upload wiring happens later.')),
                    );
                  },
                  icon: const Icon(Icons.camera_alt_outlined),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _school,
              decoration: const InputDecoration(labelText: 'School / Institution'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _state,
              decoration: const InputDecoration(labelText: 'State of Origin'),
              items: const [
                DropdownMenuItem(value: 'Lagos', child: Text('Lagos')),
                DropdownMenuItem(value: 'Abuja (FCT)', child: Text('Abuja (FCT)')),
                DropdownMenuItem(value: 'Rivers', child: Text('Rivers')),
                DropdownMenuItem(value: 'Kano', child: Text('Kano')),
              ],
              onChanged: (v) => setState(() => _state = v ?? _state),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _examTarget,
              decoration: const InputDecoration(labelText: 'Target Exam'),
              items: const [
                DropdownMenuItem(value: 'WAEC', child: Text('WAEC')),
                DropdownMenuItem(value: 'JAMB', child: Text('JAMB')),
                DropdownMenuItem(value: 'NECO', child: Text('NECO')),
                DropdownMenuItem(value: 'Post-UTME', child: Text('Post-UTME')),
                DropdownMenuItem(value: 'ICAN', child: Text('ICAN')),
                DropdownMenuItem(value: 'CFA', child: Text('CFA')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _examTarget = v ?? _examTarget),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.event_outlined),
              title: const Text('Exam Date'),
              subtitle: Text(_examDate == null ? 'Not set' : DateFormat('EEE, MMM d, yyyy').format(_examDate!)),
              trailing: OutlinedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _examDate ?? now.add(const Duration(days: 30)),
                    firstDate: now.subtract(const Duration(days: 365)),
                    lastDate: now.add(const Duration(days: 365 * 3)),
                  );
                  if (picked != null) setState(() => _examDate = picked);
                },
                child: const Text('Pick'),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _language,
              decoration: const InputDecoration(labelText: 'Language Preference'),
              items: const [
                DropdownMenuItem(value: 'ENGLISH', child: Text('English')),
                DropdownMenuItem(value: 'PIDGIN', child: Text('Pidgin')),
                DropdownMenuItem(value: 'BOTH', child: Text('Both')),
              ],
              onChanged: (v) => setState(() => _language = v ?? _language),
            ),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                // TODO: PATCH /users/me
                await ref.read(authStateProvider.notifier).refreshUser();
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved (mock). Wire to backend later.')),
                );
                Navigator.of(context).maybePop();
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
