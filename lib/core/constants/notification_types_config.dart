class NotificationTypeConfig {
  final String type;
  final String title;
  final String subtitle;

  const NotificationTypeConfig({
    required this.type,
    required this.title,
    required this.subtitle,
  });
}

class NotificationTypesConfig {
  static const List<NotificationTypeConfig> types = [
    NotificationTypeConfig(
      type: 'transaction',
      title: 'Transaction Confirmations',
      subtitle: 'Deposits, purchases, confirmations',
    ),
    NotificationTypeConfig(
      type: 'achievements',
      title: 'Achievement Alerts',
      subtitle: 'Milestones, rewards, goals',
    ),
    NotificationTypeConfig(
      type: 'expiry_reminder',
      title: 'Expiry Reminders',
      subtitle: 'Product expiry, renewal alerts',
    ),
    NotificationTypeConfig(
      type: 'promotional',
      title: 'Promotional Messages',
      subtitle: 'Marketing updates, special offers',
    ),
    NotificationTypeConfig(
      type: 'security',
      title: 'Security Alerts',
      subtitle: 'Login alerts, security updates',
    ),
    NotificationTypeConfig(
      type: 'system',
      title: 'System Updates',
      subtitle: 'App updates, maintenance notices',
    ),
  ];
}
