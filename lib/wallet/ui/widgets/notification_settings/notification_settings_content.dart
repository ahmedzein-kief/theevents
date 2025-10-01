import 'package:flutter/material.dart';

import '../../../data/model/notification_preferences.dart';
import 'notification_type_section.dart';

class NotificationSettingsContent extends StatelessWidget {
  final NotificationPreferences notificationPreferences;

  const NotificationSettingsContent({
    super.key,
    required this.notificationPreferences,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          NotificationTypeSection(notificationPreferences: notificationPreferences),
        ],
      ),
    );
  }
}
