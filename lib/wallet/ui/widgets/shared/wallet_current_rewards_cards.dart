import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';
import 'wallet_card.dart';

class WalletCurrentRewardsCards extends StatelessWidget {
  final double currentBalance;
  final double rewards;
  final String currency;

  const WalletCurrentRewardsCards({
    super.key,
    required this.currentBalance,
    required this.rewards,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      child: Row(
        children: [
          Expanded(
            child: WalletCard(
              title: AppStrings.currentBalanceTitle.tr,
              amount: currentBalance,
              currency: currency,
              icon: Icons.account_balance_wallet_outlined,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: WalletCard(
              title: AppStrings.rewardsEarnedTitle.tr,
              amount: rewards,
              currency: currency,
              icon: Icons.stars_outlined,
            ),
          ),
        ],
      ),
    );
  }
}
