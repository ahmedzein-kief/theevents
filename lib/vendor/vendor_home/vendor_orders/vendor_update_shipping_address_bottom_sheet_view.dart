import 'package:event_app/provider/payment_address/country_picks_provider.dart';
import 'package:event_app/provider/payment_address/create_address_provider.dart';
import 'package:event_app/provider/payment_address/customer_address.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:event_app/core/widgets/custom_profile_views/custom_text_field_view.dart';
import 'package:event_app/utils/apiStatus/api_status.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_order_details_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_update_shipping_address_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../Components/utils/utils.dart';

class VendorUpdateShippingAddressBottomSheetView extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final String orderId;
  final String shipmentId;
  final VoidCallback onSave;
  final VoidCallback onUpdate;
  final CustomerRecords? customerAddress;
  final showUseDefaultButton;

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

  @override
  _VendorUpdateShippingAddressBottomSheetViewState createState() => _VendorUpdateShippingAddressBottomSheetViewState();
}

class _VendorUpdateShippingAddressBottomSheetViewState extends State<VendorUpdateShippingAddressBottomSheetView> {
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

  CountryModels? countryModel;
  bool _isChecked = false;

  void _toggleCheckBox(bool? value) {
    setState(() {
      _isChecked = value!;
    });
  }

  bool _isProcessing = false;

  setProcessing(value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future<void> fetchCountryData() async {
    try {
      setProcessing(true);
      countryModel = await fetchCountries(context);
      if (widget.customerAddress != null) {
        _nameController.text = widget.customerAddress?.name ?? '';
        _phoneController.text = widget.customerAddress?.phone ?? '';
        _emailController.text = widget.customerAddress?.email ?? '';
        _zipController.text = widget.customerAddress?.zip_code ?? '';
        _addressController.text = widget.customerAddress?.address ?? '';
        _countryController.text = findCountryNameUsingCode(widget.customerAddress?.country ?? '');
        _stateController.text = widget.customerAddress?.state ?? '';
        _cityController.text = widget.customerAddress?.city ?? '';
      }
      setProcessing(false);
    } catch (error) {
      setProcessing(false);
      print('error $error');
    }
  }

  String findCountryNameUsingCode(String code) {
    countryCode = code;
    return countryModel?.data?.list?.firstWhere((countryData) => countryData.value == code).label ?? '';
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await fetchCountryData();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FractionallySizedBox(
        heightFactor: 0.85,
        child: Scaffold(
          body: SafeArea(
            child: Utils.modelProgressHud(
              processing: _isProcessing,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Custom Field for Change Password
                      CustomFieldProfileScreen(
                        hintText: "Enter your name",
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        nextFocusNode: _phoneFocusNode,
                        labelText: "Enter Name",
                        formFieldValidator: Validator.name,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter phone Number",
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        labelText: "Phone",
                        nextFocusNode: _emailFocusNode,
                        keyboardType: TextInputType.number,
                        formFieldValidator: Validator.phone,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter Email address",
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        labelText: "Email",
                        keyboardType: TextInputType.emailAddress,
                        nextFocusNode: _zipFocusNode,
                        formFieldValidator: Validator.emailOptional,
                      ),

                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter Zip Code",
                        controller: _zipController,
                        // Use another controller for different fields
                        focusNode: _zipFocusNode,
                        labelText: " Zip Code",
                        keyboardType: TextInputType.number,
                        nextFocusNode: _addressFocusNode,
                        formFieldValidator: Validator.zipCodeOptional,
                        textInputFormatters: [
                          LengthLimitingTextInputFormatter(5), // Set the maximum character limit
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter address",
                        controller: _addressController,
                        // Use another controller for different fields
                        focusNode: _addressFocusNode,
                        labelText: " Address",
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

                          if (countryModel != null && countryModel?.data != null) {
                            _showCountryPicker(countryModel?.data?.list ?? []);
                          } else {
                            print("Country field is not editable.");
                          }
                        },
                        hintText: "Enter Country",
                        controller: _countryController,
                        focusNode: _countryFocusNode,
                        labelText: " Country",
                        nextFocusNode: _stateFocusNode,
                        suffixIcon: Icon(Icons.arrow_drop_down_outlined),
                        formFieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select country.';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter State",
                        controller: _stateController,
                        // Use another controller for different fields
                        focusNode: _stateFocusNode,
                        labelText: "State",
                        keyboardType: TextInputType.streetAddress,
                        nextFocusNode: _cityFocusNode,
                      ),
                      SizedBox(height: screenHeight * 0.01),

                      CustomFieldProfileScreen(
                        hintText: "Enter City",
                        controller: _cityController,
                        // Use another controller for different fields
                        focusNode: _cityFocusNode,
                        labelText: "City",
                        keyboardType: TextInputType.streetAddress,
                        nextFocusNode: _cityFocusNode,
                        formFieldValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City cannot be empty.';
                          }
                          return null;
                        },
                      ),

                      if (!(widget.showUseDefaultButton)) kSmallSpace,

                      if (widget.showUseDefaultButton)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
                          child: Row(
                            children: [
                              Checkbox(focusColor: Colors.black, activeColor: Colors.black, checkColor: Colors.white, value: _isChecked, onChanged: _toggleCheckBox),
                              Text("Use this default address"),
                            ],
                          ),
                        ),

                      ChangeNotifierProvider(
                        create: (context) => VendorUpdateShippingAddressViewModel(),
                        child: Consumer<VendorUpdateShippingAddressViewModel>(
                          builder: (context, provider, _) {
                            return AppCustomButton(
                              isLoading: provider.apiResponse.status == ApiStatus.loading,
                              title: 'Update',
                              // Show "Update" or "Save" based on address existence
                              onPressed: () async {
                                try {
                                  if (_formKey.currentState?.validate() ?? false) {
                                    AddressModel address = AddressModel(
                                      id: widget.orderId,
                                      name: _nameController.text,
                                      email: _emailController.text,
                                      phone: _phoneController.text,
                                      address: _addressController.text,
                                      country: countryCode,
                                      city: _cityController.text,
                                      state: _stateController.text,
                                      zipCode: _zipController.text,
                                    );
                                    final form = address.vendorOrderDetailsUpdateShippingAddressToJson();

                                    /// converting json form
                                    final result = await provider.vendorUpdateShippingAddress(shippingID: widget.shipmentId.toString(), form: form, context: context);
                                    if (result) {
                                      /// refresh the order detail page
                                      context.read<VendorGetOrderDetailsViewModel>().vendorGetOrderDetails(orderId: widget.orderId);
                                      Navigator.pop(context);
                                    }
                                  }
                                } catch (e) {
                                  print("Error while updating address: $e");
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void _showCountryPicker(List<CountryList> countryList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          child: Container(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: countryList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(countryList[index].label ?? 'Unknown Country'),
                        onTap: () {
                          setState(() {
                            countryCode = countryList[index].value ?? '';
                            _countryController.text = countryList[index].label ?? '';
                          });
                          Navigator.pop(context); // Close the dialog
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
