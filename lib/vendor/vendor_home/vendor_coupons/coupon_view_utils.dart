import 'package:flutter/material.dart';

/// Enum for couponType
enum CouponType { amount, percentage, shipping }

class CouponViewUtils {
  /// Label Text Style
  static TextStyle couponLabelTextStyle() => const TextStyle(
      color: Colors.black, fontSize: 14, fontWeight: FontWeight.w700);

  /// discount filed prefix and suffix
  static Widget discountFieldPrefixAndSuffix(
          {required CouponType couponType,
          required bool isPrefix,
          required screenWidth}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, vertical: 0),
            child: Text(
              isPrefix
                  ? getDiscountFieldPrefixText(couponType: couponType)
                  : getDiscountFieldSuffixText(couponType: couponType),
              style: discountPrefixStyle(),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );

  /// prefix text for discount field
  static String getDiscountFieldPrefixText({required CouponType couponType}) {
    switch (couponType) {
      case CouponType.amount:
        return 'Discount';
      case CouponType.percentage:
        return 'Discount';
      case CouponType.shipping:
        return 'When shipping is less than';
    }
  }

  /// suffix text for discount field
  static String getDiscountFieldSuffixText({required CouponType couponType}) {
    switch (couponType) {
      case CouponType.amount:
        return 'AED';
      case CouponType.percentage:
        return '%';
      case CouponType.shipping:
        return 'AED';
    }
  }

  /// discount field prefix text style
  static TextStyle discountPrefixStyle() => const TextStyle(
      color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w700);

  static List<DropdownMenuItem> couponTypeMenuItems() => [
        const DropdownMenuItem(
            value: CouponType.amount, child: Text('Amount - Fixed')),
        const DropdownMenuItem(
            value: CouponType.percentage, child: Text('Discount %')),
        const DropdownMenuItem(
            value: CouponType.shipping, child: Text('Free Shipping')),
      ];

  static String getTypeOption(CouponType couponType) {
    switch (couponType) {
      case CouponType.amount:
        return 'amount';
      case CouponType.shipping:
        return 'shipping';
      case CouponType.percentage:
        return 'percentage';
    }
  }

  static String generateCouponHelperText({
    required String typeOption,
    double? value,
  }) {
    switch (typeOption) {
      case 'shipping':
        return "Free shipping to all orders when shipping fee is less than or equal to AED${value?.toStringAsFixed(2) ?? '0.00'}";
      case 'amount':
        return "Discount AED${value?.toStringAsFixed(2) ?? '0.00'} for all orders";
      case 'percentage':
        return "Discount ${value?.toStringAsFixed(1) ?? '0'}% for all orders";
      default:
        return 'Invalid coupon type';
    }
  }
}
