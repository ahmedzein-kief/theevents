import 'package:event_app/views/cart_screens/cart_items_screen.dart';
import 'package:event_app/views/profile_page_screens/privacy_policy_screen.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_profile_views/custom_profile_text.dart';
import '../../provider/auth_provider/user_auth_provider.dart';
import '../../vendor/components/vendor_stepper_screen.dart';
import '../auth_screens/auth_page_view.dart';
import '../profile_page_screens/about_us_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLight = false;
  String? userName;
  bool _isLoggedIn = false;

  Future<void> _checkLoginStatus() async {
    final preferences = await SharedPreferences.getInstance();
    final bool loginStatus = preferences.getBool('isLoggedInKey') ?? false;
    setState(() {
      _isLoggedIn = loginStatus;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      _checkLoginStatus(); // Call the method to check login status
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    height: 70,
                    child: Text(
                      AppStrings.profile,
                      maxLines: 1,
                      style: profileItems(context),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      /// navigate to authentication screen
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => AuthScreen(),
                          fullscreenDialog: true,
                        ),
                      );
                    },
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/Logout-1.svg',
                                  height: 45,
                                  width: 45,
                                ),
                                // Text('Signup / Login',
                                Text(
                                  AppStrings.loginSignUp,
                                  style: withoutLoginTextStyle(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.06),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          CustomProfileText(
                                            title: AppStrings.cart,
                                            imagePath:
                                                AppStrings.thirdRightIconPath,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const CartItemsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/notification.svg',
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onPrimary,
                                                ),
                                                const SizedBox(width: 20),
                                                Text(
                                                  'Notification',
                                                  style: profileItems(
                                                    context,
                                                  ),
                                                ),
                                                const Spacer(),
                                                SizedBox(
                                                  height: 27,
                                                  child: CupertinoSwitch(
                                                    value: _isLight,
                                                    onChanged: (bool value) {
                                                      setState(() {
                                                        _isLight = value;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 10,
                                            ),
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const VendorStepperScreen(),
                                                  ),
                                                );
                                                // Navigator.pushNamed(context, AppRoutes.vendorLogin);
                                              },
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/Join_seller.svg',
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onPrimary,
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    AppStrings.joinAsSeller,
                                                    style: profileItems(
                                                      context,
                                                    ),
                                                  ),

                                                  // Icon(iconData, color: iconColor, size: iconSize,),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            // color: AppColors.infoBackGround,
                            color: Colors.blue.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    children: [
                                      Column(
                                        children: [
                                          CustomProfileText(
                                            title: AppStrings.switchLanguage,
                                            imagePath: 'assets/Language.svg',
                                            // iconData: Icons.arrow_forward_ios_rounded,
                                            onTap: () {},
                                          ),
                                          CustomProfileText(
                                            title: AppStrings.privacyPolicy,
                                            imagePath: 'assets/Privacy.svg',
                                            // iconData: Icons.arrow_forward_ios_rounded,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const PrivacyPolicyScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          CustomProfileText(
                                            title: AppStrings.aboutUs,
                                            imagePath: 'assets/Info.svg',
                                            // iconData: Icons.arrow_forward_ios_rounded,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const AboutUsScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                          CustomProfileText(
                                            title: 'Terms & Condition',
                                            imagePath: 'assets/termsandcon.svg',
                                            // iconData: Icons.arrow_forward_ios_rounded,
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const TermsAndCondtionScreen(),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
