import 'package:flutter/material.dart';

class AiTutorHomeScreen extends StatelessWidget {
  const AiTutorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Tutor')),
      body: Center(child: Text('AI Tutor Home Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
