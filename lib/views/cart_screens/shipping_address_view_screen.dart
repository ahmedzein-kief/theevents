import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
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
  _ShippingAddressViewScreenState createState() => _ShippingAddressViewScreenState();
}

class _ShippingAddressViewScreenState extends State<ShippingAddressViewScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the current session address ID
    final sessionAddressId = widget.checkoutData?.sessionCheckoutData.addressId;

    // Find the address that matches the session address ID
    final Address? currentAddress = widget.checkoutData?.addresses.firstWhere(
      (address) => address.id == sessionAddressId,
      orElse: () => widget.checkoutData!.addresses.firstWhere(
        (address) => address.isDefault == 1,
        orElse: () => widget.checkoutData!.addresses.first,
      ),
    );

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
            color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.08),
          ),
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
                  child: Text(
                    AppStrings.shippingAddress.tr,
                    style: chooseStyle(context),
                  ),
                ),
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
                              id: widget.checkoutData?.sessionCheckoutData.addressId.toString() ?? '',
                              name: widget.checkoutData?.sessionCheckoutData.name ?? '',
                              email: widget.checkoutData?.sessionCheckoutData.email ?? '',
                              phone: widget.checkoutData?.sessionCheckoutData.phone ?? '',
                              countryId: widget.checkoutData?.sessionCheckoutData.country ?? '',
                              cityId: widget.checkoutData?.sessionCheckoutData.city ?? '',
                              address: widget.checkoutData?.sessionCheckoutData.address ?? '',
                              stateId: widget.checkoutData?.sessionCheckoutData.state ?? '',
                              country: currentAddress?.locationCountry.name ?? '',
                              state: currentAddress?.locationState.name ?? '',
                              city: currentAddress?.locationCity.name ?? '',
                              isDefault: true,
                            ),
                          ),
                        ),
                      );

                      if (result == true) {
                        widget.loadCheckoutData(true);
                      }
                    }
                  },
                  child: Text(
                    AppStrings.update.tr,
                    style: const TextStyle(
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
                Expanded(
                  child: Text(AppStrings.name.tr, style: description(context)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.name ??
                          widget.checkoutData?.sessionCheckoutData.name ??
                          '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(AppStrings.email.tr, style: description(context)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.email ??
                          widget.checkoutData?.sessionCheckoutData.email ??
                          '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(AppStrings.phone.tr, style: description(context)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.phone ??
                          widget.checkoutData?.sessionCheckoutData.phone ??
                          '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(
                    AppStrings.country.tr,
                    style: description(context),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.locationCountry.name ?? '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(
                    AppStrings.state.tr,
                    style: description(context),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.locationState.name ?? '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(
                    AppStrings.city.tr,
                    style: description(context),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.locationCity.name ?? '${AppStrings.loading.tr}..',
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
                Expanded(
                  child: Text(
                    AppStrings.address.tr,
                    style: description(context),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      currentAddress?.address ??
                          widget.checkoutData?.sessionCheckoutData.address ??
                          '${AppStrings.loading.tr}..',
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
  }
}
