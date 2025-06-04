import 'package:event_app/models/checkout_models/checkout_data_models.dart';
import 'package:event_app/views/cart_screens/save_address_screen.dart';
import 'package:flutter/material.dart';

import '../../core/styles/custom_text_styles.dart';
import '../../provider/payment_address/create_address_provider.dart';

class ShippingAddressViewScreen extends StatefulWidget {
  const ShippingAddressViewScreen({
    super.key,
    this.checkoutToken,
    this.checkoutData,
    required this.loadCheckoutData,
  });
  final String? checkoutToken;
  final CheckoutData? checkoutData;
  final void Function(bool checkoutData) loadCheckoutData;

  @override
  _ShippingAddressViewScreenState createState() =>
      _ShippingAddressViewScreenState();
}

class _ShippingAddressViewScreenState extends State<ShippingAddressViewScreen> {
  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    return Padding(
      padding: EdgeInsets.only(
        top: screenHeight * 0.02,
        right: screenWidth * 0.02,
        left: screenWidth * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.08)),
          borderRadius: BorderRadius.circular(4),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child:
                        Text('Shipping address', style: chooseStyle(context))),
                GestureDetector(
                  onTap: () async {
                    final checkoutToken = widget.checkoutToken;
                    if (checkoutToken != null) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveAddressScreen(
                            tracked_start_checkout: checkoutToken,
                            isEditable: true,
                            addressModel: AddressModel(
                              id: widget.checkoutData?.sessionCheckoutData
                                      ?.addressId
                                      .toString() ??
                                  '',
                              name: widget.checkoutData?.sessionCheckoutData
                                      ?.name ??
                                  '',
                              email: widget.checkoutData?.sessionCheckoutData
                                      ?.email ??
                                  '',
                              phone: widget.checkoutData?.sessionCheckoutData
                                      ?.phone ??
                                  '',
                              country: widget.checkoutData?.sessionCheckoutData
                                      ?.country ??
                                  '',
                              city: widget.checkoutData?.sessionCheckoutData
                                      ?.city ??
                                  '',
                              address: widget.checkoutData?.sessionCheckoutData
                                      ?.address ??
                                  '',
                              state: widget.checkoutData?.sessionCheckoutData
                                      ?.state ??
                                  '',
                              zipCode: widget.checkoutData?.sessionCheckoutData
                                      ?.zipCode ??
                                  '',
                              // Add state if available
                              isDefault: true, // Set if applicable
                            ),
                          ),
                        ),
                      );

                      if (result == true) {
                        widget.loadCheckoutData(true);
                      }
                    }
                  },
                  child: const Text(
                    'Update',
                    style: TextStyle(
                      fontFamily: 'FontSf',
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Expanded(child: Text(value.checkoutData?.data!.token ?? '', style: chooseStyle(context))),
                Expanded(child: Text('Name', style: description(context))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.checkoutData?.sessionCheckoutData?.name
                              .toString() ??
                          'loading..',
                      style: description(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text('Email', style: description(context))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.checkoutData?.sessionCheckoutData?.email ??
                          'loading..',
                      style: description(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text('Phone', style: description(context))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.checkoutData?.sessionCheckoutData?.phone
                              .toString() ??
                          'loading..',
                      style: description(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: Text('Address', style: description(context))),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.checkoutData?.sessionCheckoutData?.address ??
                          'loading..',
                      style: description(context),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
    /*},
    );*/
  }
}
