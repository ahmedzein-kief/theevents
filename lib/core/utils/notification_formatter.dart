import 'package:flutter/material.dart';

import '../../wallet/data/model/notification_model.dart';
import 'notification_style_helper.dart';

class NotificationFormatter {
  static String getTitle(NotificationModel notification) {
    if (notification.title != null && notification.title!.isNotEmpty) {
      return notification.title!;
    }
    return notification.displayName;
  }

  static String getFormattedDate(NotificationModel notification) {
    if (notification.createdAtFormatted != null) {
      return notification.createdAtFormatted!;
    }
    return _formatDateTime(notification.createdAt);
  }

  static Color getAmountColor(NotificationModel notification) {
    if (notification.data?.direction == 'CR') {
      return Colors.green;
    } else if (notification.data?.direction == 'DR') {
      return Colors.red;
    }
    return NotificationStyleHelper.getColor(notification.type);
  }

  static String _formatDateTime(DateTime dateTime) {
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
