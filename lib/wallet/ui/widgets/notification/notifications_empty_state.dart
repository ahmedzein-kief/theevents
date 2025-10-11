import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

class NotificationsEmptyState extends StatelessWidget {
  const NotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: theme.iconTheme.color?.withAlpha((0.4 * 255).toInt())),
          const SizedBox(height: 16),
          Text(
            AppStrings.noNotifications.tr,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.titleMedium?.color?.withAlpha((0.8 * 255).toInt()),
            ),
          ),
        ],
      ),
    );
  }
}
