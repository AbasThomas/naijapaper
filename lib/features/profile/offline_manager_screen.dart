import 'package:flutter/material.dart';

class OfflineManagerScreen extends StatelessWidget {
  const OfflineManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Content')),
      body: Center(child: Text('Offline Manager Screen - TODO', style: Theme.of(context).textTheme.bodyLarge)),
    );
  }
}
