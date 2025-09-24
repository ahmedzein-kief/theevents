import 'package:flutter/material.dart';

import '../../wallet/data/model/notification_model.dart';

class NotificationThemeHelper {
  final BuildContext context;
  final NotificationModel notification;
  final ThemeData theme;
  final bool isDark;

  NotificationThemeHelper(this.context, this.notification)
      : theme = Theme.of(context),
        isDark = Theme.of(context).brightness == Brightness.dark;

  Color get backgroundColor {
    if (notification.isRead) {
      return isDark ? Colors.grey[850]! : Colors.grey[50]!;
    } else {
      return isDark ? const Color(0xFFF0F7FF).withAlpha((0.3 * 255).toInt()) : const Color(0xFFF0F7FF);
    }
  }

  Color get borderColor {
    if (notification.isRead) {
      return isDark ? Colors.grey[700]! : Colors.grey[200]!;
    } else {
      return isDark
          ? const Color(0xFFF0F7FF).withAlpha((.7 * 255).toInt())
          : const Color(0xFF006DFF).withAlpha((.5 * 255).toInt());
    }
  }

  Color get titleColor {
    if (notification.isRead) {
      return theme.textTheme.titleMedium?.color?.withAlpha((0.7 * 255).toInt()) ??
          (isDark ? Colors.grey[400]! : Colors.grey[700]!);
    } else {
      return theme.textTheme.titleLarge?.color ?? (isDark ? Colors.white : Colors.black);
    }
  }

  Color get messageColor {
    if (notification.isRead) {
      return theme.textTheme.bodyMedium?.color?.withAlpha((0.6 * 255).toInt()) ??
          (isDark ? Colors.grey[500]! : Colors.grey[600]!);
    } else {
      return theme.textTheme.bodyMedium?.color?.withAlpha((0.8 * 255).toInt()) ??
          (isDark ? Colors.grey[300]! : Colors.grey[700]!);
    }
  }
}
