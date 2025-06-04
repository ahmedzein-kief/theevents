import 'package:dio/dio.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  late MediaServices _mediaServices;

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
    addressController.dispose();
    taxIdController.dispose();
    businessNameController.dispose();
    businessNameFocusNode.dispose();
    taxIdFocusNode.dispose();
    addressFocusNode.dispose();
    super.dispose();
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
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  void _initializeTheField(
      {required VendorGetSettingsViewModel vendorGetSettingsProvider}) {
    final taxInfo = vendorGetSettingsProvider.apiResponse.data?.data?.taxInfo;
    if (taxInfo != null) {
      businessNameController.text = taxInfo.businessName?.toString() ?? '';
      taxIdController.text = taxInfo.taxId?.toString() ?? '';
      addressController.text = taxInfo.address?.toString() ?? '';
    }
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

  Widget _buildUi() => SimpleCard(
        expandedContent: Form(
          key: _formKey,
          child: Column(
            children: [
              /// Business Name
              CustomTextFormField(
                labelText: 'Business Name',
                required: true,
                hintText: 'Enter Business Name',
                validator: Validator.fieldCannotBeEmpty,
                controller: businessNameController,
                focusNode: businessNameFocusNode,
                nextFocusNode: taxIdFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Tax ID
              CustomTextFormField(
                labelText: 'Tax ID',
                required: true,
                validator: Validator.fieldCannotBeEmpty,
                hintText: 'Enter Tax ID',
                controller: taxIdController,
                focusNode: taxIdFocusNode,
                nextFocusNode: addressFocusNode,
                onChanged: (value) {},
              ),
              kFormFieldSpace,

              /// Address
              CustomTextFormField(
                labelText: 'Address',
                required: false,
                hintText: 'Enter Address',
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
                  buttonText: 'Save Settings',
                  borderRadius: kButtonRadius,
                  mainAxisSize: MainAxisSize.max,
                  buttonColor: AppColors.lightCoral,
                  isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                  onTap: () async {
                    try {
                      if (_formKey.currentState?.validate() ?? false) {
                        setProcessing(true);
                        _createForm();

                        /// send data to server
                        final vendorSettingsProvider =
                            context.read<VendorSettingsViewModel>();
                        final result =
                            await vendorSettingsProvider.vendorSettings(
                                vendorSettingsType: VendorSettingType.taxInfo,
                                form: form,
                                context: context);
                        if (result) {
                          setProcessing(false);
                          await _onRefresh();
                        }
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
