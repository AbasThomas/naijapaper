import 'package:flutter/material.dart';

class ForumQuestionScreen extends StatelessWidget {
  final String questionId;
  const ForumQuestionScreen({super.key, required this.questionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question')),
      body: Center(child: Text('Forum Question Screen - Question: $questionId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
