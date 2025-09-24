class NotificationPreferences {
  final Map<String, NotificationTypePreference> preferences;

  const NotificationPreferences({required this.preferences});

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    final preferencesMap = <String, NotificationTypePreference>{};

    // Handle both API response format and local storage format
    Map<String, dynamic> prefsData;

    if (json.containsKey('data')) {
      // API response format: data is at root level
      prefsData = json['data'] as Map<String, dynamic>? ?? {};
    } else if (json.containsKey('preferences')) {
      // Local storage format: data is under preferences key
      prefsData = json['preferences'] as Map<String, dynamic>? ?? {};
    } else {
      // Direct format: preferences are at root level
      prefsData = json;
    }

    prefsData.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        preferencesMap[key] = NotificationTypePreference.fromJson(value);
      }
    });

    return NotificationPreferences(preferences: preferencesMap);
  }

  Map<String, dynamic> toJson() {
    final prefsMap = <String, dynamic>{};
    preferences.forEach((key, value) {
      prefsMap[key] = value.toJson();
    });

    return {'preferences': prefsMap};
  }

  NotificationPreferences copyWith({
    Map<String, NotificationTypePreference>? preferences,
  }) {
    return NotificationPreferences(
      preferences: preferences ?? this.preferences,
    );
  }
}

class NotificationTypePreference {
  final bool enabled;
  final List<String> channels;
  final Map<String, String>? availableChannels; // Added to store available channels info

  const NotificationTypePreference({
    required this.enabled,
    required this.channels,
    this.availableChannels,
  });

  factory NotificationTypePreference.fromJson(Map<String, dynamic> json) {
    // Parse available_channels if present
    Map<String, String>? availableChannels;
    if (json['available_channels'] != null) {
      availableChannels = Map<String, String>.from(json['available_channels']);
    }

    return NotificationTypePreference(
      enabled: json['enabled'] ?? false,
      channels: (json['channels'] as List<dynamic>? ?? []).map((e) => e.toString()).toList(),
      availableChannels: availableChannels,
    );
  }

  Map<String, dynamic> toJson() {
    final result = {
      'enabled': enabled,
      'channels': channels,
    };

    if (availableChannels != null) {
      result['available_channels'] = availableChannels!;
    }

    return result;
  }

  NotificationTypePreference copyWith({
    bool? enabled,
    List<String>? channels,
    Map<String, String>? availableChannels,
  }) {
    return NotificationTypePreference(
      enabled: enabled ?? this.enabled,
      channels: channels ?? this.channels,
      availableChannels: availableChannels ?? this.availableChannels,
    );
  }
}
