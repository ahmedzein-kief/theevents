import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../Components/utils/utils.dart';

class CustomIconButtonWithText extends StatelessWidget {
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

  const CustomIconButtonWithText({
    Key? key,
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      elevation: 0,
      visualDensity: visualDensity ?? VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      color: color ?? Colors.transparent,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        side: BorderSide(color: isLoading ? AppColors.lightCoral : borderColor),
      ),
      child: isLoading
          ? SizedBox(height: 20, width: 20, child: Utils.pageLoadingIndicator(context: context,color:textColor))
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon,
                SizedBox(width: 4), // Adds spacing between icon and text
                Text(
                  text,
                  style: TextStyle(fontSize: fontSize, color: textColor),
                ),
              ],
            ),
    );
  }
}
