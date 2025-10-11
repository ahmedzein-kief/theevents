import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/price_row.dart';
import '../../../logic/drawer/drawer_cubit.dart';
import '../../../logic/wallet/wallet_state.dart';

class WalletBalanceCard extends StatelessWidget {
  const WalletBalanceCard({super.key, required this.isDark, required this.state});

  final bool isDark;
  final WalletLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.walletBalanceTitle.tr,
            style: GoogleFonts.openSans(
              fontSize: 16,
              color: theme.textTheme.titleMedium?.color,
            ),
          ),
          const SizedBox(height: 25),
          PriceRow(
            currencySize: 22,
            alignment: MainAxisAlignment.center,
            price: state.wallet.currentBalance.toStringAsFixed(2),
            style: GoogleFonts.openSans(
              fontSize: 36,
              color: theme.textTheme.headlineLarge?.color,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${AppStrings.lastUpdatedPrefix.tr} ${Formatters.formatDateTime(state.wallet.lastUpdated)}',
            style: GoogleFonts.openSans(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color?.withAlpha((0.7 * 255).toInt()),
            ),
          ),
          const SizedBox(height: 35),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () => context.read<DrawerCubit>().setSelectedScreen(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      AppStrings.addFunds.tr,
                      style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => context.read<DrawerCubit>().setSelectedScreen(2),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      side: BorderSide(color: isDark ? Colors.white : Colors.black, width: .5),
                      foregroundColor: isDark ? Colors.white : Colors.black,
                    ),
                    child: Text(
                      AppStrings.history.tr,
                      style: GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
