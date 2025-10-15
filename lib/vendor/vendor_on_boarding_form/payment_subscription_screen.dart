import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/bottom_navigation_bar.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/models/vendor_models/post_models/payment_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/payment_methods_response.dart';
import 'package:event_app/models/vendor_models/response_models/subscription_package_response.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../../views/home_screens_shortcode/shortcode_information_icons/gift_card/payments_methods.dart';
import '../../views/payment_screens/payment_view_screen.dart';
import '../components/custom_vendor_auth_button.dart';
import '../components/vendor_text_style.dart';

class PaymentSubscriptionScreen extends StatefulWidget {
  const PaymentSubscriptionScreen({super.key});

  @override
  State<PaymentSubscriptionScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentSubscriptionScreen> {
  SubscriptionPackageResponse? subscriptionResponse;
  PaymentMethodsResponse? paymentMethodsResponse;
  Map<String, String> paymentMethod = {};
  PaymentPostData pModel = PaymentPostData();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getSubscriptionPackageDetails();
    });
    super.initState();
  }

  Future<void> getSubscriptionPackageDetails() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    subscriptionResponse = await provider.getSubscriptionPackageDetails(context);
    getPaymentMethods(subscriptionResponse?.data.formatedPriceWithVat ?? '');
  }

  Future<void> getPaymentMethods(String price) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    paymentMethodsResponse = await provider.getPaymentMethods(context, price);
  }

  Future<CheckoutPaymentModel?> updatePayment(
    PaymentPostData pData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.updatePayment(context, pData);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);
    // Payment Screen
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) {
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04,
                            top: screenHeight * 0.03,
                            bottom: screenHeight * 0.015,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withAlpha((0.5 * 255).toInt())
                                      : Colors.black.withAlpha((0.2 * 255).toInt()),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              shadowColor: Colors.black,
                              color: isDark ? Colors.grey.shade900 : Colors.white,
                              elevation: 15,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 20,
                                  left: 10,
                                  right: 10,
                                  bottom: 30,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      VendorAppStrings.payment.tr,
                                      style: loginHeading(),
                                    ),
                                    Divider(
                                      color: isDark ? Colors.grey.shade600 : Colors.grey,
                                      thickness: 1,
                                      indent: 20,
                                      endIndent: 20,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: screenHeight * 0.03,
                                      ),
                                      child: Text(
                                        subscriptionResponse?.data.heading ?? '',
                                        style: loginHeading(),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.03,
                                      ),
                                      child: Text(
                                        subscriptionResponse?.data.subHeading ?? '',
                                        style: vendorDescriptionAgreement(),
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text(
                                      '${VendorAppStrings.nowAed.tr} ${subscriptionResponse?.data.formatedPriceWithVat}',
                                      style: loginHeading(),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    PaymentMethods(
                                      amount: subscriptionResponse?.data.formatedPriceWithVat ?? '',
                                      paymentType: 'subscription',
                                      onSelectionChanged: (selectedMethod) {
                                        paymentMethod = selectedMethod;
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.03,
                                      ),
                                      child: Text(
                                        VendorAppStrings.youWillBeRedirectedToTelrTabby.tr,
                                        softWrap: true,
                                        textAlign: TextAlign.center,
                                        style: agreementAccept(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomVendorAuthButton(
                isLoading: mainProvider.isLoading,
                title: VendorAppStrings.payNow.tr,
                onPressed: () async {
                  // Capture navigator before any async operations
                  final navigator = Navigator.of(context);

                  pModel.cardAmount = double.tryParse(subscriptionResponse?.data.formatedPriceWithVat ?? '');
                  pModel.paymentMethod = paymentMethod;

                  final checkoutPaymentLink = await updatePayment(pModel);
                  if (checkoutPaymentLink != null) {
                    final bool? paymentResult = await navigator.push(
                      MaterialPageRoute(
                        builder: (context) => PaymentViewScreen(
                          checkoutUrl: checkoutPaymentLink.data.checkoutUrl,
                          paymentType: 'subscription',
                        ),
                      ),
                    );

                    if (paymentResult == true) {
                      if (!mounted) return;
                      showCongratsDialog(screenWidth, screenHeight);
                    } else if (paymentResult == false) {
                      AppUtils.showToast(VendorAppStrings.paymentFailure.tr);
                    } else {
                      AppUtils.showToast(VendorAppStrings.paymentCancelled.tr);
                    }
                  } else {
                    AppUtils.showToast(VendorAppStrings.paymentLinkError.tr);
                  }
                },
              ),
            ),
            if (mainProvider.isLoading)
              Container(
                color: Colors.black.withAlpha((0.5 * 255).toInt()),
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showCongratsDialog(double screenWidth, double screenHeight) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => PopScope(
        canPop: false,
        child: Dialog(
          backgroundColor: Theme.of(dialogContext).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: SingleChildScrollView(
            child: GestureDetector(
              onTap: () {
                // Capture both navigators
                final dialogNavigator = Navigator.of(dialogContext);
                final rootNavigator = Navigator.of(context, rootNavigator: true);

                dialogNavigator.pop();
                rootNavigator.pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const BaseHomeScreen(),
                  ),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.05),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: isDark
                            ? Colors.greenAccent.withAlpha((0.25 * 255).toInt())
                            : Colors.greenAccent.withAlpha((0.35 * 255).toInt()),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withAlpha((0.5 * 255).toInt())
                                : Colors.black.withAlpha((0.2 * 255).toInt()),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.card_giftcard,
                            size: 50,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                          Text(
                            VendorAppStrings.congratulations.tr,
                            style: congratulations(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenHeight * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          AppStrings.registrationDone.tr,
                          style: paymentHeading(),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.040,
                          ),
                          child: Text(
                            AppStrings.paymentDone.tr,
                            style: paymentDesc(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                          child: Text(
                            AppStrings.paymentThanks.tr,
                            style: vendorPayment(),
                            textAlign: TextAlign.center,
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
      ),
    );
  }
}
