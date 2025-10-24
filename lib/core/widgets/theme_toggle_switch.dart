import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/theme_notifier.dart';
import '../constants/app_strings.dart';

class ThemeToggleSwitch extends StatelessWidget {
  const ThemeToggleSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    return SwitchListTile(
      title: Text(AppStrings.darkMode.tr),
      value: !themeNotifier.isLightTheme,
      onChanged: (value) => themeNotifier.toggleTheme(),
      activeThumbColor: isDarkMode ? Colors.white : null,
      activeTrackColor: isDarkMode ? Colors.green : null,
    );
  }
}
