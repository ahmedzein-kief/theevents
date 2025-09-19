import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_strings.dart';
import '../../logic/history/history_cubit.dart';
import '../../logic/history/history_state.dart';
import '../widgets/history/filter_row.dart';
import '../widgets/history/search_bar_field.dart';
import '../widgets/history/transaction_item.dart';
import '../widgets/shared/wallet_current_rewards_cards.dart';
import '../widgets/shared/wallet_header.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistoryCubit(),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

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
    final cubit = context.read<HistoryCubit>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            WalletHeader(isDark: isDark),
            const WalletCurrentRewardsCards(
              currentBalance: 1500,
              rewards: 75,
              currency: 'AED',
            ),
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
                        onChanged: cubit.updateSearch,
                      ),
                      const SizedBox(height: 16),

                      // Filters
                      BlocBuilder<HistoryCubit, HistoryState>(
                        builder: (context, state) {
                          return FilterRow(
                            selectedType: state.selectedType,
                            selectedMethod: state.selectedMethod,
                            selectedPeriod: state.selectedPeriod,
                            onTypeChanged: cubit.updateType,
                            onMethodChanged: cubit.updateMethod,
                            onPeriodChanged: cubit.updatePeriod,
                            onReset: cubit.resetFilters,
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Transactions
                      Expanded(
                        child: BlocBuilder<HistoryCubit, HistoryState>(
                          builder: (context, state) {
                            return ListView.builder(
                              itemCount: state.filteredTransactions.length,
                              itemBuilder: (_, i) => TransactionItem(
                                transaction: state.filteredTransactions[i],
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
        ),
      ),
    );
  }
}
