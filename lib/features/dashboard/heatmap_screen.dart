import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// HeatmapScreen — Visual mastery map across subjects and topics
class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topic Heatmap')),
      body: Center(
        child: Text(
          'Heatmap Screen\n\nTODO: Implement topic mastery heatmap',
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
