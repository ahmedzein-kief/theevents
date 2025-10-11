import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/price_row.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/payment_buttons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentFooter extends StatelessWidget {
  const PaymentFooter({
    super.key,
    required this.provider,
    required this.paymentMethod,
    required this.isDark,
    required this.isNewAddress,
    required this.trackedStartCheckout,
    required this.onNext,
  });

  final CheckoutProvider provider;
  final Map<String, String> paymentMethod;
  final bool isDark;
  final bool isNewAddress;
  final String? trackedStartCheckout;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final orderAmount = provider.checkoutData?.data?.formattedPrices.orderAmount ?? '0.00';
    final grandTotal = double.tryParse(orderAmount.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.grandTotal.tr,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              PriceRow(
                price: grandTotal.toStringAsFixed(1),
                currencySize: 16,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PaymentButtons(
            provider: provider,
            paymentMethod: paymentMethod,
            isDarkMode: isDark,
            isNewAddress: isNewAddress,
            trackedStartCheckout: trackedStartCheckout,
            onNext: onNext,
          ),
        ],
      ),
    );
  }
}
