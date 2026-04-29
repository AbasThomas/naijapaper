import 'package:flutter/material.dart';

class TrackerDetailScreen extends StatelessWidget {
  final String type;
  final String itemId;
  const TrackerDetailScreen({super.key, required this.type, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: Center(child: Text('Tracker Detail Screen - Type: $type, ID: $itemId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
