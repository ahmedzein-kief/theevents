import 'package:equatable/equatable.dart';

import '../../data/model/notification_model.dart';

// Sentinel object to indicate "no change" for selectedCategory
class NoChangeCategory {
  const NoChangeCategory._();
}

// Singleton instance of the sentinel
const noChangeCategory = NoChangeCategory._();

abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final NotificationMeta meta;
  final bool isLoadingMore;
  final NotificationCategory? selectedCategory;

  const NotificationsLoaded({
    required this.notifications,
    required this.meta,
    this.isLoadingMore = false,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [notifications, meta, isLoadingMore, selectedCategory];

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    NotificationMeta? meta,
    bool? isLoadingMore,
    Object? selectedCategory = noChangeCategory, // accept NotificationCategory?, noChangeCategory
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      selectedCategory:
          selectedCategory == noChangeCategory ? this.selectedCategory : selectedCategory as NotificationCategory?,
    );
  }
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}
