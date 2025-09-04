import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/cupertino.dart';

import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../home_screens_shortcode/shortcode_information_icons/gift_card/payments_methods.dart';

class ShippingAddressScreen extends StatefulWidget {
  const ShippingAddressScreen({super.key, required this.onNext});

  final void Function(Map<String, String> paymentMethod) onNext;

  @override
  State<ShippingAddressScreen> createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  Map<String, String> paymentMethod = {};

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight * 0.08,
                      right: screenWidth * 0.02,
                      left: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.choosePaymentMethod.tr,
                          style: chooseStyle(context),
                        ),
                        Text(
                          AppStrings.shippingAddressDescription.tr,
                          style: description(context),
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        PaymentMethods(
                          onSelectionChanged: (selectedMethod) {
                            paymentMethod = selectedMethod;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Button at the bottom

          Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: AppCustomButton(
              onPressed: () {
                widget.onNext(paymentMethod);
              },
              icon: CupertinoIcons.forward,
              title: AppStrings.continueToPayment.tr,
            ),
          ),
        ],
      ),
    );
  }
}
