import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/loading_indicator.dart';
import '../../logic/history/history_cubit.dart';
import '../../logic/history/history_state.dart';
import '../../logic/wallet/wallet_cubit.dart';
import '../../logic/wallet/wallet_state.dart';
import '../widgets/history/filter_row.dart';
import '../widgets/history/search_bar_field.dart';
import '../widgets/history/transaction_item.dart';
import '../widgets/shared/wallet_current_rewards_cards.dart';
import '../widgets/shared/wallet_header.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    context.read<HistoryCubit>().loadTransactions();
    super.initState();
  }

  void _exportTransactions(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export functionality will be implemented'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final historyCubit = context.read<HistoryCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: BlocBuilder<WalletCubit, WalletState>(
          builder: (context, walletState) {
            final expiryCount = walletState is WalletLoaded ? walletState.wallet.expiringLotsCount : 0;

            return Column(
              children: [
                WalletHeader(isDark: isDark, expiryCount: expiryCount),
                const WalletCurrentRewardsCards(),
                Expanded(
                  child: Container(
                    color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            children: [
                              Icon(Icons.history, size: 24, color: theme.iconTheme.color),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  AppStrings.history.tr,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: theme.textTheme.titleLarge?.color,
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: () => _exportTransactions(context),
                                icon: Icon(Icons.download_outlined, size: 18, color: theme.iconTheme.color),
                                label: Text(
                                  AppStrings.export.tr,
                                  style: GoogleFonts.openSans(
                                    fontSize: 12,
                                    color: theme.textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Search
                          SearchBarField(
                            controller: TextEditingController(),
                            onChanged: historyCubit.updateSearch,
                          ),
                          const SizedBox(height: 16),

                          // Filters
                          BlocBuilder<HistoryCubit, HistoryState>(
                            builder: (context, historyState) {
                              return FilterRow(
                                selectedType: historyState.selectedType,
                                selectedMethod: historyState.selectedMethod,
                                selectedPeriod: historyState.selectedPeriod,
                                onTypeChanged: historyCubit.updateType,
                                onMethodChanged: historyCubit.updateMethod,
                                onPeriodChanged: historyCubit.updatePeriod,
                                onReset: historyCubit.resetFilters,
                              );
                            },
                          ),
                          const SizedBox(height: 24),

                          // Transactions
                          Expanded(
                            child: BlocBuilder<HistoryCubit, HistoryState>(
                              builder: (context, historyState) {
                                if (historyState.isLoading) {
                                  return const LoadingIndicator();
                                }

                                if (historyState.errorMessage != null) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                                        const SizedBox(height: 16),
                                        Text(
                                          historyState.errorMessage!,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(color: Colors.red),
                                        ),
                                        const SizedBox(height: 16),
                                        ElevatedButton(
                                          onPressed: () => historyCubit.loadTransactions(),
                                          child: const Text('Retry'),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                if (historyState.filteredTransactions.isEmpty) {
                                  return const Center(
                                    child: Text('No transactions found'),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: historyState.filteredTransactions.length,
                                  itemBuilder: (_, i) => TransactionItem(
                                    transaction: historyState.filteredTransactions[i],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
