import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../provider/auth_provider/get_user_provider.dart';
import '../../../logic/drawer/drawer_cubit.dart';
import '../../../logic/drawer/drawer_state.dart';
import '../../../logic/wallet/wallet_cubit.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    required this.isDark,
    required this.expiryCount,
  });

  final bool isDark;
  final int expiryCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = context.read<UserProvider>().user?.name ?? '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.appBarTheme.backgroundColor,
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Row(
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
          Expanded(
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
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          // Expiry badge with notification count
          GestureDetector(
            onTap: () {
              // Get the current WalletCubit from context
              final walletCubit = context.read<WalletCubit>();

              Navigator.of(context).pushNamed(
                AppRoutes.fundExpiryAlertScreen,
                arguments: walletCubit, // Pass the existing cubit
              );
            },
            child: Stack(
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
            ),
          ),

          const SizedBox(width: 12),
          BlocBuilder<DrawerCubit, DrawerState>(
            builder: (context, drawerState) {
              return IconButton(
                onPressed: () => context.read<DrawerCubit>().toggleDrawer(),
                icon: Icon(Icons.menu, color: theme.iconTheme.color),
              );
            },
          ),
        ],
      ),
    );
  }
}
