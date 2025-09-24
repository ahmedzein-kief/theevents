import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/delivery_channels_config.dart';
import '../../../data/model/notification_preferences.dart';
import '../../../logic/notification/notification_settings_cubit.dart';
import 'delivery_channel_chip.dart';

class DeliveryChannelChips extends StatelessWidget {
  final NotificationPreferences preferences;
  final String notificationType;

  const DeliveryChannelChips({
    super.key,
    required this.preferences,
    required this.notificationType,
  });

  @override
  Widget build(BuildContext context) {
    final preference =
        preferences.preferences[notificationType] ?? const NotificationTypePreference(enabled: false, channels: []);

    return Row(
      children: DeliveryChannelsConfig.channels
          .map(
            (channel) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: channel != DeliveryChannelsConfig.channels.last ? 6 : 0,
                ),
                child: DeliveryChannelChip(
                  channel: channel,
                  isSelected: preference.channels.contains(channel.key),
                  onTap: () => _toggleChannel(context, channel.key, preference),
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
