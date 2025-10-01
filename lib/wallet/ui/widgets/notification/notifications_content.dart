import 'package:event_app/core/constants/app_assets.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/wallet/ui/widgets/notification/category_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/notification_dialog_helper.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../logic/notification/notification_cubit.dart';
import '../../../logic/notification/notification_state.dart';
import '../../screens/notification_settings_screen.dart';
import 'notifications_empty_state.dart';
import 'notifications_list.dart';

class NotificationsContent extends StatelessWidget {
  const NotificationsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Row
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.notifications_outlined, size: 24, color: theme.iconTheme.color),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            AppStrings.notifications.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: theme.textTheme.titleLarge?.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Mark all as read button (only show if there are unread notifications)
                  if (state is NotificationsLoaded && state.meta.unreadCount > 0)
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => context.read<NotificationsCubit>().markAllAsRead(),
                      icon: Icon(
                        Icons.done_all_outlined,
                        color: theme.iconTheme.color,
                        size: 20,
                      ),
                      tooltip: 'Mark all as read',
                    ),

                  // Delete all button (only show if there are notifications)
                  if (state is NotificationsLoaded && state.notifications.isNotEmpty)
                    IconButton(
                      style: IconButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => NotificationDialogHelper.showDeleteAllConfirmation(
                        context,
                        context.read<NotificationsCubit>(),
                      ),
                      icon: Image.asset(
                        AppAssets.delete,
                        width: 20,
                        height: 20,
                        color: Colors.red[400],
                      ),
                      tooltip: 'Delete all notifications',
                    ),

                  // Settings button
                  IconButton(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      size: 20,
                      color: theme.iconTheme.color,
                    ),
                  ),
                ],
              );
            },
          ),

          // Category Filter Section
          const SizedBox(height: 16),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is NotificationsLoaded) {
                return Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      size: 16,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.filters.tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: theme.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: CategoryFilter(state: state),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),

          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return const LoadingIndicator();
                } else if (state is NotificationsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<NotificationsCubit>().refreshNotifications(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state is NotificationsLoaded) {
                  // Use filtered notifications
                  final filteredNotifications = context.read<NotificationsCubit>().getFilteredNotifications();

                  if (filteredNotifications.isEmpty) {
                    return const NotificationsEmptyState();
                  }

                  return RefreshIndicator(
                    onRefresh: () => context.read<NotificationsCubit>().refreshNotifications(),
                    child: NotificationsList(
                      notifications: filteredNotifications,
                      meta: state.meta,
                      onLoadMore: () => context.read<NotificationsCubit>().loadNotifications(),
                      onMarkAsRead: (id) => context.read<NotificationsCubit>().markAsRead(id),
                      onMarkAsUnread: (id) => context.read<NotificationsCubit>().markAsUnread(id),
                      onDelete: (id) => context.read<NotificationsCubit>().deleteNotification(id),
                    ),
                  );
                } else {
                  return const NotificationsEmptyState();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
