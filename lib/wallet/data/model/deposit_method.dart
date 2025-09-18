import 'package:equatable/equatable.dart';

enum DepositMethodType { giftCard, creditCard }

class DepositMethod extends Equatable {
  final DepositMethodType type;
  final String title;
  final String subtitle;
  final String processingInfo;
  final bool isInstant;

  const DepositMethod({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.processingInfo,
    this.isInstant = true,
  });

  @override
  List<Object?> get props => [type, title, subtitle, processingInfo, isInstant];
}
