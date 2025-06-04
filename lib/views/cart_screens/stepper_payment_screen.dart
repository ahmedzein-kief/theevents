import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/views/cart_screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../base_screens/base_app_bar.dart';
import 'payment_screen.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key, this.tracked_start_checkout});
  final String? tracked_start_checkout;

  @override
  _StepperScreenState createState() => _StepperScreenState();
}

class _StepperScreenState extends State<StepperScreen> {
  int activeStep = 0;

  Map<String, String> paymentMethod = {};

  final List<String> stepsName = [
    'Shipping',
    'Payment', /*, 'Review'*/
  ];

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: PreferredSize(
        // AppBar or BaseAppBar stays outside and fixed at the top
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        // Adjust height as needed
        child: activeStep == 2
            ? BaseAppBar(
                firstRightIconPath: AppStrings.firstRightIconPath,
                secondRightIconPath: AppStrings.secondRightIconPath,
                thirdRightIconPath: AppStrings.thirdRightIconPath,
              )
            : AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                // Prevent the back button from appearing
                flexibleSpace: Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Stack(
                    children: [
                      // Container to hold the Cancel button
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: screenWidth * 0.04),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pop(); // Cancel button functionality
                          },
                          child: Text(
                            'Cancel',
                            style: profileItemsTextStyle(),
                          ),
                        ),
                      ),
                      // Center the Checkout title
                      Center(
                        child: Text(
                          'Checkout',
                          style: checkOutStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * 0.01),
            // Check if activeStep is 2 to use BaseAppBar, otherwise use custom app bar
            Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    2,
                    (index) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        const SizedBox(width: 5),
                        Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: (index == 2 && activeStep != 2)
                                ? Colors
                                    .grey // Set color to grey for step 3 if activeStep is not 2
                                : (index <= activeStep
                                    ? AppColors.peachyPink
                                    : Colors.black),
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
                        const SizedBox(width: 5),
                        Text(
                          stepsName[index],
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (index < 1) // Add connector lines between steps
                          Container(
                            color: Colors.grey,
                            height: 2,
                            width: 10,
                          ),
                        const SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(color: Colors.grey, width: screenWidth, height: 1),
            // Main content for each step
            Expanded(child: getStepWidget()),
          ],
        ),
      ),
    );
  }

  // Switch between step widgets
  Widget getStepWidget() {
    switch (activeStep) {
      case 0:
        return ShippingAddressScreen(
          onNext: (payment) {
            setState(() {
              paymentMethod = payment;
              activeStep += 1;
            });
          },
        );
      case 1:
        return PaymentScreen(
          tracked_start_checkout: widget.tracked_start_checkout,
          paymentMethod: paymentMethod,
          onNext: () {
            setState(() {
              activeStep += 1;
            });
          },
        );
      /*case 2:
        return OrderConfirmationScreen(
          onPrevious: () {
            setState(() {
              activeStep -= 1;
            });
          },
        );*/
      default:
        return ShippingAddressScreen(
          onNext: (payment) {
            setState(() {
              paymentMethod = payment;
              activeStep += 1;
            });
          },
        );
    }
  }
}
