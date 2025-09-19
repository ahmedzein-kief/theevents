import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';
import 'notification_item.dart';

class NotificationsList extends StatelessWidget {
  const NotificationsList({super.key, required this.notifications});

  final List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationItem(notification: notification);
        },
      ),
    );
  }
}
