import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({Key? key, required this.notification}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: _getBackgroundColor(isDark),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor(isDark),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getNotificationColor().withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getNotificationIcon(),
              color: _getNotificationColor(),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _getTitleColor(theme, isDark),
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 14,
                    color: _getMessageColor(theme, isDark),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatDateTime(notification.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor(bool isDark) {
    if (notification.isRead) {
      return isDark ? Colors.grey[850]! : Colors.grey[50]!;
    } else {
      return isDark ? Colors.blue[900]!.withAlpha((0.3 * 255).toInt()) : Colors.blue[50]!;
    }
  }

  Color _getBorderColor(bool isDark) {
    if (notification.isRead) {
      return isDark ? Colors.grey[700]! : Colors.grey[200]!;
    } else {
      return isDark ? Colors.blue[700]! : Colors.blue[200]!;
    }
  }

  Color _getTitleColor(ThemeData theme, bool isDark) {
    if (notification.isRead) {
      return theme.textTheme.titleMedium?.color?.withAlpha((0.7 * 255).toInt()) ??
          (isDark ? Colors.grey[400]! : Colors.grey[700]!);
    } else {
      return theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black);
    }
  }

  Color _getMessageColor(ThemeData theme, bool isDark) {
    if (notification.isRead) {
      return theme.textTheme.bodyMedium?.color?.withAlpha((0.6 * 255).toInt()) ??
          (isDark ? Colors.grey[500]! : Colors.grey[600]!);
    } else {
      return theme.textTheme.bodyMedium?.color?.withAlpha((0.8 * 255).toInt()) ??
          (isDark ? Colors.grey[300]! : Colors.grey[700]!);
    }
  }

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.success:
        return Icons.check_circle_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.error:
        return Icons.error_outline;
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.reward:
        return Icons.star_outline;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.success:
        return Colors.green;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.error:
        return Colors.red;
      case NotificationType.info:
        return Colors.blue;
      case NotificationType.reward:
        return Colors.amber;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
    }
  }
}
