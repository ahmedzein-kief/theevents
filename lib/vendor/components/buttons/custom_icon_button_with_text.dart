import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';

class CustomIconButtonWithText extends StatelessWidget {
  const CustomIconButtonWithText({
    super.key,
    required this.text,
    required this.icon,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
    this.borderColor = Colors.grey, // Default border color
    this.iconSize = 12.0, // Default icon size
    this.fontSize = 14.0, // Default text font size
    this.borderRadius,
    this.color,
    this.textColor,
    this.visualDensity,
    this.isLoading = false,
  });

  final String text;
  final Widget icon;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final Color borderColor;
  final Color? color;
  final Color? textColor;
  final double iconSize;
  final double fontSize;
  final double? borderRadius;
  final VisualDensity? visualDensity;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onPressed,
        elevation: 0,
        visualDensity: visualDensity ?? VisualDensity.standard,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        color: color ?? Theme.of(context).colorScheme.surface,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
          side: BorderSide(
            color: isLoading ? Theme.of(context).colorScheme.primary : borderColor,
          ),
        ),
        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: AppUtils.pageLoadingIndicator(
                  context: context,
                  color: textColor ?? Theme.of(context).colorScheme.primary,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  icon,
                  const SizedBox(width: 4),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: textColor ?? Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ],
              ),
      );
}
