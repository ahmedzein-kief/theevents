import 'package:event_app/wallet/ui/widgets/overview/wallet_balance_card.dart';
import 'package:flutter/material.dart';

import '../../../logic/wallet/wallet_state.dart';
import '../shared/wallet_current_rewards_cards.dart';

class OverviewContent extends StatelessWidget {
  const OverviewContent({super.key, required this.isDark, required this.state});

  final bool isDark;
  final WalletLoaded state;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Balance cards
          const WalletCurrentRewardsCards(),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(20),
            child: WalletBalanceCard(isDark: isDark, state: state),
          ),
        ],
      ),
    );
  }
}
