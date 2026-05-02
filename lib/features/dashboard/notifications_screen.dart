import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';

// Notification model
class AppNotification {
  final String id;
  final String title;
  final String body;
  final String type; // 'streak', 'exam', 'leaderboard', 'community', 'subscription'
  final DateTime timestamp;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
}

// Mock provider for notifications
final notificationsProvider = StateProvider<List<AppNotification>>((ref) {
  return [
    AppNotification(
      id: '1',
      title: '🔥 7-Day Streak!',
      body: 'Amazing! You\'ve practiced for 7 days straight. Keep it up!',
      type: 'streak',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    AppNotification(
      id: '2',
      title: '📅 Exam Reminder',
      body: 'JAMB UTME 2026 is in 45 days. Time to focus on your weak topics.',
      type: 'exam',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    AppNotification(
      id: '3',
      title: '🏆 Leaderboard Update',
      body: 'You just climbed to #42 in Lagos State! Can you reach the Top 10?',
      type: 'leaderboard',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    AppNotification(
      id: '4',
      title: '💬 Community Reply',
      body: 'Tunde replied to your question in the Physics Study Group.',
      type: 'community',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
      isRead: true,
    ),
  ];
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: () {
                ref.read(notificationsProvider.notifier).state = 
                  notifications.map((n) => AppNotification(
                    id: n.id,
                    title: n.title,
                    body: n.body,
                    type: n.type,
                    timestamp: n.timestamp,
                    isRead: true,
                  )).toList();
              },
              child: const Text('Mark all as read'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _buildNotificationItem(context, ref, notification)
                    .animate()
                    .fadeIn(delay: (index * 100).ms)
                    .slideX(begin: 0.1, end: 0);
              },
            ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    WidgetRef ref,
    AppNotification notification,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(notificationsProvider.notifier).state = 
          ref.read(notificationsProvider).where((n) => n.id != notification.id).toList();
      },
      child: Container(
        decoration: BoxDecoration(
          color: notification.isRead ? null : AppColors.primary.withOpacity(0.05),
          border: Border(
            left: BorderSide(
              color: notification.isRead ? Colors.transparent : AppColors.primary,
              width: 4,
            ),
            bottom: const BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: ListTile(
          onTap: () {
            // Mark as read
            if (!notification.isRead) {
              ref.read(notificationsProvider.notifier).state = 
                ref.read(notificationsProvider).map((n) => n.id == notification.id 
                  ? AppNotification(
                      id: n.id,
                      title: n.title,
                      body: n.body,
                      type: n.type,
                      timestamp: n.timestamp,
                      isRead: true,
                    )
                  : n).toList();
            }
          },
          leading: CircleAvatar(
            backgroundColor: _getNotificationColor(notification.type).withOpacity(0.1),
            child: Icon(
              _getNotificationIcon(notification.type),
              color: _getNotificationColor(notification.type),
              size: 20,
            ),
          ),
          title: Text(
            notification.title,
            style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
              fontSize: 15,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                notification.body,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(notification.timestamp),
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          isThreeLine: true,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none_outlined,
            size: 80,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ll notify you about your progress,\nexam updates, and more.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'streak':
        return Icons.bolt;
      case 'exam':
        return Icons.event_note;
      case 'leaderboard':
        return Icons.emoji_events;
      case 'community':
        return Icons.groups;
      case 'subscription':
        return Icons.card_membership;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'streak':
        return AppColors.warning;
      case 'exam':
        return AppColors.error;
      case 'leaderboard':
        return AppColors.primary;
      case 'community':
        return AppColors.success;
      case 'subscription':
        return AppColors.info;
      default:
        return AppColors.primary;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
