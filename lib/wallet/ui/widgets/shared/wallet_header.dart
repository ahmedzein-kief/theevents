import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../logic/drawer/drawer_cubit.dart';
import '../../../logic/drawer/drawer_state.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({super.key, required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[800] : Colors.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 24),
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
                  'Hi, Ahmed Al-Mahmoud',
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              AppStrings.expirySoon.tr,
              style: GoogleFonts.openSans(fontSize: 10, color: Colors.white),
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
