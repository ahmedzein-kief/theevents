import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';

/// EARNING REVENUE CARD
class EarningsRevenueCard extends StatelessWidget {
  const EarningsRevenueCard({
    super.key,
    required this.title,
    required this.amount,
    required this.icon,
    required this.containerColor,
    required this.onTap,
  });
  final String title;
  final String amount;
  final IconData icon;
  final Color containerColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              // Make the main container expanded
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(
                    4), // Increased padding for better spacing
                child: Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 10), // Added spacing for clarity
                    Expanded(
                      // Wrap the Column in Expanded to use available space
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: vendorDashBoard(context)),
                          Text(amount, style: vendorDashBoardPrices(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
