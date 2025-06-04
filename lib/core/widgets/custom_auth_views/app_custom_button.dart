import 'package:flutter/material.dart';

import '../../../vendor/components/utils/utils.dart';
import '../../styles/app_colors.dart';

class CustomAppButton extends StatefulWidget {
  CustomAppButton({
    super.key,
    required this.buttonText,
    required this.buttonColor,
    this.prefixIcon,
    this.suffixIcon,
    required this.onTap,
    this.borderRadius,
    this.mainAxisSize,
    this.padding,
    this.textStyle,
    this.borderColor,
    this.isLoading = false,
    this.height,
    this.prefixIconColor,
    this.suffixIconColor,
    this.loadingIndicatorColor,
  });
  final String buttonText;
  final Color buttonColor;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback onTap;
  double? borderRadius;
  MainAxisSize? mainAxisSize;
  EdgeInsetsGeometry? padding;
  TextStyle? textStyle;
  Color? borderColor;
  bool isLoading;
  double? height;
  Color? prefixIconColor;
  Color? suffixIconColor;
  Color? loadingIndicatorColor;

  @override
  State<CustomAppButton> createState() => _CustomAppButtonState();
}

class _CustomAppButtonState extends State<CustomAppButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTapDown: (_) {
        // When the user starts pressing the container
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        // When the user lifts the finger
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        // When the touch is cancelled (e.g. by dragging outside)
        setState(() {
          _isPressed = false;
        });
      },
      onTap: widget.isLoading ? () {} : widget.onTap,
      child: Container(
        height: widget.height,
        padding: widget.padding ??
            EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 10),
        decoration: BoxDecoration(
          color: _isPressed ? AppColors.stoneGray : widget.buttonColor,
          borderRadius: widget.borderRadius != null
              ? BorderRadius.circular(widget.borderRadius ?? 0)
              : null,
          border: Border.all(
              color: widget.isLoading
                  ? widget.loadingIndicatorColor ?? Colors.transparent
                  : widget.borderColor ?? Colors.transparent),
        ),
        child: Row(
          mainAxisSize: widget.mainAxisSize ?? MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.prefixIcon != null)
              Icon(widget.prefixIcon,
                  color: widget.prefixIconColor ?? Colors.white, size: 18),
            SizedBox(width: widget.prefixIcon != null ? 8.0 : 0),
            // Add spacing if prefixIcon is present
            if (widget.isLoading)
              Utils.pageLoadingIndicator(
                  context: context,
                  color: widget.loadingIndicatorColor ?? Colors.white)
            else
              Text(
                widget.buttonText,
                style: widget.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            SizedBox(width: widget.suffixIcon != null ? 8.0 : 0),
            // Add spacing if suffixIcon is present
            if (widget.suffixIcon != null)
              Icon(widget.suffixIcon,
                  color: widget.suffixIconColor ?? Colors.white, size: 18),
          ],
        ),
      ),
    );
  }
}
