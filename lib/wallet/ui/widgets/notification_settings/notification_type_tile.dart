import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/notification_types_config.dart';
import '../../../../core/utils/notification_settings_theme.dart';
import '../../../data/model/notification_preferences.dart';
import '../../../logic/notification/notification_settings_cubit.dart';
import 'delivery_channel_chips.dart';

class NotificationTypeTile extends StatelessWidget {
  final NotificationTypeConfig config;
  final NotificationPreferences preferences;

  const NotificationTypeTile({
    super.key,
    required this.config,
    required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    final themeHelper = NotificationSettingsTheme(context);
    final preference =
        preferences.preferences[config.type] ?? const NotificationTypePreference(enabled: false, channels: []);

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: themeHelper.tileDecoration,
      child: Column(
        children: [
          _buildHeader(context, preference, themeHelper.theme),
          if (preference.enabled) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            DeliveryChannelChips(
              preferences: preferences,
              notificationType: config.type,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, NotificationTypePreference preference, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                config.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodySmall?.color,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: preference.enabled,
          activeColor: Colors.white,
          activeTrackColor: const Color(0xFFF3A195),
          onChanged: (value) => _toggleNotificationType(context, value),
        ),
      ],
    );
  }

  void _toggleNotificationType(BuildContext context, bool value) {
    context.read<NotificationSettingsCubit>().toggleNotificationType(config.type, value);
  }
}
