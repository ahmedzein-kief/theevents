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
        if (value.checkoutData == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final checkoutData = value.checkoutData;
        final shippingDefault = checkoutData?.data?.shipping?.shippingDefault;
        shippingDefault?.keys.toList().asMap().forEach(
          (index, value) {
            if (value == widget.shippingMethod['method_id']) {
              selectedShippingIndex = index;
            }
          },
        );

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
              Text('Shipping Method', style: chooseStyle(context)),
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
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: shippingDefault?.length,
                  itemBuilder: (context, index) {
                    final key = shippingDefault?.keys.elementAt(index);
                    final entry = shippingDefault?.entries.elementAt(index);
                    final shippingName = entry?.value.name ?? 'loading...';
                    final shippingPrice = entry?.value.price ?? 'loading...';

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
                                'AED $shippingPrice',
                                style: shippingMethod(context),
                              ),
                              Radio<int>(
                                value: index,
                                groupValue: selectedShippingIndex,
                                activeColor:
                                    AppColors.peachyPink, // Ensure visibility
                                onChanged: (int? value) {
                                  final shippingMethodData = {
                                    'method_id': '$key',
                                    'method_amount': '$shippingPrice',
                                  };
                                  widget.onSelectShippingMethod(
                                      shippingMethodData);
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
