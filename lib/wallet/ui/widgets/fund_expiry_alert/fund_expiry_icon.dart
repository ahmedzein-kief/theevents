import 'package:flutter/material.dart';

import '../../../data/model/fund_expiry_model.dart';

class FundExpiryIcon extends StatelessWidget {
  final FundExpiryModel fund;

  const FundExpiryIcon({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _getIconBackgroundColor(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getIcon(),
        color: _getIconColor(),
        size: 20,
      ),
    );
  }

  IconData _getIcon() {
    if (fund.fundStatus == FundStatus.expired) {
      return Icons.error_outline;
    }

    switch (fund.type) {
      case FundType.wallet:
        return Icons.account_balance_wallet;
      case FundType.giftCard:
        return Icons.card_giftcard;
      case FundType.other:
        return Icons.payment;
    }
  }

  Color _getIconBackgroundColor() {
    switch (fund.fundStatus) {
      // Use fundStatus getter
      case FundStatus.expired:
        return Colors.red.withAlpha((0.2 * 255).toInt());
      case FundStatus.expiringSoon:
        return Colors.orange.withAlpha((0.2 * 255).toInt());
      case FundStatus.active:
        return Colors.green.withAlpha((0.2 * 255).toInt());
    }
  }

  Color _getIconColor() {
    switch (fund.fundStatus) {
      // Use fundStatus getter
      case FundStatus.expired:
        return Colors.red;
      case FundStatus.expiringSoon:
        return Colors.orange;
      case FundStatus.active:
        return Colors.green;
    }
  }
}
