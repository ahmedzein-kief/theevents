enum FundStatus { expiringSoon, expired, active }

enum FundType { wallet, giftCard, other }

class FundExpiryModel {
  final String id;
  final String userId;
  final String source;
  final double amount;
  final double remaining;
  final String currency;
  final DateTime acquiredAt;
  final DateTime expiresAt;
  final String status;
  final double baseValue;
  final double bonusValue;
  final String? promoRuleId;
  final String? giftCardId;
  final String? refNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FundExpiryModel({
    required this.id,
    required this.userId,
    required this.source,
    required this.amount,
    required this.remaining,
    required this.currency,
    required this.acquiredAt,
    required this.expiresAt,
    required this.status,
    required this.baseValue,
    required this.bonusValue,
    this.promoRuleId,
    this.giftCardId,
    this.refNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FundExpiryModel.fromJson(Map<String, dynamic> json) {
    return FundExpiryModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      source: json['source'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      remaining: double.tryParse(json['remaining'].toString()) ?? 0.0,
      currency: json['currency'] ?? 'AED',
      acquiredAt: DateTime.parse(json['acquired_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      status: json['status'] ?? 'active',
      baseValue: double.tryParse(json['base_value'].toString()) ?? 0.0,
      bonusValue: double.tryParse(json['bonus_value'].toString()) ?? 0.0,
      promoRuleId: json['promo_rule_id']?.toString(),
      giftCardId: json['gift_card_id']?.toString(),
      refNumber: json['ref_number']?.toString(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Helper getters for UI
  FundType get type {
    switch (source.toLowerCase()) {
      case 'gift_card':
        return FundType.giftCard;
      case 'wallet':
        return FundType.wallet;
      default:
        return FundType.other;
    }
  }

  FundStatus get fundStatus {
    final now = DateTime.now();
    if (expiresAt.isBefore(now)) {
      return FundStatus.expired;
    } else if (expiresAt.difference(now).inDays <= 30) {
      return FundStatus.expiringSoon;
    } else {
      return FundStatus.active;
    }
  }

  // For backward compatibility with your existing UI
  DateTime get expiryDate => expiresAt;

  DateTime get rechargedDate => acquiredAt;
}
