import '../../wallet/data/model/notification_model.dart';

String getCategoryDisplayName(NotificationCategory category) {
  switch (category) {
    case NotificationCategory.transaction:
      return 'Transaction';
    case NotificationCategory.expiryReminder:
      return 'Expiry Reminder';
    case NotificationCategory.promotional:
      return 'Promotional';
    case NotificationCategory.security:
      return 'Security';
    case NotificationCategory.system:
      return 'System';
    case NotificationCategory.achievements:
      return 'Achievements';
  }
}
