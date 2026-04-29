import 'package:flutter/material.dart';

class MockResultsScreen extends StatelessWidget {
  final String sessionId;
  const MockResultsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Center(child: Text('Mock Results Screen - Session: $sessionId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
