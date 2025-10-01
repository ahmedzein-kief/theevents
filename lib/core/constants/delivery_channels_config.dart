class DeliveryChannelConfig {
  final String key;
  final String label;

  const DeliveryChannelConfig({
    required this.key,
    required this.label,
  });

  factory DeliveryChannelConfig.fromChannelKey(key) =>
      DeliveryChannelsConfig.channels.where((channel) => channel.key == key).first;
}

class DeliveryChannelsConfig {
  static const List<DeliveryChannelConfig> channels = [
    DeliveryChannelConfig(key: 'mail', label: 'Email'),
    DeliveryChannelConfig(key: 'database', label: 'In-App'),
    DeliveryChannelConfig(key: 'broadcast', label: 'Push'),
    DeliveryChannelConfig(key: 'sms', label: 'SMS'),
  ];
}
