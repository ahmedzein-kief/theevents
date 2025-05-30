import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/models/vendor_models/post_models/payment_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/payment_methods_response.dart';
import 'package:event_app/models/vendor_models/response_models/subscription_package_response.dart';
import 'package:event_app/navigation/bottom_navigation_bar.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../../core/styles/app_colors.dart';
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
    getPaymentMethods(subscriptionResponse?.data.price ?? '');
  }

  Future<void> getPaymentMethods(String price) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    paymentMethodsResponse = await provider.getPaymentMethods(context, price);
  }

  Future<CheckoutPaymentModel?> updatePayment(
    PaymentPostData pData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    var response = await provider.updatePayment(context, pData);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(builder: (context, provider, child) {
              return SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.only(bottom: 60),
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
                              color: Colors.black.withOpacity(0.2), // Shadow color
                              spreadRadius: 2, // How much the shadow spreads
                              blurRadius: 5, // How blurry the shadow is
                              offset: const Offset(0, 2), // Shadow offset (X, Y)
                            ),
                          ],
                        ),
                        child: Material(
                          shadowColor: Colors.black,
                          color: Colors.white,
                          elevation: 15,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 30),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Payment", style: loginHeading()),
                                Divider(
                                  color: Colors.grey, // Line color
                                  thickness: 1, // Line thickness
                                  indent: 20, // Start padding
                                  endIndent: 20, // End padding
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                                  child: Text(
                                    subscriptionResponse?.data.heading ?? '',
                                    style: loginHeading(),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                                  child: Text(
                                    subscriptionResponse?.data.subHeading ?? '',
                                    style: vendorDescriptionAgreement(),
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Text("Now AED ${subscriptionResponse?.data.price}", style: loginHeading()),
                                SizedBox(
                                  height: 20,
                                ),
                                PaymentMethods(
                                  subCardShow: false,
                                  onSelectionChanged: (selectedMethod) {
                                    paymentMethod = selectedMethod;
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                                  child: Text(
                                    "You will be redirected to Telr/Tabby to complete payment",
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
                    )
                  ],
                ),
              ));
            }),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomVendorAuthButton(
                  isLoading: mainProvider.isLoading,
                  title: "Pay Now",
                  onPressed: () async {
                    pModel.cardAmount = int.tryParse(subscriptionResponse?.data.price ?? '');
                    pModel.paymentMethod = paymentMethod;

                    final checkoutPaymentLink = await updatePayment(pModel);
                    if (checkoutPaymentLink != null) {
                      final paymentResult = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentViewScreen(
                            checkoutUrl: checkoutPaymentLink.data.checkoutUrl,
                          ),
                        ),
                      );
                      if (paymentResult) {
                        showCongratsDialog(context, screenWidth, screenHeight);
                      } else {
                        CustomSnackbar.showError(context, "Payment Failure");
                      }
                    }
                  }),
            ),
            if (mainProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
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

  void showCongratsDialog(BuildContext context, double screenWidth, double screenHeight) {
    showDialog(
      context: context,
      barrierDismissible: false,
      // Prevent closing the dialog by tapping outside

      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0), // No rounded corners
            ),
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BaseHomeScreen()));
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
                            // No rounded corners
                            color: Colors.greenAccent.withOpacity(0.35),
                            // Customize the container color
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                // Shadow color
                                spreadRadius: 2,
                                // How much the shadow spreads
                                blurRadius: 5,
                                // How blurry the shadow is
                                offset: const Offset(0, 2), // Shadow offset (X, Y)
                              )
                            ]),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.card_giftcard,
                              size: 50,
                            ),
                            Text(
                              "Congratulations!",
                              style: congratulations(),
                            )
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
                            AppStrings.registrationDone,
                            style: paymentHeading(),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.040),
                            child: Text(
                              AppStrings.paymentDone,
                              style: paymentDesc(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: screenHeight * 0.04),
                            child: Text(
                              AppStrings.paymentThanks,
                              style: vendorPayment(),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
