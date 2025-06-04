import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    this.customBackIcon,
    this.leftIconPath,
    this.firstRightIconPath,
    this.secondRightIconPath,
    this.thirdRightIconPath,
    this.onLeftIconPressed,
    this.backgroundColor,
    this.leftWidget,
    this.onFirstRightIconPressed,
    this.onSecondRightIconPressed,
    this.onBackIconPressed,
    this.onThirdRightIconPressed,
    this.appBarHeight = kToolbarHeight,
    this.leftText,
    this.cartItemCount = 0,
    this.wishlistItemCount = 0,
    this.title = '',
  });
  final String? leftIconPath;
  final String? firstRightIconPath;
  final String? secondRightIconPath;
  final String? thirdRightIconPath;
  final Widget? leftWidget;
  final VoidCallback? onLeftIconPressed;
  final VoidCallback? onFirstRightIconPressed;
  final VoidCallback? onSecondRightIconPressed;
  final VoidCallback? onThirdRightIconPressed;
  final VoidCallback? onBackIconPressed;
  final Color? backgroundColor;
  final double appBarHeight;
  final String? leftText;
  final Widget? customBackIcon;
  final int cartItemCount;
  final int wishlistItemCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: AppBar(
          // leading: leftWidget,
          automaticallyImplyLeading: false,
          title: Text(title),
          centerTitle: title.isNotEmpty,
          // backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary, // Set the background color for AppBar
          flexibleSpace: Container(
            color: backgroundColor ?? Theme.of(context).colorScheme.primary,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    height: screenHeight,
                    child: GestureDetector(
                      onTap: onBackIconPressed,
                      child: Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (customBackIcon != null) customBackIcon!,
                            if (leftText != null) Text(leftText!)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (firstRightIconPath != null)
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.05),
                          child: GestureDetector(
                            onTap: onFirstRightIconPressed,
                            child: SvgPicture.asset(firstRightIconPath!,
                                height: screenHeight * 0.030,
                                width: screenWidth * 0.30,
                                fit: BoxFit.fill),
                          ),
                        ),
                      if (secondRightIconPath != null)
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.04),
                          child: GestureDetector(
                            onTap: onSecondRightIconPressed,
                            child: badges.Badge(
                              position: badges.BadgePosition.topEnd(
                                  top: -10, end: -10),
                              badgeStyle: const badges.BadgeStyle(
                                  badgeColor: Colors.red,
                                  elevation: 4,
                                  shape: BadgeShape.circle,
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.2)),
                              badgeContent: Text(
                                wishlistItemCount >= 10
                                    ? '9+'
                                    : wishlistItemCount.toString(),
                                // Show the cart count here
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 7),
                              ),
                              showBadge: wishlistItemCount > 0,
                              child: SvgPicture.asset(
                                secondRightIconPath!,
                                height: screenHeight * 0.030,
                                width: screenWidth * 0.030,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      if (thirdRightIconPath != null)
                        Padding(
                          padding: EdgeInsets.only(right: screenWidth * 0.04),
                          child: GestureDetector(
                            onTap: onThirdRightIconPressed,
                            child: badges.Badge(
                              position: badges.BadgePosition.topEnd(
                                  top: -10, end: -4),
                              badgeStyle: const badges.BadgeStyle(
                                  shape: BadgeShape.circle,
                                  badgeColor: Colors.green,
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 0.2)),
                              badgeContent: Text(
                                cartItemCount >= 10
                                    ? '9+'
                                    : cartItemCount
                                        .toString(), // Show the cart count here
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 7),
                              ),
                              showBadge: cartItemCount > 0,
                              // Show only if count is greater than 0
                              child: SvgPicture.asset(
                                thirdRightIconPath!,
                                height: screenHeight * 0.030,
                                width: screenWidth * 0.030,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                    ],
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
