import 'package:flutter/material.dart';

import '../core/services/shared_preferences_helper.dart';

class ThemeNotifier with ChangeNotifier {
  ThemeNotifier() {
    _loadFromPrefs();
  }

  bool _isLightTheme = true; // Default theme
  final String key = 'theme';

  bool get isLightTheme => _isLightTheme;

  void toggleTheme() {
    _isLightTheme = !_isLightTheme;
    notifyListeners(); // Notify first for instant UI change
    _saveToPrefs(); // Then persist asynchronously
  }

  Future<void> _loadFromPrefs() async {
    final storedValue = SecurePreferencesUtil.getBool(key);
    if (storedValue != null) {
      _isLightTheme = storedValue;
    }
    // Only notify here once after initial load
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    await SecurePreferencesUtil.setBool(key, _isLightTheme);
  }
}
