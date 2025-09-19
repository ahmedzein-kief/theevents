

enum TransactionType { deposit, payment, reward, refund }

enum TransactionStatus { pending, completed, failed, cancelled }

enum PaymentMethod { creditCard, giftCard, bankTransfer, other }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;
  final PaymentMethod? method; // New field added

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
    this.method, // New optional parameter
  });

  // Add copyWith method if you don't have it
  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? description,
    DateTime? date,
    TransactionStatus? status,
    PaymentMethod? method,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      status: status ?? this.status,
      method: method ?? this.method,
    );
  }

  // Add toJson/fromJson if you need serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'status': status.name,
      'method': method?.name,
    };
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      type: TransactionType.values.firstWhere((e) => e.name == json['type']),
      amount: json['amount'].toDouble(),
      description: json['description'],
      date: DateTime.parse(json['date']),
      status: TransactionStatus.values.firstWhere((e) => e.name == json['status']),
      method: json['method'] != null ? PaymentMethod.values.firstWhere((e) => e.name == json['method']) : null,
    );
  }
}
