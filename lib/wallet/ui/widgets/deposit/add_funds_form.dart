import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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

    if (state is DepositMethodsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is DepositError) {
      return _buildErrorState(context, theme);
    }

    if (state is! DepositMethodsLoaded) {
      return const SizedBox();
    }

    final loadedState = state as DepositMethodsLoaded;

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
              DepositMethodsList(
                methods: loadedState.methods,
                selectedMethod: loadedState.selectedMethod,
              ),
              if (loadedState.selectedMethod == DepositMethodType.giftCard) ...[
                const SizedBox(height: 24),
                CouponCodeField(controller: couponController),
              ],
              if (loadedState.selectedMethod == DepositMethodType.creditCard) ...[
                const SizedBox(height: 24),
                AmountInputSection(
                  controller: amountController,
                  quickAmounts: quickAmounts,
                  currentAmount: loadedState.amount,
                ),
              ],
              const SizedBox(height: 32),
              ContinueButton(isProcessing: state is DepositProcessing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error: ${(state as DepositError).message}',
            style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          ),
          ElevatedButton(
            onPressed: () => context.read<DepositCubit>().loadDepositMethods(),
            child: const Text('Retry'),
          ),
        ],
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
