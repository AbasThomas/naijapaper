import 'package:flutter/material.dart';

class ParentDashboardScreen extends StatelessWidget {
  final String studentId;
  const ParentDashboardScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Dashboard')),
      body: Center(child: Text('Parent Dashboard Screen - Student: $studentId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
