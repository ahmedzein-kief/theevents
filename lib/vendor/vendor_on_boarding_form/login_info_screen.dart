import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/models/vendor_models/post_models/signup_post_data.dart';
import 'package:event_app/models/vendor_models/response_models/signup_response.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/services/shared_preferences_helper.dart';
import '../common_dropdowns.dart';
import '../components/custom_vendor_auth_button.dart';
import '../components/vendor_custom_text_fields.dart';
import '../components/vendor_text_style.dart';

class VendorLoginInfoScreen extends StatefulWidget {
  const VendorLoginInfoScreen({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  State<VendorLoginInfoScreen> createState() => _VendorLoginInfoScreenState();
}

class _VendorLoginInfoScreenState extends State<VendorLoginInfoScreen> {
  int selectedIndex = 0; // The current selected index (first container by default)
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _genderFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _confirmPasswordFocusNode = FocusNode();
  final _companyNameFocusNode = FocusNode();
  final _companySlugFocusNode = FocusNode();
  final FocusNode _companyMobileNumberFocusNode = FocusNode();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _companySlugController = TextEditingController();
  final _companyMobileNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _passwordObscureText = true;
  bool _confirmPasswordObscureText = true;

  Future<SignUpResponse?> signUp(
    VendorSignUpPostData vendorSignUpPostData,
  ) async {
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final response = await provider.signUp(context, vendorSignUpPostData);
    return response;
  }

  final ScrollController _scrollController = ScrollController();

  void _scrollToField(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 100)).then((_) {
        _scrollController.animateTo(
          _scrollController.offset + 100, // Adjust the offset as needed
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  void initState() {
    _passwordFocusNode.addListener(() => _scrollToField(_passwordFocusNode));
    _companyMobileNumberFocusNode.addListener(() => _scrollToField(_companyMobileNumberFocusNode));
    super.initState();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _genderFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _companyNameFocusNode.dispose();
    _companySlugFocusNode.dispose();
    _companyMobileNumberFocusNode.dispose();

    _nameController.dispose();
    _emailController.dispose();
    _genderController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _companyNameController.dispose();
    _companySlugController.dispose();
    _companyMobileNumberController.dispose();
    super.dispose();
  }

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
                                color: Colors.black.withOpacity(0.2), // Shadow color
                                spreadRadius: 2, // How much the shadow spreads
                                blurRadius: 5, // How blurry the shadow is
                                offset: const Offset(0, 2), // Shadow offset (X, Y)
                              ),
                            ],
                          ),
                          child: Material(
                            shadowColor: Colors.black,
                            color: Colors.white,
                            elevation: 15,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 10,
                                right: 10,
                                bottom: 30,
                              ),
                              child: Form(
                                key: _formKey, // Add Form key here
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      VendorAppStrings.loginInformation.tr,
                                      style: loginHeading(),
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.titleFullName.tr,
                                      hintText: VendorAppStrings.hintEnterFullName.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _nameController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _nameFocusNode,
                                      nextFocusNode: _emailFocusNode,
                                      validator: Validator.vendorName,
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.titleEmail.tr,
                                      hintText: VendorAppStrings.hintEnterEmail.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      focusNode: _emailFocusNode,
                                      nextFocusNode: _genderFocusNode,
                                      validator: Validator.vendorEmail,
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.titleGender.tr,
                                      hintText: VendorAppStrings.hintSelectGender.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _genderController,
                                      // keyboardType: TextInputType.emailAddress,
                                      suffixIconColor: Colors.black,
                                      keyboardType: TextInputType.none,
                                      focusNode: _genderFocusNode,
                                      nextFocusNode: _passwordFocusNode,
                                      suffixIcon: Icons.keyboard_arrow_down,
                                      validator: Validator.gender,
                                      isEditable: false,
                                      onIconPressed: () async {
                                        final selectedGender = await showGenderDropdown(
                                          context,
                                          _genderController.text,
                                        );
                                        if (selectedGender != null) {
                                          _genderController.text = selectedGender;
                                        }
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.password.tr,
                                      hintText: VendorAppStrings.enterYourPassword.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _passwordController,
                                      keyboardType: TextInputType.visiblePassword,
                                      focusNode: _passwordFocusNode,
                                      nextFocusNode: _confirmPasswordFocusNode,
                                      validator: Validator.vendorPasswordValidation,
                                      suffixWidget: IconButton(
                                        icon: SvgPicture.asset(
                                          height: screenHeight * 0.02,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          _passwordObscureText ? AppStrings.hideEye.tr : AppStrings.showEye.tr,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _passwordObscureText = !_passwordObscureText;
                                          });
                                        },
                                      ),
                                      obscureText: _passwordObscureText,
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.confirmPassword.tr,
                                      hintText: VendorAppStrings.enterYourPassword.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _confirmPasswordController,
                                      keyboardType: TextInputType.visiblePassword,
                                      focusNode: _confirmPasswordFocusNode,
                                      nextFocusNode: _companyNameFocusNode,
                                      validator: Validator.vendorPasswordValidation,
                                      suffixWidget: IconButton(
                                        icon: SvgPicture.asset(
                                          height: screenHeight * 0.02,
                                          fit: BoxFit.cover,
                                          color: Theme.of(context).colorScheme.onPrimary,
                                          _confirmPasswordObscureText ? AppStrings.hideEye.tr : AppStrings.showEye.tr,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _confirmPasswordObscureText = !_confirmPasswordObscureText;
                                          });
                                        },
                                      ),
                                      obscureText: _confirmPasswordObscureText,
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companyName.tr,
                                      hintText: VendorAppStrings.enterYourCompanyName.tr,
                                      textStar: ' *',
                                      controller: _companyNameController,
                                      keyboardType: TextInputType.name,
                                      focusNode: _companyNameFocusNode,
                                      nextFocusNode: _companySlugFocusNode,
                                      validator: Validator.companyName,
                                      onValueChanged: (value) {
                                        setState(() {
                                          _companySlugController.text = (value ?? '')
                                              .trim()
                                              .toLowerCase()
                                              .replaceAll(
                                                RegExp(r'[^a-zA-Z0-9 ]'),
                                                '',
                                              )
                                              .replaceAll(RegExp(r'\s+'), '-');
                                        });
                                      },
                                    ),
                                    VendorCustomTextFields(
                                      labelText: VendorAppStrings.companySlug.tr,
                                      hintText: VendorAppStrings.enterCompanySlug.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companySlugController,
                                      keyboardType: TextInputType.url,
                                      focusNode: _companySlugFocusNode,
                                      nextFocusNode: _companyMobileNumberFocusNode,
                                      validator: Validator.companySlug,
                                    ),
                                    VendorCustomTextFields(
                                      prefixText: '+971',
                                      isPrefixFilled: true,
                                      prefixIcon: Icons.keyboard_arrow_down_outlined,
                                      labelText: VendorAppStrings.companyMobileNumber.tr,
                                      hintText: VendorAppStrings.enterMobileNumber.tr,
                                      textStar: VendorAppStrings.asterick.tr,
                                      controller: _companyMobileNumberController,
                                      keyboardType: TextInputType.phone,
                                      focusNode: _companyMobileNumberFocusNode,
                                      validator: Validator.companyMobile,
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
                title: VendorAppStrings.continueButton.tr,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final vendorSignUpPostData = VendorSignUpPostData(
                      name: _nameController.text,
                      email: _emailController.text,
                      password: _passwordController.text,
                      confirmPassword: _confirmPasswordController.text,
                      companyName: _companyNameController.text,
                      companySlug: _companySlugController.text,
                      companyMobileNumber: _companyMobileNumberController.text,
                    );
                    final signUpResponse = await signUp(vendorSignUpPostData);
                    if (signUpResponse != null) {
                      if (signUpResponse.data != null) {
                        await SecurePreferencesUtil.setVendorData(
                          approved: signUpResponse.data?.isApproved ?? false,
                          verified: signUpResponse.data?.isVerified ?? false,
                          vendor: signUpResponse.data?.isVendor == true ? 1 : 0,
                        );
                        if (signUpResponse.data?.isVendor == true) {
                          await SecurePreferencesUtil.saveToken(
                            'Bearer ${signUpResponse.data!.token}',
                          );
                          await SecurePreferencesUtil.setBool(
                            SecurePreferencesUtil.isLoggedInKey,
                            true,
                          );
                          widget.onNext();
                        }
                      }
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
