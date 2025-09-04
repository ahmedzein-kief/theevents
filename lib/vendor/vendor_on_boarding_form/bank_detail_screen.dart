import 'dart:io';

import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/models/vendor_models/post_models/bank_details_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/bank_details_response.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../components/custom_vendor_auth_button.dart';
import '../components/vendor_custom_text_fields.dart';
import '../components/vendor_text_style.dart';

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({super.key, required this.onNext});
  final VoidCallback onNext;

  @override
  State<BankDetailScreen> createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  final _bankNameFocusNode = FocusNode();
  final _iBANNumberFocusNode = FocusNode();
  final _accountNameFocusNode = FocusNode();
  final _accountNumberFocusNode = FocusNode();
  final _bankLetterFocusNode = FocusNode();

  final _iBANNumberController = TextEditingController();
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _bankLetterController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  BankDetailsPostData bdModel = BankDetailsPostData();

  Future<BankDetailsResponse?> updateBankDetails(
    BankDetailsPostData bdPostData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.updateBankDetails(context, bdPostData);
    return response;
  }

  Future<void> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.getAllMetaData(context);

    if (response != null) {
      /**
       * Parsing bank details data
       */
      SecurePreferencesUtil.saveServerStep(
          int.parse(response.data['step'] ?? '1'),);
      bdModel.bankName =
          _bankNameController.text = response.data['bank_name'] ?? '';
      bdModel.ibanNumber =
          _iBANNumberController.text = response.data['iban_number'] ?? '';
      bdModel.accountName =
          _accountNameController.text = response.data['account_name'] ?? '';
      bdModel.accountNumber =
          _accountNumberController.text = response.data['account_number'] ?? '';
      bdModel.bankLetterFileName = _bankLetterController.text =
          response.data['bank_letter_file_name'] ?? '';
      bdModel.bankLetterFileServerPath =
          response.data['bank_letter_file_path'] ?? '';
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getAllMetaData();
    });
    super.initState();
  }

  @override
  void dispose() {
    _bankNameFocusNode.dispose();
    _iBANNumberFocusNode.dispose();
    _accountNameFocusNode.dispose();
    _accountNumberFocusNode.dispose();
    _bankLetterFocusNode.dispose();

    _iBANNumberController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _bankLetterController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider =
        Provider.of<VendorSignUpProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.04,
                            right: screenWidth * 0.04,
                            top: screenHeight * 0.03,
                            bottom: screenHeight * 0.015,),
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // How much the shadow spreads
                                blurRadius: 5, // How blurry the shadow is
                                offset:
                                    const Offset(0, 2), // Shadow offset (X, Y)
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Material(
                              shadowColor: Colors.black,
                              color: Colors.white,
                              elevation: 15,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 20, left: 10, right: 10, bottom: 30,),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      VendorAppStrings.bankDetails.tr,
                                      style: loginHeading(),
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.bankName.tr,
                                      hintText:
                                          VendorAppStrings.enterBankName.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _bankNameController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _bankNameFocusNode,
                                      nextFocusNode: _iBANNumberFocusNode,
                                      validator: Validator.bankName,
                                      onValueChanged: (value) {
                                        bdModel.bankName = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.ibanNumber.tr,
                                      hintText:
                                          VendorAppStrings.enterIbanNumber.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _iBANNumberController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _iBANNumberFocusNode,
                                      nextFocusNode: _accountNameFocusNode,
                                      validator: Validator.ibanNumber,
                                      onValueChanged: (value) {
                                        bdModel.ibanNumber = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText:
                                          VendorAppStrings.accountName.tr,
                                      hintText:
                                          VendorAppStrings.enterAccountName.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _accountNameController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _accountNameFocusNode,
                                      nextFocusNode: _accountNumberFocusNode,
                                      validator: Validator.accountName,
                                      onValueChanged: (value) {
                                        bdModel.accountName = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText:
                                          VendorAppStrings.accountNumber.tr,
                                      hintText: VendorAppStrings
                                          .enterAccountNumber.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _accountNumberController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _accountNumberFocusNode,
                                      nextFocusNode: _bankLetterFocusNode,
                                      validator: Validator.accountNumber,
                                      onValueChanged: (value) {
                                        bdModel.accountNumber = value;
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText:
                                          VendorAppStrings.bankLetterPdf.tr,
                                      hintText:
                                          VendorAppStrings.noFileChosen.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _bankLetterController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _bankLetterFocusNode,
                                      isEditable: false,
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.upload_outlined,
                                      prefixContainerColor:
                                          Colors.grey.shade300,
                                      borderSideColor: const BorderSide(
                                          color: Colors.grey, width: 0.5,),
                                      prefixIconColor: Colors.black,
                                      nextFocusNode: _bankLetterFocusNode,
                                      validator: Validator.fieldRequired,
                                      onIconPressed: () async {
                                        final FilePickerResult? result =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['pdf'],
                                        );
                                        if (result != null) {
                                          final File file =
                                              File(result.files.single.path!);
                                          _bankLetterController.text =
                                              result.files.single.name;
                                          bdModel.bankLetterFile = file;
                                          bdModel.bankLetterFileName =
                                              result.files.single.name;
                                        } else {
                                          _bankLetterController.text = '';
                                          bdModel.bankLetterFile = null;
                                          bdModel.bankLetterFileName = '';
                                        }
                                      },
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
                    final result = await updateBankDetails(
                      bdModel,
                    );
                    if (result != null) {
                      widget.onNext();
                    }
                  } else {}
                },
              ),
            ),
            if (mainProvider.isLoading)
              Container(
                color: Colors.black
                    .withOpacity(0.5), // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
