import 'package:flutter/material.dart';

class ActiveMockScreen extends StatelessWidget {
  final String sessionId;
  const ActiveMockScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Exam')),
      body: Center(child: Text('Active Mock Screen - Session: $sessionId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
