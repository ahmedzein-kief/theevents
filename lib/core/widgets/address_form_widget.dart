import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/helper/extensions/app_localizations_extension.dart';
import '../../../core/helper/validators/validator.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../models/wishlist_models/states_cities_models.dart';
import '../../../provider/payment_address/create_address_provider.dart';
import '../../../provider/payment_address/customer_address_provider.dart';
import '../../provider/payment_address/country_picks_provider.dart';
import '../../provider/payment_address/update_address_provider.dart';
import '../../views/country_picker/country_pick_screen.dart';
import '../network/api_status/api_status.dart';
import 'custom_items_views/custom_add_to_cart_button.dart';
import 'location_picker_field.dart';

class AddressFormWidget extends StatefulWidget {
  final CustomerRecords? existingAddress;
  final VoidCallback? onAddressSaved;
  final VoidCallback? onCancel;

  const AddressFormWidget({
    super.key,
    this.existingAddress,
    this.onAddressSaved,
    this.onCancel,
  });

  @override
  State<AddressFormWidget> createState() => _AddressFormWidgetState();
}

class _AddressFormWidgetState extends State<AddressFormWidget> {
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
    _disposeResources();
    super.dispose();
  }

  void _initializeData() {
    fetchCountryData();
    if (widget.existingAddress != null) {
      _populateAddressForm(widget.existingAddress!);
    }
  }

  void _disposeResources() {
    // Dispose controllers
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();

    // Dispose focus nodes
    _nameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _cityFocusNode.dispose();
  }

  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _populateAddressForm(CustomerRecords customerAddress) async {
    _nameController.text = customerAddress.name ?? '';
    _phoneController.text = customerAddress.phone ?? '';
    _emailController.text = customerAddress.email ?? '';
    _addressController.text = customerAddress.address ?? '';
    _countryController.text = customerAddress.country ?? '';
    _stateController.text = customerAddress.state ?? '';
    _cityController.text = customerAddress.city ?? '';
    _isChecked = customerAddress.isDefault == 1;

    // Set the IDs from existing address data
    if (customerAddress.countryId != null) {
      selectedCountryId = int.tryParse(customerAddress.countryId!);
    }

    // Wait for country data to load if it hasn't already
    if (countryModel?.data?.list?.isEmpty ?? true) {
      await fetchCountryData();
    }

    await _setupExistingAddressData(customerAddress);
    setState(() {});
  }

  Future<void> _setupExistingAddressData(CustomerRecords address) async {
    if (countryModel?.data?.list?.isNotEmpty == true) {
      // First try to find by ID, then fallback to name
      CountryList? countryRecord;

      if (address.countryId != null) {
        final countryIdInt = int.tryParse(address.countryId!);
        if (countryIdInt != null) {
          countryRecord = countryModel!.data!.list!.firstWhere(
            (element) => element.id == countryIdInt,
            orElse: () => countryModel!.data!.list!.firstWhere(
              (element) => element.name == address.country,
              orElse: () => countryModel!.data!.list!.first,
            ),
          );
        }
      }

      if (countryRecord == null && address.country != null) {
        countryRecord = countryModel!.data!.list!.firstWhere(
          (element) => element.name == address.country,
          orElse: () => countryModel!.data!.list!.first,
        );
      }

      if (countryRecord != null) {
        selectedCountryId = countryRecord.id;
        countryCode = countryRecord.code ?? '';

        if (selectedCountryId != null) {
          try {
            stateModel = await fetchStates(selectedCountryId!);

            if (stateModel?.data?.isNotEmpty == true) {
              // First try to find by ID, then fallback to name
              StateRecord? foundState;

              if (address.stateId != null) {
                final stateIdInt = int.tryParse(address.stateId!);
                if (stateIdInt != null) {
                  foundState = stateModel!.data!.firstWhere(
                    (element) => element.id == stateIdInt,
                    orElse: () => stateModel!.data!.firstWhere(
                      (element) => element.name == address.state,
                      orElse: () => stateModel!.data!.first,
                    ),
                  );
                }
              }

              if (foundState == null && address.state != null) {
                foundState = stateModel!.data!.firstWhere(
                  (element) => element.name == address.state,
                  orElse: () => stateModel!.data!.first,
                );
              }

              selectedState = foundState;

              if (selectedState?.id != null) {
                try {
                  // FIX: Check mounted before using context
                  if (!mounted) return;

                  cityModel = await fetchCities(
                    context,
                    selectedState!.id!,
                    selectedCountryId!,
                  );

                  if (cityModel?.data?.isNotEmpty == true) {
                    // First try to find by ID, then fallback to name
                    CityRecord? foundCity;

                    if (address.cityId != null) {
                      final cityIdInt = int.tryParse(address.cityId!);
                      if (cityIdInt != null) {
                        foundCity = cityModel!.data!.firstWhere(
                          (element) => element.id == cityIdInt,
                          orElse: () => cityModel!.data!.firstWhere(
                            (element) => element.name == address.city,
                            orElse: () => cityModel!.data!.first,
                          ),
                        );
                      }
                    }

                    if (foundCity == null && address.city != null) {
                      foundCity = cityModel!.data!.firstWhere(
                        (element) => element.name == address.city,
                        orElse: () => cityModel!.data!.first,
                      );
                    }

                    selectedCity = foundCity;
                  }
                } catch (error) {
                  debugPrint(error.toString());
                }
              }
            }
          } catch (error) {
            debugPrint(error.toString());
          }
        }
      }
    }
  }

  Future<void> fetchStateData(int countryId, {bool isEditingExisting = false}) async {
    try {
      setState(() {
        _stateLoader = true;
        if (!isEditingExisting) {
          _stateController.clear();
          _cityController.clear();
          selectedState = null;
          selectedCity = null;
        }
        stateModel = null;
        cityModel = null;
      });

      stateModel = await fetchStates(countryId);

      setState(() {
        _stateLoader = false;
      });
    } catch (error) {
      setState(() {
        _stateLoader = false;
      });
    }
  }

  Future<void> fetchCityData(int stateId, int countryId, {bool isEditingExisting = false}) async {
    try {
      setState(() {
        _cityLoader = true;
        if (!isEditingExisting) {
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
      setState(() {
        _cityLoader = false;
      });
    }
  }

  AddressModel _createAddressModel() {
    return AddressModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      country: countryCode,
      // Use IDs instead of names for city, state, and countryId
      city: selectedCity?.id?.toString() ?? widget.existingAddress?.cityId ?? '',
      state: selectedState?.id?.toString() ?? widget.existingAddress?.stateId ?? '',
      countryId: selectedCountryId?.toString() ?? widget.existingAddress?.countryId ?? '',
      // Keep these as IDs too for consistency
      stateId: selectedState?.id?.toString() ?? widget.existingAddress?.stateId ?? '',
      cityId: selectedCity?.id?.toString() ?? widget.existingAddress?.cityId ?? '',
      isDefault: _isChecked,
    );
  }

  Future<void> _saveAddress() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final AddressModel address = _createAddressModel();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;

    // FIX: Check mounted before using context
    if (!mounted) return;

    try {
      await Provider.of<AddressProvider>(context, listen: false).saveAddress(context, address);
      if (mounted && widget.onAddressSaved != null) {
        widget.onAddressSaved!();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<bool> _updateAddress(int addressId) async {
    final AddressModel address = _createAddressModel();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return false;

    // FIX: Check mounted before using context
    if (!mounted) return false;

    try {
      final response = await Provider.of<UpdateAddressProvider>(context, listen: false)
          .updateAddress(address, token, addressId, context);
      if (response && mounted && widget.onAddressSaved != null) {
        widget.onAddressSaved!();
      }
      return response;
    } catch (error) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
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
            LocationPickerField(
              hintText: AppStrings.country.tr,
              controller: _countryController,
              focusNode: _countryFocusNode,
              nextFocusNode: _stateFocusNode,
              isLoading: false,
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

                          _stateController.clear();
                          _cityController.clear();
                          selectedState = null;
                          selectedCity = null;
                          stateModel = null;
                          cityModel = null;
                        });

                        if (selectedCountryId != null) {
                          fetchStateData(selectedCountryId!);
                        }
                      },
                    ),
                  );
                }
              },
              formFieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.countryIsRequired.tr;
                }
                return null;
              },
            ),

            SizedBox(height: screenHeight * 0.01),

            // State Field
            LocationPickerField(
              hintText: AppStrings.state.tr,
              controller: _stateController,
              focusNode: _stateFocusNode,
              nextFocusNode: _cityFocusNode,
              isLoading: _stateLoader,
              onTap: () async {
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

                          _cityController.clear();
                          selectedCity = null;
                          cityModel = null;
                        });

                        if (selectedState?.id != null && selectedCountryId != null) {
                          fetchCityData(selectedState!.id!, selectedCountryId!);
                        }
                      },
                    ),
                  );
                }
              },
              formFieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.stateIsRequired.tr;
                }
                return null;
              },
            ),

            SizedBox(height: screenHeight * 0.01),

            // City Field
            LocationPickerField(
              hintText: AppStrings.city.tr,
              controller: _cityController,
              focusNode: _cityFocusNode,
              nextFocusNode: _addressFocusNode,
              isLoading: _cityLoader,
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
              formFieldValidator: (value) {
                if (value == null || value.isEmpty) {
                  return AppStrings.cityIsRequired.tr;
                }
                return null;
              },
            ),

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
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: Theme.of(context).colorScheme.onPrimary,
                    checkColor: Theme.of(context).colorScheme.primary,
                  ),
                  Text(
                    AppStrings.useDefaultAddress.tr,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            // Save/Update Button
            AppCustomButton(
              isLoading: context.watch<CustomerAddressProvider>().status == ApiStatus.loading,
              title: widget.existingAddress != null ? AppStrings.update.tr : AppStrings.save.tr,
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  if (widget.existingAddress != null) {
                    final int? id = widget.existingAddress!.id;
                    if (id != null) {
                      await _updateAddress(id);
                    }
                  } else {
                    await _saveAddress();
                  }
                }
              },
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
