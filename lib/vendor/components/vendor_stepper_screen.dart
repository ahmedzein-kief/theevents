import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/vendor_models/response_models/meta_data_response.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:event_app/vendor/components/vendor_custom_appBar.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_on_boarding_form/email_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/app_colors.dart';
import '../vendor_on_boarding_form/bank_detail_screen.dart';
import '../vendor_on_boarding_form/business_and_authorization_screen.dart';
import '../vendor_on_boarding_form/company_information_screen.dart';
import '../vendor_on_boarding_form/contract_agreement_screen.dart';
import '../vendor_on_boarding_form/login_info_screen.dart';
import '../vendor_on_boarding_form/payment_subscription_screen.dart';

class VendorStepperScreen extends StatefulWidget {
  const VendorStepperScreen({super.key});

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<VendorStepperScreen> {
  int activeStep = 0;
  bool isVerified = false;
  bool isApproved = false;

  @override
  void initState() {
    checkLoginData();
    super.initState();
  }

  Future<MetaDataResponse?> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);

    final response = await provider.getAllMetaData(context);
    return response;
  }

  Future<void> checkLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString(SecurePreferencesUtil.tokenKey);
    final token = await SecurePreferencesUtil.getToken();

    if (token == null || token.isEmpty) return;

    if (!isVerified && !isApproved) {
      setState(() {
        activeStep = 1;
        isVerified = prefs.getBool(SecurePreferencesUtil.verified) ?? false;
        isApproved = prefs.getBool(SecurePreferencesUtil.approved) ?? false;
      });
    }

    if (isVerified) {
      final metaResponse = await getAllMetaData();
      setState(() {
        if (metaResponse != null) {
          SecurePreferencesUtil.saveServerStep(
            int.parse(metaResponse.data['step'] ?? '1'),
          );

          activeStep = int.parse(metaResponse.data['step'] ?? '1');
        } else {
          activeStep = 1;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;

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
            // Handle back button press here

            if (activeStep == 0) {
              Navigator.of(context).pop();
              return;
            }

            if (activeStep == 1) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                activeStep = activeStep - 1;
              });
            }
          },
        ),
        automaticallyImplyLeading: true,
        flexibleSpace: const VendorCustomAppBar(),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
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
                          final int serverStep = await SecurePreferencesUtil.getServerStep() ?? 0;
                          print(
                            'Tapped on step index ==> $index || activeStep==> $activeStep || serverStep==> $serverStep',
                          );
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
                                ? AppColors.peachyPink // Keep the first step red
                                : (index <= activeStep)
                                    ? AppColors.peachyPink // Active step colors
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
            Expanded(child: getStepWidget()),
          ],
        ),
      ),
    );
  }

  // Switch between step widgets
  Widget getStepWidget() {
    switch (activeStep) {
      case 1:
        if (!isVerified) {
          return EmailVerificationScreen(
            onNext: () {
              setState(() {
                checkLoginData();
              });
            },
          );
        } else {
          return BusinessAndAuthorizationScreen(
            onNext: () {
              setState(() {
                activeStep += 1;
              });
            },
          );
        }
      case 2:
        return CompanyInformationScreen(
          onNext: () {
            setState(() {
              activeStep += 1;
            });
          },
        );
      case 3:
        return BankDetailScreen(
          onNext: () {
            setState(() {
              activeStep += 1;
            });
          },
        );
      case 4:
        return ContractAgreementScreen(
          onNext: () {
            setState(() {
              activeStep += 1;
            });
          },
        );
      case 5:
        return const PaymentSubscriptionScreen();
      default:
        SecurePreferencesUtil.saveServerStep(0);
        return VendorLoginInfoScreen(
          onNext: () {
            setState(() {
              activeStep += 1;
            });
          },
        );
    }
  }
}
