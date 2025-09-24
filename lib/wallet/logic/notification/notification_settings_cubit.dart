import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/notification_preferences.dart';
import '../../data/repo/wallet_repository.dart';
import 'notification_settings_state.dart';

class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final WalletRepository _walletRepository;

  NotificationSettingsCubit(this._walletRepository) : super(NotificationSettingsInitial());

  Future<void> loadPreferences() async {
    emit(NotificationSettingsLoading());

    try {
      final result = await _walletRepository.getNotificationPreferences();
      result.fold(
        (failure) {
          log('Error loading preferences: ${failure.message}');
          emit(NotificationSettingsError(failure.message));
        },
        (preferences) {
          emit(NotificationSettingsLoaded(preferences));
        },
      );
    } catch (e) {
      log('Exception loading preferences: $e');
      emit(NotificationSettingsError('Failed to load preferences: $e'));
    }
  }

  Future<void> updatePreference(String type, NotificationTypePreference preference) async {
    log('Updating preference for type: $type, enabled: ${preference.enabled}, channels: ${preference.channels}');

    final currentState = state;
    if (currentState is! NotificationSettingsLoaded) {
      log('Cannot update preference: current state is not loaded');
      return;
    }

    // Store original state for potential rollback
    final originalState = currentState;

    try {
      // Optimistic update
      final updatedPreferences = Map<String, NotificationTypePreference>.from(
        currentState.preferences.preferences,
      );
      updatedPreferences[type] = preference;

      emit(NotificationSettingsLoaded(
        currentState.preferences.copyWith(preferences: updatedPreferences),
      ));

      // Make API call
      final result = await _walletRepository.updateNotificationPreferenceByType(type, preference);
      result.fold(
        (failure) {
          log('API call failed: ${failure.message}');
          // Revert to original state
          emit(originalState);
          emit(NotificationSettingsError(failure.message));
        },
        (_) {
          // Success - keep optimistic update
          // If your API returns updated preferences, you can handle them here
        },
      );
    } catch (e) {
      log('Exception updating preference: $e');
      emit(originalState);
      emit(NotificationSettingsError('Failed to update preference: $e'));
    }
  }

  Future<void> toggleDeliveryMethod(String type, String channel, bool enabled) async {
    log('Toggling delivery method: type=$type, channel=$channel, enabled=$enabled');

    final currentState = state;
    if (currentState is! NotificationSettingsLoaded) {
      log('Cannot toggle delivery method: current state is not loaded');
      return;
    }

    final currentPref = currentState.preferences.preferences[type];
    if (currentPref == null) {
      log('Cannot find preference for type: $type');
      return;
    }

    final List<String> updatedChannels = List.from(currentPref.channels);

    if (enabled && !updatedChannels.contains(channel)) {
      updatedChannels.add(channel);
      log('Added channel $channel to type $type');
    } else if (!enabled && updatedChannels.contains(channel)) {
      updatedChannels.remove(channel);
      log('Removed channel $channel from type $type');
    } else {
      log('No change needed for channel $channel in type $type');
      return; // No change needed
    }

    final updatedPreference = currentPref.copyWith(channels: updatedChannels);
    await updatePreference(type, updatedPreference);
  }

  Future<void> toggleNotificationType(String type, bool enabled) async {
    log('Toggling notification type: type=$type, enabled=$enabled');

    final currentState = state;
    if (currentState is! NotificationSettingsLoaded) {
      log('Cannot toggle notification type: current state is not loaded');
      return;
    }

    final currentPref = currentState.preferences.preferences[type];
    if (currentPref == null) {
      log('Cannot find preference for type: $type');
      return;
    }

    // If disabling, clear all channels. If enabling, keep current channels or set default
    List<String> channels = currentPref.channels;
    if (!enabled) {
      channels = []; // Clear channels when disabling
    } else if (channels.isEmpty) {
      // If enabling but no channels selected, add default channels
      // You might want to set some default channels here
      channels = ['database']; // Default to in-app notifications
    }

    final updatedPreference = currentPref.copyWith(
      enabled: enabled,
      channels: channels,
    );

    await updatePreference(type, updatedPreference);
  }
}
