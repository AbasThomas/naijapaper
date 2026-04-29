import 'package:flutter/material.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Challenges')),
      body: Center(child: Text('Challenges Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
