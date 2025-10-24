import 'package:flutter/material.dart';

import '../../../data/model/notification_model.dart';

class NotificationIcon extends StatelessWidget {
  final NotificationModel notification;

  const NotificationIcon({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(
        notification.icon ?? '💳',
      ),
      // child: Image.asset(
      //   NotificationStyleHelper.getIconAsset(notification.type),
      //   height: 12,
      //   width: 12,
      // ),
    );
  }
}
