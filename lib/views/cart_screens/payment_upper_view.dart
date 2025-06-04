import 'package:flutter/material.dart';

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
          left: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please Confirm and submit your order',
              style: chooseStyle(context)),
          SizedBox(height: screenHeight * 0.01),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: description(context),
              // Apply your default text style here
              children: <TextSpan>[
                const TextSpan(
                  text:
                      'By clicking submit order, you agree to event’s ', // Regular text
                ),
                TextSpan(
                  text: '\nTerms of Use', // Underlined text
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.6),
                    decoration:
                        TextDecoration.underline, // Underline decoration
                  ),
                ),
                const TextSpan(
                  text: ' and ', // Regular text
                ),
                TextSpan(
                  text: 'Privacy Policy', // Underlined text
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.6),
                    decoration:
                        TextDecoration.underline, // Underline decoration
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
