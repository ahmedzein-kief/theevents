import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final double currentBalance;
  final double rewardsEarned;
  final DateTime lastUpdated;
  final String currency;

  const WalletModel({
    required this.currentBalance,
    required this.rewardsEarned,
    required this.lastUpdated,
    this.currency = 'AED',
  });

  WalletModel copyWith({
    double? currentBalance,
    double? rewardsEarned,
    DateTime? lastUpdated,
    String? currency,
  }) {
    return WalletModel(
      currentBalance: currentBalance ?? this.currentBalance,
      rewardsEarned: rewardsEarned ?? this.rewardsEarned,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      currency: currency ?? this.currency,
    );
  }

  @override
  List<Object?> get props => [currentBalance, rewardsEarned, lastUpdated, currency];
}
