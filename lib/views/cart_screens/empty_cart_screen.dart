import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/widgets/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../wish_list_screens/like_items_screen.dart';

class EmptyCartScreen extends StatefulWidget {
  const EmptyCartScreen({super.key});

  @override
  State<EmptyCartScreen> createState() => _EmptyCartScreenState();
}

class _EmptyCartScreenState extends State<EmptyCartScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/emptyCart.png'),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Text('Cart Is Empty \n Start adding to your cart ',
                        style: cartTextStyle(context),
                        softWrap: true,
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppCustomButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const WishListScreen()));
                          },
                          title: 'Go To Wishlist',
                        ),
                        GestureDetector(
                          onTap: () async {
                            final bool isLoggedIn =
                                await SecurePreferencesUtil.isLoggedIn();
                            if (isLoggedIn) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BaseHomeScreen()));
                            }
                            // PersistentNavBarNavigator.pushNewScreen(
                            //   context,
                            //   screen: AuthScreen(),
                            //   withNavBar: false,
                            //    pageTransitionAnimation: PageTransitionAnimation.fade,
                            // );
                          },
                          child: Container(
                            height: 50,
                            padding: const EdgeInsets.all(5),
                            color: AppColors.lightCoral,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Continue Shopping',
                                    softWrap: true,
                                    maxLines: 1,
                                    style: addToCartText(context)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
