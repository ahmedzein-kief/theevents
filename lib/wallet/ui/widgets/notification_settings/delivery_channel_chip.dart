import 'package:flutter/material.dart';

import '../../../../core/constants/delivery_channels_config.dart';
import '../../../../core/utils/notification_settings_theme.dart';

class DeliveryChannelChip extends StatelessWidget {
  final DeliveryChannelConfig channel;
  final bool isSelected;
  final VoidCallback onTap;

  const DeliveryChannelChip({
    super.key,
    required this.channel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeHelper = NotificationSettingsTheme(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: themeHelper.getChipDecoration(isSelected),
        child: Text(
          channel.label,
          style: themeHelper.getChipTextStyle(isSelected),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
