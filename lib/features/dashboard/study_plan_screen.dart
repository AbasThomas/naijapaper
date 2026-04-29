import 'package:flutter/material.dart';

/// StudyPlanScreen — AI-generated 30-day study schedule
class StudyPlanScreen extends StatelessWidget {
  const StudyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('30-Day Study Plan')),
      body: Center(
        child: Text(
          'Study Plan Screen\n\nTODO: Implement 30-day study plan',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
