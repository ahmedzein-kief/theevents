enum TransactionType { deposit, payment, reward, refund }

enum TransactionStatus { pending, completed, failed, cancelled }

enum PaymentMethod { creditCard, giftCard, bankTransfer, other }

class TransactionsModel {
  final List<TransactionModel> transactions;
  final int? total;
  final int? perPage;
  final int? currentPage;
  final int? lastPage;
  final int? from;
  final int? to;

  const TransactionsModel({
    required this.transactions,
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.from,
    this.to,
  });

  factory TransactionsModel.fromJson(Map<String, dynamic> json) {
    return TransactionsModel(
      transactions:
          (json['data'] as List<dynamic>?)?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>)).toList() ??
              [],
      total: json['total'] as int?,
      perPage: json['per_page'] as int?,
      currentPage: json['current_page'] as int?,
      lastPage: json['last_page'] as int?,
      from: json['from'] as int?,
      to: json['to'] as int?,
    );
  }

  // Convenience getters
  bool get hasNextPage => currentPage != null && lastPage != null && currentPage! < lastPage!;

  bool get hasPreviousPage => currentPage != null && currentPage! > 1;

  bool get isEmpty => transactions.isEmpty;

  int get length => transactions.length;
}

class TransactionModel {
  final int id;
  final String? refId;
  final TransactionType type;
  final double amount;
  final double currentBalance;
  final String currency;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final PaymentMethod? method;
  final String? direction; // Add direction field from API

  const TransactionModel({
    required this.id,
    this.refId,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    required this.currency,
    required this.currentBalance,
    this.method,
    this.direction,
  });

  TransactionModel copyWith({
    int? id,
    String? refId,
    TransactionType? type,
    double? amount,
    String? description,
    String? currency,
    DateTime? date,
    TransactionStatus? status,
    PaymentMethod? method,
    double? currentBalance,
    String? direction,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      refId: refId ?? this.refId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      status: status ?? this.status,
      method: method ?? this.method,
      currentBalance: currentBalance ?? this.currentBalance,
      direction: direction ?? this.direction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ref_id': refId,
      'payment_type': type.name,
      'amount': amount,
      'description': description,
      'currency': currency,
      'created_at': date.toIso8601String(),
      'status': status.name,
      'method': method?.name,
      'running_balance': currentBalance,
      'direction': direction,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as int,
      refId: json['ref_id'] as String?,
      currency: json['currency'] as String,
      // Handle running_balance as either int or string
      currentBalance: _parseDouble(json['running_balance']),
      amount: _parseDouble(json['amount']),
      description: json['description'] as String,
      date: DateTime.parse(json['created_at']),
      status: _parseTransactionStatus(json['status']),
      type: _parseTransactionType(json['payment_type']),
      method: _parsePaymentMethod(json['payment_method']),
      // Derive from payment_type
      direction: json['direction'] as String?,
    );
  }

  // Helper method to parse double from various types
  static double _parseDouble(value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  // Helper method to parse transaction status
  static TransactionStatus _parseTransactionStatus(String status) {
    try {
      return TransactionStatus.values.firstWhere((e) => e.name == status);
    } catch (e) {
      return TransactionStatus.completed; // Default fallback
    }
  }

  // Helper method to parse transaction type from payment_type
  static TransactionType _parseTransactionType(String paymentType) {
    switch (paymentType) {
      case 'Deposits':
        return TransactionType.deposit;
      case 'Purchase':
      case 'Payment':
        return TransactionType.payment;
      case 'Reward':
      case 'Loyalty':
        return TransactionType.reward;
      case 'Refund':
        return TransactionType.refund;
      default:
        return TransactionType.deposit; // Default fallback
    }
  }

  // Helper method to derive payment method from payment_type
  static PaymentMethod? _parsePaymentMethod(String paymentType) {
    switch (paymentType) {
      case 'gift_card_redeem':
        return PaymentMethod.giftCard;
      case 'purchase':
        return PaymentMethod.creditCard;
      case 'bank_transfer':
        return PaymentMethod.bankTransfer;
      default:
        return null; // Unknown payment method
    }
  }
}
