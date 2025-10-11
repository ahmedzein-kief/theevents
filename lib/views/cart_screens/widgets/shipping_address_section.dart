import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/provider/checkout_provider/checkout_provider.dart';
import 'package:event_app/views/cart_screens/widgets/section_card.dart';
import 'package:event_app/views/cart_screens/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'address_row.dart';

class ShippingAddressSection extends StatelessWidget {
  const ShippingAddressSection({
    super.key,
    required this.provider,
    required this.isDark,
  });

  final CheckoutProvider provider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sessionData = provider.checkoutData?.data?.sessionCheckoutData;

    return SectionCard(
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionTitle(
            title: AppStrings.deliverTo.tr,
            isDark: isDark,
          ),
          const SizedBox(height: 16),
          if (sessionData != null)
            _AddressDetails(provider: provider, isDark: isDark)
          else
            Text(
              AppStrings.noAddressSelected.tr,
              style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[600]),
            ),
        ],
      ),
    );
  }
}

class _AddressDetails extends StatelessWidget {
  const _AddressDetails({
    required this.provider,
    required this.isDark,
  });

  final CheckoutProvider provider;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final sessionData = provider.checkoutData!.data!.sessionCheckoutData;
    final addresses = provider.checkoutData!.data!.addresses;

    final selectedAddress = addresses.cast<dynamic>().firstWhere(
          (a) => a.id == sessionData.addressId,
          orElse: () => null,
        );

    if (selectedAddress == null) {
      return Text(
        AppStrings.addressDetailsNotFound.tr,
        style: GoogleFonts.inter(fontSize: 14, color: Colors.red),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AddressRow(AppStrings.fullName.tr, selectedAddress.name, isDark),
        AddressRow(AppStrings.address.tr, selectedAddress.address, isDark),
        AddressRow(AppStrings.city.tr, selectedAddress.locationCity.name, isDark),
        AddressRow(AppStrings.areaState.tr, selectedAddress.locationState.name, isDark),
        AddressRow(AppStrings.country.tr, selectedAddress.locationCountry.name, isDark),
        AddressRow(AppStrings.phoneNumber.tr, selectedAddress.phone, isDark),
        AddressRow(AppStrings.email.tr, selectedAddress.email, isDark),
      ],
    );
  }
}
