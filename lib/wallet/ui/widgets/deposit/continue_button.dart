// continue_button.dart
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/helper/functions/functions.dart';
import '../../../data/model/deposit_method.dart';
import '../../../logic/deposit/deposit_cubit.dart';

class ContinueButton extends StatelessWidget {
  final bool isProcessing;
  final DepositMethodType? selectedMethod;

  const ContinueButton({
    super.key,
    required this.isProcessing,
    this.selectedMethod,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isProcessing
            ? null
            : () {
                if (selectedMethod == DepositMethodType.creditCard) {
                  final hasAddress = checkUserHasAddress(context);
                  if (!hasAddress) return;
                }

                context.read<DepositCubit>().processDeposit();
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark ? theme.textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt()) : Colors.black,
          foregroundColor: isDark ? Colors.black : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        child: isProcessing
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(isDark ? Colors.black : Colors.white),
                ),
              )
            : Text(
                AppStrings.continueToPayment.tr,
                style: GoogleFonts.openSans(
                  fontSize: 16,
                ),
              ),
      ),
    );
  }
}
