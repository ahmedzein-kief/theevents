import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/wallet/wallet_cubit.dart';
import '../../../logic/wallet/wallet_state.dart';
import '../shared/wallet_card.dart';

class NotificationsBalanceCards extends StatelessWidget {
  const NotificationsBalanceCards({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.appBarTheme.backgroundColor,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: BlocBuilder<WalletCubit, WalletState>(
        builder: (context, state) {
          double currentBalance = 1500.0;
          double rewardsEarned = 75.0;

          if (state is WalletLoaded) {
            currentBalance = state.wallet.currentBalance;
            rewardsEarned = state.wallet.rewardsEarned;
          }

          return Row(
            children: [
              Expanded(
                child: WalletCard(
                  title: AppStrings.currentBalanceTitle.tr,
                  amount: currentBalance,
                  currency: 'AED',
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: WalletCard(
                  title: AppStrings.rewardsEarnedTitle.tr,
                  amount: rewardsEarned,
                  currency: 'AED',
                  icon: Icons.stars_outlined,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
