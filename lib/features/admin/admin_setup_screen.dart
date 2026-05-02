import 'package:flutter/material.dart';

class AdminSetupScreen extends StatefulWidget {
  const AdminSetupScreen({super.key});

  @override
  State<AdminSetupScreen> createState() => _AdminSetupScreenState();
}

class _AdminSetupScreenState extends State<AdminSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _institutionName = TextEditingController();
  final _contactName = TextEditingController();
  final _contactEmail = TextEditingController();
  String _institutionType = 'Secondary School';
  String _state = 'Lagos';
  int _seatCount = 50;

  @override
  void dispose() {
    _institutionName.dispose();
    _contactName.dispose();
    _contactEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Institution Setup')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Set up your institution details. Payment + enrolment code wiring happens later with Paystack.',
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _institutionName,
              decoration: const InputDecoration(labelText: 'Institution Name'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _institutionType,
              decoration: const InputDecoration(labelText: 'Institution Type'),
              items: const [
                DropdownMenuItem(value: 'Secondary School', child: Text('Secondary School')),
                DropdownMenuItem(value: 'Tutorial Centre', child: Text('Tutorial Centre')),
                DropdownMenuItem(value: 'University', child: Text('University')),
              ],
              onChanged: (v) => setState(() => _institutionType = v ?? _institutionType),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _state,
              decoration: const InputDecoration(labelText: 'State'),
              items: const [
                DropdownMenuItem(value: 'Lagos', child: Text('Lagos')),
                DropdownMenuItem(value: 'Abuja (FCT)', child: Text('Abuja (FCT)')),
                DropdownMenuItem(value: 'Rivers', child: Text('Rivers')),
                DropdownMenuItem(value: 'Kano', child: Text('Kano')),
              ],
              onChanged: (v) => setState(() => _state = v ?? _state),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactName,
              decoration: const InputDecoration(labelText: 'Contact Person'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contactEmail,
              decoration: const InputDecoration(labelText: 'Contact Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || !v.contains('@')) ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 16),
            Text('Seat Count: $_seatCount', style: Theme.of(context).textTheme.titleMedium),
            Slider(
              value: _seatCount.toDouble(),
              min: 10,
              max: 500,
              divisions: 49,
              label: '$_seatCount',
              onChanged: (v) => setState(() => _seatCount = v.round()),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Saved locally (mock). Connect to backend later.')),
                );
                Navigator.of(context).maybePop();
              },
              child: const Text('Save Setup'),
            ),
          ],
        ),
      ),
    );
  }
}

