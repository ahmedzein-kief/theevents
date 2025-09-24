import 'package:event_app/wallet/ui/widgets/notification/notification_card.dart';
import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';
import 'notification_actions.dart';
import 'notification_dismissible.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;
  final Function(String)? onMarkAsRead;
  final Function(String)? onMarkAsUnread;
  final Function(String)? onDelete;
  final Function(String)? onTap;

  const NotificationItem({
    super.key,
    required this.notification,
    this.onMarkAsRead,
    this.onMarkAsUnread,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationDismissible(
      notification: notification,
      onMarkAsRead: onMarkAsRead,
      onMarkAsUnread: onMarkAsUnread,
      onDelete: onDelete,
      child: InkWell(
        onTap: () => _handleTap(context),
        onLongPress: () => NotificationActions.showActionMenu(
          context,
          notification,
          onMarkAsRead: onMarkAsRead,
          onMarkAsUnread: onMarkAsUnread,
          onDelete: onDelete,
        ),
        borderRadius: BorderRadius.circular(12),
        child: NotificationCard(
          notification: notification,
          onActionTap: () => NotificationActions.showActionMenu(
            context,
            notification,
            onMarkAsRead: onMarkAsRead,
            onMarkAsUnread: onMarkAsUnread,
            onDelete: onDelete,
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (onTap != null) {
      onTap!(notification.id);
    } else {
      NotificationActions.showDetails(
        context,
        notification,
        onMarkAsRead: onMarkAsRead,
        onTap: onTap,
      );
    }
  }
}
