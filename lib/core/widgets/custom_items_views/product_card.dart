import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/views/auth_screens/auth_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/shared_preferences_helper.dart';
import '../../styles/app_colors.dart';
import '../../styles/custom_text_styles.dart';
import 'custom_toast.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.storeName,
    required this.off,
    required this.price,
    required this.frontSalePriceWithTaxes,
    required this.priceWithTaxes,
    required this.reviewsCount,
    required this.isHeartObscure,
    required this.onHeartTap,
    required this.itemsId,
    this.optionalIcon, // Default to null
    required this.onOptionalIconTap, // Default to null
    required this.isOutOfStock, // Default to null
  });
  final String? imageUrl;
  final String? name;
  final String? storeName;
  final String? price;
  final String off;
  final String? priceWithTaxes;
  final String? frontSalePriceWithTaxes;
  final int? reviewsCount;
  final bool isHeartObscure;
  final int itemsId;
  final VoidCallback onHeartTap;
  final IconData? optionalIcon;
  final VoidCallback onOptionalIconTap;
  final bool isOutOfStock;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
  }

  ///   ----------------------- FUNCTION TO CHECK THE USER IS LOGIN INTO THE APP OR NOT -------------------------
  // Future<bool> _isLoggedIn() async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //
  //   print(
  //       'token prefs ===> ${prefs.getString(SecurePreferencesUtil.tokenKey)}');
  //
  //   return prefs.getString(SecurePreferencesUtil.tokenKey)?.isNotEmpty ?? false;
  // }

  Future<bool> _isLoggedIn() async =>
      (await SecurePreferencesUtil.getToken()) != null;

  Future<void> _onHeartTap() async {
    setState(() {
      _isTapped = !_isTapped;
    });
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      // Navigate to the login screen if not logged in
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: AuthScreen(),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );

      // Custom Flutter Toast using the reusable class
      final CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: 'Please Log-In to add items to Your WishList.',
        onDismiss: () {
          customToast
              .removeToast(); // Dismiss the toast when the button is tapped
        },
      );
      // Reset the tapped state if not logged in
      setState(() {
        _isTapped = !_isTapped;
      });
    } else {
      // Call the onHeartTap action provided by the widget
      setState(() {
        widget.onHeartTap();
      });
    }
  }

  Future<void> _onCartTap() async {
    if (widget.isOutOfStock) return;
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      // Navigate to the login screen if not logged in
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: AuthScreen(),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(CupertinoPageRoute(fullscreenDialog: true, builder: (context) => AuthScreen()));
      final CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: 'Please Log-In to add items to Your Cart.',
        onDismiss: () {
          customToast
              .removeToast(); // Dismiss the toast when the button is tapped
        },
      );
    } else {
      // Call the onHeartTap action provided by the widget
      widget.onOptionalIconTap.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Stack(
                    children: [
                      // Your image or background widget should be here
                      CachedNetworkImage(
                        imageUrl: widget.imageUrl ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                        height: MediaQuery.sizeOf(context).height * 0.28,
                        errorListener: (object) {
                          Image.asset(
                            'assets/placeholder.png', // Replace with your actual image path
                            fit: BoxFit.cover, // Adjust fit if needed
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                          );
                        },
                        errorWidget: (context, _, error) => Image.asset(
                          'assets/placeholder.png', // Replace with your actual image path
                          fit: BoxFit.cover, // Adjust fit if needed
                          height: MediaQuery.sizeOf(context).height * 0.28,
                          width: double.infinity,
                        ),
                        placeholder: (BuildContext context, String url) =>
                            Container(
                          height: MediaQuery.sizeOf(context).height * 0.28,
                          width: double.infinity,
                          color: Colors.blueGrey[300], // Background color
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'assets/placeholder.png', // Replace with your actual image path
                                fit: BoxFit.cover, // Adjust fit if needed
                                height:
                                    MediaQuery.sizeOf(context).height * 0.28,
                                width: double.infinity,
                              ),
                              const CupertinoActivityIndicator(
                                radius: 16, // Adjust size of the loader
                                animating: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        right: 5, // To make the Row fill the width
                        bottom: 12, // Spacing from the bottom of the image
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 4, right: 8, top: 1, bottom: 1),
                              color: Colors.white,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      widget.reviewsCount?.toString() ?? '',
                                      maxLines: 1,
                                      style: ratings(context),
                                    ),
                                  ),
                                  const Icon(Icons.star,
                                      size: 13, color: Colors.yellow),
                                  Container(
                                    height: 20,
                                    width: 1,
                                    color: AppColors.semiTransparentBlack,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2),
                                    child: Text(
                                      widget.frontSalePriceWithTaxes.toString(),
                                      maxLines: 1,
                                      style: ratings(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Heart icon
                            GestureDetector(
                              onTap: _onHeartTap,
                              child: Icon(
                                Icons.favorite,
                                size: 25,
                                shadows: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                                color: widget.isHeartObscure
                                    ? Colors.red
                                    : Colors.white,
                                // color: heartColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.optionalIcon !=
                      null) // Conditionally display the optional icon
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: _onCartTap,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.grey, width: 1), // Add a border
                          ),
                          child: SvgPicture.asset(
                            height: 18,
                            width: 18,
                            widget.isOutOfStock
                                ? AppStrings.outOfStock
                                : AppStrings.itemAddToCart,
                            color: widget.isOutOfStock ? Colors.red : null,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 5, bottom: 4, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            widget.name ?? '',
                            maxLines: 1,
                            style: productsName(context),
                          ),
                        ),
                        if (widget.storeName != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              'By ${widget.storeName}',
                              maxLines: 1,
                              style: productsName(context),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.price != null
                                      ? 'AED${widget.price}'
                                      : '',
                                  maxLines: 1,
                                  style: priceStyle(context),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.priceWithTaxes != null
                                      ? ' ${widget.priceWithTaxes}'
                                      : '',
                                  maxLines: 1,
                                  style: standardPriceStyle(context),
                                ),
                              ),
                              Text(
                                widget.off,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: Colors.orange, fontSize: 8),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
