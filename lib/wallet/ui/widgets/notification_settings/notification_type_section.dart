import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/notification_types_config.dart';
import '../../../data/model/notification_preferences.dart';
import 'notification_type_tile.dart';

class NotificationTypeSection extends StatelessWidget {
  final NotificationPreferences notificationPreferences;

  const NotificationTypeSection({
    super.key,
    required this.notificationPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildSectionHeader(theme),
        ),
        const SizedBox(height: 16),
        ...NotificationTypesConfig.types.map(
          (config) => NotificationTypeTile(
            key: Key(config.type),
            config: config,
            notificationPreferences: notificationPreferences,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Text(
      AppStrings.notificationTypes.tr,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: theme.textTheme.titleLarge?.color,
      ),
    );
  }
}
