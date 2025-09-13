import 'dart:developer';

import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/network/api_status/api_status.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:event_app/core/widgets/custom_profile_views/custom_text_field_view.dart';
import 'package:event_app/provider/payment_address/country_picks_provider.dart';
import 'package:event_app/provider/payment_address/create_address_provider.dart';
import 'package:event_app/provider/payment_address/customer_address.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_order_details_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_update_shipping_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/wishlist_models/states_cities_models.dart';
import '../../../views/country_picker/country_pick_screen.dart';

class VendorUpdateShippingAddressBottomSheetView extends StatefulWidget {
  const VendorUpdateShippingAddressBottomSheetView({
    super.key,
    required this.formKey,
    required this.onSave,
    required this.onUpdate,
    required this.customerAddress,
    required this.orderId,
    required this.shipmentId,
    this.showUseDefaultButton = true,
  });

  final GlobalKey<FormState> formKey;
  final String orderId;
  final String shipmentId;
  final VoidCallback onSave;
  final VoidCallback onUpdate;
  final CustomerRecords? customerAddress;
  final bool showUseDefaultButton;

  @override
  _VendorUpdateShippingAddressBottomSheetViewState createState() => _VendorUpdateShippingAddressBottomSheetViewState();
}

class _VendorUpdateShippingAddressBottomSheetViewState extends State<VendorUpdateShippingAddressBottomSheetView> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Focus Nodes
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();

  // State variables
  String countryCode = '';
  bool _isChecked = false;
  bool _isProcessing = false;

  // Location data
  CountryModels? countryModel;
  int? selectedCountryId;
  StateModels? stateModel;
  CityModels? cityModel;
  bool _stateLoader = false;
  bool _cityLoader = false;
  StateRecord? selectedState;
  CityRecord? selectedCity;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await fetchCountryData();
    });
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    super.dispose();
  }

  // Dispose methods
  void _disposeControllers() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();

    _addressController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
  }

  void _disposeFocusNodes() {
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();

    _addressFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();
  }

  // Utility methods
  void setProcessing(bool value) {
    if (mounted) {
      setState(() {
        _isProcessing = value;
      });
    }
  }

  void _toggleCheckBox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  // Replace your fetchCountryData method with this complete implementation
  Future<void> fetchCountryData() async {
    try {
      setProcessing(true);

      // Fetch all countries first
      countryModel = await fetchCountries(context);

      if (widget.customerAddress != null && countryModel?.data?.list?.isNotEmpty == true) {
        final countryName = widget.customerAddress?.country;

        // Find the country that matches the customer's address
        final countryRecord = countryModel!.data!.list!.firstWhere(
          (element) => element.name == countryName,
          orElse: () => countryModel!.data!.list!.first, // fallback to first country
        );

        // Set country data
        selectedCountryId = countryRecord.id;
        countryCode = countryRecord.code ?? '';

        // Fetch states for this country
        if (selectedCountryId != null) {
          stateModel = await fetchStates(context, selectedCountryId!);

          // Find and set the matching state
          if (stateModel?.data?.isNotEmpty == true) {
            final stateName = widget.customerAddress?.state;

            selectedState = stateModel!.data!.firstWhere(
              (element) => element.name == stateName,
              orElse: () => stateModel!.data!.first, // fallback to first state
            );

            // Fetch cities for this state
            if (selectedState?.id != null) {
              cityModel = await fetchCities(
                context,
                selectedState!.id!,
                selectedCountryId!,
              );

              // Find and set the matching city
              if (cityModel?.data?.isNotEmpty == true) {
                final cityName = widget.customerAddress?.city;

                selectedCity = cityModel!.data!.firstWhere(
                  (element) => element.name == cityName,
                  orElse: () => cityModel!.data!.first, // fallback to first city
                );
              }
            }
          }
        }

        // Populate the form with the existing address data
        _populateAddressForm();
      }

      setProcessing(false);
    } catch (error) {
      log('Error fetching countries: $error');
      setProcessing(false);
    }
  }

// Also update your _populateAddressForm method to handle the selected objects
  void _populateAddressForm() {
    final address = widget.customerAddress;

    if (address != null) {
      _nameController.text = address.name ?? '';
      _phoneController.text = address.phone ?? '';
      _emailController.text = address.email ?? '';

      _addressController.text = address.address ?? '';

      // Set country controller text
      _countryController.text = address.country ?? '';

      // Set state controller text
      _stateController.text = address.state ?? '';

      // Set city controller text
      _cityController.text = address.city ?? '';
    }
  }

// Update your fetchStateData method to preserve existing selection when possible
  Future<void> fetchStateData(int countryId) async {
    try {
      setState(() {
        _stateLoader = true;
        // Don't clear controllers if we're populating from existing data
        if (widget.customerAddress == null) {
          _stateController.clear();
          _cityController.clear();
          selectedState = null;
          selectedCity = null;
        }
        stateModel = null;
        cityModel = null;
      });

      stateModel = await fetchStates(context, countryId);

      log('STATE MODEL ${stateModel?.data?.length.toString() ?? 'No data'}');

      setState(() {
        _stateLoader = false;
      });
    } catch (error) {
      log('Error fetching states: $error');
      setState(() {
        _stateLoader = false;
      });
    }
  }

// Update your fetchCityData method to preserve existing selection when possible
  Future<void> fetchCityData(int stateId, int countryId) async {
    try {
      setState(() {
        _cityLoader = true;
        // Don't clear controller if we're populating from existing data
        if (widget.customerAddress == null) {
          _cityController.clear();
          selectedCity = null;
        }
        cityModel = null;
      });

      cityModel = await fetchCities(context, stateId, countryId);

      setState(() {
        _cityLoader = false;
      });
    } catch (error) {
      log('Error fetching cities: $error');
      setState(() {
        _cityLoader = false;
      });
    }
  }

  // UI Builder methods
  Widget _buildCountryField() {
    return CustomFieldProfileScreen(
      isEditable: false,
      hintText: VendorAppStrings.enterCountry.tr,
      controller: _countryController,
      focusNode: _countryFocusNode,
      labelText: VendorAppStrings.enterCountry.tr,
      nextFocusNode: _stateFocusNode,
      suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select country.';
        }
        return null;
      },
      onTap: () async {
        if (countryModel?.data?.list?.isNotEmpty ?? false) {
          showDialog(
            context: context,
            builder: (context) => CountryPickerDialog(
              countryList: countryModel!.data!.list!,
              currentSelection: _countryController.text,
              onCountrySelected: (selectedCountry) {
                setState(() {
                  countryCode = selectedCountry.code ?? '';
                  selectedCountryId = selectedCountry.id ?? 0;
                  _countryController.text = selectedCountry.name ?? '';
                });

                if (selectedCountryId != null) {
                  fetchStateData(selectedCountryId!);
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildStateField() {
    return CustomFieldProfileScreen(
      hintText: VendorAppStrings.enterState.tr,
      controller: _stateController,
      focusNode: _stateFocusNode,
      labelText: VendorAppStrings.state.tr,
      nextFocusNode: _cityFocusNode,
      isEditable: false,
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'State is required.';
        }
        return null;
      },
      suffixIcon: _stateLoader
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.peachyPink,
                ),
              ),
            )
          : const Icon(Icons.arrow_drop_down_outlined),
      onTap: () async {
        log('stateModel?.data?.isNotEmpty  ${stateModel?.data?.isNotEmpty}');
        if (stateModel?.data?.isNotEmpty ?? false) {
          showDialog(
            context: context,
            builder: (context) => StatePickerDialog(
              stateList: stateModel!.data!,
              currentSelection: selectedState,
              onStateSelected: (state) {
                setState(() {
                  selectedState = state;
                  _stateController.text = selectedState?.name ?? '';
                });

                if (selectedState?.id != null && selectedCountryId != null) {
                  fetchCityData(selectedState!.id!, selectedCountryId!);
                }
              },
            ),
          );
        }
      },
    );
  }

  Widget _buildCityField() {
    return CustomFieldProfileScreen(
      hintText: VendorAppStrings.enterCity.tr,
      controller: _cityController,
      focusNode: _cityFocusNode,
      labelText: VendorAppStrings.city.tr,
      nextFocusNode: _cityFocusNode,
      isEditable: false,
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'City cannot be empty.';
        }
        return null;
      },
      suffixIcon: _cityLoader
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.peachyPink,
                ),
              ),
            )
          : const Icon(Icons.arrow_drop_down_outlined),
      onTap: () async {
        if (cityModel?.data?.isNotEmpty ?? false) {
          showDialog(
            context: context,
            builder: (context) => CityPickerDialog(
              cityList: cityModel!.data!,
              currentSelection: selectedCity,
              onCitySelected: (city) {
                setState(() {
                  selectedCity = city;
                  _cityController.text = selectedCity?.name ?? '';
                });
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
      heightFactor: 0.85,
      child: Scaffold(
        body: SafeArea(
          child: AppUtils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Name Field
                    CustomFieldProfileScreen(
                      hintText: 'Enter your name',
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _phoneFocusNode,
                      labelText: 'Enter Name',
                      formFieldValidator: Validator.name,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Phone Field
                    CustomFieldProfileScreen(
                      hintText: 'Enter phone Number',
                      controller: _phoneController,
                      focusNode: _phoneFocusNode,
                      labelText: 'Phone',
                      nextFocusNode: _emailFocusNode,
                      keyboardType: TextInputType.number,
                      formFieldValidator: Validator.phone,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Email Field
                    CustomFieldProfileScreen(
                      hintText: 'Enter Email address',
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      labelText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      nextFocusNode: _addressFocusNode,
                      formFieldValidator: Validator.emailOptional,
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Address Field
                    CustomFieldProfileScreen(
                      hintText: VendorAppStrings.enterAddress.tr,
                      controller: _addressController,
                      focusNode: _addressFocusNode,
                      labelText: VendorAppStrings.enterAddress.tr,
                      keyboardType: TextInputType.streetAddress,
                      nextFocusNode: _countryFocusNode,
                      formFieldValidator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address cannot be empty.';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: screenHeight * 0.01),

                    // Country Field
                    _buildCountryField(),

                    SizedBox(height: screenHeight * 0.01),

                    // State Field
                    _buildStateField(),

                    SizedBox(height: screenHeight * 0.01),

                    // City Field
                    _buildCityField(),

                    // Use Default Address Checkbox
                    if (!widget.showUseDefaultButton) kSmallSpace,

                    if (widget.showUseDefaultButton)
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.05,
                          vertical: screenHeight * 0.02,
                        ),
                        child: Row(
                          children: [
                            Checkbox(
                              focusColor: Colors.black,
                              activeColor: Theme.of(context).colorScheme.onPrimary,
                              checkColor: Theme.of(context).colorScheme.primary,
                              value: _isChecked,
                              onChanged: _toggleCheckBox,
                            ),
                            Text(VendorAppStrings.useThisDefaultAddress.tr),
                          ],
                        ),
                      ),

                    // Update Button
                    ChangeNotifierProvider(
                      create: (context) => VendorUpdateShippingAddressViewModel(),
                      child: Consumer<VendorUpdateShippingAddressViewModel>(
                        builder: (context, provider, _) => AppCustomButton(
                          isLoading: provider.apiResponse.status == ApiStatus.loading,
                          title: VendorAppStrings.update.tr,
                          onPressed: () async {
                            try {
                              if (_formKey.currentState?.validate() ?? false) {
                                final AddressModel address = AddressModel(
                                  id: widget.orderId,
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address: _addressController.text,
                                  country: countryCode,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  countryId: _countryController.text,
                                  stateId: _stateController.text,
                                  cityId: _cityController.text,
                                );

                                final form = address.vendorOrderDetailsUpdateShippingAddressToJson();

                                final result = await provider.vendorUpdateShippingAddress(
                                  shippingID: widget.shipmentId.toString(),
                                  form: form,
                                  context: context,
                                );

                                if (result) {
                                  // Refresh the order detail page
                                  context.read<VendorGetOrderDetailsViewModel>().vendorGetOrderDetails(
                                        orderId: widget.orderId,
                                      );

                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              }
                            } catch (e) {
                              log('Error while updating address: $e');
                            }
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: screenHeight * 0.02),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
