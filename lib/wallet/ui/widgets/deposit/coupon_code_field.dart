// coupon_code_field.dart
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../logic/deposit/deposit_cubit.dart';

class CouponCodeField extends StatelessWidget {
  final TextEditingController controller;

  const CouponCodeField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.couponCodeGiftCard.tr,
          style: GoogleFonts.openSans(
            fontSize: 14,
            color: theme.textTheme.titleMedium?.color,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          style: TextStyle(color: theme.textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt())),
          decoration: InputDecoration(
            hintText: 'enterYourCouponCode'.tr,
            hintStyle: GoogleFonts.openSans(
              fontSize: 12,
              color: theme.textTheme.bodySmall?.color?.withAlpha((0.6 * 255).toInt()),
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
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: isDark ? Colors.white : Colors.black),
            ),
          ),
          onChanged: (value) => context.read<DepositCubit>().updateCouponCode(value),
        ),
      ],
    );
  }
}
