// amount_input_section.dart
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/deposit/deposit_cubit.dart';
import 'amount_text_field.dart';
import 'quick_amount_buttons.dart';

class AmountInputSection extends StatelessWidget {
  final TextEditingController controller;
  final List<double> quickAmounts;
  final double currentAmount;

  const AmountInputSection({
    super.key,
    required this.controller,
    required this.quickAmounts,
    required this.currentAmount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.amountAed.tr,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        AmountTextField(controller: controller),
        const SizedBox(height: 16),
        QuickAmountButtons(
          amounts: quickAmounts,
          currentAmount: currentAmount,
          onAmountSelected: (amount) {
            controller.text = amount.toString();
            context.read<DepositCubit>().updateAmount(amount);
          },
        ),
      ],
    );
  }
}
