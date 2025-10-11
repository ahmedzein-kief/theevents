import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/fund_expiry_model.dart';

class FundExpiryBadge extends StatelessWidget {
  final FundExpiryModel fund;

  const FundExpiryBadge({super.key, required this.fund});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getBadgeColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getBadgeText(),
        style: GoogleFonts.openSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: _getTextColor(),
        ),
      ),
    );
  }

  Color _getBadgeColor() {
    switch (fund.fundStatus) {
      // Use fundStatus getter
      case FundStatus.expired:
        return Colors.red.withAlpha((0.3 * 255).toInt());
      case FundStatus.expiringSoon:
        return Colors.orange.withAlpha((0.2 * 255).toInt());
      case FundStatus.active:
        return Colors.green.withAlpha((0.2 * 255).toInt());
    }
  }

  Color _getTextColor() {
    switch (fund.fundStatus) {
      // Use fundStatus getter
      case FundStatus.expired:
        return Colors.red[700]!;
      case FundStatus.expiringSoon:
        return Colors.orange[700]!;
      case FundStatus.active:
        return Colors.green[700]!;
    }
  }

  String _getBadgeText() {
    if (fund.fundStatus == FundStatus.expired) {
      return 'Expired';
    }

    final daysLeft = fund.expiresAt.difference(DateTime.now()).inDays; // Use expiresAt

    if (fund.fundStatus == FundStatus.active) {
      return '${daysLeft}d left';
    }

    return '${daysLeft}d left';
  }
}
