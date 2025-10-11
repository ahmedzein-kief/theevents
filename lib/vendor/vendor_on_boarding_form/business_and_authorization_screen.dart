import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/models/vendor_models/post_models/authorized_signatory_info_post_data.dart';
import 'package:event_app/models/vendor_models/post_models/business_owner_info_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/business_signatory_response.dart';
import 'package:event_app/vendor/vendor_on_boarding_form/authorized_signatory_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../components/custom_vendor_auth_button.dart';
import '../components/vendor_text_style.dart';
import 'business_owner_information_screen.dart';

class BusinessAndAuthorizationScreen extends StatefulWidget {
  const BusinessAndAuthorizationScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<BusinessAndAuthorizationScreen> createState() => _BusinessAndAuthorizationScreenState();
}

class _BusinessAndAuthorizationScreenState extends State<BusinessAndAuthorizationScreen> {
  int selectedIndex = 0;
  int _radioValue = 0;
  final _formKey = GlobalKey<FormState>();
  final BusinessOwnerInfoPostData boiModel = BusinessOwnerInfoPostData();
  final AuthorizedSignatoryInfoPostData asiModel = AuthorizedSignatoryInfoPostData();

  Future<void> getAllMetaData() async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.getAllMetaData();

    if (response != null) {
      SecurePreferencesUtil.saveServerStep(
        int.parse(response.data['step'] ?? '1'),
      );
      _radioValue = response.data['user_information_type']?.toLowerCase() == 'owner' ? 0 : 1;
      /**
       * Parsing business data
       */
      boiModel.companyDisplayName = response.data['company_display_name'];
      boiModel.phoneNumber = response.data['phone_number'];
      boiModel.country = response.data['country'];
      boiModel.region = response.data['region'];
      boiModel.eidNumber = response.data['eid_number'];
      boiModel.eidExpiry = response.data['eid_expiry'];
      boiModel.eidFileName = response.data['eid_file_name'];
      boiModel.eidServerFilePath = response.data['eid_file_path'];
      boiModel.passportFileName = response.data['passport_file_name'];
      boiModel.passportServerFilePath = response.data['passport_file_path'];

      /**
       * Parsing authorized signatory data
       */
      asiModel.ownerDisplayName = response.data['owner_display_name'];
      asiModel.ownerPhoneNumber = response.data['owner_phone_number'];
      asiModel.ownerCountry = response.data['owner_country'];
      asiModel.ownerRegion = response.data['owner_region'];
      asiModel.ownerEIDNumber = response.data['owner_eid_number'];
      asiModel.ownerEIDExpiry = response.data['owner_eid_expiry'];
      asiModel.ownerEIDFileName = response.data['owner_eid_file_name'];
      asiModel.ownerEIDServerFilePath = response.data['owner_eid_file_path'];
      asiModel.passportFileName = response.data['owner_passport_file_name'];
      asiModel.passportServerFilePath = response.data['owner_passport_file_path'];
      asiModel.poamoaFileName = response.data['signatory_poamoa_file_name'];
      asiModel.poamoaServerPath = response.data['signatory_poamoa_file_path'];
    }
  }

  Future<BusinessSignatoryResponse?> updateBusinessSignatoryData(
    BusinessOwnerInfoPostData boiData,
    AuthorizedSignatoryInfoPostData? asiData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.updateBusinessSignatoryData(context, boiData, asiData);
    return response;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getAllMetaData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<int>(
                                  activeColor: Theme.of(context).colorScheme.onPrimary,
                                  title: Text(
                                    VendorAppStrings.areYouBusinessOwner.tr,
                                    style: vendorBusinessInfo(),
                                  ),
                                  value: 0,
                                  groupValue: _radioValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _radioValue = value ?? 0;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<int>(
                                  title: Text(
                                    VendorAppStrings.areYouAuthorizedSignatory.tr,
                                    style: vendorBusinessInfo(),
                                  ),
                                  activeColor: Theme.of(context).colorScheme.onPrimary,
                                  value: 1,
                                  groupValue: _radioValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _radioValue = value ?? 1;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  BusinessOwnerInformationScreen(
                                    boiModel: boiModel,
                                    onBOIModelUpdate: (boiData) {},
                                  ),
                                  if (_radioValue == 1)
                                    AuthorizedSignatoryInformationScreen(
                                      asiModel: asiModel,
                                      onASIModelUpdate: (asiData) {},
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
                    final result = await updateBusinessSignatoryData(
                      boiModel,
                      _radioValue == 1 ? asiModel : null,
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
                color: Colors.black.withAlpha((0.5 * 255).toInt()), // Semi-transparent background
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
