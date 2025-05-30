import 'package:event_app/utils/apiStatus/api_status.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/cart_screens/stepper_payment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider/get_user_provider.dart';
import '../../provider/checkout_provider/submit_checkout_information.dart';
import '../../provider/payment_address/country_picks_provider.dart';
import '../../provider/payment_address/create_address_provider.dart';
import '../../provider/payment_address/customer_address.dart';
import '../../core/styles/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/custom_toast.dart';
import '../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../core/widgets/custom_items_views/custom_textField_saveaddress.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../country_picker/country_pick_screen.dart';

class SaveAddressScreen extends StatefulWidget {
  final bool isEditable;
  final String tracked_start_checkout;
  final AddressModel? addressModel; // New field for customer data

  SaveAddressScreen({required this.tracked_start_checkout, this.isEditable = false, this.addressModel});

  @override
  _SaveAddressScreenState createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  int? defaultAddressId; // Default constant addressId if null
  String countryCode = '';
  bool _countryLoader = false;
  bool _isNameEditable = false; // Initially editable
  bool _isEmailEditable = false; // Initially editable
  bool _isPhoneEditable = false; // Initially editable
  bool _isCountryEditable = false; // Initially editable
  bool _isCityEditable = false; // Initially editable
  bool _isAddressEditable = false; // Initially editable
  bool _isZipCodeEditable = false; // Initially editable

  final _formKey = GlobalKey<FormState>();

  final _newAddressFocusNode = FocusNode();
  final _NameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _zipCodeFocusNode = FocusNode();

  final _newAddressController = TextEditingController();
  final _NamController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  late bool isLoggedIn = false;
  String? userName;
  String? userMail;

  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  /// +++++++++++++++++++ FUNCTION FOR POPULATE THE CUSTOMER ADDRESS ON THE BASIS OF /* isDefault = 1 */ FROM API   ============================
  CustomerAddressModels? customerAddresses;
  CustomerRecords? selectedAddress;
  CountryModels? countryModel;

  @override
  void initState() {
    super.initState();
    fetchCountryData();
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

  void populateData() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      print('ads ==> ${widget.addressModel?.zipCode}');

      if (widget.addressModel != null) {
        _newAddressController.text = widget.addressModel?.address ?? '';
        _NamController.text = widget.addressModel?.name ?? '';
        _emailController.text = widget.addressModel?.email ?? '';
        _phoneController.text = widget.addressModel?.phone ?? '';
        _countryController.text = findCountryNameUsingCode(widget.addressModel?.country ?? '');
        _cityController.text = widget.addressModel?.city ?? '';
        _addressController.text = widget.addressModel?.address ?? '';
        _zipCodeController.text = widget.addressModel?.zipCode ?? '';

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
          zip_code: widget.addressModel!.zipCode,
        );
      }

      if (widget.addressModel == null) {
        _isNameEditable = _isEmailEditable = _isPhoneEditable = _isCountryEditable = _isCityEditable = _isAddressEditable = _isZipCodeEditable = true;
      }

      await fetchDataOfCustomer();
      // _scrollController.addListener(_onScroll);
      await fetchUserData();
    });
  }

  String findCountryNameUsingCode(String code) {
    countryCode = code;
    final country = countryModel?.data?.list?.firstWhere((countryData) => countryData.value?.toLowerCase() == code.toLowerCase()).label ?? '';
    return country;
  }

  ///   +++++++++++++++++++++  FUNCTION FOR FETCH THE DATA OF CUSTOMER  ============================
  Future<void> fetchDataOfCustomer() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      final token = await SharedPreferencesUtil.getToken();
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
            CustomerRecords? address = list.firstWhere(
              (address) => address.isDefault == true,
              orElse: () => list[0],
            );

            selectedAddress = address;
            _newAddressController.text = address.fullAddress ?? 'Unknown Address';
            _NamController.text = address.name ?? 'Unknown Name';
            _emailController.text = address.email ?? 'Unknown Email';
            _phoneController.text = address.phone ?? 'Unknown Phone';
            _countryController.text = findCountryNameUsingCode(address.country ?? '');
            _cityController.text = address.city ?? 'Unknown City';
            _addressController.text = address.address ?? 'Unknown Address';
            _zipCodeController.text = address.zip_code ?? '';
            _isNameEditable = _isEmailEditable = _isPhoneEditable = _isCountryEditable = _isCityEditable = _isAddressEditable = false;
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

  /// +++++++++++++++++++ FUNCTION FOR FETCHING THE USER ADDRESS FROM API   ============================
  Future<void> fetchUserData() async {
    final token = await SharedPreferencesUtil.getToken();
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchUserData(token ?? '', context);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screeHeight = MediaQuery.sizeOf(context).height;
    final submitProvider = Provider.of<SubMitCheckoutInformationProvider>(context, listen: true);
    final addressProvider = Provider.of<AddressProvider>(context, listen: true);
    final providerUser = Provider.of<UserProvider>(context, listen: false);
    final customerAddressProvider = Provider.of<CustomerAddressProvider>(context, listen: true);
    final user = providerUser.user;

    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
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
                    // if (!widget.isEditable)
                    CustomFieldSaveAddress(
                      hintText: 'Add new address',
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
                            hintText: 'Full Name',
                            controller: _NamController,
                            focusNode: _NameFocusNode,
                            nextFocusNode: _emailFocusNode,
                            keyboardType: TextInputType.name,
                            displayName: user?.name ?? 'loading...',
                            isEditable: _isNameEditable,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required.";
                              }
                              return null;
                            },
                          ),
                          CustomFieldSaveAddress(
                            hintText: 'Email',
                            displayName: user?.email ?? 'loading...',
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            keyboardType: TextInputType.emailAddress,
                            nextFocusNode: _phoneFocusNode,
                            isEditable: _isEmailEditable,
                            // Use the flag here
                            formFieldValidator: Validator.email,
                          ),
                          CustomFieldSaveAddress(
                            hintText: 'Phone',
                            keyboardType: TextInputType.number,
                            controller: _phoneController,
                            focusNode: _phoneFocusNode,
                            nextFocusNode: _countryFocusNode,
                            isEditable: _isPhoneEditable,
                            formFieldValidator: Validator.phone,
                          ),
                          CustomFieldSaveAddress(
                            hintText: "Country",
                            controller: _countryController,
                            focusNode: _countryFocusNode,
                            nextFocusNode: _cityFocusNode,
                            isEditable: false,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Country field is required.";
                              }
                              return null;
                            },
                            suffixIcon: Icon(Icons.arrow_drop_down_outlined),
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
                                          countryCode = selectedCountry.value ?? '';
                                          _countryController.text = selectedCountry.label ?? '';
                                        });
                                      },
                                    ),
                                  );
                                }
                              } else {
                              }
                            },
                          ),
                          CustomFieldSaveAddress(
                            hintText: 'City',
                            controller: _cityController,
                            focusNode: _cityFocusNode,
                            keyboardType: TextInputType.text,
                            nextFocusNode: _addressFocusNode,
                            isEditable: _isCityEditable,
                            formFieldValidator: Validator.cityValidator,
                          ),
                          CustomFieldSaveAddress(
                            hintText: 'Address',
                            controller: _addressController,
                            focusNode: _addressFocusNode,
                            keyboardType: TextInputType.text,
                            nextFocusNode: _addressFocusNode,
                            isEditable: _isAddressEditable,
                            formFieldValidator: Validator.addressValidator,
                          ),
                          CustomFieldSaveAddress(
                            hintText: 'ZIP Code',
                            controller: _zipCodeController,
                            focusNode: _zipCodeFocusNode,
                            keyboardType: TextInputType.text,
                            isEditable: _isZipCodeEditable,
                            formFieldValidator: Validator.zipCode,
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
                                  padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                                  child: AppCustomButton(
                                    title: "Continue",
                                    onPressed: () async {
                                      final token = await SharedPreferencesUtil.getToken();
                                      // Ensure selectedAddress is set and use its ID
                                      int addressId = selectedAddress?.id ?? 0; // Use the addressId from selectedAddress
                                      var result = await Provider.of<SubMitCheckoutInformationProvider>(context, listen: false).submitCheckoutInformation(
                                        context: context,
                                        token: token ?? '',
                                        tracked_start_checkout: widget.tracked_start_checkout,
                                        address_id: addressId.toString(),
                                        name: _NamController.text,
                                        email: _emailController.text,
                                        city: _cityController.text,
                                        address: _addressController.text,
                                        phone: int.tryParse(_phoneController.text) ?? 0,
                                        country: countryCode,
                                        vendorId: 23,
                                        shippingMethod: "default",
                                        shippingOption: "3", // Replace with actual shipping option
                                      );

                                      if (result != null) {
                                        // Navigate to the next screen
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => StepperScreen(
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
                                  padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                                  child: Consumer<AddressProvider>(
                                    builder: (context, provider, child) {
                                      return AppCustomButton(
                                        title: "Save Address",
                                        isLoading: provider.isLoading,
                                        onPressed: () async {
                                          if (_formKey.currentState?.validate() ?? false) {
                                            _saveAddress();
                                          } else {
                                            CustomSnackbar.showError(context, "Please enter correct details.");
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                            ],
                          )
                        else
                          Padding(
                            padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                            child: AppCustomButton(
                              onPressed: () async {
                                final token = await SharedPreferencesUtil.getToken();

                                var result = await Provider.of<SubMitCheckoutInformationProvider>(context, listen: false).submitCheckoutInformation(
                                  context: context,
                                  token: token ?? '123456789',
                                  tracked_start_checkout: widget.tracked_start_checkout,
                                  address_id: selectedAddress?.id.toString() ?? "new",
                                  name: _NamController.text,
                                  email: _emailController.text,
                                  city: _cityController.text,
                                  address: _addressController.text,
                                  phone: int.tryParse(_phoneController.text) ?? 0,
                                  country: countryCode,
                                  vendorId: 23,
                                  shippingMethod: "default",
                                  shippingOption: "3", // Replace with actual shipping option
                                );

                                if (result != null) {
                                  Navigator.pop(context, true);
                                }
                              },
                              title: "Update Address",
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
              if (_countryLoader || submitProvider.isLoading || addressProvider.isLoading || customerAddressProvider.isLoadingAddresses)
                Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  child: Center(
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(2))),
      builder: (BuildContext context) {
        final screenWidth = MediaQuery.sizeOf(context).width;
        final screenHeight = MediaQuery.sizeOf(context).height;
        return Column(
          children: [
            Consumer<CustomerAddressProvider>(
              builder: (BuildContext context, CustomerAddressProvider provider, Widget? child) {
                if (provider.isLoadingAddresses && _currentPage == 1) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5),
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
                                    child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5),
                                  );
                                }

                                final address = provider.addresses[index];
                                return ListTile(
                                  title: Text(address.fullAddress ?? 'Unknown Address'),
                                  onTap: () {
                                    setState(() {
                                      selectedAddress = address;
                                      _newAddressController.text = address.fullAddress ?? 'Unknown Address';
                                      _NamController.text = address.name ?? 'Unknown Name';
                                      _emailController.text = address.email ?? 'Unknown Email';
                                      _phoneController.text = address.phone ?? 'Unknown Phone';
                                      _countryController.text = findCountryNameUsingCode(address.country ?? '');
                                      _cityController.text = address.city ?? 'Unknown City';
                                      _addressController.text = address.address ?? 'Unknown Address';
                                      _zipCodeController.text = address.zip_code ?? 'Unknown Zip code';

                                      _isNameEditable = _isEmailEditable = _isPhoneEditable = _isCountryEditable = _isCityEditable = _isAddressEditable = _isZipCodeEditable = false;
                                    });
                                    Navigator.of(context).pop(); // Close the bottom sheet
                                  },
                                );
                              },
                            )
                          else if (!provider.isLoading && provider.addresses.isEmpty)
                            Container(
                              width: screenWidth,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenHeight * 0.02),
                              color: AppColors.peachyPink.withOpacity(0.2),
                              child: Text("No record found!", style: GoogleFonts.inter(color: Colors.brown.shade600, fontWeight: FontWeight.w600)),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            if (!widget.isEditable)
              ListTile(
                title: Text("Add New Address", style: TextStyle(color: AppColors.peachyPink)),
                onTap: () {
                  setState(() {
                    selectedAddress = null; // Clear selected address for new entry
                    _newAddressController.clear();
                    _NamController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                    _countryController.clear();
                    _cityController.clear();
                    _addressController.clear();
                    _zipCodeController.clear();

                    _isNameEditable = _isEmailEditable = _isPhoneEditable = _isCountryEditable = _isCityEditable = _isAddressEditable = _isZipCodeEditable= true;
                  });
                  Navigator.of(context).pop(); // Close the bottom sheet
                },
              ),
          ],
        );
      },
    );
  }

  ///  +++++++++++++++++++++++++++++  FUNCTION FOR SAVE THE NEW ADDRESS OF THE CUSTOMER --------------------------------

  void _saveAddress() async {
    final token = await SharedPreferencesUtil.getToken();
    if (token == null) return;

    if (_formKey.currentState!.validate()) {
      AddressModel address = AddressModel(
        name: _NamController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        country: countryCode,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipCodeController.text,
        isDefault: true,
      );

      var result = await Provider.of<AddressProvider>(context, listen: false).saveAddress(address);

      if (result != null) {
        var resultSubmit = await Provider.of<SubMitCheckoutInformationProvider>(context, listen: false).submitCheckoutInformation(
          context: context,
          token: token ?? '123456789',
          tracked_start_checkout: widget.tracked_start_checkout,
          address_id: result.toString(),
          name: _NamController.text,
          email: _emailController.text,
          city: _cityController.text,
          address: _addressController.text,
          phone: int.tryParse(_phoneController.text) ?? 0,
          country: countryCode,
          vendorId: 23,
          shippingMethod: "default",
          shippingOption: "3", // Replace with actual shipping option
        );

        if (resultSubmit != null) {
          // Navigate to the next screen
          CustomSnackbar.showSuccess(context, "Address saved successfully!");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StepperScreen(
                tracked_start_checkout: widget.tracked_start_checkout,
              ),
            ),
          );
        }
      } else {
        CustomSnackbar.showError(context, "Please enter the valid details!");
      }
    }
    /*}*/
  }
}
