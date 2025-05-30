import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:event_app/views/auth_screens/auth_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../navigation/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';

class ShortcodeInformationIconsScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ShortcodeInformationIconsScreen({super.key, required this.data});

  @override
  State<ShortcodeInformationIconsScreen> createState() => _ShortcodeInformationIconsScreenState();
}

class _ShortcodeInformationIconsScreenState extends State<ShortcodeInformationIconsScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    List<Map<String, String>> items = [];

    widget.data['attributes'].forEach((key, value) {
      if (key.startsWith('title')) {
        String index = key.replaceAll('title', '');
        String title = value;
        String link = widget.data['attributes']['link$index'] ?? '';
        String icon = widget.data['attributes']['icon$index'] ?? '';

        items.add({
          'title': title,
          'link': link,
          'icon': 'https://api.staging.theevents.ae/storage/$icon',
        });
      }
    });

    return Container(
      // margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.infoBackGround,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * (145 / MediaQuery.of(context).size.width),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                String icon = items[index]['icon']!;
                bool isLocalAsset = !icon.startsWith('http');
                return GestureDetector(
                  onTap: () async {
                    String routeName;
                    switch (index) {
                      case 0:
                        bool isLoggedIn = await SharedPreferencesUtil.isLoggedIn();
                        if (!isLoggedIn) {
                          // PersistentNavBarNavigator.pushNewScreen(
                          //   context,
                          //   screen: AuthScreen(),
                          //   withNavBar: false,
                          //   // OPTIONAL VALUE. True by default.
                          //   pageTransitionAnimation: PageTransitionAnimation.fade,
                          // );
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => AuthScreen(), fullscreenDialog: true));
                          return; // Stop further execution to prevent navigation to OrderPage
                        }
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: OrderPageScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );

                        routeName = AppRoutes.orderPage;
                        break;
                      case 1:
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: NewProductPageScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );
                        routeName = AppRoutes.newProduct;
                        break;
                      case 2:
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: GiftCardScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );
                        routeName = AppRoutes.giftCard;
                        break;
                      case 3:
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: EventBrandScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );
                        routeName = AppRoutes.eventBrand;
                        break;
                      case 4:
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: BestSellerScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );
                        routeName = AppRoutes.bestSeller;
                        break;
                      case 5:
                        // PersistentNavBarNavigator.pushNewScreen(
                        //   context,
                        //   screen: DiscountScreen(),
                        //   withNavBar: true,
                        //   // OPTIONAL VALUE. True by default.
                        //   pageTransitionAnimation: PageTransitionAnimation.fade,
                        // );
                        routeName = AppRoutes.discountScreen;
                        break;
                      default:
                        routeName = '';
                    }
                    Navigator.pushNamed(context, routeName, arguments: {'title': items[index]['title']});
                  },
                  child: Padding(
                    // padding: const EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.only(bottom: screenHeight * 0.02, top: screenHeight * 0.02),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.2),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.network(
                              icon,
                              height: screenWidth * 0.1,
                              width: screenWidth * 0.1,
                              errorBuilder: (context,error,object){
                                return Image.asset('assets/placeholder.png', // Replace with your actual image path
                                  fit: BoxFit.cover, // Adjust fit if needed
                                  height: screenWidth * 0.1,
                                  width: screenWidth * 0.1,
                                );
                              },
                            ),
                          ),
                        ),
                        Text(items[index]['title']!, style: shotCodeInfoTextStyle(context), softWrap: true),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
