import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/wallet/logic/wallet/wallet_cubit.dart';
import 'package:event_app/wallet/ui/widgets/shared/wallet_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../logic/wallet/wallet_state.dart';
import 'wallet_card.dart';

class WalletCurrentRewardsCards extends StatelessWidget {
  const WalletCurrentRewardsCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final walletLoaded = state as WalletLoaded;
        final walletModel = walletLoaded.wallet;
        return Container(
          padding: const EdgeInsets.all(20),
          color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
          child: Row(
            children: [
              Expanded(
                child: WalletCard(
                  title: AppStrings.currentBalanceTitle.tr,
                  amount: walletModel.currentBalance,
                  currency: walletModel.currency!,
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: WalletInfoCard(
                  title: AppStrings.totalTransactions.tr,
                  value: walletModel.transactionsCount.toString(),
                  icon: Icons.history,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
