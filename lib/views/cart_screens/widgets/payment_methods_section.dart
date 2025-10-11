import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/section_card.dart';
import 'package:event_app/views/cart_screens/widgets/section_title.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/gift_card/payments_methods.dart';
import 'package:flutter/material.dart';

class PaymentMethodsSection extends StatelessWidget {
  const PaymentMethodsSection({
    super.key,
    required this.provider,
    required this.isDark,
    required this.onMethodChanged,
  });

  final CheckoutProvider provider;
  final bool isDark;
  final ValueChanged<Map<String, String>> onMethodChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: AppStrings.choosePaymentMethod.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          PaymentMethods(
            amount: provider.checkoutData?.data?.formattedPrices.subTotal,
            onSelectionChanged: onMethodChanged,
          ),
        ],
      ),
    );
  }
}
