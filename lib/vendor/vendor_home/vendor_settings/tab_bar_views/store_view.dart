import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/payment_address/country_picks_provider.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/settings_components/choose_file_card.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_editable_text_field.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController coverImageLinkController =
      TextEditingController();

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
  CountryModels? countryModel;
  String countryCode = '';

  List<DropdownMenuItem> countryMenuItemsList = [];

  /// TODO: set the Dropdown menu items for country

  Future<void> _fetchCountryData() async {
    try {
      countryModel = await fetchCountries(context);
      _initializeTheCountryDropdown();
    } catch (error) {}
  }

  void _initializeTheCountryDropdown() {
    countryMenuItemsList = countryModel?.data?.list
            ?.map(
              (element) => DropdownMenuItem(
                value: element.value?.toString().trim(),
                child: Text(
                  element.label?.toString() ?? '',
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            )
            .toList() ??
        [];
    setState(() {});
  }

  /// To show modal progress hud
  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    final VendorGetSettingsViewModel vendorGetSettingsProvider =
        context.read<VendorGetSettingsViewModel>();
    _fetchCountryData();

    ///calling without blocking main thread
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  void _initializeTheField(
      {required VendorGetSettingsViewModel vendorGetSettingsProvider}) {
    /// everytime set files to null on refresh
    logoFile = null;
    coverImageFile = null;

    _initializeTheCountryDropdown();

    /// initialize the country dropdown

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
            convertHtmlToDelta(htmlContent: contentController.text));
      }
      countryController.text = storeInfo.country?.toString() ?? '';
      stateController.text = storeInfo.state?.toString() ?? '';
      cityController.text = storeInfo.city?.toString() ?? '';
      addressController.text = storeInfo.address?.toString() ?? '';
      companyController.text = storeInfo.company?.toString() ?? '';
      logoLinkController.text = storeInfo.logo?.toString().trim() ?? '';
      coverImageLinkController.text =
          storeInfo.coverImage?.toString().trim() ?? '';
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

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Utils.pageRefreshIndicator(
          onRefresh: _onRefresh,
          child: Consumer<VendorGetSettingsViewModel>(
            builder: (context, vendorGetSettingsProvider, _) {
              /// Show loading if refreshing
              if (vendorGetSettingsProvider.apiResponse.status ==
                  ApiStatus.LOADING)
                return Utils.pageLoadingIndicator(context: context);

              /// return ui if loading ends
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  _buildUi(),
                ],
              );
            },
          ),
        ),
      );

  SimpleCard _buildUi() => SimpleCard(
        expandedContent: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Name
              CustomTextFormField(
                labelText: 'Name',
                required: true,
                hintText: 'Enter Name',
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
                labelText: 'Shop URL',
                required: true,
                hintText: 'Enter Shop URL',
                validator: Validator.fieldCannotBeEmpty,

                /// Don't need validation here. It will get validated through teh server only.
                controller: shopUrlController,
                focusNode: shopUrlFocusNode,
                nextFocusNode: emailFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Email
              CustomTextFormField(
                labelText: 'Email',
                required: true,
                hintText: 'Enter Email',
                validator: Validator.email,
                controller: emailController,
                focusNode: emailFocusNode,
                nextFocusNode: phoneFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Phone
              CustomTextFormField(
                labelText: 'Phone',
                required: true,
                hintText: 'Enter Phone',
                validator: Validator.phone,
                maxLength: 15,
                keyboardType: TextInputType.number,
                controller: phoneController,
                focusNode: phoneFocusNode,
                nextFocusNode: titleFocusNode,
                onChanged: (value) {},
              ),
              // kFormFieldSpace,

              /// Title
              CustomTextFormField(
                labelText: 'Title',
                required: false,
                hintText: 'Enter Title',
                controller: titleController,
                focusNode: titleFocusNode,
                nextFocusNode: descriptionFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Description
              CustomTextFormField(
                labelText: 'Description',
                required: false,
                hintText: 'Enter Description',
                controller: descriptionController,
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                nextFocusNode: contentFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Content: Editable text
              fieldTitle(text: 'Content'),
              kFormTitleFieldSpace,
              Material(
                child: CustomEditableTextField(
                  placeholder: 'Enter content here..',
                  quillController: _contentQuilController,
                ),
              ),
              kFormFieldSpace,

              /// Country
              fieldTitle(text: 'Country', required: true),
              kExtraSmallSpace,
              CustomDropdown(
                hintText: 'Select Country',
                value: countryController.text,
                validator: Validator.country,
                textStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                menuItemsList: countryMenuItemsList,
                onChanged: (value) {
                  setState(() {
                    countryController.text = value;
                  });
                },
              ),
              kFormFieldSpace,

              /// State
              CustomTextFormField(
                labelText: 'State',
                required: false,
                hintText: 'Enter State',
                controller: stateController,
                focusNode: stateFocusNode,
                nextFocusNode: cityFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// City
              CustomTextFormField(
                labelText: 'City',
                required: false,
                hintText: 'Enter City',
                controller: cityController,
                focusNode: cityFocusNode,
                nextFocusNode: addressFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Address
              CustomTextFormField(
                labelText: 'Address',
                required: false,
                hintText: 'Enter Address',
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
                labelText: 'Company',
                required: false,
                hintText: 'Enter Company',
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
                  buttonText: 'Save Settings',
                  borderRadius: kButtonRadius,
                  mainAxisSize: MainAxisSize.max,
                  buttonColor: AppColors.lightCoral,
                  isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                  onTap: () async {
                    try {
                      setProcessing(true);

                      /// converting content text to html and storing in content controller
                      contentController.text = convertDeltaToHtml(
                          quilController: _contentQuilController);
                      if (_formKey.currentState?.validate() ?? false) {
                        _createForm();
                        final result = await provider.vendorSettings(
                            vendorSettingsType: VendorSettingType.store,
                            form: form,
                            context: context);
                        setProcessing(false);
                        if (result) await _onRefresh();

                        /// refresh the page if settings are updated
                      }
                    } catch (e) {
                      setProcessing(false);
                      AlertServices.showErrorSnackBar(
                          message: 'Oops! something went wrong..',
                          context: context);
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
            title: 'Logo',
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
            title: 'Cover Image',
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
  Widget _chooseImage(
          {File? myFile,
          String? title,
          String? imageLink,
          required Function(File?) onFileSelected,
          required Function(File?) onFileClose}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            title ?? '',
            style: headingFields().copyWith(
                fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
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
                onFileSelected(
                    file); // Update the parent state with the selected file
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
                onFileSelected(
                    file); // Update the parent state with the selected file
              }
            },
            child: Text(
              'Choose Image',
              style: headingFields().copyWith(
                  fontSize: 16, fontWeight: FontWeight.w400, color: Colors.red),
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
      'country': countryController.text,
      'state': stateController.text,
      'city': cityController.text,
      'address': addressController.text,
      'company': companyController.text,
      // Check for null files and add accordingly
      if (logoFile != null)
        'logo_input': MultipartFile.fromFileSync(logoFile!.path,
            filename:
                logoFile!.path.split('/').last), // Default placeholder if null
      if (coverImageFile != null)
        'cover_image_input': MultipartFile.fromFileSync(coverImageFile!.path,
            filename: coverImageFile!.path.split('/').last),
    });
  }
}
