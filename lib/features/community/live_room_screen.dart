import 'package:flutter/material.dart';

class LiveRoomScreen extends StatelessWidget {
  final String roomId;
  const LiveRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Live Room')),
      body: Center(child: Text('Live Room Screen - Room: $roomId\n\nTODO', style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center)),
    );
  }
}
