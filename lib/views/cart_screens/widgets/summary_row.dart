import 'package:event_app/core/widgets/price_row.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SummaryRow extends StatelessWidget {
  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.isDark,
    this.isTotal = false,
    this.isDiscount = false,
    this.isCouponCode = false,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool isTotal;
  final bool isDiscount;
  final bool isCouponCode;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.white : Colors.black;
    const discountColor = Colors.green;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: textColor,
            ),
          ),
          if (isCouponCode)
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: discountColor,
              ),
            )
          else
            PriceRow(
              price: value,
              currencyColor: isDiscount ? discountColor : textColor,
              currencySize: 12,
              style: GoogleFonts.inter(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: isDiscount ? discountColor : textColor,
              ),
            ),
        ],
      ),
    );
  }
}
