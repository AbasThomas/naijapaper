import 'package:flutter/material.dart';

class CommunityHubScreen extends StatelessWidget {
  const CommunityHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community')),
      body: Center(child: Text('Community Hub Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
