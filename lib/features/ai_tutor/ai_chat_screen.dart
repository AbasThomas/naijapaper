import 'package:flutter/material.dart';

class AiChatScreen extends StatelessWidget {
  final String? chatId;
  const AiChatScreen({super.key, this.chatId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Chat')),
      body: Center(child: Text('AI Chat Screen - Chat ID: ${chatId ?? "new"}\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
