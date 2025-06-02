import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/storage/shared_preferences_helper.dart';
import '../../../views/auth_screens/auth_page_view.dart';
import '../../styles/custom_text_styles.dart';
import 'custom_toast.dart';

class CustomPackagesView extends StatefulWidget {
  final double containerHeight;
  final List<Color> containerColors; // List of colors for the gradient
  final int colorIndex; // Index for selecting colors
  final String imageUrl;
  final String? productName;
  final String? price;
  final VoidCallback? addInCart;
  final VoidCallback onHeartTap;
  final bool isHeartObscure;

  const CustomPackagesView({
    Key? key,
    this.containerHeight = 130,
    required this.containerColors,
    required this.colorIndex,
    this.productName,
    this.price,
    this.addInCart,
    required this.onHeartTap,
    required this.isHeartObscure,
    required this.imageUrl,
  }) : super(key: key);

  @override
  State<CustomPackagesView> createState() => _CustomPackagesViewState();
}

class _CustomPackagesViewState extends State<CustomPackagesView> {
  int rating = 0;
  bool _isTapped = false;

  ///   ----------------------- FUNCTION TO CHECK THE USER IS LOGIN INTO THE APP OR NOT -------------------------
  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(SecurePreferencesUtil.isLoggedInKey) ?? false;
  }

  void _onCartTap() async {
    bool loggedIn = await _isLoggedIn();
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
      CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: "Please Log-In to add items to Your Cart.",
        onDismiss: () {
          customToast.removeToast(); // Dismiss the toast when the button is tapped
        },
      );
    } else {
      // Call the onHeartTap action provided by the widget
      widget.addInCart?.call();
    }
  }

  void _onHeartTap() async {
    setState(() {
      _isTapped = !_isTapped;
    });
    bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      // Navigate to the login screen if not logged in
      // Navigator.of(context).push(CupertinoPageRoute(
      //   fullscreenDialog: true,
      //   builder: (context) => AuthScreen(),
      // ));

      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: AuthScreen(),
        withNavBar: false,
        // OPTIONAL VALUE. True by default.
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );

      // Custom Flutter Toast using the reusable class
      CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: "Please Log-In to add items to Your WishList.",
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
  Widget build(BuildContext context) {
    return Column(
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
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl,
                height: 200,
                placeholder: (BuildContext context, String url) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height * 0.28,
                    width: double.infinity,
                    color: Colors.blueGrey[300], // Background color
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'assets/placeholder.png', // Replace with your actual image path
                          fit: BoxFit.cover, // Adjust fit if needed
                          height: MediaQuery.sizeOf(context).height * 0.28,
                          width: double.infinity,
                        ),
                        const CupertinoActivityIndicator(
                          radius: 16, // Adjust size of the loader
                          animating: true,
                        ),
                      ],
                    ),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 5,
              left: -0,
              right: -0,
              child: Container(
                // color: Colors.red,
                margin: EdgeInsets.only(bottom: 1, left: 2, right: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(widget.productName.toString(), style: packagesProduct()),
                    Text(widget.price.toString(), style: packagesProduct()),
                    GestureDetector(
                      onTap: _onCartTap,
                      child: Container(
                        padding: EdgeInsets.only(left: 2, right: 2),
                        color: Colors.black,
                        height: 30,
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Add To Cart',
                            maxLines: 1,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              rating = index + 1;
                            });
                          },
                          child: Icon(Icons.star, size: 12, color: Colors.white),
                        );
                      }),
                    ),
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
        SizedBox(height: 20), // Add spacing for aesthetic purposes
      ],
    );
  }
}
