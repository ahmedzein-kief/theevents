import 'package:flutter/material.dart';

import '../../vendor/components/status_constants/order_return_constants.dart';
import '../../vendor/components/status_constants/order_status_constants.dart';
import '../../vendor/components/status_constants/payment_status_constants.dart';
import '../../vendor/components/status_constants/product_packages_constants.dart';
import '../../vendor/components/status_constants/shipment_status_constants.dart';
import '../../vendor/components/status_constants/withdrawal_status_constants.dart';

class AppColors {
  static List<Color> staticColorsSlider = [
    Colors.red.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.green.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.pink.withOpacity(0.5),
    Colors.orange.withOpacity(0.5),
    Colors.purple.withOpacity(0.5),
    Colors.brown.withOpacity(0.5),
    Colors.teal.withOpacity(0.5),
    Colors.cyan.withOpacity(0.5),
    Colors.amber.withOpacity(0.5),
  ];

  static const Color lightCoral = Color(0xFFF3A195);
  static const Color orange = Color(0xFFFDD9BE);
  static const Color vividRed = Color(0xFFFF0040);
  static const Color semiTransparentBlack = Color(0x80000000);
  static const Color peachyPink = Color(0xFFF3A095);
  static const Color lightBackground = Color(0xFFF4EEEE);
  static const Color freshItemsBack = Color(0xFFE3BEAB);
  static const Color darkGray = Color(0xFF171717);
  static const Color darkAshBrown = Color(0xFF312F2E);
  static const Color softBlueGrey = Color(0xFFCCD5E4);
  static const Color itemContainerBack = Color(0xFFF1F9FE);
  static const Color totalItemsText = Color(0xFF868181);
  static const Color lightPink = Color(0xFFF4EEEE);
  static const Color lightPinkGray = Color(0xFFF4EEEE);
  static const Color productBackground = Color(0xFFF2EEDF);
  static const Color sizeGuide = Color(0xFFF2EEDF);
  static const Color myRed = Color(0xFFDC3545);
  static const Color lightPinkBeige = Color(0xFFF4EEEE);
  static const Color paleSkyBlue = Color(0xFFF3F8FE);
  static const Color forestGreen = Color(0xFF248D3B);
  static const Color infoBackGround = Color(0xFFF4EEEE);
  static const Color deleteAccount = Color(0xCCFF0000);
  static const Color searchBackground = Color(0xFFECE6F0);
  static const Color darkGrey = Color(0xFF2C2C2C);
  static const Color mainHead = Color(0xFF2C2C2C); // The first two characters '1B' represent the alpha channel (transparency)
  static const Color packagesBackground = Color(0xFFE77D6F); // The first two characters '1B' represent the alpha channel (transparency)
  static const Color packagesBackgroundS = Color(0xFFB18966); // The first two characters '1B' represent the alpha channel (transparency)
  static const Color packagesBackgroundL = Color(0xFFB18966); // The first two characters '1B' represent the alpha channel (transparency)

  static const Color bgColor = Color(0xfff7f8fb);
  static const Color stoneGray = Color(0xff999999);
  static const Color mistyGray = Color(0xFF7D7D7D);
  static const Color lavenderHaze = Color(0xffECE6F0);
  static const Color charcoalPurple = Color(0xFF49454F);
  static const Color slateGrayBlue = Color(0xFF5B5E63);
  static const Color pumpkinOrange = Color(0xFFF76707);
  static const Color success = Color(0xFf34C759);
  static const Color cornflowerBlue = Color(0xFF5F99E1);
  static const Color neutralGray = Color(0xff5b5e63);

  // static const Color charcoalGray = Color(0xFF5B5E63);
  static const Color charcoalGray = Color(0xFF1b1f26);
  static const Color royalIndigo = Color(0xFF2711ac);
  static const Color deepForestGreen = Color(0xFF016620);

  static Color getShipmentStatusColor(String? status) {
    const statusColors = {
      ShipmentStatusConst.NOT_APPROVED: Colors.grey, // Neutral for unapproved orders
      ShipmentStatusConst.APPROVED: Colors.green, // Green for approved status
      ShipmentStatusConst.PENDING: Colors.amber, // Yellow for pending status
      ShipmentStatusConst.ARRANGE_SHIPMENT: Colors.blue, // Blue to indicate action required
      ShipmentStatusConst.READY_TO_BE_SHIPPED_OUT: Colors.orangeAccent, // Orange to indicate urgency
      ShipmentStatusConst.PICKING: Colors.deepPurpleAccent, // Purple for warehouse-related actions
      ShipmentStatusConst.DELAY_PICKING: Colors.red, // Red for delayed processes
      ShipmentStatusConst.PICKED: Colors.teal, // Teal to signify successful picking
      ShipmentStatusConst.NOT_PICKED: Colors.redAccent, // Red for failure or issue
      ShipmentStatusConst.DELIVERING: Colors.blueAccent, // Blue to indicate in-transit
      ShipmentStatusConst.DELIVERED: AppColors.success, // Light green for successful delivery
      ShipmentStatusConst.NOT_DELIVERED: Colors.red, // Red for unsuccessful delivery
      ShipmentStatusConst.AUDITED: Colors.indigo, // Indigo for reviewed/audited status
      ShipmentStatusConst.CANCELED: Colors.black,
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }

  static Color getPaymentStatusColor(String? status) {
    const statusColors = {
      PaymentStatusConst.PENDING: AppColors.pumpkinOrange,
      PaymentStatusConst.COMPLETED: AppColors.success,
      PaymentStatusConst.REFUNDING: Colors.amber, // Amber for pending refund status
      PaymentStatusConst.REFUNDED: AppColors.success, // Green for successfully refunded status
      PaymentStatusConst.FRAUD: Colors.red, // Red to indicate fraud
      PaymentStatusConst.FAILED: Colors.red, // Red to indicate failure
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }

  static Color getOrderStatusColor(String? status) {
    const statusColors = {
      OrderStatusConst.PENDING: Colors.amber, // Amber for pending status
      OrderStatusConst.PROCESSING: Colors.blue, // Blue for processing orders
      OrderStatusConst.COMPLETED: AppColors.success, // Green for completed orders
      OrderStatusConst.CANCELLED: Colors.red, // Red for cancelled orders
      OrderStatusConst.PARTIAL_RETURNED: AppColors.pumpkinOrange, // Orange for partial returns
      OrderStatusConst.RETURNED: Colors.teal, // Teal for fully returned orders
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }

  static Color getOrderReturnStatusColor(String? status) {
    const statusColors = {
      OrderReturnStatusConst.PENDING: AppColors.pumpkinOrange,
      OrderReturnStatusConst.PROCESSING: Colors.blue,
      OrderReturnStatusConst.COMPLETED: AppColors.success,
      OrderReturnStatusConst.CANCELLED: Colors.red,
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }

  static Color getProductPackageStatusColor(String? status) {
    const statusColors = {
      ProductPackagesConst.PUBLISHED: AppColors.success,
      ProductPackagesConst.PENDING: AppColors.pumpkinOrange,
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }

  static Color getWithdrawalStatusColor(String? status) {
    const statusColors = {
      WithdrawalStatusConstants.PENDING: AppColors.pumpkinOrange,
      WithdrawalStatusConstants.PROCESSING: Colors.blue,
      WithdrawalStatusConstants.COMPLETED: AppColors.success,
      WithdrawalStatusConstants.CANCELED: AppColors.neutralGray,  // Neutral gray for canceled transactions
      WithdrawalStatusConstants.REFUSED: Colors.red,    // Red to indicate refusal/rejection
    };
    return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
  }


}
