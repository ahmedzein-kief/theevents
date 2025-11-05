import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../provider/locale_provider.dart';
import '../custom_app_views/search_bar.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
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
    this.showSearchBar = false,
    this.searchController,
    this.searchHintText = 'Search Events',
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
  final bool showSearchBar;
  final TextEditingController? searchController;
  final String searchHintText;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final localeProvider = Provider.of<LocaleProvider>(context);
    final isRTL = localeProvider.isCurrentLocaleRTL;

    return SafeArea(
      child: Container(
        color: widget.backgroundColor,
        child: AppBar(
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: widget.title.isNotEmpty && !widget.showSearchBar ? Text(widget.title) : null,
          centerTitle: widget.title.isNotEmpty && !widget.showSearchBar,
          flexibleSpace: Container(
            color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
            child: SafeArea(
              child: Directionality(
                textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Back button / Left content (only show when search is not enabled)
                    if (!widget.showSearchBar)
                      Container(
                        color: Colors.transparent,
                        height: screenHeight,
                        child: GestureDetector(
                          onTap: widget.onBackIconPressed,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: isRTL ? 0 : screenWidth * 0.02,
                              right: isRTL ? screenWidth * 0.02 : 0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (widget.customBackIcon != null) widget.customBackIcon!,
                                if (widget.leftText != null)
                                  Text(
                                    widget.leftText!,
                                    style: widget.leftTextStyle,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Search bar (when enabled) - using the flexible CustomSearchBar
                    if (widget.showSearchBar)
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
                          child: CustomSearchBar(
                            controller: widget.searchController,
                            hintText: widget.searchHintText,
                            isCompact: true,
                            height: 40,
                            borderRadius: 20,
                            fontSize: 13,
                            iconSize: 18,
                            horizontalPadding: 12,
                            showSuggestions: false,
                            // Disable suggestions in compact mode
                            autofocus: false, // Add this to prevent auto-focus
                          ),
                        ),
                      ),

                    // Right icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (widget.firstRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.03,
                              left: isRTL ? screenWidth * 0.03 : 0,
                            ),
                            child: GestureDetector(
                              onTap: widget.onFirstRightIconPressed,
                              child: SvgPicture.asset(
                                widget.firstRightIconPath!,
                                colorFilter: ColorFilter.mode(
                                  widget.iconsColor ?? Theme.of(context).colorScheme.onPrimary,
                                  BlendMode.srcIn,
                                ),
                                height: screenHeight * 0.030,
                                width: screenWidth * 0.30,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        if (widget.secondRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.03,
                              left: isRTL ? screenWidth * 0.03 : 0,
                            ),
                            child: GestureDetector(
                              onTap: widget.onSecondRightIconPressed,
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
                                  widget.wishlistItemCount >= 10 ? '9+' : widget.wishlistItemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                                showBadge: widget.wishlistItemCount > 0,
                                child: SvgPicture.asset(
                                  widget.secondRightIconPath!,
                                  colorFilter: ColorFilter.mode(
                                    widget.iconsColor ?? Theme.of(context).colorScheme.onPrimary,
                                    BlendMode.srcIn,
                                  ),
                                  height: screenHeight * 0.030,
                                  width: screenWidth * 0.030,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        if (widget.thirdRightIconPath != null)
                          Padding(
                            padding: EdgeInsets.only(
                              right: isRTL ? 0 : screenWidth * 0.03,
                              left: isRTL ? screenWidth * 0.03 : 0,
                            ),
                            child: GestureDetector(
                              onTap: widget.onThirdRightIconPressed,
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
                                  widget.cartItemCount >= 10 ? '9+' : widget.cartItemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7,
                                  ),
                                ),
                                showBadge: widget.cartItemCount > 0,
                                child: SvgPicture.asset(
                                  widget.thirdRightIconPath!,
                                  colorFilter: ColorFilter.mode(
                                    widget.iconsColor ?? Theme.of(context).colorScheme.onPrimary,
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
}
