import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../provider/locale_provider.dart';

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
    this.iconsColor,
    this.leftTextStyle,
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
  final Color? iconsColor;
  final TextStyle? leftTextStyle;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isRTL = localeProvider.isCurrentLocaleRTL;

    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: AppBar(
          automaticallyImplyLeading: false,
          title: Text(title),
          centerTitle: title.isNotEmpty,
          flexibleSpace: Container(
            color: backgroundColor ?? Theme.of(context).colorScheme.primary,
            child: Center(
              child: Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button / Left content
                    Container(
                      color: Colors.transparent,
                      height: screenHeight,
                      child: GestureDetector(
                        onTap: onBackIconPressed,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: isRTL ? 0 : screenWidth * 0.02,
                            right: isRTL ? screenWidth * 0.02 : 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (customBackIcon != null) customBackIcon!,
                              if (leftText != null)
                                Text(
                                  leftText!,
                                  style: leftTextStyle,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Right icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (firstRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.05,
                              left: isRTL ? screenWidth * 0.05 : 0,
                            ),
                            child: GestureDetector(
                              onTap: onFirstRightIconPressed,
                              child: SvgPicture.asset(
                                firstRightIconPath!,
                                colorFilter: ColorFilter.mode(
                                  iconsColor ?? Theme.of(context).colorScheme.onPrimary,
                                  BlendMode.srcIn,
                                ),
                                height: screenHeight * 0.030,
                                width: screenWidth * 0.30,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        if (secondRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.04,
                              left: isRTL ? screenWidth * 0.04 : 0,
                            ),
                            child: GestureDetector(
                              onTap: onSecondRightIconPressed,
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(
                                  top: -10,
                                  end: isRTL ? -10 : -10,
                                ),
                                badgeStyle: const badges.BadgeStyle(
                                  badgeColor: Colors.red,
                                  elevation: 4,
                                  shape: BadgeShape.circle,
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),
                                badgeContent: Text(
                                  wishlistItemCount >= 10 ? '9+' : wishlistItemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                                showBadge: wishlistItemCount > 0,
                                child: SvgPicture.asset(
                                  secondRightIconPath!,
                                  colorFilter: ColorFilter.mode(
                                    iconsColor ?? Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                  height: screenHeight * 0.030,
                                  width: screenWidth * 0.030,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        if (thirdRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.04,
                              left: isRTL ? screenWidth * 0.04 : 0,
                            ),
                            child: GestureDetector(
                              onTap: onThirdRightIconPressed,
                              child: badges.Badge(
                                position: badges.BadgePosition.topEnd(
                                  top: -10,
                                  end: isRTL ? -4 : -4,
                                ),
                                badgeStyle: const badges.BadgeStyle(
                                  shape: BadgeShape.circle,
                                  badgeColor: Colors.green,
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 0.2,
                                  ),
                                ),
                                badgeContent: Text(
                                  cartItemCount >= 10 ? '9+' : cartItemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                                showBadge: cartItemCount > 0,
                                child: SvgPicture.asset(
                                  thirdRightIconPath!,
                                  colorFilter: ColorFilter.mode(
                                    iconsColor ?? Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
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
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}
