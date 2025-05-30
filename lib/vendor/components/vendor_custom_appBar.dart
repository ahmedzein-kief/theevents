import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VendorCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? leftIconPath;
  final String? firstRightIconPath;
  final String? secondRightIconPath;
  final String? thirdRightIconPath;
  final Widget? leftWidget;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onBackIconPressed;
  final Color? backgroundColor;
  final double appBarHeight;
  final String? leftText;
  final Widget? customBackIcon;

  const VendorCustomAppBar({
    this.customBackIcon,
    this.leftIconPath,
    this.firstRightIconPath,
    this.secondRightIconPath,
    this.thirdRightIconPath,
    this.onLeftIconPressed,
    this.backgroundColor,
    this.leftWidget,
    this.onBackIconPressed,
    this.appBarHeight = kToolbarHeight,
    this.leftText,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary, // Set the background color for AppBar
          flexibleSpace: Container(
            color: backgroundColor ?? Theme.of(context).colorScheme.primary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: onBackIconPressed ?? onLeftIconPressed, // Handle left icon or back button
                    child: Padding(
                      padding: EdgeInsets.only(top: screenWidth * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (customBackIcon != null) customBackIcon!, // Custom back icon
                          if (leftIconPath != null)
                            SvgPicture.asset(
                              leftIconPath!,
                              fit: BoxFit.cover,
                            ),
                          SizedBox(width: screenWidth * 0.02, height: screenHeight * 0.02),
                          if (leftWidget != null) leftWidget!,
                          if (leftText != null) Text(leftText!)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
