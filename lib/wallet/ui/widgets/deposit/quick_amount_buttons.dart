// quick_amount_buttons.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';

class QuickAmountButtons extends StatelessWidget {
  final List<double> amounts;
  final double currentAmount;
  final ValueChanged<double> onAmountSelected;

  const QuickAmountButtons({
    super.key,
    required this.amounts,
    required this.currentAmount,
    required this.onAmountSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: amounts.map((amount) {
        final isSelected = currentAmount == amount;
        return GestureDetector(
          onTap: () => onAmountSelected(amount),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? (isDark ? theme.textTheme.bodySmall?.color?.withOpacity(0.6) : Colors.black)
                  : (isDark ? Colors.grey[800] : Colors.grey[200]),
              borderRadius: BorderRadius.circular(3),
              border: isDark && !isSelected ? Border.all(color: Colors.grey[700]!) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  AppAssets.dirham,
                  width: 10,
                  height: 10,
                  colorFilter: ColorFilter.mode(
                    isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white : Colors.black),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 3),
                Text(
                  '${amount.toInt()}',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: isSelected ? (isDark ? Colors.black : Colors.white) : (isDark ? Colors.white : Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
