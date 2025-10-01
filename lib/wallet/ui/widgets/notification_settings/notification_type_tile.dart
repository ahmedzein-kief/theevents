import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/notification_types_config.dart';
import '../../../../core/utils/notification_settings_theme.dart';
import '../../../data/model/notification_preferences.dart';
import '../../../logic/notification/notification_settings_cubit.dart';
import 'delivery_channel_chips.dart';

class NotificationTypeTile extends StatelessWidget {
  final NotificationTypeConfig config;
  final NotificationPreferences notificationPreferences;

  const NotificationTypeTile({
    super.key,
    required this.config,
    required this.notificationPreferences,
  });

  @override
  Widget build(BuildContext context) {
    final themeHelper = NotificationSettingsTheme(context);
    final preference = notificationPreferences.preferences[config.type] ??
        const NotificationTypePreference(enabled: false, channels: []);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
              notificationPreferences: notificationPreferences,
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
                config.title.tr,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                config.subtitle.tr,
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
          activeTrackColor: AppColors.peachyPink.withAlpha((0.8 * 255).toInt()),
          onChanged: (value) => _toggleNotificationType(context, value),
        ),
      ],
    );
  }

  void _toggleNotificationType(BuildContext context, bool value) {
    context.read<NotificationSettingsCubit>().toggleNotificationType(config.type, value);
  }
}
