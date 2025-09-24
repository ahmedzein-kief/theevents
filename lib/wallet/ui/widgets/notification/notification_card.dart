import 'package:flutter/material.dart';

import '../../../../core/utils/notification_formatter.dart';
import '../../../../core/utils/notification_theme_helper.dart';
import '../../../data/model/notification_model.dart';
import 'notification_icon.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onActionTap;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeHelper = NotificationThemeHelper(context, notification);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: themeHelper.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeHelper.borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationIcon(notification: notification),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, themeHelper),
                const SizedBox(height: 8),
                _buildMessage(context, themeHelper),
                const SizedBox(height: 8),
                _buildFooter(context, themeHelper),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationThemeHelper themeHelper) {
    return Row(
      children: [
        Expanded(
          child: Text(
            NotificationFormatter.getTitle(notification),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: themeHelper.titleColor,
            ),
          ),
        ),
        if (!notification.isRead) _buildUnreadIndicator(),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, NotificationThemeHelper themeHelper) {
    return Text(
      notification.message,
      style: TextStyle(
        fontSize: 14,
        color: themeHelper.messageColor,
        height: 1.4,
      ),
    );
  }

  Widget _buildFooter(BuildContext context, NotificationThemeHelper themeHelper) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          NotificationFormatter.getFormattedDate(notification),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt()),
          ),
        ),
        if (notification.data?.amount != null) _buildAmountText(),
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildUnreadIndicator() {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildAmountText() {
    return Text(
      '${notification.data!.amount} ${notification.data!.currency ?? ''}',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: NotificationFormatter.getAmountColor(notification),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: onActionTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(
          Icons.more_vert,
          size: 16,
          color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt()),
        ),
      ),
    );
  }
}
