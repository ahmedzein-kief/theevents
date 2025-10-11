import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/custom_items_views/coupon_text_field.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/section_card.dart';
import 'package:event_app/views/cart_screens/widgets/section_title.dart';
import 'package:flutter/material.dart';

import 'coupon_state.dart';

class CouponSection extends StatelessWidget {
  const CouponSection({
    super.key,
    required this.provider,
    required this.couponState,
    required this.isDark,
    required this.onCouponChanged,
    required this.onCouponAction,
    this.isLoading = false,
  });

  final CheckoutProvider provider;
  final CouponState couponState;
  final bool isDark;
  final ValueChanged<String> onCouponChanged;
  final Future<void> Function(String, bool) onCouponAction;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: AppStrings.couponCodeText.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          CustomTextFieldWithCoupon(
            enabled: !isLoading,
            labelText: AppStrings.couponLabel.tr,
            hintText: AppStrings.couponHint.tr,
            couponData: couponState.toMap(),
            onValueChange: isLoading ? (_) {} : onCouponChanged,
            onCouponApplyRemove: isLoading ? (_, __) {} : onCouponAction,
          ),
        ],
      ),
    );
  }
}
// GC-1TZDCKS4HGV5
