import 'package:flutter/material.dart';

import '../styles/app_colors.dart';

class NotificationSettingsTheme {
  final BuildContext context;
  final ThemeData theme;
  final bool isDark;

  NotificationSettingsTheme(this.context)
      : theme = Theme.of(context),
        isDark = Theme.of(context).brightness == Brightness.dark;

  BoxDecoration get containerDecoration {
    return BoxDecoration(
      color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.05 * 255).toInt()),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
    );
  }

  BoxDecoration get tileDecoration {
    return BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isDark ? const Color(0xFF404040) : const Color(0xFFEEEEEE),
      ),
    );
  }

  BoxDecoration getChipDecoration(bool isSelected) {
    return BoxDecoration(
      color: isSelected
          ? AppColors.peachyPink.withAlpha((0.7 * 255).toInt())
          : isDark
              ? const Color(0xFF767474)
              : theme.colorScheme.primary,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isSelected ? AppColors.peachyPink : theme.colorScheme.onSurface.withAlpha((0.1 * 255).toInt()),
      ),
    );
  }

  TextStyle getChipTextStyle(bool isSelected) {
    return TextStyle(
      fontSize: 12,
      color: isSelected
          ? Colors.black
          : isDark
              ? Colors.white
              : theme.colorScheme.onPrimary,
    );
  }
}
