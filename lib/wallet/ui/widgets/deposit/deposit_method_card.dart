import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/model/deposit_method.dart';

class DepositMethodCard extends StatelessWidget {
  final DepositMethod method;
  final bool isSelected;
  final VoidCallback onTap;

  const DepositMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected ? (isDark ? Colors.white : Colors.black) : (isDark ? Colors.grey[600]! : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(5),
          color: theme.cardColor,
        ),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? (isDark ? Colors.white : Colors.black) : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? (isDark ? Colors.white : Colors.black)
                      : (isDark ? Colors.grey[500]! : Colors.grey[400]!),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 15),
            Icon(
              method.type == DepositMethodType.giftCard ? Icons.card_giftcard : Icons.credit_card,
              size: 30,
              color: theme.iconTheme.color?.withAlpha((0.7 * 255).toInt()) ??
                  (isDark ? Colors.grey[400] : Colors.grey[600]),
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
                          color: theme.textTheme.titleMedium?.color,
                        ),
                      ),
                      if (method.isInstant) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[700] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            AppStrings.instant.tr,
                            style: GoogleFonts.openSans(
                              fontSize: 10,
                              color: theme.textTheme.bodySmall?.color,
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
                      color: theme.textTheme.bodyMedium?.color?.withAlpha((0.8 * 255).toInt()),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    method.processingInfo,
                    style: GoogleFonts.openSans(
                      fontSize: 10,
                      color: theme.textTheme.bodySmall?.color?.withAlpha((0.7 * 255).toInt()),
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
