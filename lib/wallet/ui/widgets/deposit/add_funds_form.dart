import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/loading_indicator.dart';
import '../../../data/model/deposit_method.dart';
import '../../../logic/deposit/deposit_cubit.dart';
import '../../../logic/deposit/deposit_state.dart';
import 'amount_input_section.dart';
import 'continue_button.dart';
import 'coupon_code_field.dart';
import 'deposit_methods_list.dart';

class AddFundsForm extends StatelessWidget {
  final DepositState state;
  final TextEditingController amountController;
  final TextEditingController couponController;
  final List<double> quickAmounts;

  const AddFundsForm({
    super.key,
    required this.state,
    required this.amountController,
    required this.couponController,
    required this.quickAmounts,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (state.isLoading) {
      return const LoadingIndicator();
    }

    return Container(
      color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F5),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const FormTitle(),
              const SizedBox(height: 24),

              // Show error message if exists
              if (state.hasError) ...[
                _buildErrorMessage(context, theme),
                const SizedBox(height: 16),
              ],

              // Show form content if methods are loaded
              if (state.methods.isNotEmpty) ...[
                DepositMethodsList(
                  methods: state.methods,
                  selectedMethod: state.selectedMethod,
                ),
                if (state.selectedMethod == DepositMethodType.giftCard) ...[
                  const SizedBox(height: 24),
                  CouponCodeField(controller: couponController),
                ],
                if (state.selectedMethod == DepositMethodType.creditCard) ...[
                  const SizedBox(height: 24),
                  AmountInputSection(
                    controller: amountController..text = state.amount.toString(),
                    quickAmounts: quickAmounts,
                    currentAmount: state.amount,
                  ),
                ],
                const SizedBox(height: 32),
                ContinueButton(isProcessing: state.isProcessing),
              ] else if (state.hasError) ...[
                // Show retry button if no methods loaded due to error
                _buildRetryButton(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              state.errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 14,
              ),
            ),
          ),
          IconButton(
            onPressed: () => context.read<DepositCubit>().clearError(),
            icon: Icon(
              Icons.close,
              color: theme.colorScheme.error,
              size: 18,
            ),
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => context.read<DepositCubit>().loadDepositMethods(),
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
      ),
    );
  }
}

class FormTitle extends StatelessWidget {
  const FormTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet,
          size: 24,
          color: theme.iconTheme.color,
        ),
        const SizedBox(width: 12),
        Text(
          AppStrings.addFundsToWallet.tr,
          style: GoogleFonts.openSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ],
    );
  }
}
