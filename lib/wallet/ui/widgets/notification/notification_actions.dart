import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/notification_dialog_helper.dart';
import '../../../data/model/notification_model.dart';

enum NotificationMenuAction {
  markAsRead,
  markAsUnread,
  delete,
}

class NotificationActions {
  static void showActionMenu(
    BuildContext context,
    NotificationModel notification, {
    Function(String)? onMarkAsRead,
    Function(String)? onMarkAsUnread,
    Function(String)? onDelete,
  }) {
    // Find the action button in the widget tree to position the menu correctly
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    final isRtl = Directionality.of(context) == TextDirection.rtl;

    // Position menu to appear near the 3-dot icon (bottom right of the action button)
    final menuPosition = RelativeRect.fromSize(
      Rect.fromPoints(
        isRtl
            ? position + Offset(0, size.height) // align left in RTL
            : position + Offset(size.width - 100, size.height), // align right in LTR
        isRtl
            ? position + Offset(100, size.height + 40) // expand to right in RTL
            : position + Offset(size.width, size.height + 40), // expand to left in LTR
      ),
      overlay.size,
    );

    showMenu<NotificationMenuAction>(
      context: context,
      position: menuPosition,
      items: [
        PopupMenuItem<NotificationMenuAction>(
          value: notification.isRead ? NotificationMenuAction.markAsUnread : NotificationMenuAction.markAsRead,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
              color: notification.isRead ? Colors.orange : Colors.blue,
              size: 20,
            ),
            title: Text(
              notification.isRead ? AppStrings.markAsUnread.tr : AppStrings.markAsRead.tr,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
        PopupMenuItem<NotificationMenuAction>(
          value: NotificationMenuAction.delete,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(
              Icons.delete,
              color: Colors.red,
              size: 20,
            ),
            title: Text(
              AppStrings.delete.tr,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ],
    ).then((value) {
      if (context.mounted) {
        _handleMenuSelection(
          context,
          value,
          notification,
          onMarkAsRead: onMarkAsRead,
          onMarkAsUnread: onMarkAsUnread,
          onDelete: onDelete,
        );
      }
    });
  }

  static Future<void> _handleMenuSelection(
    BuildContext context,
    NotificationMenuAction? action,
    NotificationModel notification, {
    Function(String)? onMarkAsRead,
    Function(String)? onMarkAsUnread,
    Function(String)? onDelete,
  }) async {
    if (action == null) return;

    switch (action) {
      case NotificationMenuAction.markAsRead:
        onMarkAsRead?.call(notification.id);
        break;
      case NotificationMenuAction.markAsUnread:
        onMarkAsUnread?.call(notification.id);
        break;
      case NotificationMenuAction.delete:
        final shouldDelete = await NotificationDialogHelper.showDeleteConfirmation(context);
        if (shouldDelete == true && onDelete != null) {
          onDelete(notification.id);
        }
        break;
    }
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
