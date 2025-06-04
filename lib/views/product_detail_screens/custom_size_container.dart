import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';

class CustomSizeContainer extends StatelessWidget {
  const CustomSizeContainer({
    super.key,
    required this.title,
    required this.onTap,
    required this.selected,
    required this.isAvailable,
  });
  final String title;
  final void Function() onTap;
  final bool selected;
  final bool isAvailable;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Function to calculate text width
    double calculateTextWidth(String text) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      return textPainter.width;
    }

    // Calculate width based on text
    final textWidth = calculateTextWidth(title);
    final containerWidth = textWidth + 24; // Add padding around text

    return Opacity(
      opacity: isAvailable ? 1.0 : 0.5, // Reduce opacity if not available
      child: GestureDetector(
        onTap: isAvailable ? onTap : null, // Disable tap if not available
        child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Container(
            height: screenWidth * 0.1,
            width: containerWidth.clamp(screenWidth * 0.1, screenWidth * 0.3),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected ? const Color(0xff3C3C43) : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isAvailable
                    ? AppColors.peachyPink
                    : Colors.grey, // Change border color when unavailable
                width: 0.4,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: selected
                      ? Colors.white
                      : isAvailable
                          ? Colors.black
                          : Colors.grey, // Change text color when unavailable
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
