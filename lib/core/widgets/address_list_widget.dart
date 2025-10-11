import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helper/extensions/app_localizations_extension.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../provider/payment_address/customer_address.dart';
import '../../../vendor/components/dialogs/delete_item_alert_dialog.dart';

class AddressListWidget extends StatelessWidget {
  final List<CustomerRecords> addresses;
  final Function(CustomerRecords) onEditAddress;
  final bool isLoading;
  final String? errorMessage;
  final ScrollController? scrollController;
  final bool isFetchingMore;

  const AddressListWidget({
    super.key,
    required this.addresses,
    required this.onEditAddress,
    this.isLoading = false,
    this.errorMessage,
    this.scrollController,
    this.isFetchingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (isLoading && addresses.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.black,
          strokeWidth: 0.5,
        ),
      );
    }

    if (errorMessage != null) {
      return Center(child: Text(errorMessage!));
    }

    if (addresses.isEmpty) {
      return Container(
        width: screenWidth,
        padding: EdgeInsets.only(
          left: screenHeight * 0.02,
          top: screenHeight * 0.01,
          bottom: screenHeight * 0.01,
        ),
        color: AppColors.peachyPink.withAlpha((0.2 * 255).toInt()),
        child: Text(
          AppStrings.noRecord.tr,
          style: GoogleFonts.inter(
            color: Colors.brown.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: scrollController,
      itemCount: addresses.length + (isFetchingMore ? 1 : 0),
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      itemBuilder: (context, index) {
        if (isFetchingMore && index == addresses.length) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        final address = addresses[index];
        return AddressItemWidget(
          address: address,
          onEdit: () => onEditAddress(address),
        );
      },
    );
  }
}

class AddressItemWidget extends StatelessWidget {
  final CustomerRecords address;
  final VoidCallback onEdit;

  const AddressItemWidget({
    super.key,
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.08 * 255).toInt()),
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Default address badge
          if (address.isDefault == 1)
            Container(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(4),
              child: Text(
                AppStrings.defaultAddress.tr,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w200,
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          // Address details
          AddressDetailRow(
            label: AppStrings.name.tr,
            value: address.name ?? '',
          ),
          SizedBox(height: screenHeight * 0.01),
          AddressDetailRow(
            label: AppStrings.email.tr,
            value: address.email ?? '',
          ),
          SizedBox(height: screenHeight * 0.01),
          AddressDetailRow(
            label: AppStrings.phone.tr,
            value: address.phone ?? '${AppStrings.loading.tr}...',
          ),
          SizedBox(height: screenHeight * 0.01),
          AddressDetailRow(
            label: AppStrings.address.tr,
            value: address.fullAddress ?? '${AppStrings.loading.tr}...',
          ),
          SizedBox(height: screenHeight * 0.02),

          // Action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Edit button
              GestureDetector(
                onTap: onEdit,
                child: Text(
                  AppStrings.edit.tr,
                  style: const TextStyle(
                    fontFamily: 'FontSf',
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    decorationStyle: TextDecorationStyle.dotted,
                    decorationColor: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Delete button
              GestureDetector(
                onTap: () async {
                  deleteItemAlertDialog(
                    context: context,
                    buttonColor: AppColors.peachyPink,
                    onDelete: () async {
                      final provider = Provider.of<CustomerAddressProvider>(
                        context,
                        listen: false,
                      );
                      await provider.deleteAddress(address.id ?? 0, context);
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
                child: const SizedBox(
                  height: 35,
                  width: 35,
                  child: Icon(
                    CupertinoIcons.delete_simple,
                    size: 25,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AddressDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const AddressDetailRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(child: Text(label, style: description(context))),
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(value, style: description(context)),
          ),
        ),
      ],
    );
  }
}
