import 'dart:io';

import 'package:camera_gallery_image_picker/camera_gallery_image_picker.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/models/vendor_models/post_models/company_info_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/company_info_response.dart';
import 'package:event_app/models/wishlist_models/states_cities_models.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../provider/payment_address/country_picks_provider.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../../views/country_picker/country_pick_screen.dart';
import '../common_dropdowns.dart';
import '../components/custom_vendor_auth_button.dart';
import '../components/vendor_custom_text_fields.dart';
import '../components/vendor_text_style.dart';

class CompanyInformationScreen extends StatefulWidget {
  const CompanyInformationScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<CompanyInformationScreen> createState() => _CompanyInformationScreenState();
}

class _CompanyInformationScreenState extends State<CompanyInformationScreen> {
  final _companyNameFocusNode = FocusNode();
  final _companyLogoFocusNode = FocusNode();
  final _companyCategoryFocusNode = FocusNode();
  final _companyEmailFocusNode = FocusNode();
  final _companyNumberFocusNode = FocusNode();
  final _cMobileNumberFocusNode = FocusNode();
  final _tlnFocusNode = FocusNode();
  final _utlFocusNode = FocusNode();
  final _cAddressFocusNode = FocusNode();
  final _tradeLicenseNumberFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _regionFocusNode = FocusNode();
  final _nocApplicableFocusNode = FocusNode();
  final _vatCertificateFocusNode = FocusNode();

  final _companyNameController = TextEditingController();
  final _companyLogoController = TextEditingController();
  final _companyCategoryController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _companyNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _tlnController = TextEditingController();
  final _utlController = TextEditingController();
  final _addressController = TextEditingController();
  final _tradeLicenseNumberExpiryController = TextEditingController();
  final _countryController = TextEditingController();
  final _regionController = TextEditingController();
  final _nocApplicableController = TextEditingController();
  final _vatCertificateController = TextEditingController();

  String? selectedHomeShopOption = 'home';
  final _formKey = GlobalKey<FormState>();
  final CompanyInfoPostData ciModel = CompanyInfoPostData();

  CountryModels? countryModel;
  String countryCode = '';
  int? selectedCountryId;
  StateModels? stateModel;
  StateRecord? selectedState;
  bool _stateLoader = false;
  List<Map<String, dynamic>>? vendorTypes;

  Future<void> fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
      if (countryModel != null) {
        getAllMetaData();
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    vendorTypes = await provider.getAllVendorTypes();
    final response = await provider.getAllMetaData();

    if (response != null) {
      SecurePreferencesUtil.saveServerStep(
        int.parse(response.data['step'] ?? '1'),
      );
      /**
       * Parsing company information data
       */

      if (vendorTypes != null && vendorTypes!.isNotEmpty) {
        final categoryType = vendorTypes!.firstWhere(
          (element) => element['name'] == response.data['company_type'],
          orElse: () => vendorTypes!.first,
        );
        _companyCategoryController.text = categoryType['name'];
        ciModel.companyType = categoryType['id'];
      }
      ciModel.companyName = _companyNameController.text = response.data['company_name'] ?? '';
      ciModel.companyEmail = _companyEmailController.text = response.data['company_email'] ?? '';
      ciModel.companyPhoneNumber = _companyNumberController.text = response.data['company_phone_number'] ?? '';
      ciModel.tradingLicenseNumber = _tlnController.text = response.data['trading_license_number'] ?? '';
      ciModel.companyAddress = _addressController.text = response.data['company_address'] ?? '';
      ciModel.addressType = selectedHomeShopOption = response.data['address_type'] ?? 'home';
      ciModel.mobileNumber = _mobileNumberController.text = response.data['mobile_number'] ?? '';
      ciModel.tradingLicenseExpiryDate =
          _tradeLicenseNumberExpiryController.text = response.data['trading_license_expiry'] ?? '';
      ciModel.companyLogoFileName = _companyLogoController.text = response.data['company_logo_name'] ?? '';
      ciModel.companyLogoFileServerPath = response.data['company_logo_path'] ?? '';
      ciModel.utlFileName = _utlController.text = response.data['tdl_file_name'] ?? '';
      ciModel.utlFileServerPath = response.data['tdl_file_path'] ?? '';
      ciModel.nocPoaFileName = _nocApplicableController.text = response.data['noc_file_name'] ?? '';
      ciModel.nocPoaFileServerPath = response.data['noc_file_path'] ?? '';
      ciModel.vatFileName = _vatCertificateController.text = response.data['vat_file_name'] ?? '';
      ciModel.vatFileServerPath = response.data['vat_file_path'] ?? '';

      // Setup existing country and region data
      final countryData = response.data['company_country'] ?? '';
      ciModel.companyRegion = response.data['company_region'] ?? '';

      await _setupExistingData(countryData, ciModel.companyRegion);
    }
  }

  Future<void> _setupExistingData(String countryData, String? regionData) async {
    if (countryData.isNotEmpty) {
      // Find country by name or code
      final CountryList? countryRecord = countryModel?.data?.list?.firstWhere(
        (element) => element.name == countryData || element.code == countryData,
        orElse: () => countryModel!.data!.list!.first,
      );

      if (countryRecord != null) {
        selectedCountryId = countryRecord.id;
        countryCode = countryRecord.code ?? '';
        _countryController.text = countryRecord.name ?? '';
        ciModel.companyCountry = countryCode;

        // Fetch states for this country
        if (selectedCountryId != null) {
          try {
            stateModel = await fetchStates(selectedCountryId!);

            // Find and set the existing region/state
            if (regionData != null && regionData.isNotEmpty && stateModel?.data?.isNotEmpty == true) {
              final StateRecord foundState = stateModel!.data!.firstWhere(
                (element) => element.name == regionData,
                orElse: () => stateModel!.data!.first,
              );

              selectedState = foundState;
              _regionController.text = foundState.name ?? '';
            }

            if (mounted) {
              setState(() {});
            }
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
    _companyNameFocusNode.dispose();
    _companyLogoFocusNode.dispose();
    _companyCategoryFocusNode.dispose();
    _companyEmailFocusNode.dispose();
    _companyNumberFocusNode.dispose();
    _cMobileNumberFocusNode.dispose();
    _tlnFocusNode.dispose();
    _utlFocusNode.dispose();
    _cAddressFocusNode.dispose();
    _tradeLicenseNumberFocusNode.dispose();
    _countryFocusNode.dispose();
    _regionFocusNode.dispose();
    _nocApplicableFocusNode.dispose();
    _vatCertificateFocusNode.dispose();

    _companyNameController.dispose();
    _companyLogoController.dispose();
    _companyCategoryController.dispose();
    _companyEmailController.dispose();
    _companyNumberController.dispose();
    _mobileNumberController.dispose();
    _tlnController.dispose();
    _utlController.dispose();
    _addressController.dispose();
    _tradeLicenseNumberExpiryController.dispose();
    _countryController.dispose();
    _regionController.dispose();
    _nocApplicableController.dispose();
    _vatCertificateController.dispose();

    super.dispose();
  }

  Future<CompanyInfoResponse?> updateCompanyInfoData(
    CompanyInfoPostData ciData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.updateCompanyInfoData(context, ciData);
    return response;
  }

  @override
  Widget build(BuildContext context) {
    ciModel.addressType = selectedHomeShopOption;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
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
                          child: Form(
                            key: _formKey,
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
                                      VendorAppStrings.companyInformation.tr,
                                      style: loginHeading(),
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companyName.tr,
                                      hintText: VendorAppStrings.enterCompanyName.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companyNameController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _companyNameFocusNode,
                                      nextFocusNode: _companyLogoFocusNode,
                                      validator: Validator.companyName,
                                      onValueChanged: (value) {
                                        ciModel.companyName = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.uploadCompanyLogo.tr,
                                      hintText: VendorAppStrings.noFileChosen.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companyLogoController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _companyLogoFocusNode,
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.upload_outlined,
                                      prefixContainerColor: Colors.grey.shade300,
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      nextFocusNode: _companyCategoryFocusNode,
                                      isEditable: false,
                                      validator: Validator.fieldRequired,
                                      onIconPressed: () async {
                                        final File? file = await CameraGalleryImagePicker.pickImage(
                                          context: context,
                                          source: ImagePickerSource.gallery,
                                        );
                                        if (file != null) {
                                          _companyLogoController.text = p.basename(file.path);
                                          ciModel.companyLogoFile = file;
                                          ciModel.companyLogoFileName = p.basename(file.path);
                                        } else {
                                          _companyLogoController.text = '';
                                          ciModel.companyLogoFile = null;
                                          ciModel.companyLogoFileName = '';
                                        }
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companyCategoryType.tr,
                                      hintText: VendorAppStrings.selectCcType.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companyCategoryController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _companyCategoryFocusNode,
                                      nextFocusNode: _companyEmailFocusNode,
                                      isEditable: false,
                                      suffixIcon: Icons.keyboard_arrow_down_outlined,
                                      suffixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      validator: Validator.companyCategoryType,
                                      onIconPressed: () async {
                                        final Map? categoryType = await showCompanyCategoryType(
                                          context,
                                          _companyCategoryController.text,
                                          vendorTypes,
                                        );
                                        if (categoryType != null && categoryType.isNotEmpty) {
                                          _companyCategoryController.text = categoryType['companyCategoryTypeName'];
                                          ciModel.companyType = categoryType['companyCategoryTypeId'];
                                        }
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companyEmail.tr,
                                      hintText: VendorAppStrings.enterCompanyEmail.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companyEmailController,
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: _companyEmailFocusNode,
                                      nextFocusNode: _companyNumberFocusNode,
                                      validator: Validator.email,
                                      onValueChanged: (value) {
                                        ciModel.companyEmail = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                                      labelText: VendorAppStrings.phoneNumberLandline.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      hintText: VendorAppStrings.enterPhoneNumber.tr,
                                      controller: _companyNumberController,
                                      prefixIcon: Icons.keyboard_arrow_down_outlined,
                                      prefixText: '+971',
                                      isPrefixFilled: true,
                                      keyboardType: TextInputType.phone,
                                      focusNode: _companyNumberFocusNode,
                                      nextFocusNode: _cMobileNumberFocusNode,
                                      validator: Validator.companyLandline,
                                      onValueChanged: (value) {
                                        ciModel.companyPhoneNumber = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                                      labelText: VendorAppStrings.mobileNumber.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      hintText: VendorAppStrings.enterMobileNumber.tr,
                                      controller: _mobileNumberController,
                                      prefixIcon: Icons.keyboard_arrow_down_outlined,
                                      prefixText: '+971',
                                      isPrefixFilled: true,
                                      keyboardType: TextInputType.phone,
                                      focusNode: _cMobileNumberFocusNode,
                                      nextFocusNode: _tlnFocusNode,
                                      validator: Validator.companyMobile,
                                      onValueChanged: (value) {
                                        ciModel.mobileNumber = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.tradeLicenseNumber.tr,
                                      hintText: VendorAppStrings.enterTradeLicenseNumber.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _tlnController,
                                      keyboardType: TextInputType.text,
                                      focusNode: _tlnFocusNode,
                                      isPrefixFilled: true,
                                      prefixText: ' CN -',
                                      prefixContainerColor: Colors.grey.shade300,
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      nextFocusNode: _utlFocusNode,
                                      onValueChanged: (value) {
                                        ciModel.tradingLicenseNumber = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.uploadTradeLicensePdf.tr,
                                      hintText: VendorAppStrings.noFileChosen.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _utlController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _utlFocusNode,
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.upload_outlined,
                                      prefixContainerColor: Colors.grey.shade300,
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      nextFocusNode: _cAddressFocusNode,
                                      validator: Validator.fieldRequired,
                                      onIconPressed: () async {
                                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          final File file = File(result.files.single.path!);
                                          _utlController.text = result.files.single.name;
                                          ciModel.utlFile = file;
                                          ciModel.utlFileName = result.files.single.name;
                                        } else {
                                          _utlController.text = '';
                                          ciModel.utlFile = null;
                                          ciModel.utlFileName = '';
                                        }
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companyAddress.tr,
                                      hintText: VendorAppStrings.enterCompanyAddress.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _addressController,
                                      keyboardType: TextInputType.streetAddress,
                                      focusNode: _cAddressFocusNode,
                                      nextFocusNode: _tradeLicenseNumberFocusNode,
                                      validator: Validator.companyAddress,
                                      onValueChanged: (value) {
                                        ciModel.companyAddress = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.tradeLicenseNumberExpiryDate.tr,
                                      hintText: VendorAppStrings.enterTradeLicenseExpiryDate.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _tradeLicenseNumberExpiryController,
                                      keyboardType: TextInputType.datetime,
                                      focusNode: _tradeLicenseNumberFocusNode,
                                      nextFocusNode: _countryFocusNode,
                                      suffixIcon: Icons.calendar_today_outlined,
                                      suffixIconColor: Colors.grey,
                                      isEditable: false,
                                      validator: Validator.tradeLicenseNumberExpiryDate,
                                      onIconPressed: () async {
                                        final result = await showDatePickerDialog(context);
                                        if (result != null) {
                                          final date = result.toString().split(' ')[0];
                                          _tradeLicenseNumberExpiryController.text = date;
                                          ciModel.tradingLicenseExpiryDate = date;
                                        }
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
                                      nextFocusNode: _regionFocusNode,
                                      isEditable: false,
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
                                                  ciModel.companyCountry = selectedCountryId.toString();
                                                  ciModel.companyRegion = null;
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
                                      nextFocusNode: _nocApplicableFocusNode,
                                      suffixIcon:
                                          _stateLoader ? Icons.hourglass_empty : Icons.keyboard_arrow_down_outlined,
                                      isEditable: false,
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
                                                  ciModel.companyRegion = state.id?.toString() ?? '0';
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
                                      labelText: VendorAppStrings.nocPoaIfApplicablePdf.tr,
                                      hintText: VendorAppStrings.noFileChosen.tr,
                                      textStar: '',
                                      controller: _nocApplicableController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _nocApplicableFocusNode,
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.upload_outlined,
                                      prefixContainerColor: Colors.grey.shade300,
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      isEditable: false,
                                      nextFocusNode: _vatCertificateFocusNode,
                                      onIconPressed: () async {
                                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          final File file = File(result.files.single.path!);
                                          _nocApplicableController.text = result.files.single.name;
                                          ciModel.nocPoaFile = file;
                                          ciModel.nocPoaFileName = result.files.single.name;
                                        } else {
                                          _nocApplicableController.text = '';
                                          ciModel.nocPoaFile = null;
                                          ciModel.nocPoaFileName = '';
                                        }
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.vatCertificateIfApplicablePdf.tr,
                                      hintText: VendorAppStrings.noFileChosen.tr,
                                      textStar: '',
                                      controller: _vatCertificateController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _vatCertificateFocusNode,
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.upload_outlined,
                                      prefixContainerColor: Colors.grey.shade300,
                                      borderSide: const BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      prefixIconColor: Theme.of(context).colorScheme.onPrimary,
                                      isEditable: false,
                                      onIconPressed: () async {
                                        final FilePickerResult? result = await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          final File file = File(result.files.single.path!);
                                          _vatCertificateController.text = result.files.single.name;
                                          ciModel.vatFile = file;
                                          ciModel.vatFileName = result.files.single.name;
                                        } else {
                                          _vatCertificateController.text = '';
                                          ciModel.vatFile = null;
                                          ciModel.vatFileName = '';
                                        }
                                      },
                                    ),
                                    RadioGroup<String>(
                                      groupValue: selectedHomeShopOption,
                                      onChanged: (value) {
                                        setState(() {
                                          ciModel.addressType = value;
                                          selectedHomeShopOption = value!;
                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              const Radio<String>(
                                                value: 'home',
                                                activeColor: AppColors.peachyPink,
                                              ),
                                              Text(VendorAppStrings.home.tr),
                                            ],
                                          ),
                                          const SizedBox(width: 20),
                                          Row(
                                            children: [
                                              const Radio<String>(
                                                value: 'shop',
                                                activeColor: AppColors.peachyPink,
                                              ),
                                              Text(VendorAppStrings.shop.tr),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomVendorAuthButton(
                isLoading: mainProvider.isLoading,
                title: VendorAppStrings.saveAndContinue.tr,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final result = await updateCompanyInfoData(ciModel);
                    if (result != null) {
                      widget.onNext();
                    }
                  }
                },
              ),
            ),
            if (mainProvider.isLoading)
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
