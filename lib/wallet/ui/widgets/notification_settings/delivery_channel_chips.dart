import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/delivery_channels_config.dart';
import '../../../data/model/notification_preferences.dart';
import '../../../logic/notification/notification_settings_cubit.dart';
import 'delivery_channel_chip.dart';

class DeliveryChannelChips extends StatelessWidget {
  final NotificationPreferences notificationPreferences;
  final String notificationType;

  const DeliveryChannelChips({
    super.key,
    required this.notificationPreferences,
    required this.notificationType,
  });

  @override
  Widget build(BuildContext context) {
    final preference = notificationPreferences.preferences[notificationType] ??
        const NotificationTypePreference(enabled: false, channels: []);

    return Row(
      children: (preference.availableChannels?.keys.toList() ?? [])
          .map(
            (channelKey) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 6),
                child: DeliveryChannelChip(
                  channel: DeliveryChannelConfig.fromChannelKey(channelKey),
                  isSelected: preference.channels.contains(channelKey),
                  onTap: () => _toggleChannel(context, channelKey, preference),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  void _toggleChannel(BuildContext context, String channelKey, NotificationTypePreference preference) {
    final isSelected = preference.channels.contains(channelKey);
    context.read<NotificationSettingsCubit>().toggleDeliveryMethod(
          notificationType,
          channelKey,
          !isSelected,
        );
  }
}
