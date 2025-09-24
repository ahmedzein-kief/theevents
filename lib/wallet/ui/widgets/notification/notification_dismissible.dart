import 'package:flutter/material.dart';

import '../../../../core/utils/notification_dialog_helper.dart';
import '../../../data/model/notification_model.dart';
import 'dismissible_background.dart';

class NotificationDismissible extends StatelessWidget {
  final NotificationModel notification;
  final Function(String)? onMarkAsRead;
  final Function(String)? onMarkAsUnread;
  final Function(String)? onDelete;
  final Widget child;

  const NotificationDismissible({
    super.key,
    required this.notification,
    this.onMarkAsRead,
    this.onMarkAsUnread,
    this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.horizontal,
      background: DismissibleBackground(
        notification: notification,
        isLeft: true,
      ),
      secondaryBackground: DismissibleBackground(
        notification: notification,
        isLeft: false,
      ),
      confirmDismiss: (direction) => _handleDismiss(context, direction),
      onDismissed: (direction) => _handleDismissed(direction),
      child: child,
    );
  }

  Future<bool> _handleDismiss(BuildContext context, DismissDirection direction) async {
    if (direction == DismissDirection.startToEnd) {
      _handleReadToggle();
      return false; // Don't dismiss, just perform action
    } else {
      return await NotificationDialogHelper.showDeleteConfirmation(context) ?? false;
    }
  }

  void _handleDismissed(DismissDirection direction) {
    if (direction == DismissDirection.endToStart && onDelete != null) {
      onDelete!(notification.id);
    }
  }

  void _handleReadToggle() {
    if (notification.isRead && onMarkAsUnread != null) {
      onMarkAsUnread!(notification.id);
    } else if (!notification.isRead && onMarkAsRead != null) {
      onMarkAsRead!(notification.id);
    }
  }
}
