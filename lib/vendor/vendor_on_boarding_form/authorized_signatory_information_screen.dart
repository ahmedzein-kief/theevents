import 'dart:io';

import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/models/vendor_models/post_models/authorized_signatory_info_post_data.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../provider/payment_address/country_picks_provider.dart';
import '../../views/country_picker/country_pick_screen.dart';
import '../common_dropdowns.dart';
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
  State<AuthorizedSignatoryInformationScreen> createState() =>
      _AuthorizedSignatoryInformationScreenState();
}

class _AuthorizedSignatoryInformationScreenState
    extends State<AuthorizedSignatoryInformationScreen> {
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

  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
      if (countryModel != null) {
        _nameController.text = widget.asiModel.ownerDisplayName ?? '';
        _phNumberController.text = widget.asiModel.ownerPhoneNumber ?? '';
        _countryController.text =
            findCountryNameUsingCode(widget.asiModel.ownerCountry ?? '');
        _regionController.text = widget.asiModel.ownerRegion ?? '';
        _emiratesIdController.text = widget.asiModel.ownerEIDNumber ?? '';
        _emiratesExpireDateController.text =
            widget.asiModel.ownerEIDExpiry ?? '';
        _eidPdfController.text = widget.asiModel.ownerEIDFileName ?? '';
        _passportController.text = widget.asiModel.passportFileName ?? '';
        _poaMoaController.text = widget.asiModel.poamoaFileName ?? '';
      }
    } catch (error) {}
  }

  String findCountryNameUsingCode(String code) {
    countryCode = code;
    return countryModel?.data?.list
            ?.firstWhere((countryData) => countryData.value == code)
            .label ??
        '';
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
              bottom: screenHeight * 0.015),
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  spreadRadius: 2, // How much the shadow spreads
                  blurRadius: 5, // How blurry the shadow is
                  offset: const Offset(0, 2), // Shadow offset (X, Y)
                ),
              ],
            ),
            child: Material(
              shadowColor: Colors.black,
              color: Colors.white,
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Authorized Signatory Information',
                      style: loginHeading(),
                    ),
                    VendorCustomTextFields(
                      labelText: 'Full Name',
                      hintText: 'Enter Full Name',
                      textStar: ' *',
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
                      labelText: 'Phone Number',
                      textStar: '*',
                      hintText: 'Enter your number',
                      controller: _phNumberController,
                      prefixIcon: Icons.keyboard_arrow_down_outlined,
                      prefixText: '+971',
                      isPrefixFilled: true,
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
                      labelText: 'Country',
                      hintText: 'Please select country',
                      textStar: ' *',
                      controller: _countryController,
                      keyboardType: TextInputType.name,
                      focusNode: _countryFocusNode,
                      suffixIconColor: Colors.black,
                      isEditable: false,
                      nextFocusNode: _regionFocusNode,
                      suffixIcon: Icons.keyboard_arrow_down_outlined,
                      validator: Validator.country,
                      onIconPressed: () {
                        if (countryModel != null &&
                            countryModel?.data != null) {
                          final List<CountryList> filteredList = countryModel
                                  ?.data?.list
                                  ?.where((value) =>
                                      value.value?.toLowerCase() == 'ae')
                                  .toList() ??
                              [];
                          showDialog(
                            context: context,
                            builder: (context) => CountryPickerDialog(
                              countryList: filteredList,
                              currentSelection: _countryController.text,
                              onCountrySelected: (selectedCountry) {
                                setState(() {
                                  countryCode = selectedCountry.value ?? '';
                                  _countryController.text =
                                      selectedCountry.label ?? '';
                                  widget.asiModel.ownerCountry =
                                      selectedCountry.value;
                                  widget.onASIModelUpdate(widget.asiModel);
                                });
                              },
                            ),
                          );
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: 'Region',
                      hintText: 'Please select region',
                      textStar: ' *',
                      controller: _regionController,
                      keyboardType: TextInputType.name,
                      focusNode: _regionFocusNode,
                      suffixIconColor: Colors.black,
                      isEditable: false,
                      nextFocusNode: _emiratesIdFocusNode,
                      suffixIcon: Icons.keyboard_arrow_down_outlined,
                      validator: Validator.region,
                      onIconPressed: () async {
                        final region = await showRegionDropdown(
                            context, _regionController.text);
                        if (region != null) {
                          _regionController.text = region;
                          widget.asiModel.ownerRegion = region;
                          widget.onASIModelUpdate(widget.asiModel);
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: 'Emirates ID Number',
                      hintText: 'Enter ID Number',
                      textStar: ' *',
                      controller: _emiratesIdController,
                      keyboardType: TextInputType.name,
                      focusNode: _emiratesIdFocusNode,
                      nextFocusNode: _emiratesExpireDateFocusNode,
                      validator: Validator.emiratesIdNumber,
                      onValueChanged: (value) {
                        widget.asiModel.ownerEIDNumber = value;
                        widget.onASIModelUpdate(widget.asiModel);
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: 'Emirates ID Number Expiry Date',
                      hintText: 'dd-MM-yyyy',
                      textStar: ' *',
                      controller: _emiratesExpireDateController,
                      keyboardType: TextInputType.name,
                      focusNode: _emiratesExpireDateFocusNode,
                      isEditable: false,
                      nextFocusNode: _eidPdfFocusNode,
                      suffixIcon: Icons.calendar_today_outlined,
                      suffixIconColor: Colors.grey,
                      validator: Validator.emiratesIdNumberDate,
                      onIconPressed: () async {
                        final result =
                            await showDatePickerDialog(context, 'dd-MM-yyyy');
                        if (result != null) {
                          final date = result.toString().split(' ')[0];
                          _emiratesExpireDateController.text = date;
                          widget.asiModel.ownerEIDExpiry = date;
                          widget.onASIModelUpdate(widget.asiModel);
                        }
                      },
                    ),
                    VendorCustomTextFields(
                      labelText: 'Upload EID (pdf)',
                      hintText: 'No file Chosen',
                      textStar: ' *',
                      controller: _eidPdfController,
                      keyboardType: TextInputType.name,
                      focusNode: _eidPdfFocusNode,
                      nextFocusNode: _passportFocusNode,
                      isPrefixFilled: true,
                      isEditable: false,
                      prefixIconColor: Colors.black,
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      borderSideColor:
                          const BorderSide(color: Colors.grey, width: 0.5),
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _eidPdfController.text = result.files.single.name;
                          widget.asiModel.ownerEIDFile = file;
                          widget.asiModel.ownerEIDFileName =
                              result.files.single.name;
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
                      labelText: 'Upload Passport (pdf)',
                      hintText: 'No file Chosen',
                      textStar: ' *',
                      controller: _passportController,
                      keyboardType: TextInputType.name,
                      focusNode: _passportFocusNode,
                      isPrefixFilled: true,
                      isEditable: false,
                      nextFocusNode: _poaMoaFocusNode,
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      prefixIconColor: Colors.black,
                      borderSideColor:
                          const BorderSide(color: Colors.grey, width: 0.5),
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _passportController.text = result.files.single.name;
                          widget.asiModel.passportFile = file;
                          widget.asiModel.passportFileName =
                              result.files.single.name;
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
                      labelText: 'POA /MOA (pdf)',
                      hintText: 'No file Chosen',
                      textStar: ' *',
                      controller: _poaMoaController,
                      keyboardType: TextInputType.name,
                      focusNode: _poaMoaFocusNode,
                      isEditable: false,
                      isPrefixFilled: true,
                      prefixIcon: Icons.upload_outlined,
                      prefixContainerColor: Colors.grey.shade300,
                      borderSideColor:
                          const BorderSide(color: Colors.grey, width: 0.5),
                      prefixIconColor: Colors.black,
                      validator: Validator.fieldRequired,
                      onIconPressed: () async {
                        final FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf'],
                        );
                        if (result != null) {
                          final File file = File(result.files.single.path!);
                          _poaMoaController.text = result.files.single.name;
                          widget.asiModel.poamoaFile = file;
                          widget.asiModel.poamoaFileName =
                              result.files.single.name;
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
