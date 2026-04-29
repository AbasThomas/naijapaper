import 'package:flutter/material.dart';

class StudyGroupScreen extends StatelessWidget {
  final String groupId;
  const StudyGroupScreen({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Group')),
      body: Center(child: Text('Study Group Screen - Group: $groupId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
