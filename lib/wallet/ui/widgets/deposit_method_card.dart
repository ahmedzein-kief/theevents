import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/constants/app_strings.dart';

import '../../data/model/deposit_method.dart';

class DepositMethodCard extends StatelessWidget {
  final DepositMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const DepositMethodCard({
    Key? key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.black : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.grey[400]!,
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              method.type == DepositMethodType.giftCard ? Icons.card_giftcard : Icons.credit_card,
              size: 30,
              color: Colors.grey[600],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        method.title,
                        style: GoogleFonts.openSans(
                          fontSize: 14,
                          color: const Color(0xFF101828),
                        ),
                      ),
                      if (method.isInstant) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppStrings.instant.tr,
                            style: GoogleFonts.openSans(
                              fontSize: 10,
                              color: const Color(0xFF4A5565),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method.subtitle,
                    style: GoogleFonts.openSans(
                      fontSize: 12,
                      color: const Color(0xFF4A5565),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.processingInfo,
                    style: GoogleFonts.openSans(
                      fontSize: 10,
                      color: const Color(0xFF4A5565),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
