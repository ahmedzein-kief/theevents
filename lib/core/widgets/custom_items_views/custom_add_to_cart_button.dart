import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../styles/app_colors.dart';
import '../../styles/custom_text_styles.dart';

class AppCustomButton extends StatelessWidget {
  const AppCustomButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isChecked = true,
    this.icon,
    this.darkModeColor, // Optional custom color for dark mode
  });

  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isChecked;
  final Color? darkModeColor; // Custom color for dark mode

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: isLoading || !isChecked ? null : onPressed,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          alignment: Alignment.center,
          height: 45,
          constraints: BoxConstraints(minWidth: screenWidth * 0.4),
          decoration: BoxDecoration(
            color: isDark ? darkModeColor ?? AppColors.lightCoral : null,
            gradient: isDark
                ? null
                : const LinearGradient(
                    colors: [AppColors.darkGray, AppColors.darkAshBrown],
                  ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: LoadingAnimationWidget.stretchedDots(
                    color: theme.colorScheme.primary,
                    size: 25,
                  ),
                )
              else
                Flexible(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    softWrap: true,
                    style: addToCartText(context).copyWith(
                      color: isDark ? Colors.white : Colors.white, // Changed text color for dark mode
                    ),
                  ),
                ),
              if (icon != null && !isLoading) ...[
                const SizedBox(width: 8),
                Icon(
                  icon,
                  color: isDark ? Colors.white : Colors.white, // Changed icon color for dark mode
                  size: 18,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
