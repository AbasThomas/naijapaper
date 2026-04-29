import 'package:flutter/material.dart';

class AnswerReviewScreen extends StatelessWidget {
  final String sessionId;
  const AnswerReviewScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Answers')),
      body: Center(child: Text('Answer Review Screen - Session: $sessionId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
