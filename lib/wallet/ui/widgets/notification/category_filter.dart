import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/notification_categories.dart';
import '../../../data/model/notification_model.dart';
import '../../../logic/notification/notification_cubit.dart';
import '../../../logic/notification/notification_state.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({super.key, required this.state});

  final NotificationsLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<NotificationCategory?>(
          value: state.selectedCategory,
          hint: Text(
            '${'allTypes'.tr} (${state.notifications.length})',
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              fontSize: 12,
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: theme.iconTheme.color,
            size: 16,
          ),
          style: TextStyle(
            color: theme.textTheme.bodyMedium?.color,
            fontSize: 12,
          ),
          isDense: true,
          onChanged: (NotificationCategory? category) {
            context.read<NotificationsCubit>().filterByCategory(category);
          },
          items: [
            // All categories option
            DropdownMenuItem<NotificationCategory?>(
              value: null,
              child: Text('${'allTypes'.tr} (${state.notifications.length})'),
            ),
            // Individual categories
            ...NotificationCategory.values.map((category) {
              final count = state.notifications.where((n) => n.category == category).length;
              return DropdownMenuItem<NotificationCategory>(
                value: category,
                child: Text('${getCategoryDisplayName(category).tr} ($count)'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
