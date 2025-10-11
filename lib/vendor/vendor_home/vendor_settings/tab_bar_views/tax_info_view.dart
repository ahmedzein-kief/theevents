import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/vendor_app_strings.dart';

class TaxInfoView extends StatefulWidget {
  const TaxInfoView({super.key});

  @override
  State<TaxInfoView> createState() => _TaxInfoViewState();
}

class _TaxInfoViewState extends State<TaxInfoView> {
  /// FormKey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextEditingControllers for the form fields
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController taxIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  /// Focus Nodes
  final FocusNode businessNameFocusNode = FocusNode();
  final FocusNode taxIdFocusNode = FocusNode();
  final FocusNode addressFocusNode = FocusNode();

  @override
  void initState() {
    /// Initialize MediaServices
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
    super.initState();
  }

  // Dispose all controllers when done
  @override
  void dispose() {
    addressController.dispose();
    taxIdController.dispose();
    businessNameController.dispose();
    businessNameFocusNode.dispose();
    taxIdFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
  }

  Future _onRefresh() async {
    final VendorGetSettingsViewModel vendorGetSettingsProvider = context.read<VendorGetSettingsViewModel>();
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  void _initializeTheField({
    required VendorGetSettingsViewModel vendorGetSettingsProvider,
  }) {
    final taxInfo = vendorGetSettingsProvider.apiResponse.data?.data?.taxInfo;
    if (taxInfo != null) {
      businessNameController.text = taxInfo.businessName?.toString() ?? '';
      taxIdController.text = taxInfo.taxId?.toString() ?? '';
      addressController.text = taxInfo.address?.toString() ?? '';
    }
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

  Widget _buildUi(BuildContext context) => SimpleCard(
        color: Theme.of(context).colorScheme.surface,
        expandedContent: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Business Name
              CustomTextFormField(
                labelText: VendorAppStrings.businessName.tr,
                required: true,
                hintText: VendorAppStrings.enterBusinessName.tr,
                hintStyle: TextStyle(color: Theme.of(context).hintColor),
                validator: Validator.fieldCannotBeEmpty,
                controller: businessNameController,
                focusNode: businessNameFocusNode,
                nextFocusNode: taxIdFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Tax ID
              CustomTextFormField(
                labelText: VendorAppStrings.taxId.tr,
                required: true,
                validator: Validator.fieldCannotBeEmpty,
                hintText: VendorAppStrings.enterTaxId.tr,
                controller: taxIdController,
                focusNode: taxIdFocusNode,
                nextFocusNode: addressFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Address
              CustomTextFormField(
                labelText: VendorAppStrings.address.tr,
                required: false,
                hintText: VendorAppStrings.enterAddress.tr,
                maxLines: 3,
                controller: addressController,
                focusNode: addressFocusNode,
                keyboardType: TextInputType.multiline,
                onChanged: (value) {},
              ),
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
                      if (_formKey.currentState?.validate() ?? false) {
                        _createForm();

                        /// send data to server
                        final vendorSettingsProvider = context.read<VendorSettingsViewModel>();
                        final result = await vendorSettingsProvider.vendorSettings(
                          vendorSettingsType: VendorSettingType.taxInfo,
                          form: form,
                          context: context,
                        );
                        if (result) {
                          await _onRefresh();
                        }
                      }
                    } catch (e) {
                      AppUtils.showToast('${VendorAppStrings.error.tr}Oops! something went wrong..');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  FormData form = FormData();

  void _createForm() {
    form = FormData.fromMap({
      'tax_info': {
        'business_name': businessNameController.text,
        'tax_id': taxIdController.text,
        'address': addressController.text,
      },
    });
  }
}
