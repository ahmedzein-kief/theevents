import 'dart:convert';
import 'dart:io';

import 'package:camera_gallery_image_picker/camera_gallery_image_picker.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/models/vendor_models/post_models/contract_agreement_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/contract_agreement_response.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:event_app/vendor/components/custom_vendor_auth_button.dart';
import 'package:event_app/vendor/components/vendor_custom_text_fields.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';

import '../../core/services/agreement_pdf.dart';

class ContractAgreementScreen extends StatefulWidget {
  const ContractAgreementScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<ContractAgreementScreen> createState() => _ContractAgreementScreenState();
}

class _ContractAgreementScreenState extends State<ContractAgreementScreen> {
  bool _isAgreementAccepted = false;
  bool hasAgreementError = false, hasSignError = false;
  final _stampFocusNode = FocusNode();

  final _stampTextEditingController = TextEditingController();

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final _formKey = GlobalKey<FormState>();
  ContractAgreementPostData caModel = ContractAgreementPostData();
  bool isSaveClearShown = false;

  Future<ContractAgreementResponse?> updateContractAgreementData(
    ContractAgreementPostData caData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.updateContractAgreementData(context, caData);
    return response;
  }

  Future<Map<String, dynamic>?> previewAgreement() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.previewAgreement(context);
    return response;
  }

  Future<void> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.getAllMetaData();

    if (response != null) {
      /**
       * Parsing contract agreement data
       */
      SecurePreferencesUtil.saveServerStep(
        int.parse(response.data['step'] ?? '1'),
      );
      caModel.signImage = response.data['sign_image'] ?? '';
      caModel.companyStampFileName = _stampTextEditingController.text = response.data['company_stamp_file_name'] ?? '';
      caModel.companyStampFileServerPath = response.data['company_stamp_file_path'] ?? '';
      caModel.agreementAgree = _isAgreementAccepted = response.data['agreement_agree'] == 'true';
      if (caModel.signImage?.isNotEmpty == true) {
        isSaveClearShown = false;
      } else {
        isSaveClearShown = true;
      }
    }
  }

  // late WebViewController _webViewController;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getAllMetaData();
    });
    // _initializeWebView();
    super.initState();
  }

  // // Initialize WebView
  // void _initializeWebView() {
  //   _webViewController = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
  // }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) {
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return SingleChildScrollView(
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
                            bottom: screenHeight * 0.015,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withAlpha((0.5 * 255).toInt())
                                      : Colors.black.withAlpha((0.2 * 255).toInt()),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Material(
                                color: isDark ? Colors.grey.shade900 : Colors.white,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        VendorAppStrings.contractAgreement.tr,
                                        style: loginHeading(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: screenHeight * 0.055,
                                          bottom: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.primary,
                                            boxShadow: [
                                              BoxShadow(
                                                color: isDark
                                                    ? Colors.black.withAlpha((0.5 * 255).toInt())
                                                    : Colors.black.withAlpha((0.2 * 255).toInt()),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              top: screenHeight * 0.035,
                                              bottom: screenHeight * 0.025,
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  AppStrings.vendorContactHeading.tr,
                                                  style: vendorDescriptionAgreement(),
                                                  softWrap: true,
                                                  textAlign: TextAlign.center,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: screenWidth * 0.2,
                                                  ),
                                                  child: CustomVendorAuthButton(
                                                    title: VendorAppStrings.previewAgreement.tr,
                                                    onPressed: () async {
                                                      await previewAgreementAndGeneratePdf(
                                                        context,
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1,
                                          vertical: screenHeight * 0.01,
                                        ),
                                        child: Text(
                                          VendorAppStrings.pleaseSignHere.tr,
                                          style: signHere(),
                                          softWrap: true,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 10,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: isDark ? Colors.grey.shade800 : Colors.white,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(
                                              color: isDark ? Colors.grey.shade600 : Colors.grey,
                                              width: 2,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withAlpha(
                                                  (0.5 * 255).toInt(),
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: isSaveClearShown
                                              ? Signature(
                                                  controller: _controller,
                                                  height: screenHeight / 4,
                                                  backgroundColor: Colors.transparent,
                                                )
                                              : Container(
                                                  width: screenWidth,
                                                  height: screenHeight / 4,
                                                  color: isDark ? Colors.grey.shade800 : Colors.white,
                                                  child: Image.memory(
                                                    base64Decode(
                                                      caModel.signImage ?? '',
                                                    ),
                                                    errorBuilder: (_, __, ___) => kShowVoid,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.1,
                                          vertical: screenHeight * 0.015,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                if (isSaveClearShown)
                                                  Container(
                                                    height: screenHeight * 0.035,
                                                    width: screenWidth * 0.15,
                                                    color: Colors.green,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        child: Text(
                                                          VendorAppStrings.save.tr,
                                                          textAlign: TextAlign.center,
                                                          softWrap: true,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () async {
                                                          final Uint8List? data = await _controller.toPngBytes();
                                                          setState(() {
                                                            if (data != null) {
                                                              setState(() {
                                                                final encodeImage = base64Encode(
                                                                  data,
                                                                );
                                                                caModel.signImage = encodeImage;
                                                                hasSignError = false;
                                                                hasSignError = false;
                                                                isSaveClearShown = false;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                caModel.signImage = null;
                                                                hasSignError = true;
                                                              });
                                                            }
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                if (isSaveClearShown)
                                                  Container(
                                                    height: screenHeight * 0.035,
                                                    width: screenWidth * 0.15,
                                                    color: Colors.pink,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        child: Text(
                                                          VendorAppStrings.clear.tr,
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          _controller.clear();
                                                          setState(() {
                                                            caModel.signImage = null;
                                                            hasSignError = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                if (!isSaveClearShown)
                                                  Container(
                                                    height: screenHeight * 0.035,
                                                    width: screenWidth * 0.15,
                                                    color: Colors.blue,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        child: Text(
                                                          VendorAppStrings.edit.tr,
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            _controller.clear();
                                                            isSaveClearShown = true;
                                                            caModel.signImage = null;
                                                            hasSignError = true;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (hasSignError)
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 12.0),
                                            child: Text(
                                              VendorAppStrings.pleaseSignAgreement.tr,
                                              style: const TextStyle(
                                                color: Colors.red,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      VendorCustomTextFields(
                                        labelText: VendorAppStrings.companyStamp.tr,
                                        hintText: VendorAppStrings.noFileChosen.tr,
                                        textStar: ' *',
                                        controller: _stampTextEditingController,
                                        keyboardType: TextInputType.name,
                                        focusNode: _stampFocusNode,
                                        isPrefixFilled: true,
                                        isEditable: false,
                                        prefixIcon: Icons.upload_outlined,
                                        prefixContainerColor: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                                        borderSideColor: BorderSide(
                                          color: isDark ? Colors.grey.shade600 : Colors.grey,
                                          width: 0.5,
                                        ),
                                        prefixIconColor: isDark ? Colors.white70 : Colors.black,
                                        nextFocusNode: _stampFocusNode,
                                        validator: Validator.fieldRequired,
                                        onIconPressed: () async {
                                          final File? file = await CameraGalleryImagePicker.pickImage(
                                            context: context,
                                            source: ImagePickerSource.gallery,
                                          );
                                          if (file != null) {
                                            _stampTextEditingController.text = p.basename(file.path);
                                            caModel.companyStampFile = file;
                                            caModel.companyStampFileName = p.basename(file.path);
                                          } else {
                                            _stampTextEditingController.text = '';
                                            caModel.companyStampFile = null;
                                            caModel.companyStampFileName = '';
                                          }
                                        },
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: screenHeight * 0.015,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Checkbox(
                                                  activeColor: Theme.of(context).colorScheme.onPrimary,
                                                  checkColor: Theme.of(context).colorScheme.primary,
                                                  value: _isAgreementAccepted,
                                                  onChanged: (bool? value) {
                                                    setState(() {
                                                      _isAgreementAccepted = value!;
                                                      caModel.agreementAgree = value;
                                                      hasAgreementError = caModel.agreementAgree == false;
                                                    });
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    AppStrings.agreementAccept.tr,
                                                    softWrap: true,
                                                    style: agreementAccept(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (hasAgreementError)
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left: 12.0),
                                                  child: Text(
                                                    VendorAppStrings.youMustAgreeToProceed.tr,
                                                    style: const TextStyle(
                                                      color: Colors.red,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
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
                );
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomVendorAuthButton(
                isLoading: mainProvider.isLoading,
                title: VendorAppStrings.saveAndContinue.tr,
                onPressed: () async {
                  if (_formKey.currentState!.validate() && !hasSignError) {
                    final result = await updateContractAgreementData(
                      caModel,
                    );
                    if (result != null) {
                      widget.onNext();
                    }
                  } else {
                    setState(() {
                      hasAgreementError = caModel.agreementAgree == false;
                      hasSignError = caModel.signImage == null;
                    });
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<String> saveBase64ToExternalCache(String base64Pdf) async {
    try {
      // Decode Base64 to bytes
      final List<int> bytes = base64.decode(base64Pdf);

      final String dir = await _localPath;

      final String filePath = '$dir/Preview Agreement.pdf';

      // String filePath = '${dir.path}/temp.pdf';
      final File file = File(filePath);

      // Write bytes to file
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      return '';
    }
  }
}
