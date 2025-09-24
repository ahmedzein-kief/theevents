import 'package:flutter/material.dart';

import '../../../../core/utils/notification_dialog_helper.dart';
import '../../../data/model/notification_model.dart';

class NotificationActions {
  static void showActionMenu(
    BuildContext context,
    NotificationModel notification, {
    Function(String)? onMarkAsRead,
    Function(String)? onMarkAsUnread,
    Function(String)? onDelete,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ActionMenuSheet(
        notification: notification,
        onMarkAsRead: onMarkAsRead,
        onMarkAsUnread: onMarkAsUnread,
        onDelete: onDelete,
      ),
    );
  }

  static void showDetails(
    BuildContext context,
    NotificationModel notification, {
    Function(String)? onMarkAsRead,
    Function(String)? onTap,
  }) {
    // Mark as read when opening details
    if (!notification.isRead && onMarkAsRead != null) {
      onMarkAsRead(notification.id);
    }

    NotificationDialogHelper.showDetails(context, notification, onTap: onTap);
  }
}

class _ActionMenuSheet extends StatelessWidget {
  final NotificationModel notification;
  final Function(String)? onMarkAsRead;
  final Function(String)? onMarkAsUnread;
  final Function(String)? onDelete;

  const _ActionMenuSheet({
    required this.notification,
    this.onMarkAsRead,
    this.onMarkAsUnread,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHandle(),
            _buildReadToggleTile(context),
            _buildDeleteTile(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(top: 8, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildReadToggleTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
        color: notification.isRead ? Colors.orange : Colors.blue,
      ),
      title: Text(notification.isRead ? 'Mark as Unread' : 'Mark as Read'),
      onTap: () {
        Navigator.pop(context);
        _handleReadToggle();
      },
    );
  }

  Widget _buildDeleteTile(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.delete, color: Colors.red),
      title: const Text('Delete'),
      onTap: () async {
        Navigator.pop(context);
        final shouldDelete = await NotificationDialogHelper.showDeleteConfirmation(context);
        if (shouldDelete == true && onDelete != null) {
          onDelete!(notification.id);
        }
      },
    );
  }

  void _handleReadToggle() {
    if (notification.isRead && onMarkAsUnread != null) {
      onMarkAsUnread!(notification.id);
    } else if (!notification.isRead && onMarkAsRead != null) {
      onMarkAsRead!(notification.id);
    }
  }
}
