import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles/custom_text_styles.dart';
import '../../provider/checkout_provider/checkout_provider.dart';

class ShippingMethodViewScreen extends StatefulWidget {
  const ShippingMethodViewScreen({
    super.key,
    required this.onSelectShippingMethod,
    required this.shippingMethod,
  });

  final void Function(Map<String, String> selectedShippingMethod)
      onSelectShippingMethod;
  final Map<String, String> shippingMethod;

  @override
  _ShippingMethodViewScreenState createState() =>
      _ShippingMethodViewScreenState();
}

class _ShippingMethodViewScreenState extends State<ShippingMethodViewScreen> {
  int? selectedShippingIndex;

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<CheckoutProvider>(
      builder: (BuildContext context, CheckoutProvider value, Widget? child) {
        // Check if checkoutData exists and has data
        if (value.checkoutData?.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final checkoutData = value.checkoutData!.data!;
        final shipping = checkoutData.shipping;

        // Handle the shipping data structure
        // Assuming the shipping Map contains shipping method options
        // You might need to adjust this based on your actual API structure
        final shippingMethods = <String, dynamic>{};

        // If shipping contains method data, extract it
        if (shipping.isNotEmpty) {
          // This assumes your shipping data structure - adjust as needed
          if (shipping.containsKey('methods')) {
            shippingMethods
                .addAll(shipping['methods'] as Map<String, dynamic>? ?? {});
          } else if (shipping.containsKey('options')) {
            shippingMethods
                .addAll(shipping['options'] as Map<String, dynamic>? ?? {});
          } else {
            // If the shipping map directly contains the methods
            shippingMethods.addAll(shipping);
          }
        }

        // Set selected shipping index based on current method
        if (selectedShippingIndex == null &&
            widget.shippingMethod.containsKey('shipping[method_id]')) {
          final currentMethodId =
              widget.shippingMethod['shipping[method_id]'] ??
                  widget.shippingMethod['method_id'];

          shippingMethods.keys.toList().asMap().forEach((index, methodId) {
            final methodData = shippingMethods[methodId];
            String actualMethodId = methodId.toString();

            // Handle nested structure to get actual method ID
            if (methodData is Map<String, dynamic> && methodData.isNotEmpty) {
              final firstKey = methodData.keys.first;
              final innerData = methodData[firstKey];
              if (innerData is Map<String, dynamic>) {
                actualMethodId = firstKey.toString();
              }
            }

            if (actualMethodId == currentMethodId) {
              selectedShippingIndex = index;
            }
          });
        }

        return Padding(
          padding: EdgeInsets.only(
            top: screenHeight * 0.04,
            right: screenWidth * 0.02,
            left: screenWidth * 0.02,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(AppStrings.shippingMethod.tr, style: chooseStyle(context)),
              SizedBox(height: screenHeight * 0.01),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimary
                        .withOpacity(0.08),
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.all(10),
                child: shippingMethods.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'No shipping methods available',
                          style: shippingMethod(context),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: shippingMethods.length,
                        itemBuilder: (context, index) {
                          final methodId =
                              shippingMethods.keys.elementAt(index);
                          final methodData = shippingMethods[methodId];

                          // Extract shipping name and price based on your data structure
                          String shippingName = 'Unknown Method';
                          String shippingPrice = '0';
                          String actualMethodId = methodId.toString();

                          if (methodData is Map<String, dynamic>) {
                            // Handle nested structure like {3: {name: Delevery, price: 39.00}}
                            if (methodData.isNotEmpty) {
                              final firstKey = methodData.keys.first;
                              final innerData = methodData[firstKey];

                              if (innerData is Map<String, dynamic>) {
                                // Extract from inner map
                                shippingName = innerData['name']?.toString() ??
                                    'Unknown Method';
                                shippingPrice =
                                    innerData['price']?.toString() ?? '0';
                                actualMethodId = firstKey
                                    .toString(); // Use the inner key as method ID
                              } else {
                                // Direct structure
                                shippingName = methodData['name']?.toString() ??
                                    methodData['label']?.toString() ??
                                    methodData['title']?.toString() ??
                                    methodId.toString();
                                shippingPrice =
                                    methodData['price']?.toString() ??
                                        methodData['amount']?.toString() ??
                                        methodData['cost']?.toString() ??
                                        '0';
                              }
                            }
                          } else {
                            // If methodData is not a map, use it directly
                            shippingName =
                                methodData?.toString() ?? methodId.toString();
                            shippingPrice = '0';
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Shipping name on the left
                                Expanded(
                                  child: Text(
                                    shippingName,
                                    style: shippingMethod(context),
                                  ),
                                ),
                                // Price and radio button on the right
                                Row(
                                  children: [
                                    Text(
                                      '${AppStrings.aed.tr} $shippingPrice',
                                      style: shippingMethod(context),
                                    ),
                                    Radio<int>(
                                      value: index,
                                      groupValue: selectedShippingIndex,
                                      activeColor: AppColors.peachyPink,
                                      onChanged: (int? value) {
                                        final shippingMethodData = {
                                          'shipping[method_id]': actualMethodId,
                                          'shipping[method_amount]':
                                              shippingPrice,
                                          'shipping[method_name]': shippingName,
                                        };
                                        widget.onSelectShippingMethod(
                                            shippingMethodData,);
                                        setState(() {
                                          selectedShippingIndex = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
