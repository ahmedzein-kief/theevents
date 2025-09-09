import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/cart_screens/stepper_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/app_colors.dart';
import '../../core/utils/custom_toast.dart';
import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../core/widgets/custom_items_views/custom_textField_saveaddress.dart';
import '../../models/wishlist_models/states_cities_models.dart';
import '../../provider/auth_provider/get_user_provider.dart';
import '../../provider/checkout_provider/submit_checkout_information.dart';
import '../../provider/payment_address/country_picks_provider.dart';
import '../../provider/payment_address/create_address_provider.dart';
import '../../provider/payment_address/customer_address.dart';
import '../../provider/payment_address/customer_edit.dart';
import '../country_picker/country_pick_screen.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({
    super.key,
    required this.tracked_start_checkout,
    this.isEditable = false,
    this.addressModel,
  });

  final bool isEditable;
  final String tracked_start_checkout;
  final AddressModel? addressModel;

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  int? defaultAddressId;
  String countryCode = '';
  bool _countryLoader = false;
  bool _isNameEditable = false;
  bool _isEmailEditable = false;
  bool _isPhoneEditable = false;
  bool _isCountryEditable = false;
  bool _isStateEditable = false;
  bool _isCityEditable = false;
  bool _isAddressEditable = false;
  bool isNewAddress = false; // Tracks whether a new address is being added

  final _formKey = GlobalKey<FormState>();

  final _newAddressFocusNode = FocusNode();
  final _NameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();

  final _newAddressController = TextEditingController();
  final _NamController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();

  late bool isLoggedIn = false;
  String? userName;
  String? userMail;

  final int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  CustomerAddressModels? customerAddresses;
  CustomerRecords? selectedAddress;
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
    fetchCountryData();
    isNewAddress = widget.addressModel == null; // Initialize based on addressModel
  }

  Future<void> fetchCountryData() async {
    try {
      _countryLoader = true;
      countryModel = await fetchCountries(context);
      _countryLoader = false;
      populateData();
    } catch (error) {
      _countryLoader = false;
    }
  }

  Future<void> fetchStateData(int countryId) async {
    try {
      setState(() {
        _stateLoader = true;
        _stateController.clear();
        _cityController.clear();
        selectedState = null;
        selectedCity = null;
        stateModel = null;
        cityModel = null;
      });

      stateModel = await fetchStates(context, countryId);

      setState(() {
        _stateLoader = false;
        _isStateEditable = true;
      });
    } catch (error) {
      setState(() {
        _stateLoader = false;
      });
    }
  }

  Future<void> fetchCityData(int stateId, int countryId) async {
    try {
      setState(() {
        _cityLoader = true;
        _cityController.clear();
        selectedCity = null;
        cityModel = null;
      });

      cityModel = await fetchCities(context, stateId, countryId);

      setState(() {
        _cityLoader = false;
        _isCityEditable = true;
      });
    } catch (error) {
      setState(() {
        _cityLoader = false;
      });
    }
  }

  void populateData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.addressModel != null) {
        _newAddressController.text = widget.addressModel?.address ?? '';
        _NamController.text = widget.addressModel?.name ?? '';
        _emailController.text = widget.addressModel?.email ?? '';
        _phoneController.text = widget.addressModel?.phone ?? '';
        _countryController.text = widget.addressModel?.country ?? '';
        _stateController.text = widget.addressModel?.state ?? '';
        _cityController.text = widget.addressModel?.city ?? '';
        _addressController.text = widget.addressModel?.address ?? '';

        selectedAddress = CustomerRecords(
          id: int.parse(widget.addressModel!.id),
          name: widget.addressModel!.name,
          email: widget.addressModel!.email,
          isDefault: widget.addressModel!.isDefault ? 1 : 0,
          fullAddress: widget.addressModel!.address,
          phone: widget.addressModel!.phone,
          country: widget.addressModel!.country,
          address: widget.addressModel!.address,
          state: widget.addressModel!.state,
        );
      }

      if (widget.addressModel == null) {
        _isNameEditable = _isEmailEditable =
            _isPhoneEditable = _isCountryEditable = _isStateEditable = _isCityEditable = _isAddressEditable = true;
      }

      await fetchDataOfCustomer();
      await fetchUserData();
    });
  }

  String findSt(String code) {
    countryCode = code;
    final country = countryModel?.data?.list
            ?.firstWhere(
              (countryData) => countryData.iso?.toLowerCase() == code.toLowerCase(),
            )
            .name ??
        '';
    return country;
  }

  Future<void> fetchDataOfCustomer() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      final token = await SecurePreferencesUtil.getToken();
      final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
      final result = await provider.fetchCustomerAddresses(
        token ?? '',
        context,
        perPage: 12,
        page: _currentPage,
      );

      if (!widget.isEditable) {
        setState(() {
          final list = result?.data?.records ?? [];

          if (list.isNotEmpty) {
            final CustomerRecords address = list.firstWhere(
              (address) => address.isDefault == 1,
              orElse: () => list.first,
            );

            selectedAddress = address;
            _newAddressController.text = address.fullAddress ?? AppStrings.unknownAddress.tr;
            _NamController.text = address.name ?? AppStrings.unknownName.tr;
            _emailController.text = address.email ?? AppStrings.unknownEmail.tr;
            _phoneController.text = address.phone ?? AppStrings.unknownPhone.tr;
            _countryController.text = address.country ?? '';
            _stateController.text = address.state ?? '';
            _cityController.text = address.city ?? '';
            _addressController.text = address.address ?? AppStrings.unknownAddress.tr;

            // Check if country is null or empty to enable country selection
            final bool hasCountry = address.country != null && address.country!.isNotEmpty;
            final bool hasState = address.state != null && address.state!.isNotEmpty;
            final bool hasCity = address.city != null && address.city!.isNotEmpty;

            _isNameEditable = false;
            _isEmailEditable = false;
            _isPhoneEditable = false;
            _isCountryEditable = !hasCountry; // Enable if country is missing
            _isStateEditable = !hasState; // Enable if state is missing
            _isCityEditable = !hasCity; // Enable if city is missing
            _isAddressEditable = false;

            isNewAddress = false; // Existing address selected
          }
        });
      }

      setState(() {
        _isFetchingMore = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  Future<void> fetchUserData() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchUserData(token ?? '', context);
  }

  Future<bool> _updateAddress(int addressId) async {
    final AddressModel address = _createAddressModel();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return false;

    try {
      final response =
          await Provider.of<CustomerAddress>(context, listen: false).updateAddress(address, token, addressId, context);
      if (response) {
        // Refresh the address list after update
        await _refreshAddressList();
      }
      return response;
    } catch (error) {
      log('Error updating address: $error');
      return false;
    }
  }

  // Add helper method to create AddressModel
  AddressModel _createAddressModel() {
    return AddressModel(
      name: _NamController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      country: countryCode.isNotEmpty ? countryCode : _countryController.text,
      city: selectedCity?.id?.toString() ?? _cityController.text,
      state: selectedState?.id?.toString() ?? _stateController.text,
      countryId: selectedCountryId?.toString() ?? _countryController.text,
      stateId: selectedState?.id?.toString() ?? _stateController.text,
      cityId: selectedCity?.id?.toString() ?? _cityController.text,
      isDefault: selectedAddress?.isDefault == 1 ? true : false,
    );
  }

// Add helper method to refresh address list
  Future<void> _refreshAddressList() async {
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;

    final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
    await provider.fetchCustomerAddresses(token, context);

    // Update selectedAddress with latest data if it exists
    if (selectedAddress != null) {
      final updatedAddress = provider.addresses.firstWhere(
        (addr) => addr.id == selectedAddress!.id,
        orElse: () => selectedAddress!,
      );
      selectedAddress = updatedAddress;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screeHeight = MediaQuery.sizeOf(context).height;
    final submitProvider = Provider.of<SubMitCheckoutInformationProvider>(context, listen: true);
    final addressProvider = Provider.of<AddressProvider>(context, listen: true);
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    final customerAddressProvider = Provider.of<CustomerAddressProvider>(context, listen: true);
    final user = providerUser.user;

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: screeHeight * 0.02),
                    CustomFieldSaveAddress(
                      hintText: AppStrings.addNewAddress.tr,
                      focusNode: _newAddressFocusNode,
                      nextFocusNode: _NameFocusNode,
                      isEditable: false,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      controller: _newAddressController,
                      onTap: () async {
                        _showAddressBottomSheet();
                      },
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomFieldSaveAddress(
                            hintText: AppStrings.fullName.tr,
                            controller: _NamController,
                            focusNode: _NameFocusNode,
                            nextFocusNode: _emailFocusNode,
                            keyboardType: TextInputType.name,
                            displayName: user?.name ?? '${AppStrings.loading.tr}...',
                            isEditable: _isNameEditable,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppStrings.nameIsRequired.tr;
                              }
                              return null;
                            },
                          ),
                          CustomFieldSaveAddress(
                            hintText: AppStrings.email.tr,
                            displayName: user?.email ?? '${AppStrings.loading.tr}...',
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            nextFocusNode: _phoneFocusNode,
                            isEditable: _isEmailEditable,
                            formFieldValidator: Validator.email,
                          ),
                          CustomFieldSaveAddress(
                            hintText: AppStrings.phone.tr,
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            nextFocusNode: _countryFocusNode,
                            isEditable: _isPhoneEditable,
                            formFieldValidator: Validator.phone,
                          ),
                          CustomFieldSaveAddress(
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
                              if (_isCountryEditable) {
                                if (countryModel != null && countryModel?.data != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CountryPickerDialog(
                                      countryList: countryModel?.data?.list ?? [],
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
                              }
                            },
                          ),
                          CustomFieldSaveAddress(
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
                              if (_isStateEditable) {
                                if (countryModel != null && countryModel?.data != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => StatePickerDialog(
                                      stateList: stateModel?.data ?? [],
                                      currentSelection: selectedState,
                                      onStateSelected: (state) {
                                        setState(() {
                                          selectedState = state;
                                          _stateController.text = selectedState?.name ?? '';
                                        });
                                        if (selectedState != null &&
                                            selectedState?.id != null &&
                                            selectedCountryId != null) {
                                          fetchCityData(
                                            selectedState!.id!,
                                            selectedCountryId!,
                                          );
                                        }
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                          CustomFieldSaveAddress(
                            hintText: AppStrings.city.tr,
                            controller: _cityController,
                            focusNode: _cityFocusNode,
                            nextFocusNode: _addressFocusNode,
                            isEditable: _isCityEditable,
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
                              if (_isCityEditable) {
                                if (stateModel != null && stateModel?.data != null && selectedState != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) => CityPickerDialog(
                                      cityList: cityModel?.data ?? [],
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
                              }
                            },
                          ),
                          CustomFieldSaveAddress(
                            hintText: AppStrings.address.tr,
                            controller: _addressController,
                            focusNode: _addressFocusNode,
                            keyboardType: TextInputType.text,
                            isEditable: _isAddressEditable,
                            formFieldValidator: Validator.addressValidator,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        if (!widget.isEditable)
                          Column(
                            children: [
                              if (selectedAddress != null)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: AppCustomButton(
                                    title: AppStrings.continueButton.tr,
                                    onPressed: () async {
                                      final token = await SecurePreferencesUtil.getToken();

                                      final bool needsUpdate = selectedAddress != null &&
                                          ((selectedAddress!.country == null || selectedAddress!.country!.isEmpty) ||
                                              (selectedAddress!.state == null || selectedAddress!.state!.isEmpty) ||
                                              (selectedAddress!.city == null || selectedAddress!.city!.isEmpty));

                                      if (needsUpdate && (_isCountryEditable || _isStateEditable || _isCityEditable)) {
                                        // Validate the form first
                                        if (!(_formKey.currentState?.validate() ?? false)) {
                                          CustomSnackbar.showError(
                                            context,
                                            AppStrings.enterCorrectDetails.tr,
                                          );
                                          return;
                                        }

                                        // Update the existing address with new data
                                        final updateSuccess = await _updateAddress(selectedAddress!.id!);

                                        if (!updateSuccess) {
                                          CustomSnackbar.showError(
                                            context,
                                            'Please Enter Valid Data', // Add this to your strings
                                          );
                                          return;
                                        }
                                      }

                                      final int addressId = selectedAddress?.id ?? 0;
                                      final result = await Provider.of<SubMitCheckoutInformationProvider>(
                                        context,
                                        listen: false,
                                      ).submitCheckoutInformation(
                                        context: context,
                                        token: token ?? '',
                                        trackedStartCheckout: widget.tracked_start_checkout,
                                        addressId: addressId.toString(),
                                        name: _NamController.text,
                                        email: _emailController.text,
                                        city: _cityController.text,
                                        state: _stateController.text,
                                        address: _addressController.text,
                                        phone: int.tryParse(_phoneController.text) ?? 0,
                                        country: countryCode,
                                        vendorId: 23,
                                        shippingMethod: 'default',
                                        shippingOption: '3',
                                      );

                                      if (result != null) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StepperScreen(
                                              isNewAddress: isNewAddress,
                                              tracked_start_checkout: widget.tracked_start_checkout,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 20,
                                    left: 5,
                                    right: 5,
                                  ),
                                  child: Consumer<AddressProvider>(
                                    builder: (context, provider, child) => AppCustomButton(
                                      title: AppStrings.saveAddress.tr,
                                      isLoading: provider.isLoading,
                                      onPressed: () async {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          await _saveAddress();
                                        } else {
                                          CustomSnackbar.showError(
                                            context,
                                            AppStrings.enterCorrectDetails.tr,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),
                            ],
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 5,
                              right: 5,
                            ),
                            child: AppCustomButton(
                              onPressed: () async {
                                final token = await SecurePreferencesUtil.getToken();

                                final result = await Provider.of<SubMitCheckoutInformationProvider>(
                                  context,
                                  listen: false,
                                ).submitCheckoutInformation(
                                  context: context,
                                  token: token ?? '123456789',
                                  trackedStartCheckout: widget.tracked_start_checkout,
                                  addressId: selectedAddress?.id.toString() ?? 'new',
                                  name: _NamController.text,
                                  email: _emailController.text,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  address: _addressController.text,
                                  phone: int.tryParse(_phoneController.text) ?? 0,
                                  country: countryCode,
                                  vendorId: 23,
                                  shippingMethod: 'default',
                                  shippingOption: '3',
                                );

                                if (result != null) {
                                  Navigator.pop(context, true);
                                }
                              },
                              title: AppStrings.updateAddress.tr,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (_countryLoader ||
                  submitProvider.isLoading ||
                  addressProvider.isLoading ||
                  customerAddressProvider.isLoadingAddresses)
                Container(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()),
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddressBottomSheet() {
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
      ),
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final screenHeight = MediaQuery.sizeOf(context).height;
        return Column(
          children: [
            if (!widget.isEditable)
              ListTile(
                title: Text(
                  '${AppStrings.addNewAddressTitle.tr}...',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                //
                onTap: () {
                  setState(() {
                    selectedAddress = null;
                    _newAddressController.clear();
                    _NamController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _countryController.clear();
                    _cityController.clear();
                    _stateController.clear();
                    _addressController.clear();

                    _isNameEditable = _isEmailEditable = _isPhoneEditable =
                        _isCountryEditable = _isStateEditable = _isCityEditable = _isAddressEditable = true;
                    isNewAddress = true; // New address being added
                  });
                  Navigator.of(context).pop();
                },
              ),
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
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!provider.isLoading && provider.addresses.isNotEmpty)
                            ListView.builder(
                              itemCount: provider.addresses.length + (_isFetchingMore ? 1 : 0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (_isFetchingMore && index == provider.addresses.length) {
                                  return const Align(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                      strokeWidth: 0.5,
                                    ),
                                  );
                                }

                                final address = provider.addresses[index];
                                return ListTile(
                                  title: Text(
                                    address.fullAddress ?? 'Unknown Address',
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedAddress = address;
                                      _newAddressController.text = address.fullAddress ?? AppStrings.unknownAddress.tr;
                                      _NamController.text = address.name ?? AppStrings.unknownName.tr;
                                      _emailController.text = address.email ?? AppStrings.unknownEmail.tr;
                                      _phoneController.text = address.phone ?? AppStrings.unknownPhone.tr;
                                      _countryController.text = address.country ?? '';
                                      _cityController.text = address.city ?? '';
                                      _stateController.text = address.state ?? '';
                                      _addressController.text = address.address ?? AppStrings.unknownAddress.tr;

                                      // Check if country is null or empty to enable country selection
                                      final bool hasCountry = address.country != null && address.country!.isNotEmpty;
                                      final bool hasState = address.state != null && address.state!.isNotEmpty;
                                      final bool hasCity = address.city != null && address.city!.isNotEmpty;

                                      _isNameEditable = false;
                                      _isEmailEditable = false;
                                      _isPhoneEditable = false;
                                      _isCountryEditable = !hasCountry; // Enable if country is missing
                                      _isStateEditable = !hasState; // Enable if state is missing
                                      _isCityEditable = !hasCity; // Enable if city is missing
                                      _isAddressEditable = false;

                                      isNewAddress = false; // Existing address selected
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            )
                          else if (!provider.isLoading && provider.addresses.isEmpty)
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01,
                                horizontal: screenHeight * 0.02,
                              ),
                              color: AppColors.peachyPink.withOpacity(0.2),
                              child: Text(
                                AppStrings.noRecordsFound.tr,
                                style: GoogleFonts.inter(
                                  color: Colors.brown.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
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

  Future<void> _saveAddress() async {
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;

    if (_formKey.currentState!.validate()) {
      if (selectedCity == null || selectedState == null) {
        CustomSnackbar.showError(context, 'Please select city and state');
        return;
      }
      final AddressModel address = AddressModel(
        name: _NamController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        country: _countryController.text,
        city: selectedCity!.id.toString(),
        state: selectedState!.id.toString(),
        countryId: selectedCountryId.toString(),
        stateId: selectedState!.id.toString(),
        cityId: selectedCity!.id.toString(),
        isDefault: true,
      );

      final result = await Provider.of<AddressProvider>(context, listen: false).saveAddress(context, address);

      if (result != null) {
        final resultSubmit = await Provider.of<SubMitCheckoutInformationProvider>(
          context,
          listen: false,
        ).submitCheckoutInformation(
          context: context,
          token: token,
          trackedStartCheckout: widget.tracked_start_checkout,
          addressId: result.toString(),
          name: _NamController.text,
          email: _emailController.text,
          city: _cityController.text,
          state: _stateController.text,
          address: _addressController.text,
          phone: int.tryParse(_phoneController.text) ?? 0,
          country: _countryController.text,
          vendorId: 23,
          shippingMethod: 'default',
          shippingOption: '3',
        );

        if (resultSubmit != null) {
          CustomSnackbar.showSuccess(
            context,
            AppStrings.addressSavedSuccess.tr,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StepperScreen(
                isNewAddress: isNewAddress,
                tracked_start_checkout: widget.tracked_start_checkout,
              ),
            ),
          );
        }
      } else {
        CustomSnackbar.showError(context, AppStrings.enterValidDetails.tr);
      }
    }
  }
}
