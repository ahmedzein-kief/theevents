class DepositModel {
  final bool? status;
  final String? message;
  final String? amount;
  final String? checkoutUrl;
  final String? newBalance;
  final LotModel? lot;
  final TransactionModel? transaction;
  final GiftCardModel? giftCard;
  final String? baseValue;
  final String? bonusValue;
  final String? totalCredit;

  const DepositModel({
    this.status,
    this.message,
    this.amount,
    this.checkoutUrl,
    this.newBalance,
    this.lot,
    this.transaction,
    this.giftCard,
    this.baseValue,
    this.bonusValue,
    this.totalCredit,
  });

  factory DepositModel.fromJson(Map<String, dynamic> json) {
    // Simple and reliable detection using unique keys

    // Handle gift card response format
    // Gift card response has 'gift_card' key in data
    if (json.containsKey('data') &&
        json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>).containsKey('gift_card')) {
      return DepositModel(
        status: json['status'],
        message: json['message'],
        amount: json['data']?['total_credit']?.toString(),
        newBalance: json['data']?['new_balance']?.toString(),
        lot: json['data']?['lot'] != null ? LotModel.fromJson(json['data']['lot']) : null,
        transaction:
            json['data']?['transaction'] != null ? TransactionModel.fromJson(json['data']['transaction']) : null,
        giftCard: json['data']?['gift_card'] != null ? GiftCardModel.fromJson(json['data']['gift_card']) : null,
        baseValue: json['data']?['base_value']?.toString(),
        bonusValue: json['data']?['bonus_value']?.toString(),
        totalCredit: json['data']?['total_credit']?.toString(),
      );
    }

    // Handle credit card response format (Telr)
    // Credit card response has 'checkoutUrl' key in data
    else if (json.containsKey('data') &&
        json['data'] is Map<String, dynamic> &&
        (json['data'] as Map<String, dynamic>).containsKey('checkoutUrl')) {
      return DepositModel(
        status: json['error'] != null ? !(json['error'] as bool) : json['status'],
        message: json['message'] ?? '',
        checkoutUrl: json['data']?['checkoutUrl'],
      );
    }

    // Fallback for unknown format
    else {
      return DepositModel(
        status: json['status'],
        message: json['message'],
        amount: json['amount']?.toString(),
        checkoutUrl: json['checkoutUrl'],
      );
    }
  }

  // Helper getters
  bool get isSuccess => status == true;

  bool get hasCheckoutUrl => checkoutUrl != null && checkoutUrl!.isNotEmpty;

  bool get isGiftCardRedeem => lot != null;

  bool get isCreditCardPayment => checkoutUrl != null;
}

// Additional models for gift card response
class LotModel {
  final int id;
  final int userId;
  final String source;
  final String amount;
  final String baseValue;
  final String bonusValue;
  final String remaining;
  final String currency;
  final DateTime acquiredAt;
  final DateTime expiresAt;
  final String status;
  final int? giftCardId;
  final int? promoRuleId;

  const LotModel({
    required this.id,
    required this.userId,
    required this.source,
    required this.amount,
    required this.baseValue,
    required this.bonusValue,
    required this.remaining,
    required this.currency,
    required this.acquiredAt,
    required this.expiresAt,
    required this.status,
    this.giftCardId,
    this.promoRuleId,
  });

  factory LotModel.fromJson(Map<String, dynamic> json) {
    return LotModel(
      id: json['id'],
      userId: json['user_id'],
      source: json['source'],
      amount: json['amount'],
      baseValue: json['base_value'],
      bonusValue: json['bonus_value'],
      remaining: json['remaining'],
      currency: json['currency'],
      acquiredAt: DateTime.parse(json['acquired_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      status: json['status'],
      giftCardId: json['gift_card_id'],
      promoRuleId: json['promo_rule_id'],
    );
  }
}

class TransactionModel {
  final int id;
  final int userId;
  final String direction;
  final String amount;
  final String baseValue;
  final String bonusValue;
  final String currency;
  final String type;
  final String status;
  final String refType;
  final int refId;
  final int? giftCardId;
  final int? promoRuleId;
  final List<LotAllocation> lotAllocation;

  const TransactionModel({
    required this.id,
    required this.userId,
    required this.direction,
    required this.amount,
    required this.baseValue,
    required this.bonusValue,
    required this.currency,
    required this.type,
    required this.status,
    required this.refType,
    required this.refId,
    this.giftCardId,
    this.promoRuleId,
    required this.lotAllocation,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      direction: json['direction'],
      amount: json['amount'],
      baseValue: json['base_value'],
      bonusValue: json['bonus_value'],
      currency: json['currency'],
      type: json['type'],
      status: json['status'],
      refType: json['ref_type'],
      refId: json['ref_id'],
      giftCardId: json['gift_card_id'],
      promoRuleId: json['promo_rule_id'],
      lotAllocation: (json['lot_allocation'] as List?)?.map((item) => LotAllocation.fromJson(item)).toList() ?? [],
    );
  }
}

class LotAllocation {
  final int lotId;
  final double amount;

  const LotAllocation({
    required this.lotId,
    required this.amount,
  });

  factory LotAllocation.fromJson(Map<String, dynamic> json) {
    return LotAllocation(
      lotId: json['lot_id'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}

class GiftCardModel {
  final int id;
  final String title;
  final String code;
  final DateTime startDate;
  final DateTime endDate;
  final int quantity;
  final int totalUsed;
  final double value;
  final String type;
  final String status;
  final int? redeemedBy;
  final DateTime? redeemedAt;

  const GiftCardModel({
    required this.id,
    required this.title,
    required this.code,
    required this.startDate,
    required this.endDate,
    required this.quantity,
    required this.totalUsed,
    required this.value,
    required this.type,
    required this.status,
    this.redeemedBy,
    this.redeemedAt,
  });

  factory GiftCardModel.fromJson(Map<String, dynamic> json) {
    return GiftCardModel(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      quantity: json['quantity'],
      totalUsed: json['total_used'],
      value: (json['value'] as num).toDouble(),
      type: json['type'],
      status: json['status'],
      redeemedBy: json['redeemed_by'],
      redeemedAt: json['redeemed_at'] != null ? DateTime.parse(json['redeemed_at']) : null,
    );
  }
}
