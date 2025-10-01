import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WalletInfoCard extends StatelessWidget {
  const WalletInfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.isDark,
  });

  final String title;
  final String value;
  final IconData icon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withAlpha((0.3 * 255).toInt()) : Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: isDark ? Border.all(color: Colors.grey[800]!, width: 1) : null,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color:
                theme.iconTheme.color?.withAlpha((0.7 * 255).toInt()) ?? (isDark ? Colors.grey[400] : Colors.grey[600]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                    fontSize: 11,
                    color: theme.textTheme.bodyMedium?.color?.withAlpha((0.8 * 255).toInt()),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: GoogleFonts.openSans(
                    fontSize: 16,
                    color: theme.textTheme.headlineSmall?.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
