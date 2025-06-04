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
  });
  final String title;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isChecked;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTap: isLoading
          ? null
          : isChecked
              ? onPressed
              : null,
      child: IntrinsicWidth(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
          alignment: Alignment.center,
          height: 45,
          // Fixed height for the button
          constraints: BoxConstraints(minWidth: screenWidth * 0.4),
          // Set a minimum width for the button
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.darkGray, AppColors.darkAshBrown],
            ),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Keep width as per content
            children: [
              if (isLoading)
                SizedBox(
                  width: 20, // Size of the loader
                  height: 20,
                  child: LoadingAnimationWidget.stretchedDots(
                    color: Theme.of(context).colorScheme.primary,
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
                    style: addToCartText(context),
                  ),
                ),
              if (icon != null && !isLoading) ...[
                const SizedBox(width: 8), // Space between text and icon
                Icon(
                  icon,
                  color: Colors.white,
                  size: 18, // Adjust icon size as needed
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
