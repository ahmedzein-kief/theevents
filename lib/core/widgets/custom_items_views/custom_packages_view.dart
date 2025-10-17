import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../views/auth_screens/auth_page_view.dart';
import '../../services/shared_preferences_helper.dart';
import '../../styles/custom_text_styles.dart';
import '../padded_network_banner.dart';
import 'custom_toast.dart';

class CustomPackagesView extends StatefulWidget {
  const CustomPackagesView({
    super.key,
    this.containerHeight = 130,
    required this.containerColors,
    required this.colorIndex,
    this.productName,
    this.price,
    this.addInCart,
    required this.onHeartTap,
    required this.isHeartObscure,
    required this.imageUrl,
  });

  final double containerHeight;
  final List<Color> containerColors; // List of colors for the gradient
  final int colorIndex; // Index for selecting colors
  final String imageUrl;
  final String? productName;
  final String? price;
  final VoidCallback? addInCart;
  final VoidCallback onHeartTap;
  final bool isHeartObscure;

  @override
  State<CustomPackagesView> createState() => _CustomPackagesViewState();
}

class _CustomPackagesViewState extends State<CustomPackagesView> {
  int rating = 0;
  bool _isTapped = false;

  ///   ----------------------- FUNCTION TO CHECK THE USER IS LOGIN INTO THE APP OR NOT -------------------------
  Future<bool> _isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SecurePreferencesUtil.isLoggedInKey) ?? false;
  }

  Future<void> _onCartTap() async {
    final bool loggedIn = await _isLoggedIn();
    if (!mounted) return;
    if (!loggedIn) {
      // Navigate to the login screen if not logged in
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const AuthScreen(),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      // Navigator.of(context).push(CupertinoPageRoute(fullscreenDialog: true, builder: (context) => AuthScreen()));
      final CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: AppStrings.pleaseLogInToCart.tr,
        onDismiss: () {
          customToast.removeToast(); // Dismiss the toast when the button is tapped
        },
      );
    } else {
      // Call the onHeartTap action provided by the widget
      widget.addInCart?.call();
    }
  }

  Future<void> _onHeartTap() async {
    setState(() {
      _isTapped = !_isTapped;
    });
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      // Navigate to the login screen if not logged in
      // Navigator.of(context).push(CupertinoPageRoute(
      //   fullscreenDialog: true,
      //   builder: (context) => AuthScreen(),
      // ));
      if (!mounted) return;
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: const AuthScreen(),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );

      // Custom Flutter Toast using the reusable class
      final CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: AppStrings.pleaseLogInToWishList.tr,
        onDismiss: () {
          customToast.removeToast(); // Dismiss the toast when the button is tapped
        },
      );
      // Reset the tapped state if not logged in
      setState(() {
        _isTapped = !_isTapped;
      });
    } else {
      // Call the onHeartTap action provided by the widget
      setState(() {
        widget.onHeartTap.call();
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Stack(
            children: [
              Container(
                height: widget.containerHeight,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: LinearGradient(
                    colors: [
                      widget.containerColors[widget.colorIndex],
                      widget.containerColors[(widget.colorIndex + 1) % widget.containerColors.length],
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                bottom: 5,
                child: PaddedNetworkBanner(
                  imageUrl: widget.imageUrl,
                  height: 200,
                  fit: BoxFit.cover,
                  padding: EdgeInsets.zero,
                ),
              ),
              Positioned(
                bottom: 5,
                left: -0,
                right: -0,
                child: Container(
                  // color: Colors.red,
                  margin: const EdgeInsets.only(bottom: 1, left: 2, right: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.productName.toString(),
                        style: packagesProduct(),
                      ),
                      Text(widget.price.toString(), style: packagesProduct()),
                      GestureDetector(
                        onTap: _onCartTap,
                        child: Container(
                          padding: const EdgeInsets.only(left: 2, right: 2),
                          color: Colors.black,
                          height: 30,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.addToCart.tr,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                rating = index + 1;
                              });
                            },
                            child: const Icon(
                              Icons.star,
                              size: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _onHeartTap,
                        child: Icon(
                          Icons.favorite,
                          size: 25,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.5 * 255).toInt()),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          color: widget.isHeartObscure ? Colors.red : Colors.white,
                          // color: heartColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20), // Add spacing for aesthetic purposes
        ],
      );
}
