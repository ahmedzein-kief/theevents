import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/wallet/logic/wallet/wallet_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_views/default_app_bar.dart';
import '../../../core/widgets/custom_back_icon.dart';
import '../../../provider/auth_provider/get_user_provider.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/fund_expiry_alert/fund_expiry_content.dart';
import '../widgets/shared/wallet_current_rewards_cards.dart';

class FundExpiryAlertScreen extends StatelessWidget {
  const FundExpiryAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocBuilder<WalletCubit, WalletState>(
      builder: (context, state) {
        final expiryCount = state is WalletLoaded ? state.wallet.expiringLotsCount : 0;
        final userName = context.read<UserProvider>().user?.name ?? '';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: DefaultAppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey[800] : Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.digitalWallet.tr,
                        style: GoogleFonts.openSans(
                          fontSize: 15,
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      Text(
                        userName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        softWrap: false,
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: theme.textTheme.bodySmall?.color?.withAlpha((0.7 * 255).toInt()),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            leading: const BackIcon(),
            leadingWidth: 75,
            // centerTitle: true,
            actions: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4405F),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      AppStrings.expirySoon.tr,
                      style: GoogleFonts.openSans(fontSize: 10, color: Colors.white),
                    ),
                  ),
                  // if (expiryCount > 0)
                  Positioned(
                    right: -10,
                    top: -10,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFB3261E),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        '$expiryCount',
                        style: GoogleFonts.openSans(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                const WalletCurrentRewardsCards(),
                Expanded(
                  child: Container(
                    color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                    child: const FundExpiryContent(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
