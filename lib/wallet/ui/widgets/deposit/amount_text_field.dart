// amount_text_field.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/deposit/deposit_cubit.dart';

class AmountTextField extends StatelessWidget {
  final TextEditingController controller;

  const AmountTextField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TextField(
      enabled: false,
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: theme.textTheme.bodySmall?.color?.withOpacity(0.6)),
      decoration: InputDecoration(
        hintText: 'AED 100.00',
        hintStyle: GoogleFonts.openSans(
          fontSize: 12,
          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
        ),
        filled: true,
        fillColor: isDark ? Colors.grey[800] : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
        ),
      ),
      onChanged: (value) {
        final amount = double.tryParse(value) ?? 0.0;
        context.read<DepositCubit>().updateAmount(amount);
      },
    );
  }
}
