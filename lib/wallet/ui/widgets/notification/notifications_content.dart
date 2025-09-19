import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';
import 'notifications_empty_state.dart';
import 'notifications_list.dart';

class NotificationsContent extends StatelessWidget {
  const NotificationsContent({super.key});

  List<NotificationModel> _getNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Deposit Successful',
        message: 'Your deposit of AED 500.00 has been processed successfully.',
        type: NotificationType.success,
        date: DateTime.now().subtract(const Duration(minutes: 30)),
        isRead: false,
      ),
      NotificationModel(
        id: '2',
        title: 'Reward Earned',
        message: 'You\'ve earned AED 75.00 in cashback rewards from your recent purchase!',
        type: NotificationType.reward,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      NotificationModel(
        id: '3',
        title: 'Wallet Expiry Warning',
        message: 'Your wallet will expire soon. Please renew to continue using all features.',
        type: NotificationType.warning,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final notifications = _getNotifications();

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          Row(
            children: [
              Icon(Icons.notifications_outlined, size: 24, color: theme.iconTheme.color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppStrings.notifications.tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color),
                ),
              ),
              TextButton(
                onPressed: () {},
                child:
                    Text(AppStrings.markAllRead.tr, style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: notifications.isEmpty
                ? const NotificationsEmptyState()
                : NotificationsList(notifications: notifications),
          ),
        ],
      ),
    );
  }
}
