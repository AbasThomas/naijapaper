import 'package:flutter/material.dart';

class MockSetupScreen extends StatelessWidget {
  const MockSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mock Setup')),
      body: Center(child: Text('Mock Setup Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
