import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/vendor_settings_models/vendor_get_settings_model.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
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

  setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _onRefresh() async {
    VendorGetSettingsViewModel vendorGetSettingsProvider = context.read<VendorGetSettingsViewModel>();
    await vendorGetSettingsProvider.vendorGetSettings();
    if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.COMPLETED) {
      createPaymentMethodMenuItemsList(paymentMethodOptions: vendorGetSettingsProvider.apiResponse.data?.data?.paymentMethodOptions);
      _initializeTheField(vendorGetSettingsProvider: vendorGetSettingsProvider);
    }
  }

  _initializeTheField({required VendorGetSettingsViewModel vendorGetSettingsProvider}) {
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
  void createPaymentMethodMenuItemsList({required PaymentMethodOptions? paymentMethodOptions}) {
    try {
      if (paymentMethodOptions == null) return;

      // Use a Set to ensure unique keys
      final uniqueEntries = <String>{};

      paymentMethodsMenuItemsList = paymentMethodOptions
          .toJson()
          .entries
          .where((entry) => uniqueEntries.add(entry.key)) // Only add if unique
          .map((entry) => DropdownMenuItem<String>(
                value: entry.key,
                child: Text(
                  entry.value.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                ),
              ))
          .toList();
    } catch (e, stackTrace) {
      log("Error while creating payment method dropdown menu items list: $e", stackTrace: stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Utils.modelProgressHud(
      processing: false,
      child: Utils.pageRefreshIndicator(
        onRefresh: _onRefresh,
        child: Consumer<VendorGetSettingsViewModel>(
          builder: (context, vendorGetSettingsProvider, _) {
            /// Show loading if refreshing
            if (vendorGetSettingsProvider.apiResponse.status == ApiStatus.LOADING) return Utils.pageLoadingIndicator(context: context);

            /// return ui if loading ends
            return ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: [
                _buildUi(),
              ],
            );
          },
        ),
      ),
    ));
  }

  Widget _buildUi() {
    return SimpleCard(
        expandedContent: Form(
      key: _formKey,
      child: Column(
        children: [
          /// payment Method
          fieldTitle(text: "Payment Method", required: true),
          kExtraSmallSpace,
          CustomDropdown(
            hintText: "Select payment method",
            value: paymentMethodController.text,
            textStyle: TextStyle(color: Colors.grey, fontSize: 15),
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
                  labelText: "Bank Name",
                  required: false,
                  hintText: "Enter bank name",
                  controller: bankNameController,
                  nextFocusNode: ifscFocusNode,
                  focusNode: bankNameFocusNode,
                  onChanged: (value) {},
                ),
                kFormFieldSpace,

                /// Bank Code/IFSC
                CustomTextFormField(
                  labelText: "Bank Code/IFSC",
                  required: false,
                  hintText: "Enter bank code/IFSC",
                  controller: ifscController,
                  nextFocusNode: accountHolderNameFocusNode,
                  focusNode: ifscFocusNode,
                  validator: Validator.validationBankIFSC,
                  onChanged: (value) {},
                ),
                kFormFieldSpace,

                /// Account Holder Name
                CustomTextFormField(
                  labelText: "Account Holder Name",
                  required: false,
                  hintText: "Enter account holder name",
                  controller: accountHolderNameController,
                  nextFocusNode: accountNumberFocusNode,
                  focusNode: accountHolderNameFocusNode,
                  onChanged: (value) {},
                ),
                kFormFieldSpace,

                /// Account Number
                CustomTextFormField(
                  labelText: "Account Number",
                  required: false,
                  hintText: "Enter account number",
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
                  labelText: "UPI ID",
                  required: false,
                  hintText: "Enter UPI ID",
                  controller: upiIdController,
                  nextFocusNode: descriptionFocusNode,
                  focusNode: upiIdFocusNode,
                  onChanged: (value) {},
                ),
                kFormFieldSpace,

                /// Description
                CustomTextFormField(
                  labelText: "Description",
                  required: false,
                  hintText: "Enter description",
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
          Consumer<VendorSettingsViewModel>(builder: (context, provider, _) {
            return CustomAppButton(
                buttonText: "Save Settings",
                borderRadius: kButtonRadius,
                mainAxisSize: MainAxisSize.max,
                buttonColor: AppColors.lightCoral,
                isLoading: provider.apiResponse.status == ApiStatus.LOADING,
                onTap: () async {
                  try {
                    if (_formKey.currentState?.validate() ?? false) {
                      print("Form is valid");
                      setProcessing(true);
                      _createForm();
                      final vendorSettingsProvider = context.read<VendorSettingsViewModel>();
                      final result = await vendorSettingsProvider.vendorSettings(vendorSettingsType: VendorSettingType.payoutInfo, form: form, context: context);
                      if (result) {
                        setProcessing(false);
                        await _onRefresh();
                      }
                    } else {
                      print("Form validation failed!");
                    }
                  } catch (e) {
                    setProcessing(false);
                    AlertServices.showErrorSnackBar(message: "Oops! something went wrong..", context: context);
                  }
                });
          }),
        ],
      ),
    ));
  }

  Widget _paypalIdField() {
    return

        /// PayPal ID
        Column(
      children: [
        CustomTextFormField(
          labelText: "PayPal ID",
          required: !isBankTransfer,
          validator: Validator.validationPaypalID,
          hintText: "Enter PayPal ID",
          controller: paypalIdController,
          nextFocusNode: upiIdFocusNode,
          focusNode: paypalIdFocusNode,
          onChanged: (value) {},
        ),
        kFormFieldSpace,
      ],
    );
  }

  FormData form = FormData();

  _createForm() {
    form = FormData.fromMap({
      "payout_payment_method": paymentMethodController.text,
      "bank_info": {
        if (!isBankTransfer) "paypal": {"paypal_id": paypalIdController.text},
        if (isBankTransfer)
          "bank_transfer": {
            "name": bankNameController.text,
            "code": ifscController.text,
            "full_name": accountHolderNameController.text,
            "number": accountNumberController.text,
            "paypal_id": paypalIdController.text,
            "upi_id": upiIdController.text,
            "description": descriptionController.text
          }
      }
    });
  }
}
