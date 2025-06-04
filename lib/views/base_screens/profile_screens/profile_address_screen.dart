import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/network/api_status/api_status.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../provider/payment_address/country_picks_provider.dart';
import '../../../provider/payment_address/create_address_provider.dart';
import '../../../provider/payment_address/customer_address.dart';
import '../../../provider/payment_address/customer_edit.dart';

class ProfileAddressScreen extends StatefulWidget {
  const ProfileAddressScreen({super.key});

  @override
  State<ProfileAddressScreen> createState() => _ProfileAddressScreenState();
}

class _ProfileAddressScreenState extends State<ProfileAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  String countryCode = '';

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _zipFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _countryFocusNode = FocusNode();
  final FocusNode _stateFocusNode = FocusNode();
  final FocusNode _cityFocusNode = FocusNode();

  bool _isChecked = false;

  int _currentPage = 1;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();
  CountryModels? countryModel;

  @override
  void initState() {
    fetchCountryData();
    fetchDataOfCustomer();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  ///  -------------------- FUNCTION FOR FETCH THE DATA OF THE CUSTOMER ------------------------
  Future<void> fetchDataOfCustomer() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      final token = await SecurePreferencesUtil.getToken();
      final provider =
          Provider.of<CustomerAddressProvider>(context, listen: false);
      await provider.fetchCustomerAddresses(
        token ?? '',
        context,
        perPage: 12,
        page: _currentPage,
      );
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

  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
    } catch (error) {}
  }

  String findCountryNameUsingCode(String code) {
    countryCode = code;
    return countryModel?.data?.list
            ?.firstWhere((countryData) => countryData.value == code)
            .label ??
        '';
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchDataOfCustomer();
    }
  }

  /// ---------------------  FUNCTION FOR OPEN THE BOTTOM SHEET TO CREATE THE ADDRESS --------------------------
  void _formPageAddress(
      BuildContext context, CustomerRecords? customerAddress) {
    /// ------------- FOR EDITING THE ADDRESS -------------------
    if (customerAddress != null) {
      _nameController.text = customerAddress.name ?? '';
      _phoneController.text = customerAddress.phone ?? '';
      _emailController.text = customerAddress.email ?? '';
      _zipController.text = customerAddress.zip_code ?? '';
      _addressController.text = customerAddress.address ?? '';
      _countryController.text =
          findCountryNameUsingCode(customerAddress.country ?? '');
      _stateController.text = customerAddress.state ?? '';
      _cityController.text = customerAddress.city ?? '';
    } else {
      _nameController.text = '';
      _phoneController.text = '';
      _emailController.text = '';
      _zipController.text = '';
      _addressController.text = '';
      _countryController.text = '';
      _stateController.text = '';
      _cityController.text = '';
    }

    /// --------------------------------  BOTTOM SHEET SHOWING  ([++CREATE AND EDIT ADDRESS++]) --------------------------------
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
      builder: (context) {
        final screenHeight = MediaQuery.sizeOf(context).height;
        final screenWidth = MediaQuery.sizeOf(context).width;
        return StatefulBuilder(
          builder: (context, setState) {
            void toggleCheckBox(bool? value) {
              setState(() {
                _isChecked = value!;
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
                          // Custom Field for Change Password
                          CustomFieldProfileScreen(
                            hintText: 'Enter your name',
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            nextFocusNode: _phoneFocusNode,
                            labelText: 'Enter Name',
                            formFieldValidator: Validator.name,
                          ),

                          SizedBox(height: screenHeight * 0.01),

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

                          CustomFieldProfileScreen(
                            hintText: 'Enter Email address',
                            controller: _emailController,
                            focusNode: _emailFocusNode,
                            labelText: 'Email',
                            keyboardType: TextInputType.emailAddress,
                            nextFocusNode: _zipFocusNode,
                            formFieldValidator: Validator.email,
                          ),

                          SizedBox(height: screenHeight * 0.01),

                          CustomFieldProfileScreen(
                            hintText: 'Enter Zip Code',
                            controller: _zipController,
                            // Use another controller for different fields
                            focusNode: _zipFocusNode,
                            labelText: ' Zip Code',
                            keyboardType: TextInputType.number,
                            nextFocusNode: _addressFocusNode,
                            formFieldValidator: Validator.zipCode,
                            textInputFormatters: [
                              LengthLimitingTextInputFormatter(
                                  5), // Set the maximum character limit
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          CustomFieldProfileScreen(
                            hintText: 'Enter address',
                            controller: _addressController,
                            // Use another controller for different fields
                            focusNode: _addressFocusNode,
                            labelText: ' Address',
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

                          CustomFieldProfileScreen(
                            isEditable: false,
                            onTap: () async {
                              // Allow opening the country picker only if it's editable

                              if (countryModel != null &&
                                  countryModel?.data != null) {
                                _showCountryPicker(
                                    countryModel?.data?.list ?? []);
                              } else {}
                            },
                            hintText: 'Enter Country',
                            controller: _countryController,
                            focusNode: _countryFocusNode,
                            labelText: ' Country',
                            nextFocusNode: _stateFocusNode,
                            suffixIcon:
                                const Icon(Icons.arrow_drop_down_outlined),
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select country.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          CustomFieldProfileScreen(
                            hintText: 'Enter State',
                            controller: _stateController,
                            // Use another controller for different fields
                            focusNode: _stateFocusNode,
                            labelText: 'State',
                            keyboardType: TextInputType.streetAddress,
                            nextFocusNode: _cityFocusNode,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'State cannot be empty.';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          CustomFieldProfileScreen(
                            hintText: 'Enter City',
                            controller: _cityController,
                            // Use another controller for different fields
                            focusNode: _cityFocusNode,
                            labelText: 'City',
                            keyboardType: TextInputType.streetAddress,
                            nextFocusNode: _cityFocusNode,
                            formFieldValidator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'City cannot be empty.';
                              }
                              return null;
                            },
                          ),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                                vertical: screenHeight * 0.02),
                            child: Row(
                              children: [
                                Checkbox(
                                    focusColor: Colors.black,
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    value: _isChecked,
                                    onChanged: toggleCheckBox),
                                const Text('Use this default address'),
                              ],
                            ),
                          ),

                          AppCustomButton(
                            isLoading: context
                                    .watch<CustomerAddressProvider>()
                                    .status ==
                                ApiStatus.loading,
                            // title: 'Update',
                            title: customerAddress != null ? 'Update' : 'Save',
                            // Show "Update" or "Save" based on address existence
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                final AddressModel address = AddressModel(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  phone: _phoneController.text,
                                  address: _addressController.text,
                                  country: countryCode,
                                  city: _cityController.text,
                                  state: _stateController.text,
                                  zipCode: _zipController.text,
                                  isDefault: _isChecked,
                                );
                                if (customerAddress != null) {
                                  /// _update Address Api call
                                  final int? id = customerAddress.id;
                                  if (id != null) {
                                    final token =
                                        await SecurePreferencesUtil.getToken();
                                    final response =
                                        await Provider.of<CustomerAddress>(
                                                context,
                                                listen: false)
                                            .updateAddress(address, token ?? '',
                                                id, context);
                                    if (response) {
                                      await fetchDataOfCustomer();
                                      Navigator.pop(context);
                                    }
                                  }
                                } else {
                                  _saveAddress();
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

  ///  --------------------------------  FUNCTION FOR SAVE THE ADDRESS --------------------------------
  Future<void> _saveAddress() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (isValid) {
      final AddressModel address = AddressModel(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        address: _addressController.text,
        country: countryCode,
        city: _cityController.text,
        state: _stateController.text,
        zipCode: _zipController.text,
        isDefault: _isChecked,
      );

      final token = await SecurePreferencesUtil.getToken();
      if (token == null) return;

      Provider.of<AddressProvider>(context, listen: false)
          .saveAddress(address)
          .then((_) async {
        /// Re-fetch the list at here of address
        final token = await SecurePreferencesUtil.getToken();
        final provider =
            Provider.of<CustomerAddressProvider>(context, listen: false);
        await provider.fetchCustomerAddresses(token ?? '', context);
        Navigator.pop(context);
        CustomSnackbar.showSuccess(context, 'Address saved successfully!');
      }).catchError((error) {
        CustomSnackbar.showError(context, 'Please Check Fields');
      });
    }
  }

  /// --------------------------------  FUNCTION FOR SHOWING THE COUNTRY LIST --------------------------------
  void _showCountryPicker(List<CountryList> countryList) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        child: Container(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: countryList.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(countryList[index].label ?? 'Unknown Country'),
                    onTap: () {
                      setState(() {
                        countryCode = countryList[index].value ?? '';
                        _countryController.text =
                            countryList[index].label ?? '';
                      });
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomerRecords? customerAddressModel;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const BackAppBarStyle(
              icon: Icons.arrow_back_ios,
              text: 'My Account',
            ),
            SizedBox(height: screenHeight * 0.04),
            Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.04,
                  left: screenWidth * 0.04,
                  right: screenWidth * 0.04),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Address'),
                      CustomAppButton(
                        buttonText: 'Create',
                        // customerAddressModel
                        onTap: () => _formPageAddress(context, null),
                        prefixIcon: Icons.add,
                        buttonColor: AppColors.peachyPink,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Consumer<CustomerAddressProvider>(
              builder: (BuildContext context, CustomerAddressProvider provider,
                  Widget? child) {
                if (provider.isLoadingAddresses && _currentPage == 1) {
                  return const Center(
                      child: CircularProgressIndicator(
                          color: Colors.black, strokeWidth: 0.5));
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: screenHeight * 0.04,
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (provider.isLoading)
                                  const Center(
                                      child: CircularProgressIndicator()),
                                // Show loading spinner if loading
                                if (provider.errorMessage != null)
                                  Center(child: Text(provider.errorMessage!)),
                                // Show error message if any
                                if (!provider.isLoading &&
                                    provider.addresses
                                        .isNotEmpty) // Check if addresses are available
                                  ListView.builder(
                                    itemCount: provider.addresses.length +
                                        (_isFetchingMore ? 1 : 0),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    // Prevent scrolling
                                    itemBuilder: (context, index) {
                                      if (_isFetchingMore &&
                                          index == provider.addresses.length) {
                                        return const Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.black,
                                                  strokeWidth: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      final address = provider.addresses[index];

                                      return Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary
                                                  .withOpacity(0.08)),
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        padding: const EdgeInsets.all(8),
                                        margin: EdgeInsets.only(
                                            bottom: screenHeight * 0.02),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            if (address.isDefault == 1)
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.blueAccent,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                padding:
                                                    const EdgeInsets.all(4),
                                                child: Text('Default Address',
                                                    style: GoogleFonts.inter(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w200)),
                                              )
                                            else
                                              const SizedBox.shrink(),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text('Name',
                                                        style: description(
                                                            context))),
                                                Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            address.name ??
                                                                'ss',
                                                            style: description(
                                                                context)))),
                                              ],
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text('Email',
                                                        style: description(
                                                            context))),
                                                Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            address.email ??
                                                                'ss',
                                                            style: description(
                                                                context)))),
                                              ],
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text('Phone',
                                                        style: description(
                                                            context))),
                                                Expanded(
                                                    child: Align(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text(
                                                            address.phone ??
                                                                'loading...',
                                                            style: description(
                                                                context)))),
                                              ],
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.01),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                    child: Text('Address',
                                                        style: description(
                                                            context))),
                                                Expanded(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Text(
                                                          address.fullAddress ??
                                                              'loading...',
                                                          style: description(
                                                              context))),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                height: screenHeight * 0.02),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                GestureDetector(
                                                  onTap: () async {
                                                    _formPageAddress(
                                                        context, address);
                                                  },
                                                  child: const Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                      fontFamily: 'FontSf',
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .dotted,
                                                      decorationColor:
                                                          Colors.blue,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async {
                                                    deleteItemAlertDialog(
                                                      context: context,
                                                      buttonColor:
                                                          AppColors.peachyPink,
                                                      onDelete: () async {
                                                        await provider
                                                            .deleteAddress(
                                                                address.id ?? 0,
                                                                context);
                                                        Navigator.pop(context);
                                                      },
                                                    );

                                                    /// Re-fetch the list at here of address
                                                    // final token = await SharedPreferencesUtil.getToken();
                                                    // final reFetchUserData = Provider.of<CustomerAddressProvider>(context,listen: false);
                                                    // await reFetchUserData.fetchCustomerAddresses(token ?? '');
                                                  },
                                                  child: const SizedBox(
                                                      height: 35,
                                                      width: 35,
                                                      child: Icon(
                                                          CupertinoIcons
                                                              .delete_simple,
                                                          size: 25,
                                                          color: Colors.red)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                if (!provider.isLoading &&
                                    provider.addresses.isEmpty)
                                  Container(
                                    width: screenWidth,
                                    padding: EdgeInsets.only(
                                        left: screenHeight * 0.02,
                                        top: screenHeight * 0.01,
                                        bottom: screenHeight * 0.01),
                                    color:
                                        AppColors.peachyPink.withOpacity(0.2),
                                    child: Text('No record found!',
                                        style: GoogleFonts.inter(
                                            color: Colors.brown.shade600,
                                            fontWeight: FontWeight.w600)),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
