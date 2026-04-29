import 'package:flutter/material.dart';

class DailyDrillScreen extends StatelessWidget {
  const DailyDrillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daily Drill')),
      body: Center(child: Text('Daily Drill Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
