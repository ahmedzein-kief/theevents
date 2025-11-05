import 'dart:io';

import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/models/vendor_models/post_models/authorized_signatory_info_post_data.dart';
import 'package:event_app/models/wishlist_models/states_cities_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../provider/payment_address/country_picks_provider.dart';
import '../../views/country_picker/country_pick_screen.dart';
import '../components/vendor_custom_text_fields.dart';
import '../components/vendor_text_style.dart';

class AuthorizedSignatoryInformationScreen extends StatefulWidget {
  const AuthorizedSignatoryInformationScreen({
    super.key,
    required this.asiModel,
    required this.onASIModelUpdate,
  });

  final AuthorizedSignatoryInfoPostData asiModel;
  final Function(AuthorizedSignatoryInfoPostData) onASIModelUpdate;

  @override
  State<AuthorizedSignatoryInformationScreen> createState() => _AuthorizedSignatoryInformationScreenState();
}

class _AuthorizedSignatoryInformationScreenState extends State<AuthorizedSignatoryInformationScreen> {
  final _nameFocusNode = FocusNode();
  final _phNumberFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _regionFocusNode = FocusNode();
  final _emiratesIdFocusNode = FocusNode();
  final _emiratesExpireDateFocusNode = FocusNode();
  final _eidPdfFocusNode = FocusNode();
  final _passportFocusNode = FocusNode();
  final _poaMoaFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _phNumberController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _emiratesIdController = TextEditingController();
  final _emiratesExpireDateController = TextEditingController();
  final _eidPdfController = TextEditingController();
  final _passportController = TextEditingController();
  final _poaMoaController = TextEditingController();

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
          _nameController.text = widget.asiModel.ownerDisplayName ?? '';
          _phNumberController.text = widget.asiModel.ownerPhoneNumber ?? '';
          _emiratesIdController.text = widget.asiModel.ownerEIDNumber ?? '';
          _emiratesExpireDateController.text = widget.asiModel.ownerEIDExpiry ?? '';
          _eidPdfController.text = widget.asiModel.ownerEIDFileName ?? '';
          _passportController.text = widget.asiModel.passportFileName ?? '';
          _poaMoaController.text = widget.asiModel.poamoaFileName ?? '';
        });

        // Setup existing country and region data
        await _setupExistingData();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _setupExistingData() async {
    if (widget.asiModel.ownerCountry != null && widget.asiModel.ownerCountry!.isNotEmpty) {
      // Find country by name or code
      final CountryList? countryRecord = countryModel?.data?.list?.firstWhere(
        (element) => element.name == widget.asiModel.ownerCountry || element.code == widget.asiModel.ownerCountry,
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
            if (widget.asiModel.ownerRegion != null && stateModel?.data?.isNotEmpty == true) {
              final StateRecord foundState = stateModel!.data!.firstWhere(
                (element) => element.name == widget.asiModel.ownerRegion,
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
    _poaMoaFocusNode.dispose();

    _nameController.dispose();
    _phNumberController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _emiratesIdController.dispose();
    _emiratesExpireDateController.dispose();
    _eidPdfController.dispose();
    _passportController.dispose();
    _poaMoaController.dispose();

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
              elevation: 10,
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
                      VendorAppStrings.authorizedSignatoryInformation.tr,
                      style: loginHeading(),
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.fullName.tr,
                      hintText: VendorAppStrings.enterFullName.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _phNumberFocusNode,
                      validator: Validator.vendorName,
                      onValueChanged: (value) {
                        widget.asiModel.ownerDisplayName = value;
                        widget.onASIModelUpdate(widget.asiModel);
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
                      keyboardType: TextInputType.phone,
                      focusNode: _phNumberFocusNode,
                      nextFocusNode: _countryFocusNode,
                      validator: Validator.businessInfoPhone,
                      onValueChanged: (value) {
                        widget.asiModel.ownerPhoneCode = '+971';
                        widget.asiModel.ownerPhoneNumber = value;
                        widget.onASIModelUpdate(widget.asiModel);
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.country.tr,
                      hintText: VendorAppStrings.selectCountry.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _countryController,
                      keyboardType: TextInputType.none,
                      focusNode: _countryFocusNode,
                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                      isEditable: false,
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
                                  widget.asiModel.ownerCountry = selectedCountry.id.toString();
                                  widget.asiModel.ownerRegion = null;
                                  widget.onASIModelUpdate(widget.asiModel);
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
                      hintText: VendorAppStrings.selectRegion.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _regionController,
                      keyboardType: TextInputType.none,
                      focusNode: _regionFocusNode,
                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                      isEditable: false,
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
                                  widget.asiModel.ownerRegion = state.id?.toString() ?? '0';
                                  widget.onASIModelUpdate(widget.asiModel);
                                });
                              },
                            ),
                          );
                        } else if (selectedCountryId == null) {
                          // Show message to select country first
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(VendorAppStrings.selectCountry.tr),
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
                      keyboardType: TextInputType.text,
                      focusNode: _emiratesIdFocusNode,
                      nextFocusNode: _emiratesExpireDateFocusNode,
                      validator: Validator.emiratesIdNumber,
                      onValueChanged: (value) {
                        widget.asiModel.ownerEIDNumber = value;
                        widget.onASIModelUpdate(widget.asiModel);
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
                          widget.asiModel.ownerEIDExpiry = date;
                          widget.onASIModelUpdate(widget.asiModel);
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
                      prefixContainerColor: Colors.grey.shade300,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _eidPdfController.text = result.files.single.name;
                          widget.asiModel.ownerEIDFile = file;
                          widget.asiModel.ownerEIDFileName = result.files.single.name;
                          widget.onASIModelUpdate(widget.asiModel);
                        } else {
                          _eidPdfController.text = '';
                          widget.asiModel.ownerEIDFile = null;
                          widget.asiModel.ownerEIDFileName = '';
                          widget.onASIModelUpdate(widget.asiModel);
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
                      nextFocusNode: _poaMoaFocusNode,
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _passportController.text = result.files.single.name;
                          widget.asiModel.passportFile = file;
                          widget.asiModel.passportFileName = result.files.single.name;
                          widget.onASIModelUpdate(widget.asiModel);
                        } else {
                          _passportController.text = '';
                          widget.asiModel.passportFile = null;
                          widget.asiModel.passportFileName = '';
                          widget.onASIModelUpdate(widget.asiModel);
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: VendorAppStrings.poaMoaPdf.tr,
                      hintText: VendorAppStrings.noFileChosenAlt.tr,
                      textStar: VendorAppStrings.asterick.tr,
                      controller: _poaMoaController,
                      keyboardType: TextInputType.name,
                      focusNode: _poaMoaFocusNode,
                      isEditable: false,
                      isPrefixFilled: true,
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _poaMoaController.text = result.files.single.name;
                          widget.asiModel.poamoaFile = file;
                          widget.asiModel.poamoaFileName = result.files.single.name;
                          widget.onASIModelUpdate(widget.asiModel);
                        } else {
                          _poaMoaController.text = '';
                          widget.asiModel.poamoaFile = null;
                          widget.asiModel.poamoaFileName = '';
                          widget.onASIModelUpdate(widget.asiModel);
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
