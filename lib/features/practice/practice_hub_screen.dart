import 'package:flutter/material.dart';

/// PracticeHubScreen — Entry point for all practice modes
class PracticeHubScreen extends StatelessWidget {
  const PracticeHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Practice')),
      body: Center(
        child: Text(
          'Practice Hub Screen\n\nTODO: Implement practice modes',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
