import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/vendor_settings_models/vendor_get_settings_model.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:event_app/vendor/components/services/media_services.dart';
import 'package:event_app/vendor/components/settings_components/simple_card.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/vendor_app_strings.dart';

class PayoutInfoView extends StatefulWidget {
  const PayoutInfoView({super.key});

  @override
  State<PayoutInfoView> createState() => _PayoutInfoViewState();
}

class _PayoutInfoViewState extends State<PayoutInfoView> {
  /// FormKey
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Declare TextEditingControllers and FocusNodes
  final TextEditingController paymentMethodController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController paypalIdController = TextEditingController();
  final TextEditingController upiIdController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final FocusNode paymentMethodFocusNode = FocusNode();
  final FocusNode bankNameFocusNode = FocusNode();
  final FocusNode ifscFocusNode = FocusNode();
  final FocusNode accountHolderNameFocusNode = FocusNode();
  final FocusNode accountNumberFocusNode = FocusNode();
  final FocusNode paypalIdFocusNode = FocusNode();
  final FocusNode upiIdFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();

  late MediaServices _mediaServices;

  // Dispose all controllers when done
  @override
  void dispose() {
    paymentMethodController.dispose();
    bankNameController.dispose();
    ifscController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    paypalIdController.dispose();
    upiIdController.dispose();
    descriptionController.dispose();

    paymentMethodFocusNode.dispose();
    bankNameFocusNode.dispose();
    ifscFocusNode.dispose();
    accountHolderNameFocusNode.dispose();
    accountNumberFocusNode.dispose();
    paypalIdFocusNode.dispose();
    upiIdFocusNode.dispose();
    descriptionFocusNode.dispose();

    super.dispose();
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

  /// To show modal progress hud
  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    final VendorGetSettingsViewModel vendorGetSettingsProvider = context.read<VendorGetSettingsViewModel>();
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      createPaymentMethodMenuItemsList(
        paymentMethodOptions: vendorGetSettingsProvider.apiResponse.data?.data?.paymentMethodOptions,
      );
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  void _initializeTheField({
    required VendorGetSettingsViewModel vendorGetSettingsProvider,
  }) {
    final bankInfo = vendorGetSettingsProvider.apiResponse.data?.data?.bankInfo;
    final paymentMethod = vendorGetSettingsProvider.apiResponse.data?.data?.paymentMethod;
    paymentMethodController.text = paymentMethod?.toString() ?? 'bank_transfer';
    isBankTransfer = paymentMethodController.text.trim() == 'bank_transfer';

    /// set bank transfer if nothing is selected
    bankNameController.text = bankInfo?.name?.toString() ?? '';
    ifscController.text = bankInfo?.code?.toString() ?? '';
    accountHolderNameController.text = bankInfo?.fullName?.toString() ?? '';
    accountNumberController.text = bankInfo?.number?.toString() ?? '';
    paypalIdController.text = bankInfo?.paypalId?.toString() ?? '';
    upiIdController.text = bankInfo?.upiId?.toString() ?? '';
    descriptionController.text = bankInfo?.description?.toString() ?? '';
  }

  List<DropdownMenuItem> paymentMethodsMenuItemsList = [];
  bool isBankTransfer = false;

  // Method to create dropdown items
  void createPaymentMethodMenuItemsList({
    required PaymentMethodOptions? paymentMethodOptions,
  }) {
    try {
      if (paymentMethodOptions == null) return;

      // Use a Set to ensure unique keys
      final uniqueEntries = <String>{};

      paymentMethodsMenuItemsList = paymentMethodOptions
          .toJson()
          .entries
          .where((entry) => uniqueEntries.add(entry.key)) // Only add if unique
          .map(
            (entry) => DropdownMenuItem<String>(
              value: entry.key,
              child: Text(
                entry.value.toString(),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
              ),
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      log(
        'Error while creating payment method dropdown menu items list: $e',
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: AppUtils.modelProgressHud(
          context: context,
          processing: false,
          child: AppUtils.pageRefreshIndicator(
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
        ),
      );

  Widget _buildUi(BuildContext context) => SimpleCard(
        color: Theme.of(context).colorScheme.surface,
        expandedContent: Form(
          key: _formKey,
          child: Column(
            children: [
              /// payment Method
              fieldTitle(text: VendorAppStrings.selectPaymentMethod.tr, required: true),
              kExtraSmallSpace,
              CustomDropdown(
                hintText: VendorAppStrings.selectPaymentMethod.tr,
                value: paymentMethodController.text,
                textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 15,
                ),
                menuItemsList: paymentMethodsMenuItemsList,
                validator: Validator.fieldCannotBeEmpty,
                onChanged: (value) {
                  setState(() {
                    paymentMethodController.text = value;
                    isBankTransfer = paymentMethodController.text == 'bank_transfer';
                  });
                },
              ),
              kFormFieldSpace,
              if (!isBankTransfer) _paypalIdField(),

              if (isBankTransfer)
                Column(
                  children: [
                    /// Bank Name
                    CustomTextFormField(
                      labelText: VendorAppStrings.bankName.tr,
                      required: false,
                      hintText: VendorAppStrings.enterBankNameField.tr,
                      controller: bankNameController,
                      nextFocusNode: ifscFocusNode,
                      focusNode: bankNameFocusNode,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,

                    /// Bank Code/IFSC
                    CustomTextFormField(
                      labelText: VendorAppStrings.bankCodeIfsc.tr,
                      required: false,
                      hintText: VendorAppStrings.enterBankCodeIfsc.tr,
                      controller: ifscController,
                      nextFocusNode: accountHolderNameFocusNode,
                      focusNode: ifscFocusNode,
                      validator: Validator.validationBankIFSC,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,

                    /// Account Holder Name
                    CustomTextFormField(
                      labelText: VendorAppStrings.accountHolderName.tr,
                      required: false,
                      hintText: VendorAppStrings.enterAccountHolderName.tr,
                      controller: accountHolderNameController,
                      nextFocusNode: accountNumberFocusNode,
                      focusNode: accountHolderNameFocusNode,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,

                    /// Account Number
                    CustomTextFormField(
                      labelText: VendorAppStrings.accountNumber.tr,
                      required: false,
                      hintText: VendorAppStrings.enterAccountNumberField.tr,
                      controller: accountNumberController,
                      nextFocusNode: paypalIdFocusNode,
                      focusNode: accountNumberFocusNode,
                      validator: Validator.validationAccountNumber,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,

                    /// paypal id
                    _paypalIdField(),

                    /// UPI ID
                    CustomTextFormField(
                      labelText: VendorAppStrings.upiId.tr,
                      required: false,
                      hintText: VendorAppStrings.enterUpiId.tr,
                      controller: upiIdController,
                      nextFocusNode: descriptionFocusNode,
                      focusNode: upiIdFocusNode,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,

                    /// Description
                    CustomTextFormField(
                      labelText: VendorAppStrings.description.tr,
                      required: false,
                      hintText: VendorAppStrings.enterDescriptionFieldAlt.tr,
                      controller: descriptionController,
                      focusNode: descriptionFocusNode,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onChanged: (value) {},
                    ),
                    kFormFieldSpace,
                  ],
                ),

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
                        print('Form is valid');
                        setProcessing(true);
                        _createForm();
                        final vendorSettingsProvider = context.read<VendorSettingsViewModel>();
                        final result = await vendorSettingsProvider.vendorSettings(
                          vendorSettingsType: VendorSettingType.payoutInfo,
                          form: form,
                          context: context,
                        );
                        if (result) {
                          setProcessing(false);
                          await _onRefresh();
                        }
                      } else {
                        print('Form validation failed!');
                      }
                    } catch (e) {
                      setProcessing(false);
                      AlertServices.showErrorSnackBar(
                        message: VendorAppStrings.error.tr + 'Oops! something went wrong..',
                        context: context,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );

  Widget _paypalIdField() => Column(
        children: [
          CustomTextFormField(
            labelText: 'PayPal ID',
            required: !isBankTransfer,
            validator: Validator.validationPaypalID,
            hintText: 'Enter PayPal ID',
            controller: paypalIdController,
            nextFocusNode: upiIdFocusNode,
            focusNode: paypalIdFocusNode,
            onChanged: (value) {},
          ),
          kFormFieldSpace,
        ],
      );

  FormData form = FormData();

  void _createForm() {
    form = FormData.fromMap({
      'payout_payment_method': paymentMethodController.text,
      'bank_info': {
        if (!isBankTransfer) 'paypal': {'paypal_id': paypalIdController.text},
        if (isBankTransfer)
          'bank_transfer': {
            'name': bankNameController.text,
            'code': ifscController.text,
            'full_name': accountHolderNameController.text,
            'number': accountNumberController.text,
            'paypal_id': paypalIdController.text,
            'upi_id': upiIdController.text,
            'description': descriptionController.text,
          },
      },
    });
  }
}
