import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/views/cart_screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../base_screens/base_app_bar.dart';
import 'payment_screen.dart';

class StepperScreen extends StatefulWidget {
  const StepperScreen({super.key, this.tracked_start_checkout, required this.isNewAddress, required this.amount});

  final String? tracked_start_checkout;
  final bool isNewAddress;
  final String amount;

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

    // Get current theme
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
      appBar: PreferredSize(
        // AppBar or BaseAppBar stays outside and fixed at the top
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        // Adjust height as needed
        child: activeStep == 2
            ? BaseAppBar(
                firstRightIconPath: AppStrings.firstRightIconPath.tr,
                secondRightIconPath: AppStrings.secondRightIconPath.tr,
                thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
              )
            : AppBar(
                backgroundColor: isDarkMode ? theme.appBarTheme.backgroundColor : Colors.white,
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
                            Navigator.of(context).pop(); // Cancel button functionality
                          },
                          child: Text(
                            AppStrings.cancel.tr,
                            style: profileItemsTextStyle().copyWith(
                              color: isDarkMode ? Colors.white : null,
                            ),
                          ),
                        ),
                      ),
                      // Center the Checkout title
                      Center(
                        child: Text(
                          AppStrings.checkout.tr,
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
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: _getStepColor(index, isDarkMode),
                            shape: BoxShape.circle,
                            border: isDarkMode && index > activeStep
                                ? Border.all(color: Colors.grey[600]!, width: 1)
                                : null,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: _getStepTextColor(index, isDarkMode),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          stepsName[index],
                          style: GoogleFonts.inter(
                            color: isDarkMode
                                ? (index <= activeStep ? Colors.white : Colors.grey[400])
                                : (index <= activeStep ? Colors.black : Colors.grey[600]),
                            fontSize: 15,
                            fontWeight: index <= activeStep ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                        const SizedBox(width: 5),
                        if (index < 1) // Add connector lines between steps
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            color: isDarkMode
                                ? (index < activeStep ? AppColors.peachyPink : Colors.grey[600])
                                : (index < activeStep ? AppColors.peachyPink : Colors.grey),
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
            Container(
              color: isDarkMode ? Colors.grey[700] : Colors.grey,
              width: screenWidth,
              height: 1,
            ),
            // Main content for each step
            Expanded(child: getStepWidget()),
          ],
        ),
      ),
    );
  }

  /// Get step circle color based on current state and theme
  Color _getStepColor(int index, bool isDarkMode) {
    if (index == 2 && activeStep != 2) {
      // Special case for step 3 when not active
      return isDarkMode ? Colors.grey[700]! : Colors.grey;
    }

    if (index <= activeStep) {
      return AppColors.peachyPink;
    }

    return isDarkMode ? Colors.grey[700]! : Colors.grey[300]!;
  }

  /// Get step text color based on current state and theme
  Color _getStepTextColor(int index, bool isDarkMode) {
    if (index <= activeStep) {
      return Colors.white;
    }

    return isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;
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
          isNewAddress: widget.isNewAddress,
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
