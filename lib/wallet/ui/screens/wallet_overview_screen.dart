import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/constants/app_strings.dart';

import '../../../core/widgets/PriceRow.dart';
import '../../logic/drawer/drawer_cubit.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/wallet_card.dart';
import 'add_funds_screen.dart';

class WalletOverviewScreen extends StatelessWidget {
  const WalletOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.digitalWallet.tr,
                          style: GoogleFonts.openSans(fontSize: 15),
                        ),
                        Text(
                          'Hi, Ahmed Al-Mahmoud',
                          style: GoogleFonts.openSans(
                            fontSize: 12,
                            color: const Color(0xFF4A5565),
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
                      style: GoogleFonts.openSans(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  BlocBuilder<DrawerCubit, bool>(
                    builder: (context, isOpen) {
                      return IconButton(
                        onPressed: () => context.read<DrawerCubit>().toggleDrawer(),
                        icon: const Icon(Icons.menu),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: BlocBuilder<WalletCubit, WalletState>(
                builder: (context, state) {
                  if (state is WalletLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is WalletError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error: ${state.message}'),
                          ElevatedButton(
                            onPressed: () => context.read<WalletCubit>().loadWalletData(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else if (state is WalletLoaded) {
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          // Balance Cards
                          Row(
                            children: [
                              Expanded(
                                child: WalletCard(
                                  title: AppStrings.currentBalanceTitle.tr,
                                  amount: state.wallet.currentBalance,
                                  currency: state.wallet.currency,
                                  icon: Icons.account_balance_wallet_outlined,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: WalletCard(
                                  title: AppStrings.rewardsEarnedTitle.tr,
                                  amount: state.wallet.rewardsEarned,
                                  currency: state.wallet.currency,
                                  icon: Icons.stars_outlined,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Main Wallet Balance
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Text(
                                  AppStrings.walletBalanceTitle.tr,
                                  style: GoogleFonts.openSans(
                                    fontSize: 16,
                                    color: const Color(0xFF252525),
                                  ),
                                ),
                                const SizedBox(height: 25),
                                PriceRow(
                                  currencySize: 22,
                                  alignment: MainAxisAlignment.center,
                                  price: state.wallet.currentBalance.toStringAsFixed(2),
                                  style: GoogleFonts.openSans(
                                    fontSize: 36,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${AppStrings.lastUpdatedPrefix.tr} ${_formatDateTime(state.wallet.lastUpdated)}',
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: const Color(0xFF4A5565),
                                  ),
                                ),
                                const SizedBox(height: 35),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const AddFundsScreen(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                          child: Text(
                                            AppStrings.addFunds.tr,
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: SizedBox(
                                        height: 48,
                                        child: OutlinedButton(
                                          onPressed: () {
                                            // Navigate to history
                                          },
                                          style: OutlinedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            side: const BorderSide(color: Colors.black, width: .5),
                                          ),
                                          child: Text(
                                            AppStrings.history.tr,
                                            style: GoogleFonts.openSans(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}, ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
  }
}
