import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_utils.dart';
import '../../core/widgets/address_form_bottom_sheet.dart';
import '../../core/widgets/price_row.dart';
import '../../provider/checkout_provider/submit_checkout_information.dart';
import '../../provider/payment_address/customer_address.dart';

class StepperAddressScreen extends StatefulWidget {
  const StepperAddressScreen({
    super.key,
    required this.trackedStartCheckout,
    required this.finalAmount,
    required this.onAddressSelected,
  });

  final String trackedStartCheckout;
  final String finalAmount;
  final VoidCallback onAddressSelected;

  @override
  State<StepperAddressScreen> createState() => _StepperAddressScreenState();
}

class _StepperAddressScreenState extends State<StepperAddressScreen> {
  CustomerRecords? selectedAddress;
  final int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    // Defer the API call until after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataOfCustomer();
    });
  }

  Future<void> fetchDataOfCustomer() async {
    try {
      final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
      final result = await provider.fetchCustomerAddresses(
        context,
        perPage: 12,
        page: _currentPage,
      );

      setState(() {
        final list = result?.data?.records ?? [];

        if (list.isNotEmpty) {
          final CustomerRecords address = list.firstWhere(
            (address) => address.isDefault == 1,
            orElse: () => list.first,
          );

          selectedAddress = address;
        }
      });
    } catch (e) {
      // Handle error silently
    }
  }

  // Save the selected address and proceed
  Future<void> _handleAddressSelection() async {
    final result =
        await Provider.of<SubMitCheckoutInformationProvider>(context, listen: false).submitCheckoutInformation(
      trackedStartCheckout: widget.trackedStartCheckout,
      addressId: selectedAddress!.id.toString(),
      name: selectedAddress!.name ?? '',
      email: selectedAddress!.email ?? '',
      city: selectedAddress!.cityId ?? '',
      // Use cityId instead of city
      state: selectedAddress!.stateId ?? '',
      // Use stateId instead of state
      address: selectedAddress!.address ?? '',
      phone: int.tryParse(selectedAddress!.phone ?? '0') ?? 0,
      country: selectedAddress!.countryId ?? '',
      // Use countryId instead of country
      vendorId: 0,
      shippingMethod: '',
      shippingOption: '',
    );

    if (result != null) {
      widget.onAddressSelected();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.04,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              children: [
                Text(
                  AppStrings.shippingAddress.tr,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.selectShippingAddress.tr,
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Address selection
                        Consumer<CustomerAddressProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            final addresses = provider.addresses;

                            return Column(
                              children: [
                                // Selected Address Display (like in the image)
                                if (selectedAddress != null)
                                  GestureDetector(
                                    onTap: () => _editAddress(selectedAddress!),
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Row(
                                        children: [
                                          // Gold circle indicator
                                          Container(
                                            width: 20,
                                            height: 20,
                                            decoration: const BoxDecoration(
                                              color: Colors.orange,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          // Address details
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${AppStrings.fullName.tr}: ${selectedAddress!.name ?? AppStrings.unknownName.tr}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${AppStrings.address.tr}: ${selectedAddress!.address ?? AppStrings.unknownAddress.tr}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${AppStrings.city.tr}: ${selectedAddress!.city ?? AppStrings.unknownCity.tr}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${AppStrings.areaState.tr}: ${selectedAddress!.state ?? AppStrings.unknownState.tr}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${AppStrings.phoneNumber.tr}: ${selectedAddress!.phone ?? AppStrings.unknownPhone.tr}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    color: isDarkMode ? Colors.white : Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Edit icon (tap container to edit)
                                          Icon(
                                            Icons.edit,
                                            color: Colors.grey[600],
                                            size: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                // Add New Address Button
                                GestureDetector(
                                  onTap: () => _addNewAddress(),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.grey[900] : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey[300]!),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.add,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          AppStrings.addNewAddress.tr,
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // All Addresses List
                                if (addresses.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      _showAddressBottomSheet();
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: isDarkMode ? Colors.grey[900] : Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey[300]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: Colors.grey[600],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            '${AppStrings.selectFromExistingAddresses.tr} (${addresses.length})',
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          const Spacer(),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.grey[600],
                                            size: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Subtotal and Continue Button
          Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              children: [
                // Subtotal
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.subTotalColon.tr,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                    PriceRow(
                      price: widget.finalAmount,
                      currencySize: 12,
                      style: GoogleFonts.inter(
                        textStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Continue Button
                AppCustomButton(
                  title: AppStrings.continueToPayment.tr,
                  onPressed: selectedAddress != null
                      ? _handleAddressSelection
                      : () {
                          AppUtils.showToast(AppStrings.pleaseAddNewAddress.tr);
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        final isDarkMode = theme.brightness == Brightness.dark;

        return Column(
          children: [
            // Existing Addresses
            Consumer<CustomerAddressProvider>(
              builder: (BuildContext context, CustomerAddressProvider provider, Widget? child) {
                if (provider.isLoadingAddresses) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 0.5,
                    ),
                  );
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.addresses.isNotEmpty)
                            ListView.builder(
                              itemCount: provider.addresses.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final address = provider.addresses[index];
                                return ListTile(
                                  title: Text(
                                    address.fullAddress ?? AppStrings.unknownAddress.tr,
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: isDarkMode ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${address.name ?? ''} - ${address.phone ?? ''}',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedAddress = address;
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _editAddress(CustomerRecords address) async {
    AddressFormBottomSheet.show(
      context,
      existingAddress: address,
      onAddressSaved: () async {
        // Refresh the address list and update the selected address
        await fetchDataOfCustomer();

        // Check if widget is still mounted before using context
        if (!mounted) return;

        // Find the updated address and set it as selected
        final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
        final updatedAddress = provider.addresses.firstWhere(
          (addr) => addr.id == address.id,
          orElse: () => address,
        );
        setState(() {
          selectedAddress = updatedAddress;
        });
      },
    );
  }

// Updated _addNewAddress method to use the reusable AddressFormBottomSheet
  Future<void> _addNewAddress() async {
    AddressFormBottomSheet.show(
      context,
      onAddressSaved: () async {
        // Refresh the address list and optionally set the new address as selected
        await fetchDataOfCustomer();

        // Check if widget is still mounted before using context
        if (!mounted) return;

        final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
        if (provider.addresses.isNotEmpty && selectedAddress == null) {
          // If no address was selected before, select the newly added one
          setState(() {
            selectedAddress = provider.addresses.last;
          });
        }
      },
    );
  }
}
