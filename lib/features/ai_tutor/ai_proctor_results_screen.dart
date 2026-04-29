import 'package:flutter/material.dart';

class AiProctorResultsScreen extends StatelessWidget {
  final String sessionId;
  const AiProctorResultsScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Proctor Report')),
      body: Center(child: Text('AI Proctor Results Screen - Session: $sessionId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
