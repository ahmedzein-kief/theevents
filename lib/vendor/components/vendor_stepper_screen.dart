import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/vendor_models/response_models/meta_data_response.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:event_app/vendor/components/vendor_custom_appbar.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_on_boarding_form/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/app_colors.dart';
import '../../provider/auth_provider/get_user_provider.dart';
import '../vendor_on_boarding_form/bank_detail_screen.dart';
import '../vendor_on_boarding_form/business_and_authorization_screen.dart';
import '../vendor_on_boarding_form/company_information_screen.dart';
import '../vendor_on_boarding_form/contract_agreement_screen.dart';
import '../vendor_on_boarding_form/login_info_screen.dart';
import '../vendor_on_boarding_form/payment_subscription_screen.dart';

class VendorStepperScreen extends StatefulWidget {
  const VendorStepperScreen({super.key});

  @override
  State<VendorStepperScreen> createState() => _VendorStepperScreenState();
}

class _VendorStepperScreenState extends State<VendorStepperScreen> {
  int activeStep = 0;
  bool isInitializing = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkLoginData();
    });
  }

  Future<MetaDataResponse?> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.getAllMetaData();
    return response;
  }

  Future<void> checkLoginData() async {
    setState(() => isInitializing = true);

    final token = await SecurePreferencesUtil.getToken();

    if (token == null || token.isEmpty) {
      if (!mounted) return;
      setState(() {
        activeStep = 0;
        isInitializing = false;
      });
      return;
    }

    if (!mounted) return;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    var user = userProvider.user;

    // If user is null, fetch user data
    if (user == null) {
      if (!mounted) return;
      final vendorProvider = Provider.of<VendorSignUpProvider>(context, listen: false);
      final userData = await vendorProvider.fetchUserData(context);

      if (userData != null) {
        userProvider.setUser(userData);
        user = userData;
      } else {
        if (!mounted) return;
        setState(() {
          activeStep = 0;
          isInitializing = false;
        });
        return;
      }
    }

    final isVerified = user.isVerified ?? false;
    final isApproved = user.isApproved ?? false;
    final userStep = user.step;

    // Determine the active step based on user status
    if (!isVerified && !isApproved) {
      // User needs email verification

      if (!mounted) return;
      setState(() {
        activeStep = 1;
        isInitializing = false;
      });
    } else if (isVerified && !isApproved) {
      // User is verified but not approved, continue with onboarding

      int determinedStep = 1;

      // Priority 1: Use step from user model
      if (userStep != null && userStep > 0) {
        determinedStep = userStep;
      } else {
        // Priority 2: Fetch from metadata
        final metaResponse = await getAllMetaData();
        if (metaResponse != null && metaResponse.data['step'] != null) {
          determinedStep = int.tryParse(metaResponse.data['step'].toString()) ?? 1;
        } else {
          log('No step found, defaulting to step 1', name: 'VENDOR');
        }
      }

      SecurePreferencesUtil.saveServerStep(determinedStep);

      if (!mounted) return;
      setState(() {
        activeStep = determinedStep;
        isInitializing = false;
      });
    } else if (isVerified && isApproved) {
      // User is both verified and approved

      // Navigate to final step or completion screen
      if (!mounted) return;
      setState(() {
        activeStep = 5;
        isInitializing = false;
      });
    } else {
      // Fallback

      if (!mounted) return;
      setState(() {
        activeStep = 0;
        isInitializing = false;
      });
    }
  }

  void moveToNextStep() {
    setState(() {
      activeStep += 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.joinUsSeller.tr,
          style: joinSeller(),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (activeStep == 0) {
              Navigator.of(context).pop();
              return;
            }

            if (activeStep == 1) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                activeStep -= 1;
              });
            }
          },
        ),
        automaticallyImplyLeading: true,
        flexibleSpace: const VendorCustomAppBar(),
      ),
      body: isInitializing
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
              ),
            )
          : SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  // Step Indicators
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: GestureDetector(
                              onTap: () async {
                                final serverStep = await SecurePreferencesUtil.getServerStep() ?? 0;

                                // Allow navigation only to completed steps
                                if (index > 0 && index != activeStep && index <= serverStep) {
                                  setState(() {
                                    activeStep = index;
                                  });
                                }
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: (index == 0)
                                      ? AppColors.peachyPink
                                      : (index <= activeStep)
                                          ? AppColors.peachyPink
                                          : Colors.black,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),

                  // Description
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.03,
                      right: screenWidth * 0.03,
                      bottom: screenHeight * 0.015,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          AppStrings.vendorHeading.tr,
                          style: vendorDescription(),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  // Step Content
                  Expanded(child: getStepWidget()),
                ],
              ),
            ),
    );
  }

  Widget getStepWidget() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        final isVerified = user?.isVerified ?? false;

        switch (activeStep) {
          case 1:
            if (!isVerified) {
              return EmailVerificationScreen(
                onNext: () async {
                  await checkLoginData();
                },
              );
            } else {
              return BusinessAndAuthorizationScreen(
                onNext: moveToNextStep,
              );
            }
          case 2:
            return CompanyInformationScreen(
              onNext: moveToNextStep,
            );
          case 3:
            return BankDetailScreen(
              onNext: moveToNextStep,
            );
          case 4:
            return ContractAgreementScreen(
              onNext: moveToNextStep,
            );
          case 5:
            return const PaymentSubscriptionScreen();
          default:
            SecurePreferencesUtil.saveServerStep(0);
            return VendorLoginInfoScreen(
              onNext: moveToNextStep,
            );
        }
      },
    );
  }
}
