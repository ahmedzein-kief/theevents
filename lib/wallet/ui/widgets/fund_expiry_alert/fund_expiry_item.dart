import 'package:event_app/core/widgets/price_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/fund_expiry_model.dart';

class FundExpiryItem extends StatelessWidget {
  final FundExpiryModel fund;

  const FundExpiryItem({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(theme),
        borderRadius: BorderRadius.circular(8),
        border: fund.fundStatus == FundStatus.expired ? Border.all(color: const Color(0xFFFFD6D6)) : null,
      ),
      child: Row(
        children: [
          _buildIcon(theme),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PriceRow(
                      price: fund.amount.toStringAsFixed(2),
                      currencySize: 14,
                      style: GoogleFonts.openSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: fund.fundStatus == FundStatus.expired
                            ? Colors.grey[400]
                            : theme.textTheme.titleMedium?.color,
                      ),
                    ),
                    _buildStatusBadge(theme),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _getExpiryText(),
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    color: fund.fundStatus == FundStatus.expired ? Colors.grey[400] : theme.textTheme.bodyMedium?.color,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _getRechargedText(),
                  style: GoogleFonts.openSans(
                    fontSize: 12,
                    color: fund.fundStatus == FundStatus.expired
                        ? Colors.grey[300]
                        : isDark
                            ? Colors.grey[400]
                            : Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(theme) {
    final isDark = theme.brightness == Brightness.dark;
    final iconColor = fund.fundStatus == FundStatus.expired
        ? Colors.grey[400]
        : isDark
            ? Colors.grey[100]
            : const Color(0xFF2D3748);

    if (fund.type == FundType.giftCard) {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : iconColor?.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.card_giftcard_outlined,
          size: 16,
          color: iconColor,
        ),
      );
    } else {
      return Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: iconColor?.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          Icons.credit_card_outlined,
          size: 16,
          color: iconColor,
        ),
      );
    }
  }

  Widget _buildStatusBadge(theme) {
    final isDark = theme.brightness == Brightness.dark;
    if (fund.fundStatus == FundStatus.expired) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE6E6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'Expired',
          style: GoogleFonts.openSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFFE53E3E),
          ),
        ),
      );
    } else {
      // Calculate days left
      final daysLeft = fund.expiryDate.difference(DateTime.now()).inDays;
      return Text(
        '${daysLeft}d left',
        style: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.grey[400] : Colors.grey[600],
        ),
      );
    }
  }

  Color _getBackgroundColor(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    if (fund.fundStatus == FundStatus.expired) {
      return isDark ? theme.cardColor : const Color(0xFFFFF5F5); // Light pink background for expired items
    }
    return isDark ? theme.cardColor : const Color(0xFFF5F5F5); // White background for active items
  }

  String _getExpiryText() {
    if (fund.fundStatus == FundStatus.expired) {
      return 'Expired on ${_formatDate(fund.expiryDate)}';
    }
    return 'Expires on ${_formatDate(fund.expiryDate)}';
  }

  String _getRechargedText() {
    return 'Recharged ${_formatDate(fund.rechargedDate)}';
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
