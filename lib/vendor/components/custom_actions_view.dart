import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomIconContainer extends StatelessWidget {
  // Fixed height for the container

  const CustomIconContainer({
    super.key,
    required this.text,
    this.prefixIcon,
    this.borderRadius,
    this.suffixIcon,
    required this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.padding,
    this.fixedHeight = 40, // Default fixed height
  });
  final String text;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback onTap; // To handle container clicks
  final Color? backgroundColor; // Optional background color
  final Color? borderColor; // Optional border color
  final double? borderWidth; // Optional border width
  final double? padding; // Optional padding for the container
  final double? borderRadius; // Optional border radius for the container
  final double fixedHeight;

  @override
  Widget build(BuildContext context) {
    final bool isBackgroundColored = backgroundColor != null;

    return GestureDetector(
      onTap: onTap, // Making the container clickable
      child: Container(
        margin: const EdgeInsets.all(4),
        height: fixedHeight,
        // Set fixed height
        padding: EdgeInsets.symmetric(vertical: padding ?? 8, horizontal: 10),
        decoration: BoxDecoration(
          color: backgroundColor ??
              VendorColors.vendorAppBackground, // Default background color
          borderRadius:
              BorderRadius.circular(borderRadius ?? 2), // Border radius
          border: Border.all(
            color: (borderColor ?? Colors.transparent)
                .withOpacity(0.5), // Border color (transparent if not provided)
            width: borderWidth ?? 1.0, // Default border width
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // Takes only the width of the content
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content horizontally
          children: [
            if (prefixIcon != null)
              Icon(
                prefixIcon,
                // color: Theme.of(context).colorScheme.onPrimary ,
                color: isBackgroundColored
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary,
                size: 16,
              ), // Prefix Icon
            const SizedBox(width: 4),
            Text(
              text,
              softWrap: true,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              // Handle overflow with ellipsis
              textAlign: TextAlign.center,
              // Center align text
              style: GoogleFonts.inter(
                fontSize: 12,
                color: isBackgroundColored
                    ? Colors.white
                    : Theme.of(context).colorScheme.onPrimary.withAlpha(400),
                // color: Colors.black.withAlpha(400),
              ),
            ),
            const SizedBox(width: 4),
            if (suffixIcon != null)
              Icon(suffixIcon,
                  color: isBackgroundColored
                      ? Colors.white
                      : Theme.of(context).colorScheme.onPrimary,
                  size: 16,), // Suffix Icon
          ],
        ),
      ),
    );
  }
}
