import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart'; // <--- IMPORT AppStrings
import '../../core/styles/custom_text_styles.dart';

class PaymentConfirmText extends StatefulWidget {
  const PaymentConfirmText({super.key});

  @override
  State<PaymentConfirmText> createState() => _PaymentConfirmTextState();
}

class _PaymentConfirmTextState extends State<PaymentConfirmText> {
  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.04,
        right: screenWidth * 0.02,
        left: screenHeight * 0.02,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.confirmAndSubmitOrder.tr, // <--- REFACTORED
            style: chooseStyle(context),
          ),
          SizedBox(height: screenHeight * 0.01),
          RichText(
            // Consider textAlign: TextAlign.start for better readability
            textAlign: TextAlign.start,
            text: TextSpan(
              style: description(context),
              children: <TextSpan>[
                TextSpan(
                  text: AppStrings.byClickingSubmit.tr, // <--- REFACTORED
                ),
                TextSpan(
                  // Note: '\n' is removed here. It's better to handle new lines
                  // with layout widgets like Wrap or Column for better responsiveness.
                  // If you must have a line break, consider using `\n${AppStrings.termsOfUse.tr}`
                  text: AppStrings.termsOfUse.tr, // <--- REFACTORED
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.6 * 255).toInt()),
                    decoration: TextDecoration.underline,
                  ),
                  // Add recognizer for tap events here if needed
                  // recognizer: TapGestureRecognizer()..onTap = () => print('Terms Tapped'),
                ),
                TextSpan(
                  text: AppStrings.and.tr, // <--- REFACTORED
                ),
                TextSpan(
                  text: AppStrings.privacyPolicy.tr, // <--- REFACTORED
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.6 * 255).toInt()),
                    decoration: TextDecoration.underline,
                  ),
                  // Add recognizer for tap events here if needed
                  // recognizer: TapGestureRecognizer()..onTap = () => print('Policy Tapped'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
