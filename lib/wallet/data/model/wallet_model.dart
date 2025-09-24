import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class WalletModel extends Equatable {
  final double currentBalance;
  final double rewardsEarned;
  final DateTime lastUpdated;
  final String? currency;
  final int expiringLotsCount;
  final int transactionsCount;

  const WalletModel({
    required this.currentBalance,
    required this.rewardsEarned,
    required this.lastUpdated,
    required this.expiringLotsCount,
    required this.transactionsCount,
    this.currency,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    DateTime parseDateTime(String? dateString) {
      if (dateString == null) return DateTime.now();

      try {
        // If it contains parentheses, extract the date part
        if (dateString.contains('(') && dateString.contains(')')) {
          final dateInParentheses = dateString.split('(')[1].split(')')[0];
          // Try parsing "Sep 20, 2025 09:43" format
          return DateFormat('MMM dd, yyyy HH:mm').parse(dateInParentheses);
        }

        // Otherwise try normal parsing
        return DateTime.parse(dateString);
      } catch (e) {
        // Return current time as fallback
        return DateTime.now();
      }
    }

    return WalletModel(
      currentBalance: double.tryParse(json['total_balance']) ?? 0.0,
      rewardsEarned: double.tryParse(json['total_rewards_earned']) ?? 0.0,
      lastUpdated: parseDateTime(json['last_updated']),
      currency: json['currency'] ?? 'AED',
      expiringLotsCount: json['expiring_lots_count'],
      transactionsCount: json['transactions_count'],
    );
  }

  WalletModel copyWith({
    double? currentBalance,
    double? rewardsEarned,
    DateTime? lastUpdated,
    String? currency,
    int? expiringLotsCount,
    int? transactionsCount,
  }) {
    return WalletModel(
      currentBalance: currentBalance ?? this.currentBalance,
      rewardsEarned: rewardsEarned ?? this.rewardsEarned,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currency: currency ?? this.currency,
      expiringLotsCount: expiringLotsCount ?? this.expiringLotsCount,
      transactionsCount: transactionsCount ?? this.transactionsCount,
    );
  }

  @override
  List<Object?> get props =>
      [currentBalance, rewardsEarned, lastUpdated, currency, expiringLotsCount, transactionsCount];
}
