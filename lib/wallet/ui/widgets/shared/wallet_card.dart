import 'package:event_app/core/widgets/PriceRow.dart';
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
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        // Add subtle border in dark mode for better definition
        border: isDark && backgroundColor == null ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 24,
              color: theme.iconTheme.color?.withOpacity(0.7) ?? (isDark ? Colors.grey[400] : Colors.grey[600])),
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
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                PriceRow(
                  price: amount.toStringAsFixed(2),
                  currencySize: 12,
                  style: GoogleFonts.openSans(
                    fontSize: 18,
                    color: theme.textTheme.headlineSmall?.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
