import 'package:equatable/equatable.dart';

import '../../data/model/notification_preferences.dart';

abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object?> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final NotificationPreferences preferences;

  const NotificationSettingsLoaded(this.preferences);

  @override
  List<Object> get props => [preferences];
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object> get props => [message];
}
