import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';

// Heatmap data provider
final heatmapDataProvider = FutureProvider.family<HeatmapData, String?>(
  (ref, subjectId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // TODO: Replace with actual API call
    return _getMockHeatmapData(subjectId);
  },
);

class HeatmapData {
  final List<TopicAccuracy> topics;
  final String subjectName;

  HeatmapData({
    required this.topics,
    required this.subjectName,
  });
}

class TopicAccuracy {
  final String topicId;
  final String topicName;
  final double easyAccuracy;
  final double mediumAccuracy;
  final double hardAccuracy;
  final int totalQuestions;

  TopicAccuracy({
    required this.topicId,
    required this.topicName,
    required this.easyAccuracy,
    required this.mediumAccuracy,
    required this.hardAccuracy,
    required this.totalQuestions,
  });

  double get overallAccuracy =>
      (easyAccuracy + mediumAccuracy + hardAccuracy) / 3;
}

class HeatmapScreen extends ConsumerStatefulWidget {
  final String? subjectId;

  const HeatmapScreen({super.key, this.subjectId});

  @override
  ConsumerState<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends ConsumerState<HeatmapScreen> {
  String? _selectedSubject;

  @override
  void initState() {
    super.initState();
    _selectedSubject = widget.subjectId;
  }

  @override
  Widget build(BuildContext context) {
    final heatmapAsync = ref.watch(heatmapDataProvider(_selectedSubject));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic Mastery Heatmap'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (subject) {
              setState(() => _selectedSubject = subject);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('All Subjects')),
              const PopupMenuItem(value: 'math', child: Text('Mathematics')),
              const PopupMenuItem(value: 'eng', child: Text('English')),
              const PopupMenuItem(value: 'phy', child: Text('Physics')),
              const PopupMenuItem(value: 'chem', child: Text('Chemistry')),
            ],
          ),
        ],
      ),
      body: heatmapAsync.when(
        data: (data) => _buildHeatmapContent(data),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: AppColors.error),
              const SizedBox(height: 16),
              Text('Error: $error'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeatmapContent(HeatmapData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.subjectName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${data.topics.length} topics tracked',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Legend
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Accuracy Legend',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('Not Attempted', AppColors.border),
                      _buildLegendItem('< 50%', AppColors.error),
                      _buildLegendItem('50-80%', AppColors.warning),
                      _buildLegendItem('> 80%', AppColors.success),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Heatmap Grid
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column Headers
                  Row(
                    children: [
                      const SizedBox(width: 120), // Space for topic names
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildColumnHeader('Easy'),
                            _buildColumnHeader('Medium'),
                            _buildColumnHeader('Hard'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 24),

                  // Topic Rows
                  ...data.topics.map((topic) => _buildTopicRow(topic)).toList(),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Summary Stats
          _buildSummaryStats(data),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildColumnHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTopicRow(TopicAccuracy topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showTopicDetails(topic),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              // Topic Name
              SizedBox(
                width: 120,
                child: Text(
                  topic.topicName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Accuracy Cells
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAccuracyCell(topic.easyAccuracy),
                    _buildAccuracyCell(topic.mediumAccuracy),
                    _buildAccuracyCell(topic.hardAccuracy),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccuracyCell(double accuracy) {
    Color color;
    if (accuracy < 0) {
      color = AppColors.border; // Not attempted
    } else if (accuracy < 50) {
      color = AppColors.error;
    } else if (accuracy < 80) {
      color = AppColors.warning;
    } else {
      color = AppColors.success;
    }

    return Container(
      width: 60,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(accuracy < 0 ? 0.3 : 0.2),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          accuracy < 0 ? '-' : '${accuracy.toInt()}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: accuracy < 0 ? AppColors.textSecondary : color,
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStats(HeatmapData data) {
    final attemptedTopics = data.topics.where((t) => t.overallAccuracy >= 0).length;
    final avgAccuracy = data.topics
            .where((t) => t.overallAccuracy >= 0)
            .fold<double>(0, (sum, t) => sum + t.overallAccuracy) /
        (attemptedTopics > 0 ? attemptedTopics : 1);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Topics Attempted',
                    '$attemptedTopics/${data.topics.length}',
                    Icons.topic,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Avg Accuracy',
                    '${avgAccuracy.toInt()}%',
                    Icons.trending_up,
                    AppColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showTopicDetails(TopicAccuracy topic) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              topic.topicName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Easy Questions', '${topic.easyAccuracy.toInt()}%',
                AppColors.difficultyEasy),
            const SizedBox(height: 12),
            _buildDetailRow('Medium Questions', '${topic.mediumAccuracy.toInt()}%',
                AppColors.difficultyMedium),
            const SizedBox(height: 12),
            _buildDetailRow('Hard Questions', '${topic.hardAccuracy.toInt()}%',
                AppColors.difficultyHard),
            const SizedBox(height: 12),
            _buildDetailRow('Overall Accuracy', '${topic.overallAccuracy.toInt()}%',
                AppColors.primary),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Navigate to practice this topic
              },
              child: const Text('Practice This Topic'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}

// Mock data generator
HeatmapData _getMockHeatmapData(String? subjectId) {
  final topics = [
    'Algebra',
    'Geometry',
    'Calculus',
    'Statistics',
    'Trigonometry',
    'Probability',
    'Number Theory',
    'Linear Equations',
  ];

  return HeatmapData(
    subjectName: subjectId == null ? 'All Subjects' : 'Mathematics',
    topics: topics.map((name) {
      return TopicAccuracy(
        topicId: name.toLowerCase(),
        topicName: name,
        easyAccuracy: (50 + (name.length * 5) % 50).toDouble(),
        mediumAccuracy: (40 + (name.length * 7) % 50).toDouble(),
        hardAccuracy: (30 + (name.length * 3) % 50).toDouble(),
        totalQuestions: 20 + (name.length * 2),
      );
    }).toList(),
  );
}
