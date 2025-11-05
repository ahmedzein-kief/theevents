import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/section_card.dart';
import 'package:event_app/views/cart_screens/widgets/section_title.dart';
import 'package:event_app/views/cart_screens/widgets/summary_row.dart';
import 'package:flutter/material.dart';

import 'coupon_state.dart';

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    super.key,
    required this.provider,
    required this.couponState,
    required this.isDark,
  });

  final CheckoutProvider provider;
  final CouponState couponState;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final prices = provider.checkoutData?.data?.formattedPrices;
    final couponDiscount = provider.checkoutData?.data?.couponDiscountAmount ?? 0;
    final promoDiscount = provider.checkoutData?.data?.promotionDiscountAmount ?? 0;
    final walletApplicable = provider.checkoutData?.data?.walletApplicable ?? 0;

    return SectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: AppStrings.orderSummary.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          SummaryRow(
            label: AppStrings.subtotalUpper.tr,
            value: prices?.subTotal ?? '0.00 AED',
            isDark: isDark,
          ),
          SummaryRow(
            label: AppStrings.taxVat.tr,
            value: prices?.tax ?? '0.00 AED',
            isDark: isDark,
          ),
          SummaryRow(
            label: AppStrings.shipping.tr,
            value: prices?.shippingAmount ?? '0.00 AED',
            isDark: isDark,
          ),
          if (couponState.hasValidCoupon) ...[
            SummaryRow(
              label: '${AppStrings.couponCodeText.tr}:',
              value: couponState.code,
              isDark: isDark,
              isCouponCode: true,
            ),
            if (couponDiscount > 0)
              SummaryRow(
                label: AppStrings.couponDiscount.tr,
                value: '-${prices?.couponDiscountAmount ?? '0.00 AED'}',
                isDark: isDark,
                isDiscount: true,
              ),
          ],
          if (promoDiscount > 0)
            SummaryRow(
              label: AppStrings.promotionDiscount.tr,
              value: '-${prices?.promotionDiscountAmount ?? '0.00 AED'}',
              isDark: isDark,
              isDiscount: true,
            ),
          if (walletApplicable > 0)
            SummaryRow(
              label: AppStrings.walletApplicable.tr,
              value: walletApplicable.toString(),
              isDark: isDark,
            ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(thickness: 1),
          ),
          SummaryRow(
            label: AppStrings.totalUpper.tr,
            value: prices?.orderAmount ?? '0.00 AED',
            isDark: isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}
