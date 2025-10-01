import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/notification_model.dart';
import '../../data/repo/wallet_repository.dart';
import 'notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final WalletRepository _walletRepository;

  NotificationsCubit(this._walletRepository) : super(NotificationsInitial());

  Future<void> initializeNotifications() async {
    final currentState = state;

    if (currentState is NotificationsInitial) {
      // First time loading
      await loadNotifications();
    } else if (currentState is NotificationsLoaded) {
      // Check if data is stale (older than 5 minutes) or force refresh
      final now = DateTime.now();
      final lastUpdated = currentState.notifications.isNotEmpty
          ? currentState.notifications.first.createdAt
          : now.subtract(const Duration(hours: 1));

      final isStale = now.difference(lastUpdated).inMinutes > 5;

      if (isStale || currentState.notifications.isEmpty) {
        await loadNotifications(refresh: true);
      }
      // If data is fresh, do nothing - use existing data
    } else {
      // Error state or other - refresh
      await loadNotifications(refresh: true);
    }
  }

  Future<void> loadNotifications({bool refresh = false}) async {
    if (refresh || state is NotificationsInitial) {
      emit(NotificationsLoading());
    } else if (state is NotificationsLoaded) {
      emit((state as NotificationsLoaded).copyWith(isLoadingMore: true));
    }

    final currentState = state;
    final currentPage = currentState is NotificationsLoaded && !refresh ? currentState.meta.currentPage + 1 : 1;

    final result = await _walletRepository.getNotifications(page: currentPage);

    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (response) {
        if (refresh || currentPage == 1) {
          // For refresh or first page, replace all notifications
          emit(NotificationsLoaded(
            notifications: response.notifications,
            meta: response.meta,
            selectedCategory: currentState is NotificationsLoaded ? currentState.selectedCategory : null,
          ));
        } else if (currentState is NotificationsLoaded && currentPage > 1) {
          // Only append for pagination (page > 1)
          final updatedNotifications = [
            ...currentState.notifications,
            ...response.notifications,
          ];
          emit(NotificationsLoaded(
            notifications: updatedNotifications,
            meta: response.meta,
            isLoadingMore: false,
            selectedCategory: currentState.selectedCategory,
          ));
        } else {
          // Fallback: treat as fresh load
          emit(NotificationsLoaded(
            notifications: response.notifications,
            meta: response.meta,
          ));
        }
      },
    );
  }

  Future<void> loadMoreNotifications() async {
    final currentState = state;
    if (currentState is NotificationsLoaded && !currentState.isLoadingMore) {
      if (currentState.meta.currentPage < currentState.meta.lastPage) {
        await loadNotifications(); // This will handle pagination
      }
    }
  }

  // New method to handle category filtering
  void filterByCategory(NotificationCategory? category) {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      emit(currentState.copyWith(selectedCategory: category));
    }
  }

  // Helper method to get filtered notifications
  List<NotificationModel> getFilteredNotifications() {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      if (currentState.selectedCategory == null) {
        return currentState.notifications;
      }
      return currentState.notifications
          .where((notification) => notification.category == currentState.selectedCategory)
          .toList();
    }
    return [];
  }

  Future<void> markAsRead(String notificationId) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      // Find the notification being updated
      final notificationIndex = currentState.notifications.indexWhere((n) => n.id == notificationId);
      if (notificationIndex == -1) return;

      final notification = currentState.notifications[notificationIndex];
      if (notification.isRead) return; // Already read

      // Optimistically update the UI
      final updatedNotifications = currentState.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      // Update unread count
      final updatedMeta = NotificationMeta(
        currentPage: currentState.meta.currentPage,
        perPage: currentState.meta.perPage,
        total: currentState.meta.total,
        lastPage: currentState.meta.lastPage,
        unreadCount: currentState.meta.unreadCount - 1,
        totalCount: currentState.meta.totalCount,
      );

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        meta: updatedMeta,
      ));

      // Make API call
      final result = await _walletRepository.markNotificationAsRead(notificationId);
      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState);
          // You might want to show a snackbar or toast here
        },
        (_) {
          // Success - UI is already updated
        },
      );
    }
  }

  Future<void> markAllAsRead() async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      // Optimistically update the UI
      final updatedNotifications =
          currentState.notifications.map((notification) => notification.copyWith(isRead: true)).toList();

      final updatedMeta = NotificationMeta(
        currentPage: currentState.meta.currentPage,
        perPage: currentState.meta.perPage,
        total: currentState.meta.total,
        lastPage: currentState.meta.lastPage,
        unreadCount: 0,
        totalCount: currentState.meta.totalCount,
      );

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        meta: updatedMeta,
      ));

      // Make API call
      final result = await _walletRepository.markAllNotificationsAsRead();
      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState);
          // You might want to show a snackbar or toast here
        },
        (_) {
          // Success - UI is already updated
        },
      );
    }
  }

  Future<void> refreshNotifications() async {
    await loadNotifications(refresh: true);
  }

  Future<void> markAsUnread(String notificationId) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      // Find the notification being updated
      final notificationIndex = currentState.notifications.indexWhere((n) => n.id == notificationId);
      if (notificationIndex == -1) return;

      final notification = currentState.notifications[notificationIndex];
      if (!notification.isRead) return; // Already unread

      // Optimistic update
      final updatedNotifications = currentState.notifications.map((notification) {
        if (notification.id == notificationId) {
          return notification.copyWith(isRead: false);
        }
        return notification;
      }).toList();

      // Update unread count
      final updatedMeta = NotificationMeta(
        currentPage: currentState.meta.currentPage,
        perPage: currentState.meta.perPage,
        total: currentState.meta.total,
        lastPage: currentState.meta.lastPage,
        unreadCount: currentState.meta.unreadCount + 1,
        totalCount: currentState.meta.totalCount,
      );

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        meta: updatedMeta,
      ));

      // Make API call
      final result = await _walletRepository.markNotificationAsUnread(notificationId);
      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState);
        },
        (_) {
          // Success - UI is already updated
        },
      );
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      // Find the notification being deleted
      final notificationIndex = currentState.notifications.indexWhere((n) => n.id == notificationId);
      if (notificationIndex == -1) return;

      final notificationToDelete = currentState.notifications[notificationIndex];

      // Optimistic update
      final updatedNotifications =
          currentState.notifications.where((notification) => notification.id != notificationId).toList();

      // Update counts
      final newTotal = currentState.meta.total - 1;
      final newUnreadCount =
          notificationToDelete.isRead ? currentState.meta.unreadCount : currentState.meta.unreadCount - 1;

      final updatedMeta = NotificationMeta(
        currentPage: currentState.meta.currentPage,
        perPage: currentState.meta.perPage,
        total: newTotal,
        lastPage: currentState.meta.lastPage,
        unreadCount: newUnreadCount,
        totalCount: currentState.meta.totalCount - 1,
      );

      emit(currentState.copyWith(
        notifications: updatedNotifications,
        meta: updatedMeta,
      ));

      // Make API call
      final result = await _walletRepository.deleteNotification(notificationId);
      result.fold(
        (failure) {
          // Revert on failure
          emit(currentState);
        },
        (_) {
          // Success - UI is already updated
        },
      );
    }
  }

  Future<void> deleteAllNotification() async {
    log('deleteAllNotification');
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      // Store the current state for potential revert
      final previousState = currentState;

      // Optimistic update - clear all notifications
      final updatedMeta = NotificationMeta(
        currentPage: 1,
        perPage: currentState.meta.perPage,
        total: 0,
        lastPage: 1,
        unreadCount: 0,
        totalCount: 0,
      );

      emit(currentState.copyWith(
        notifications: [],
        meta: updatedMeta,
      ));

      // Make API call
      final result = await _walletRepository.deleteAllNotification();
      result.fold(
        (failure) {
          // Revert on failure
          emit(previousState);
        },
        (_) {
          // Success - UI is already updated
        },
      );
    }
  }

  // Helper method to get unread notification count (filtered)
  int get unreadCount {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final filteredNotifications = getFilteredNotifications();
      return filteredNotifications.where((n) => !n.isRead).length;
    }
    return 0;
  }

  // Helper method to get total notification count (filtered)
  int get totalCount {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      return getFilteredNotifications().length;
    }
    return 0;
  }

  // Helper method to check if there are more notifications to load
  bool get hasMore {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      return currentState.meta.currentPage < currentState.meta.lastPage;
    }
    return false;
  }

  // Helper method to get current selected category
  NotificationCategory? get selectedCategory {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      return currentState.selectedCategory;
    }
    return null;
  }
}
