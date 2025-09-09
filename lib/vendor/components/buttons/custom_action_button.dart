import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:flutter/material.dart';

class CustomActionButton extends StatelessWidget {
  const CustomActionButton({
    super.key,
    required this.isLoading,
    required this.name,
    this.onPressed,
    this.textStyle,
  });

  final bool isLoading;
  final VoidCallback? onPressed;
  final String name;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isLoading ? null : onPressed,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              AppUtils.pageLoadingIndicator(context: context)
            else
              Text(
                name,
                style: textStyle ??
                    const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.black, // Default color
                    ),
              ),
            kSmallSpace,
          ],
        ),
      );
}
