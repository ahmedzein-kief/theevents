import 'package:flutter/material.dart';

import '../../wallet/data/model/notification_model.dart';
import '../constants/app_assets.dart';

class NotificationStyleHelper {
  static String getIconAsset(NotificationType type) {
    switch (type) {
      case NotificationType.redeem:
        return AppAssets.success;
      case NotificationType.giftCardRedeem:
        return AppAssets.reward;
      case NotificationType.purchase:
        return AppAssets.info;
      case NotificationType.deposit:
        return AppAssets.success;
      case NotificationType.recharge:
        return AppAssets.success;
      case NotificationType.refundCredit:
        return AppAssets.success;
      case NotificationType.adminAdjustment:
        return AppAssets.info;
    }
  }

  static Color getColor(NotificationType type) {
    switch (type) {
      case NotificationType.redeem:
        return Colors.green;
      case NotificationType.giftCardRedeem:
        return Colors.pink;
      case NotificationType.purchase:
        return Colors.purple;
      case NotificationType.deposit:
        return Colors.green;
      case NotificationType.recharge:
        return Colors.blue;
      case NotificationType.refundCredit:
        return Colors.green;
      case NotificationType.adminAdjustment:
        return Colors.grey;
    }
  }
}
