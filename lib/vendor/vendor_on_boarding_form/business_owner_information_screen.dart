import 'dart:io';

import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/vendor_models/post_models/business_owner_info_post_data.dart';
import 'package:event_app/models/wishlist_models/states_cities_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/helper/validators/validator.dart';
import '../../provider/payment_address/country_picks_provider.dart';
import '../../views/country_picker/country_pick_screen.dart';
import '../components/vendor_custom_text_fields.dart';
import '../components/vendor_text_style.dart';

class BusinessOwnerInformationScreen extends StatefulWidget {
  const BusinessOwnerInformationScreen({
    super.key,
    required this.boiModel,
    required this.onBOIModelUpdate,
  });

  final BusinessOwnerInfoPostData boiModel;
  final Function(BusinessOwnerInfoPostData) onBOIModelUpdate;

  @override
  State<BusinessOwnerInformationScreen> createState() => _BusinessOwnerInformationScreenState();
}

class _BusinessOwnerInformationScreenState extends State<BusinessOwnerInformationScreen> {
  final _nameFocusNode = FocusNode();
  final _phNumberFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _regionFocusNode = FocusNode();
  final _emiratesIdFocusNode = FocusNode();
  final _emiratesExpireDateFocusNode = FocusNode();
  final _eidPdfFocusNode = FocusNode();
  final _passportFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _phNumberController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _emiratesIdController = TextEditingController();
  final _emiratesExpireDateController = TextEditingController();
  final _eidPdfController = TextEditingController();
  final _passportController = TextEditingController();

  CountryModels? countryModel;
  String countryCode = '';
  int? selectedCountryId;
  StateModels? stateModel;
  StateRecord? selectedState;
  bool _stateLoader = false;

  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);

      if (countryModel != null) {
        setState(() {
          _nameController.text = widget.boiModel.companyDisplayName ?? '';
          _phNumberController.text = widget.boiModel.phoneNumber ?? '';
          _emiratesIdController.text = widget.boiModel.eidNumber ?? '';
          _emiratesExpireDateController.text = widget.boiModel.eidExpiry ?? '';
          _eidPdfController.text = widget.boiModel.eidFileName ?? '';
          _passportController.text = widget.boiModel.passportFileName ?? '';
        });

        // Setup existing country and region data
        await _setupExistingData();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return;
  }

  Future<void> _setupExistingData() async {
    if (widget.boiModel.country != null && widget.boiModel.country!.isNotEmpty) {
      // Find country by name or code
      final CountryList? countryRecord = countryModel?.data?.list?.firstWhere(
        (element) => element.name == widget.boiModel.country || element.code == widget.boiModel.country,
        orElse: () => countryModel!.data!.list!.first,
      );

      if (countryRecord != null) {
        selectedCountryId = countryRecord.id;
        countryCode = countryRecord.code ?? '';
        _countryController.text = countryRecord.name ?? '';

        // Fetch states for this country
        if (selectedCountryId != null) {
          try {
            stateModel = await fetchStates(selectedCountryId!);

            // Find and set the existing region/state
            if (widget.boiModel.region != null && stateModel?.data?.isNotEmpty == true) {
              final StateRecord foundState = stateModel!.data!.firstWhere(
                (element) => element.name == widget.boiModel.region,
                orElse: () => stateModel!.data!.first,
              );

              selectedState = foundState;
              _regionController.text = foundState.name ?? '';
            }

            setState(() {});
          } catch (error) {
            debugPrint(error.toString());
          }
        }
      }
    }
  }

  Future<void> fetchStateData(int countryId) async {
    try {
      setState(() {
        _stateLoader = true;
        _regionController.clear();
        selectedState = null;
        stateModel = null;
      });

      stateModel = await fetchStates(countryId);

      setState(() {
        _stateLoader = false;
      });
    } catch (error) {
      setState(() {
        _stateLoader = false;
      });
      debugPrint(error.toString());
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await fetchCountryData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _phNumberFocusNode.dispose();
    _countryFocusNode.dispose();
    _regionFocusNode.dispose();
    _emiratesIdFocusNode.dispose();
    _emiratesExpireDateFocusNode.dispose();
    _eidPdfFocusNode.dispose();
    _passportFocusNode.dispose();

    _nameController.dispose();
    _phNumberController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _emiratesIdController.dispose();
    _emiratesExpireDateController.dispose();
    _eidPdfController.dispose();
    _passportController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            top: screenHeight * 0.03,
            bottom: screenHeight * 0.015,
          ),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.2 * 255).toInt()),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              shadowColor: Colors.black,
              elevation: 15,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  left: 10,
                  right: 10,
                  bottom: 30,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      VendorAppStrings.businessOwnerInformation.tr,
                      style: loginHeading(),
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.fullName.tr,
                      hintText: VendorAppStrings.enterFullName.tr,
                      textStar: ' *',
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _phNumberFocusNode,
                      validator: Validator.vendorName,
                      onValueChanged: (value) {
                        widget.boiModel.companyDisplayName = value;
                        widget.onBOIModelUpdate(widget.boiModel);
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.phoneNumber.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      hintText: VendorAppStrings.enterYourNumber.tr,
                      controller: _phNumberController,
                      prefixIcon: Icons.keyboard_arrow_down_outlined,
                      prefixText: '+971',
                      isPrefixFilled: true,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      keyboardType: TextInputType.phone,
                      focusNode: _phNumberFocusNode,
                      nextFocusNode: _countryFocusNode,
                      validator: Validator.businessInfoPhone,
                      onValueChanged: (value) {
                        widget.boiModel.phoneNumber = value;
                        widget.onBOIModelUpdate(widget.boiModel);
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.country.tr,
                      hintText: VendorAppStrings.pleaseSelectCountry.tr,
                      textStar: ' *',
                      controller: _countryController,
                      isEditable: false,
                      keyboardType: TextInputType.none,
                      focusNode: _countryFocusNode,
                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                      nextFocusNode: _regionFocusNode,
                      suffixIcon: Icons.keyboard_arrow_down_outlined,
                      validator: Validator.country,
                      onIconPressed: () {
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

                                  // Clear region when country changes
                                  _regionController.clear();
                                  selectedState = null;
                                  stateModel = null;

                                  // Update model
                                  widget.boiModel.country = selectedCountryId.toString();
                                  widget.boiModel.region = null;
                                  widget.onBOIModelUpdate(widget.boiModel);
                                });

                                // Fetch states for the selected country
                                if (selectedCountryId != null) {
                                  fetchStateData(selectedCountryId!);
                                }
                              },
                            ),
                          );
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.region.tr,
                      hintText: VendorAppStrings.pleaseSelectRegion.tr,
                      textStar: ' *',
                      controller: _regionController,
                      isEditable: false,
                      keyboardType: TextInputType.none,
                      focusNode: _regionFocusNode,
                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                      nextFocusNode: _emiratesIdFocusNode,
                      suffixIcon: _stateLoader ? Icons.hourglass_empty : Icons.keyboard_arrow_down_outlined,
                      validator: Validator.region,
                      onIconPressed: () async {
                        if (_stateLoader) return;

                        if (stateModel?.data?.isNotEmpty ?? false) {
                          showDialog(
                            context: context,
                            builder: (context) => StatePickerDialog(
                              stateList: stateModel!.data!,
                              currentSelection: selectedState,
                              onStateSelected: (state) {
                                setState(() {
                                  selectedState = state;
                                  _regionController.text = selectedState?.name ?? '';

                                  // Update model
                                  widget.boiModel.region = state.id?.toString() ?? '0';
                                  widget.onBOIModelUpdate(widget.boiModel);
                                });
                              },
                            ),
                          );
                        } else if (selectedCountryId == null) {
                          // Show message to select country first
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(VendorAppStrings.pleaseSelectCountry.tr),
                            ),
                          );
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.emiratesIdNumber.tr,
                      hintText: VendorAppStrings.enterIdNumber.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _emiratesIdController,
                      keyboardType: TextInputType.number,
                      focusNode: _emiratesIdFocusNode,
                      nextFocusNode: _emiratesExpireDateFocusNode,
                      validator: Validator.emiratesIdNumber,
                      onValueChanged: (value) {
                        widget.boiModel.eidNumber = value;
                        widget.onBOIModelUpdate(widget.boiModel);
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.emiratesIdNumberExpiryDate.tr,
                      hintText: VendorAppStrings.ddMmYyyy.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _emiratesExpireDateController,
                      keyboardType: TextInputType.datetime,
                      focusNode: _emiratesExpireDateFocusNode,
                      isEditable: false,
                      nextFocusNode: _eidPdfFocusNode,
                      suffixIcon: Icons.calendar_today_outlined,
                      suffixIconColor: Colors.grey,
                      validator: Validator.emiratesIdNumberDate,
                      onIconPressed: () async {
                        final result = await showDatePickerDialog(context);
                        if (result != null) {
                          final date = result.toString().split(' ')[0];
                          _emiratesExpireDateController.text = date;
                          widget.boiModel.eidExpiry = date;
                          widget.onBOIModelUpdate(widget.boiModel);
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.uploadEidPdf.tr,
                      hintText: VendorAppStrings.noFileChosenAlt.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _eidPdfController,
                      keyboardType: TextInputType.name,
                      focusNode: _eidPdfFocusNode,
                      nextFocusNode: _passportFocusNode,
                      isPrefixFilled: true,
                      isEditable: false,
                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                      prefixIcon: Icons.upload_outlined,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      prefixContainerColor: Colors.grey.shade300,
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _eidPdfController.text = result.files.single.name;
                          widget.boiModel.eidFile = file;
                          widget.boiModel.eidFileName = result.files.single.name;
                          widget.onBOIModelUpdate(widget.boiModel);
                        } else {
                          widget.boiModel.eidFile = null;
                          widget.boiModel.eidFileName = '';
                          widget.onBOIModelUpdate(widget.boiModel);
                          _eidPdfController.text = '';
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.uploadPassportPdf.tr,
                      hintText: VendorAppStrings.noFileChosenAlt.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _passportController,
                      keyboardType: TextInputType.name,
                      focusNode: _passportFocusNode,
                      isPrefixFilled: true,
                      isEditable: false,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _passportController.text = result.files.single.name;
                          widget.boiModel.passportFile = file;
                          widget.boiModel.passportFileName = result.files.single.name;
                          widget.onBOIModelUpdate(widget.boiModel);
                        } else {
                          _passportController.text = '';
                          widget.boiModel.passportFile = null;
                          widget.boiModel.passportFileName = '';
                          widget.onBOIModelUpdate(widget.boiModel);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Helper function for date picker (if not already defined elsewhere)
Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
  );
}
