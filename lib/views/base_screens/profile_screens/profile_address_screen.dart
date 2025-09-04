import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/network/api_status/api_status.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../models/wishlist_models/states_cities_models.dart';
import '../../../provider/payment_address/country_picks_provider.dart';
import '../../../provider/payment_address/create_address_provider.dart';
import '../../../provider/payment_address/customer_address.dart';
import '../../../provider/payment_address/customer_edit.dart';
import '../../country_picker/country_pick_screen.dart';

class ProfileAddressScreen extends StatefulWidget {
  const ProfileAddressScreen({super.key});

  @override
  State<ProfileAddressScreen> createState() => _ProfileAddressScreenState();
}

class _ProfileAddressScreenState extends State<ProfileAddressScreen> {
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
  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

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
    _initializeData();
  }

  @override
  void dispose() {
    _disposeControllers();
    _disposeFocusNodes();
    _scrollController.dispose();
    super.dispose();
  }

  // Initialization
  void _initializeData() {
    fetchCountryData();
    fetchDataOfCustomer();
    _scrollController.addListener(_onScroll);
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

  // Data fetching methods
  Future<void> fetchDataOfCustomer() async {
    if (!mounted) return;

    try {
      setState(() {
        _isFetchingMore = true;
      });

      final token = await SecurePreferencesUtil.getToken();
      if (token == null) return;

      final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
      await provider.fetchCustomerAddresses(
        token,
        context,
        perPage: 12,
        page: _currentPage,
      );

      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    } catch (error) {
      log('Error fetching customer data: $error');
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

// Update the fetchCountryData method in ProfileAddressScreen
  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
    } catch (error) {
      log('Error fetching countries: $error');
    }
  }

// Add this new method to handle existing address data
  Future<void> _setupExistingAddressData(CustomerRecords address) async {
    if (countryModel?.data?.list?.isNotEmpty == true) {
      final countryName = address.country;

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
        try {
          stateModel = await fetchStates(context, selectedCountryId!);

          // Find and set the matching state
          if (stateModel?.data?.isNotEmpty == true) {
            final stateName = address.state;

            selectedState = stateModel!.data!.firstWhere(
              (element) => element.name == stateName,
              orElse: () => stateModel!.data!.first, // fallback to first state
            );

            // Fetch cities for this state
            if (selectedState?.id != null) {
              try {
                cityModel = await fetchCities(
                  context,
                  selectedState!.id!,
                  selectedCountryId!,
                );

                // Find and set the matching city
                if (cityModel?.data?.isNotEmpty == true) {
                  final cityName = address.city;

                  selectedCity = cityModel!.data!.firstWhere(
                    (element) => element.name == cityName,
                    orElse: () => cityModel!.data!.first, // fallback to first city
                  );
                }
              } catch (error) {
                log('Error fetching cities for existing address: $error');
              }
            }
          }
        } catch (error) {
          log('Error fetching states for existing address: $error');
        }
      }
    }
  }

// Update the fetchStateData method to preserve existing selection when possible
  Future<void> fetchStateData(
    int countryId, {
    StateSetter? customSetState,
    bool isEditingExisting = false,
  }) async {
    final setStateFunction = customSetState ?? setState;

    try {
      setStateFunction(() {
        _stateLoader = true;
        // Don't clear controllers if we're editing existing data
        if (!isEditingExisting) {
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

      setStateFunction(() {
        _stateLoader = false;
      });

      log('_stateLoader $_stateLoader');
    } catch (error) {
      log('Error fetching states: $error');
      setStateFunction(() {
        _stateLoader = false;
      });
    }
  }

// Update the fetchCityData method to preserve existing selection when possible
  Future<void> fetchCityData(
    int stateId,
    int countryId, {
    StateSetter? customSetState,
    bool isEditingExisting = false,
  }) async {
    final setStateFunction = customSetState ?? setState;

    try {
      setStateFunction(() {
        _cityLoader = true;
        // Don't clear controller if we're editing existing data
        if (!isEditingExisting) {
          _cityController.clear();
          selectedCity = null;
        }
        cityModel = null;
      });

      cityModel = await fetchCities(context, stateId, countryId);

      setStateFunction(() {
        _cityLoader = false;
      });
    } catch (error) {
      log('Error fetching cities: $error');
      setStateFunction(() {
        _cityLoader = false;
      });
    }
  }

  // Scroll handling
  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchDataOfCustomer();
    }
  }

// Update the _populateAddressForm method
  Future<void> _populateAddressForm(CustomerRecords? customerAddress) async {
    if (customerAddress != null) {
      _nameController.text = customerAddress.name ?? '';
      _phoneController.text = customerAddress.phone ?? '';
      _emailController.text = customerAddress.email ?? '';
      _addressController.text = customerAddress.address ?? '';
      _countryController.text = customerAddress.country ?? '';
      _stateController.text = customerAddress.state ?? '';
      _cityController.text = customerAddress.city ?? '';

      // Set the default checkbox state
      _isChecked = customerAddress.isDefault == 1;

      // Setup existing address data (fetch states and cities)
      await _setupExistingAddressData(customerAddress);
    } else {
      _clearAddressForm();
    }
  }

  void _clearAddressForm() {
    _nameController.clear();
    _phoneController.clear();
    _emailController.clear();
    _addressController.clear();
    _countryController.clear();
    _stateController.clear();
    _cityController.clear();
    countryCode = '';
    selectedCountryId = null;
    selectedState = null;
    selectedCity = null;
    stateModel = null;
    cityModel = null;
    _isChecked = false;
  }

  // Address operations
  Future<void> _saveAddress() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final AddressModel address = _createAddressModel();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;

    try {
      await Provider.of<AddressProvider>(context, listen: false).saveAddress(address);
      await _refreshAddressList();
      if (mounted) {
        Navigator.pop(context);
        CustomSnackbar.showSuccess(context, AppStrings.addressSaved.tr);
      }
    } catch (error) {
      log('Error saving address: $error');
      if (mounted) {
        CustomSnackbar.showError(context, AppStrings.pleaseCheckFields.tr);
      }
    }
  }

  Future<bool> _updateAddress(int addressId) async {
    final AddressModel address = _createAddressModel();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return false;

    try {
      final response =
          await Provider.of<CustomerAddress>(context, listen: false).updateAddress(address, token, addressId, context);
      if (response) {
        await fetchDataOfCustomer();
      }
      return response;
    } catch (error) {
      log('Error updating address: $error');
      return false;
    }
  }

  Future<void> _refreshAddressList() async {
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;

    final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
    await provider.fetchCustomerAddresses(token, context);
  }

// Update the _createAddressModel to use proper IDs
  AddressModel _createAddressModel() {
    return AddressModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      country: countryCode,
      city: selectedCity?.id?.toString() ?? _cityController.text,
      state: selectedState?.id?.toString() ?? _stateController.text,
      countryId: selectedCountryId?.toString() ?? _countryController.text,
      stateId: selectedState?.id?.toString() ?? _stateController.text,
      cityId: selectedCity?.id?.toString() ?? _cityController.text,
      isDefault: _isChecked,
    );
  }

  // Dialog builders
// Update the _buildCountryField to handle existing data better
  Widget _buildCountryField(StateSetter bottomSheetSetState) {
    return CustomFieldProfileScreen(
      hintText: AppStrings.country.tr,
      controller: _countryController,
      focusNode: _countryFocusNode,
      nextFocusNode: _stateFocusNode,
      isEditable: false,
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.countryIsRequired.tr;
        }
        return null;
      },
      suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
      onTap: () async {
        if (countryModel?.data?.list?.isNotEmpty ?? false) {
          showDialog(
            context: context,
            builder: (context) => CountryPickerDialog(
              countryList: countryModel!.data!.list!,
              currentSelection: _countryController.text,
              onCountrySelected: (selectedCountry) {
                bottomSheetSetState(() {
                  countryCode = selectedCountry.code ?? '';
                  selectedCountryId = selectedCountry.id ?? 0;
                  _countryController.text = selectedCountry.name ?? '';

                  // Clear dependent fields when country changes
                  _stateController.clear();
                  _cityController.clear();
                  selectedState = null;
                  selectedCity = null;
                  stateModel = null;
                  cityModel = null;
                });

                if (selectedCountryId != null) {
                  fetchStateData(
                    selectedCountryId!,
                    customSetState: bottomSheetSetState,
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

// Update the _buildStateField to handle existing data better
  Widget _buildStateField(StateSetter bottomSheetSetState) {
    return CustomFieldProfileScreen(
      hintText: AppStrings.state.tr,
      controller: _stateController,
      focusNode: _stateFocusNode,
      nextFocusNode: _cityFocusNode,
      isEditable: false,
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.stateIsRequired.tr;
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
        if (stateModel?.data?.isNotEmpty ?? false) {
          showDialog(
            context: context,
            builder: (context) => StatePickerDialog(
              stateList: stateModel!.data!,
              currentSelection: selectedState,
              onStateSelected: (state) {
                bottomSheetSetState(() {
                  selectedState = state;
                  _stateController.text = selectedState?.name ?? '';

                  // Clear dependent fields when state changes
                  _cityController.clear();
                  selectedCity = null;
                  cityModel = null;
                });

                if (selectedState?.id != null && selectedCountryId != null) {
                  fetchCityData(
                    selectedState!.id!,
                    selectedCountryId!,
                    customSetState: bottomSheetSetState,
                  );
                }
              },
            ),
          );
        }
      },
    );
  }

// Update the _buildCityField to handle existing data better
  Widget _buildCityField(StateSetter bottomSheetSetState) {
    return CustomFieldProfileScreen(
      hintText: AppStrings.city.tr,
      controller: _cityController,
      focusNode: _cityFocusNode,
      nextFocusNode: _addressFocusNode,
      formFieldValidator: (value) {
        if (value == null || value.isEmpty) {
          return AppStrings.cityIsRequired.tr;
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
                bottomSheetSetState(() {
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

  // Bottom sheet
  void _formPageAddress(
    BuildContext context,
    CustomerRecords? customerAddress,
  ) {
    _populateAddressForm(customerAddress);

    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      builder: (context) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;

        return StatefulBuilder(
          builder: (context, bottomSheetSetState) {
            void toggleCheckBox(bool? value) {
              bottomSheetSetState(() {
                _isChecked = value ?? false;
              });
            }

            return FractionallySizedBox(
              heightFactor: 0.85,
              child: Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Name Field
                          CustomFieldProfileScreen(
                            hintText: AppStrings.enterYourName.tr,
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            nextFocusNode: _phoneFocusNode,
                            labelText: AppStrings.enterName.tr,
                            formFieldValidator: Validator.name,
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          // Phone Field
                          CustomFieldProfileScreen(
                            hintText: AppStrings.enterPhoneNumber.tr,
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            labelText: AppStrings.phone.tr,
                            nextFocusNode: _emailFocusNode,
                            keyboardType: TextInputType.number,
                            formFieldValidator: Validator.phone,
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          // Email Field
                          CustomFieldProfileScreen(
                            hintText: AppStrings.enterEmailAddress.tr,
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            labelText: AppStrings.email.tr,
                            keyboardType: TextInputType.emailAddress,
                            nextFocusNode: _addressFocusNode,
                            formFieldValidator: Validator.email,
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          SizedBox(height: screenHeight * 0.01),

                          // Address Field
                          CustomFieldProfileScreen(
                            hintText: AppStrings.enterAddress.tr,
                            controller: _addressController,
                            focusNode: _addressFocusNode,
                            labelText: ' ${AppStrings.address.tr}',
                            keyboardType: TextInputType.streetAddress,
                            nextFocusNode: _countryFocusNode,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.addressCannotBeEmpty.tr;
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          // Country Field
                          _buildCountryField(bottomSheetSetState),

                          SizedBox(height: screenHeight * 0.01),

                          // State Field
                          _buildStateField(bottomSheetSetState),

                          SizedBox(height: screenHeight * 0.01),

                          // City Field
                          _buildCityField(bottomSheetSetState),

                          // Default Address Checkbox
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.05,
                              vertical: screenHeight * 0.02,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: _isChecked,
                                  onChanged: toggleCheckBox,
                                  activeColor: Theme.of(context).colorScheme.onPrimary, // adapts to light/dark
                                  checkColor: Theme.of(context).colorScheme.primary, // contrast color
                                ),
                                Text(
                                  AppStrings.useDefaultAddress.tr,
                                  style: Theme.of(context).textTheme.bodyMedium, // also adapts
                                ),
                              ],
                            ),
                          ),

                          // Save/Update Button
                          AppCustomButton(
                            isLoading: context.watch<CustomerAddressProvider>().status == ApiStatus.loading,
                            title: customerAddress != null ? AppStrings.update.tr : AppStrings.save.tr,
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                if (customerAddress != null) {
                                  // Update existing address
                                  final int? id = customerAddress.id;
                                  if (id != null) {
                                    final success = await _updateAddress(id);
                                    if (success && mounted) {
                                      Navigator.pop(context);
                                    }
                                  }
                                } else {
                                  // Create new address
                                  await _saveAddress();
                                }
                              }
                            },
                          ),

                          SizedBox(height: screenHeight * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Address list item widget
  Widget _buildAddressItem(CustomerRecords address, double screenHeight) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.08),
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
          _buildAddressDetailRow(AppStrings.name.tr, address.name ?? ''),
          SizedBox(height: screenHeight * 0.01),
          _buildAddressDetailRow(AppStrings.email.tr, address.email ?? ''),
          SizedBox(height: screenHeight * 0.01),
          _buildAddressDetailRow(
            AppStrings.phone.tr,
            address.phone ?? '${AppStrings.loading.tr}...',
          ),
          SizedBox(height: screenHeight * 0.01),
          _buildAddressDetailRow(
            AppStrings.address.tr,
            address.fullAddress ?? '${AppStrings.loading.tr}...',
          ),
          SizedBox(height: screenHeight * 0.02),

          // Action buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Edit button
              GestureDetector(
                onTap: () => _formPageAddress(context, address),
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
                      if (mounted) {
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

  Widget _buildAddressDetailRow(String label, String value) {
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            BackAppBarStyle(
              icon: Icons.arrow_back_ios,
              text: AppStrings.myAccount.tr,
            ),

            SizedBox(height: screenHeight * 0.04),

            // Header with Create button
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.address.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  CustomAppButton(
                    buttonText: AppStrings.create.tr,
                    onTap: () => _formPageAddress(context, null),
                    prefixIcon: Icons.add,
                    buttonColor: AppColors.peachyPink,
                  ),
                ],
              ),
            ),

            // Address List
            Consumer<CustomerAddressProvider>(
              builder: (
                BuildContext context,
                CustomerAddressProvider provider,
                Widget? child,
              ) {
                if (provider.isLoadingAddresses && _currentPage == 1) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      strokeWidth: 0.5,
                    ),
                  );
                }

                return Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: screenHeight * 0.04,
                        left: screenWidth * 0.04,
                        right: screenWidth * 0.04,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (provider.isLoading) const Center(child: CircularProgressIndicator()),
                          if (provider.errorMessage != null) Center(child: Text(provider.errorMessage!)),
                          if (!provider.isLoading && provider.addresses.isNotEmpty)
                            ListView.builder(
                              itemCount: provider.addresses.length + (_isFetchingMore ? 1 : 0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (_isFetchingMore && index == provider.addresses.length) {
                                  return const Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final address = provider.addresses[index];
                                return _buildAddressItem(address, screenHeight);
                              },
                            ),
                          if (!provider.isLoading && provider.addresses.isEmpty)
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.only(
                                left: screenHeight * 0.02,
                                top: screenHeight * 0.01,
                                bottom: screenHeight * 0.01,
                              ),
                              color: AppColors.peachyPink.withOpacity(0.2),
                              child: Text(
                                AppStrings.noRecord.tr,
                                style: GoogleFonts.inter(
                                  color: Colors.brown.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
