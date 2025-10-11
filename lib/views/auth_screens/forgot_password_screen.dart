import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/provider/auth_provider/user_auth_provider.dart';
import 'package:event_app/views/auth_screens/auth_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auth_views/custom_auth_button.dart';
import '../../core/widgets/custom_auth_views/custom_text_fields.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                right: screenWidth * 0.05,
                left: screenWidth * 0.05,
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(screenHeight * 0.003),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha((0.5 * 255).toInt()),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth * 0.05,
                          right: screenWidth * 0.05,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.04),
                              child: Text(
                                AppStrings.forgetPassword.tr,
                                textAlign: TextAlign.center,
                                style: textStyleLogoutTop(context),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.05),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomTextFields(
                                    hintStyle: recommandName(context),
                                    textEditingController: _emailController,
                                    inputType: TextInputType.emailAddress,
                                    leftIcon: Image.asset(
                                      'assets/emailicon.png',
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                    formFieldValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppStrings.emailRequired.tr;
                                      }
                                      return null;
                                    },
                                    hintText: AppStrings.emailAddress.tr,
                                  ),
                                  Consumer<AuthProvider>(
                                    builder: (context, provider, child) => Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.01,
                                        horizontal: screenWidth * 0.03,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // CustomAuthButton(
                                          //   title: 'Send',
                                          //   isLoading: provider.isLoading,
                                          //   onPressed: () {
                                          //     if (_formKey.currentState!.validate()) {
                                          //       provider.forgotPassword(_emailController.text).then((_) {
                                          //         if (provider.message != null) {
                                          //           if (provider.errors != null) {
                                          //            AppUtils.showToast( provider.errors!.values.first[0]);
                                          //           } else {
                                          //             CustomSnackbar.showSuccess(context, provider.message!);
                                          //           }
                                          //         }
                                          //       });
                                          //     }
                                          //   },
                                          // ),
                                          CustomAuthButton(
                                            title: AppStrings.send.tr,
                                            isLoading:
                                                provider.isLoading, // Show loading indicator when provider is loading
                                            onPressed: () {
                                              if (_formKey.currentState!.validate()) {
                                                // Call forgotPassword and handle success/error
                                                provider
                                                    .forgotPassword(
                                                  _emailController.text,
                                                  context,
                                                )
                                                    .then((_) {
                                                  // if (provider.message != null) {
                                                  //   if (provider.errors != null) {
                                                  //     // Display the first error message from errors map
                                                  //    AppUtils.showToast( provider.errors!.values.first[0]);
                                                  //   } else {
                                                  //     // Display success message
                                                  //     CustomSnackbar.showSuccess(context, provider.message!);
                                                  //   }
                                                  // }
                                                });
                                              }
                                            },
                                          ),

                                          GestureDetector(
                                            onTap: () {
                                              // Navigate to sign-up screen or any other action
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                top: screenHeight * 0.1,
                                                bottom: screenHeight * 0.02,
                                              ),
                                              child: GestureDetector(
                                                onTap: () {
                                                  PersistentNavBarNavigator.pushNewScreen(
                                                    context,
                                                    screen: const AuthScreen(
                                                      initialIndex: 1,
                                                    ),
                                                    withNavBar: false,
                                                    // OPTIONAL VALUE. True by default.
                                                    pageTransitionAnimation: PageTransitionAnimation.fade,
                                                  );
                                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()));
                                                },
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppStrings.doNotHaveAccountYet.tr,
                                                      style: textStyleLogoutNoAC(
                                                        context,
                                                      ),
                                                    ),
                                                    Text(
                                                      AppStrings.createOneNow.tr,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.w200,
                                                        color: AppColors.lightCoral,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
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
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Theme.of(context).colorScheme.onPrimary,
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
}
