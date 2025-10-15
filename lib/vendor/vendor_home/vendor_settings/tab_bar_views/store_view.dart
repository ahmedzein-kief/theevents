import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/payment_address/country_picks_provider.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/settings_components/choose_file_card.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_editable_text_field.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/vendor_app_strings.dart';
import '../../../../models/wishlist_models/states_cities_models.dart';
import '../../../../views/country_picker/country_pick_screen.dart';

class StoreView extends StatefulWidget {
  const StoreView({super.key});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView> {
  /// FormKey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingControllers for the form fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController shopUrlController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController logoLinkController = TextEditingController();
  final TextEditingController coverImageLinkController = TextEditingController();

  // FocusNodes
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode shopUrlFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode contentFocusNode = FocusNode();
  final FocusNode countryFocusNode = FocusNode();
  final FocusNode stateFocusNode = FocusNode();
  final FocusNode cityFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();
  final FocusNode companyFocusNode = FocusNode();

  File? logoFile;
  File? coverImageFile;
  late MediaServices _mediaServices;
  final QuillController _contentQuilController = QuillController.basic();

  // Location data - similar to ProfileAddressScreen
  CountryModels? countryModel;
  int? selectedCountryId;
  StateModels? stateModel;
  CityModels? cityModel;
  bool _stateLoader = false;
  bool _cityLoader = false;
  StateRecord? selectedState;
  CityRecord? selectedCity;
  String countryCode = '';

  Future<void> _fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  // Location data fetching methods - similar to ProfileAddressScreen
  Future<void> fetchStateData(
    int countryId, {
    bool isEditingExisting = false,
  }) async {
    try {
      setState(() {
        _stateLoader = true;
        if (!isEditingExisting) {
          stateController.clear();
          cityController.clear();
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

  Future<void> fetchCityData(
    int stateId,
    int countryId, {
    bool isEditingExisting = false,
  }) async {
    try {
      setState(() {
        _cityLoader = true;
        if (!isEditingExisting) {
          cityController.clear();
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

  // Setup existing store data - similar to _setupExistingAddressData
  Future<void> _setupExistingStoreData(storeInfo) async {
    if (countryModel?.data?.list?.isNotEmpty == true) {
      final countryName = storeInfo.country?.toString() ?? '';

      if (countryName.isNotEmpty) {
        // Find the country that matches the store's address
        CountryList? countryRecord;
        try {
          countryRecord = countryModel!.data!.list!.firstWhere(
            (element) => element.name == countryName,
          );
        } catch (e) {
          try {
            countryRecord = countryModel!.data!.list!.firstWhere(
              (element) => element.code == countryName,
            );
          } catch (e) {
            countryRecord = null;
          }
        }

        if (countryRecord != null) {
          // Set country data
          selectedCountryId = countryRecord.id;
          countryCode = countryRecord.code ?? '';
          countryController.text = countryRecord.name ?? '';

          // Fetch states for this country
          if (selectedCountryId != null) {
            try {
              await fetchStateData(selectedCountryId!, isEditingExisting: true);

              // Find and set the matching state
              if (stateModel?.data?.isNotEmpty == true) {
                final stateName = storeInfo.state?.toString() ?? '';

                if (stateName.isNotEmpty) {
                  try {
                    selectedState = stateModel!.data!.firstWhere(
                      (element) => element.name == stateName,
                    );
                    stateController.text = selectedState!.name ?? '';

                    // Fetch cities for this state
                    if (selectedState?.id != null) {
                      try {
                        await fetchCityData(
                          selectedState!.id!,
                          selectedCountryId!,
                          isEditingExisting: true,
                        );

                        // Find and set the matching city
                        if (cityModel?.data?.isNotEmpty == true) {
                          final cityName = storeInfo.city?.toString() ?? '';

                          if (cityName.isNotEmpty) {
                            try {
                              selectedCity = cityModel!.data!.firstWhere(
                                (element) => element.name == cityName,
                              );
                              cityController.text = selectedCity!.name ?? '';
                            } catch (error) {
                              debugPrint(error.toString());
                            }
                          }
                        }
                      } catch (error) {
                        debugPrint(error.toString());
                      }
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
  }

  Future _onRefresh() async {
    final VendorGetSettingsViewModel vendorGetSettingsProvider = context.read<VendorGetSettingsViewModel>();
    await _fetchCountryData();

    ///calling without blocking main thread
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  Future<void> _initializeTheField({
    required VendorGetSettingsViewModel vendorGetSettingsProvider,
  }) async {
    /// everytime set files to null on refresh
    logoFile = null;
    coverImageFile = null;

    final storeInfo = vendorGetSettingsProvider.apiResponse.data?.data?.store;
    if (storeInfo != null) {
      nameController.text = storeInfo.name?.toString() ?? '';
      shopUrlController.text = storeInfo.slug?.toString() ?? '';
      emailController.text = storeInfo.email?.toString() ?? '';
      phoneController.text = storeInfo.phone?.toString() ?? '';
      titleController.text = storeInfo.title?.toString() ?? '';
      descriptionController.text = storeInfo.description?.toString() ?? '';
      contentController.text = storeInfo.content?.toString() ?? '';
      if (contentController.text.isNotEmpty) {
        _contentQuilController.document = Document.fromDelta(
          convertHtmlToDelta(htmlContent: contentController.text),
        );
      }

      addressController.text = storeInfo.address?.toString() ?? '';
      companyController.text = storeInfo.company?.toString() ?? '';
      logoLinkController.text = storeInfo.logo?.toString().trim() ?? '';
      coverImageLinkController.text = storeInfo.coverImage?.toString().trim() ?? '';

      // Setup location data after country model is loaded
      await _setupExistingStoreData(storeInfo);
    }
  }

  @override
  void initState() {
    /// Initialize MediaServices
    _mediaServices = MediaServices();
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
    super.initState();
  }

  // Dispose all controllers when done
  @override
  void dispose() {
    nameController.dispose();
    shopUrlController.dispose();
    emailController.dispose();
    phoneController.dispose();
    titleController.dispose();
    descriptionController.dispose();
    contentController.dispose();
    countryController.dispose();
    stateController.dispose();
    cityController.dispose();
    addressController.dispose();
    companyController.dispose();
    logoLinkController.dispose();
    coverImageLinkController.dispose();

    nameFocusNode.dispose();
    shopUrlFocusNode.dispose();
    emailFocusNode.dispose();
    phoneFocusNode.dispose();
    titleFocusNode.dispose();
    descriptionFocusNode.dispose();
    contentFocusNode.dispose();
    countryFocusNode.dispose();
    stateFocusNode.dispose();
    cityFocusNode.dispose();
    addressFocusNode.dispose();
    companyFocusNode.dispose();
    _contentQuilController.dispose();
    super.dispose();
  }

  // Country field widget - similar to ProfileAddressScreen
  Widget _buildCountryField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: VendorAppStrings.country.tr,
          required: true,
          hintText: VendorAppStrings.selectCountry.tr,
          controller: countryController,
          focusNode: countryFocusNode,
          validator: Validator.country,
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
          onTap: () async {
            if (countryModel?.data?.list?.isNotEmpty ?? false) {
              showDialog(
                context: context,
                builder: (context) => CountryPickerDialog(
                  countryList: countryModel!.data!.list!,
                  currentSelection: countryController.text,
                  onCountrySelected: (selectedCountry) {
                    setState(() {
                      countryCode = selectedCountry.code ?? '';
                      selectedCountryId = selectedCountry.id ?? 0;
                      countryController.text = selectedCountry.name ?? '';

                      // Clear dependent fields when country changes
                      stateController.clear();
                      cityController.clear();
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
        ),
      ],
    );
  }

  // State field widget - similar to ProfileAddressScreen
  Widget _buildStateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: VendorAppStrings.state.tr,
          required: false,
          hintText: VendorAppStrings.selectRegion.tr,
          controller: stateController,
          focusNode: stateFocusNode,
          nextFocusNode: cityFocusNode,
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
                    setState(() {
                      selectedState = state;
                      stateController.text = selectedState?.name ?? '';

                      // Clear dependent fields when state changes
                      cityController.clear();
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
        ),
      ],
    );
  }

  // City field widget - similar to ProfileAddressScreen
  Widget _buildCityField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFormField(
          labelText: VendorAppStrings.city.tr,
          required: false,
          hintText: VendorAppStrings.enterCity.tr,
          controller: cityController,
          focusNode: cityFocusNode,
          nextFocusNode: addressFocusNode,
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
                    setState(() {
                      selectedCity = city;
                      cityController.text = selectedCity?.name ?? '';
                    });
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AppUtils.pageRefreshIndicator(
          context: context,
          onRefresh: _onRefresh,
          child: Consumer<VendorGetSettingsViewModel>(
            builder: (context, vendorGetSettingsProvider, _) {
              /// Show loading if refreshing
              if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.LOADING) {
                return AppUtils.pageLoadingIndicator(context: context);
              }

              /// return ui if loading ends
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildUi(context),
                ],
              );
            },
          ),
        ),
      );

  SimpleCard _buildUi(BuildContext context) => SimpleCard(
        color: Theme.of(context).colorScheme.surface,
        expandedContent: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Name
              CustomTextFormField(
                labelText: VendorAppStrings.name.tr,
                required: true,
                hintText: VendorAppStrings.enterNameField.tr,
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                validator: Validator.fieldCannotBeEmpty,
                maxLength: 250,
                controller: nameController,
                focusNode: nameFocusNode,
                nextFocusNode: shopUrlFocusNode,
                onChanged: (value) {},
              ),
              // kFormFieldSpace,
              /// Shop URL
              CustomTextFormField(
                labelText: VendorAppStrings.shopUrl.tr,
                required: true,
                hintText: VendorAppStrings.enterShopUrl.tr,
                validator: Validator.fieldCannotBeEmpty,
                controller: shopUrlController,
                focusNode: shopUrlFocusNode,
                nextFocusNode: emailFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Email
              CustomTextFormField(
                labelText: VendorAppStrings.email.tr,
                required: true,
                hintText: VendorAppStrings.enterEmailAddress.tr,
                validator: Validator.email,
                controller: emailController,
                focusNode: emailFocusNode,
                nextFocusNode: phoneFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Phone
              CustomTextFormField(
                labelText: VendorAppStrings.phone.tr,
                required: true,
                hintText: VendorAppStrings.enterPhoneNumberField.tr,
                validator: Validator.phone,
                maxLength: 15,
                keyboardType: TextInputType.number,
                controller: phoneController,
                focusNode: phoneFocusNode,
                nextFocusNode: titleFocusNode,
                onChanged: (value) {},
              ),

              /// Title
              CustomTextFormField(
                labelText: VendorAppStrings.title.tr,
                required: false,
                hintText: VendorAppStrings.enterTitleField.tr,
                controller: titleController,
                focusNode: titleFocusNode,
                nextFocusNode: descriptionFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Description
              CustomTextFormField(
                labelText: VendorAppStrings.description.tr,
                required: false,
                hintText: VendorAppStrings.enterDescriptionField.tr,
                controller: descriptionController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                nextFocusNode: contentFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Content: Editable text
              fieldTitle(text: VendorAppStrings.content.tr),
              kFormTitleFieldSpace,
              Material(
                child: CustomEditableTextField(
                  placeholder: VendorAppStrings.enterDescriptionFieldAlt.tr,
                  quillController: _contentQuilController,
                ),
              ),
              kFormFieldSpace,

              /// Country - Updated to use proper dialog picker
              _buildCountryField(),
              kFormFieldSpace,

              /// State - Updated to use proper dialog picker
              _buildStateField(),
              kFormFieldSpace,

              /// City - Updated to use proper dialog picker
              _buildCityField(),
              kFormFieldSpace,

              /// Address
              CustomTextFormField(
                labelText: VendorAppStrings.companyAddress.tr,
                required: false,
                hintText: VendorAppStrings.enterCompanyAddress.tr,
                controller: addressController,
                focusNode: addressFocusNode,
                nextFocusNode: companyFocusNode,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Company
              CustomTextFormField(
                labelText: VendorAppStrings.company.tr,
                required: false,
                hintText: VendorAppStrings.companyName.tr,
                controller: companyController,
                focusNode: companyFocusNode,
                onChanged: (value) {},
              ),

              kFormFieldSpace,

              /// Choose Images
              // Logo & cover image
              _logoAndCoverImage(),

              kFormFieldSpace,
              kFormFieldSpace,

              /// Save Button
              Consumer<VendorSettingsViewModel>(
                builder: (context, provider, _) => CustomAppButton(
                  buttonText: VendorAppStrings.save.tr,
                  borderRadius: kButtonRadius,
                  mainAxisSize: MainAxisSize.max,
                  buttonColor: AppColors.lightCoral,
                  isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                  onTap: () async {
                    try {
                      /// converting content text to html and storing in content controller
                      contentController.text = convertDeltaToHtml(
                        quilController: _contentQuilController,
                      );
                      if (_formKey.currentState?.validate() ?? false) {
                        _createForm();
                        final result = await provider.vendorSettings(
                          vendorSettingsType: VendorSettingType.store,
                          form: form,
                          context: context,
                        );

                        if (result) await _onRefresh();
                      } else {}
                    } catch (e) {
                      AppUtils.showToast('Oops! something went wrong..');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  /// Logo and cover image wrapped inside row
  Wrap _logoAndCoverImage() => Wrap(
        alignment: WrapAlignment.spaceBetween,
        spacing: 30,
        runAlignment: WrapAlignment.start,
        runSpacing: kPadding,
        children: [
          _chooseImage(
            myFile: logoFile,
            title: VendorAppStrings.logo.tr,
            imageLink: logoLinkController.text,
            onFileSelected: (file) {
              setState(() {
                logoFile = file;
              });
            },
            onFileClose: (file) {
              setState(() {
                logoFile = file;
                logoLinkController.clear();
              });
            },
          ),
          _chooseImage(
            myFile: coverImageFile,
            title: VendorAppStrings.coverImage.tr,
            imageLink: coverImageLinkController.text,
            onFileSelected: (file) {
              setState(() {
                coverImageFile = file;
              });
            },
            onFileClose: (file) {
              setState(() {
                coverImageFile = file;
                coverImageLinkController.clear();
              });
            },
          ),
        ],
      );

  /// Images cards with some metadata
  Widget _chooseImage({
    File? myFile,
    String? title,
    String? imageLink,
    required Function(File?) onFileSelected,
    required Function(File?) onFileClose,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title ?? '',
            style: headingFields().copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          ChooseFileCard(
            file: myFile,
            imageLink: imageLink,
            onChoose: () async {
              final file = await _mediaServices.getSingleImageFromGallery();
              if (file != null) {
                onFileSelected(file);
              }
            },
            onClose: () {
              onFileClose(null);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              final file = await _mediaServices.getSingleImageFromGallery();
              if (file != null) {
                onFileSelected(file);
              }
            },
            child: Text(
              VendorAppStrings.uploadImages.tr,
              style: headingFields().copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.red,
              ),
            ),
          ),
        ],
      );

  /// Final form
  FormData form = FormData();

  void _createForm() {
    form = FormData.fromMap({
      'name': nameController.text,
      'slug': shopUrlController.text,
      'email': emailController.text.toString().toLowerCase().trim(),
      'phone': phoneController.text,
      'title': titleController.text,
      'description': descriptionController.text,
      'content': contentController.text,
      // Use proper location data similar to ProfileAddressScreen
      'country': countryController.text,
      'country_id': selectedCountryId?.toString() ?? '',
      'country_code': countryCode,
      'state': stateController.text,
      'state_id': selectedState?.id?.toString() ?? '',
      'city': cityController.text,
      'city_id': selectedCity?.id?.toString() ?? '',
      'address': addressController.text,
      'company': companyController.text,
      // Check for null files and add accordingly
      if (logoFile != null)
        'logo_input': MultipartFile.fromFileSync(
          logoFile!.path,
          filename: logoFile!.path.split('/').last,
        ),
      if (coverImageFile != null)
        'cover_image_input': MultipartFile.fromFileSync(
          coverImageFile!.path,
          filename: coverImageFile!.path.split('/').last,
        ),
    });
  }
}
