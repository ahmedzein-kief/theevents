import 'package:flutter/material.dart';

import '../../wallet/data/model/notification_model.dart';
import '../../wallet/logic/notification/notification_cubit.dart';
import 'notification_formatter.dart';
import 'notification_style_helper.dart';

class NotificationDialogHelper {
  static Future<bool?> showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Notification'),
        content: const Text('Are you sure you want to delete this notification?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void showDetails(
    BuildContext context,
    NotificationModel notification, {
    Function(String)? onTap,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            if (notification.icon != null && notification.icon!.isNotEmpty)
              Text(notification.icon!, style: const TextStyle(fontSize: 20))
            else
              Image.asset(
                NotificationStyleHelper.getIconAsset(notification.type),
                height: 12,
                width: 12,
              ),
            const SizedBox(width: 8),
            Expanded(child: Text(NotificationFormatter.getTitle(notification))),
          ],
        ),
        content: _buildDetailsContent(context, notification),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  static Widget _buildDetailsContent(BuildContext context, NotificationModel notification) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(notification.message),
        if (notification.data?.amount != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: NotificationStyleHelper.getColor(notification.type).withAlpha((0.1 * 255).toInt()),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Amount: ${notification.data!.amount} ${notification.data!.currency ?? ''}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (notification.data!.type != null) Text('Type: ${notification.data!.type}'),
                if (notification.data!.direction != null) Text('Direction: ${notification.data!.direction}'),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          NotificationFormatter.getFormattedDate(notification),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt()),
          ),
        ),
      ],
    );
  }

  static void showDeleteAllConfirmation(BuildContext context, NotificationsCubit notificationsCubit) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete All Notifications'),
        content: const Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Use the captured cubit reference instead of trying to read from dialogContext
              notificationsCubit.deleteAllNotification();
              Navigator.of(dialogContext).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );
  }
}
