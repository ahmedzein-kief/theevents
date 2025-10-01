import 'package:event_app/core/helper/extensions/aed_double_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletCard extends StatelessWidget {
  final String title;
  final double amount;
  final String currency;
  final IconData icon;
  final Color? backgroundColor;

  const WalletCard({
    super.key,
    required this.title,
    required this.amount,
    required this.currency,
    required this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        // Add subtle border in dark mode for better definition
        border: isDark && backgroundColor == null ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color:
                theme.iconTheme.color?.withAlpha((0.7 * 255).toInt()) ?? (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    color: theme.textTheme.bodyMedium?.color?.withAlpha((0.8 * 255).toInt()),
                  ),
                ),
                const SizedBox(height: 8),

                amount.toAEDAmount(
                  currencySize: 11,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: theme.textTheme.headlineSmall?.color,
                  ),
                )
                // PriceRow(
                //   price: amount.toStringAsFixed(2),
                //   currencySize: 12,
                //   style: GoogleFonts.openSans(
                //     fontSize: 18,
                //     color: theme.textTheme.headlineSmall?.color,
                //     fontWeight: FontWeight.w600,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
