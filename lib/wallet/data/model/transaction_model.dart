import 'package:equatable/equatable.dart';

enum TransactionType { deposit, payment, reward, refund }

enum TransactionStatus { pending, completed, failed, cancelled }

class TransactionModel extends Equatable {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionStatus status;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.status,
  });

  @override
  List<Object?> get props => [id, type, amount, description, date, status];
}
