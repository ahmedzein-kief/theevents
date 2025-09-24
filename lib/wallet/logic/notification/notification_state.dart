import 'package:equatable/equatable.dart';

import '../../data/model/notification_model.dart';

// States
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

  const NotificationsLoaded({
    required this.notifications,
    required this.meta,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [notifications, meta, isLoadingMore];

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    NotificationMeta? meta,
    bool? isLoadingMore,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      meta: meta ?? this.meta,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}
