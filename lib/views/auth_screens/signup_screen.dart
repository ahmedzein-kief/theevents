import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:event_app/views/auth_screens/auth_page_view.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider/user_auth_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auth_views/custom_auth_button.dart';
import '../../core/widgets/custom_auth_views/custom_text_fields.dart';
import '../../utils/validator/validator.dart';
import '../profile_page_screens/privacy_policy_screen.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback? onSignUpTap;

  const SignupScreen({super.key, this.onSignUpTap});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passShowNot = true;
  bool _confPass = true;
  String selectedGender = "Female"; // To keep track of the selected gender

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screeHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: screeHeight * 0.02),
                                child: CustomTextFields(
                                  leftIcon: SvgPicture.asset(color: Theme.of(context).colorScheme.onPrimary, AppStrings.profileName, height: screeHeight * 0.025),
                                  textEditingController: _nameController,
                                  inputType: TextInputType.name,
                                  formFieldValidator: Validator.name,
                                  hintText: 'Full Name',
                                  hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Theme.of(context).colorScheme.onSecondary),
                                ),
                              ),
                              CustomTextFields(
                                leftIcon: SvgPicture.asset(color: Theme.of(context).colorScheme.onPrimary, AppStrings.emailIcon, height: screeHeight * 0.02),
                                hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Theme.of(context).colorScheme.onSecondary
                                    // color: AppColors.semiTransparentBlack
                                    ),
                                textEditingController: _emailController,
                                formFieldValidator: Validator.email,
                                inputType: TextInputType.emailAddress,
                                hintText: 'Enter your Email',
                              ),
                              CustomTextFields(
                                leftIcon: SvgPicture.asset(color: Theme.of(context).colorScheme.onPrimary, AppStrings.passwordIcon, height: screeHeight * 0.025),
                                hintStyle: GoogleFonts.inter(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    // color: AppColors.semiTransparentBlack
                                    color: Theme.of(context).colorScheme.onSecondary),
                                textEditingController: _passwordController,
                                inputType: TextInputType.visiblePassword,
                                formFieldValidator: Validator.signUpPasswordValidation,
                                isObsecureText: true,
                                hintText: 'Enter your password',
                              ),
                              CustomTextFields(
                                leftIcon: SvgPicture.asset(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  AppStrings.passwordIcon,
                                  height: screeHeight * 0.025,
                                ),
                                hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, color: Theme.of(context).colorScheme.onSecondary, fontSize: 16),
                                textEditingController: _confirmPasswordController,
                                inputType: TextInputType.visiblePassword,
                                formFieldValidator: Validator.signUpPasswordValidation,
                                isObsecureText: _passShowNot,
                                suffixIcon: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _passShowNot = !_passShowNot;
                                    });
                                  },
                                  child: SvgPicture.asset(
                                      height: screeHeight * 0.02,
                                      fit: BoxFit.cover,
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      _passShowNot ? AppStrings.hideEye : AppStrings.showEye),
                                ),
                                hintText: 'Confirm Password',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Text(
                                  'Password must Contain minimum 9 characters , at least one upper case and one is lower case ',
                                  softWrap: true,
                                  maxLines: 4,
                                  style: signupPasswordConditionStyle(context),
                                ),
                              ),
                              /*Padding(
                                padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.1, top: screeHeight * 0.08),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = "Female";
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            border: Border.all(color: Colors.grey),
                                            color: Colors.transparent,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text("Female"),
                                              // Keep the text in the center
                                              if (selectedGender == "Female")
                                                Positioned(
                                                  left: 10,
                                                  // Adjust this value to position the image
                                                  child: Image.asset(
                                                    "assets/check.png",
                                                    height: 20, // Adjust the size as needed
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.02),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedGender = "Male";
                                          });
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            border: Border.all(color: Colors.grey),
                                            color: Colors.transparent,
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text("Male"),
                                              // Keep the text in the center
                                              if (selectedGender == "Male")
                                                Positioned(
                                                  left: 10,
                                                  // Adjust this value to position the image
                                                  child: Image.asset(
                                                    "assets/check.png",
                                                    height: 20, // Adjust the size as needed
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),*/
                              Padding(
                                padding: EdgeInsets.only(top: screeHeight * 0.04),
                                child: RichText(
                                    text: TextSpan(children: [
                                  TextSpan(text: 'By continuing,I agree the ', style: loginTermsConditionStyle(context)),
                                  TextSpan(
                                      recognizer: TapGestureRecognizer()..onTap = (){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const TermsAndCondtionScreen(),
                                          ),
                                        );
                                      },
                                      text: 'Terms of Use',
                                      style: GoogleFonts.inter(
                                        color: AppColors.vividRed,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      )),
                                  TextSpan(text: ' & ', style: loginTermsConditionStyle(context)),
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()..onTap = (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(),
                                        ),
                                      );
                                    } ,
                                      text: 'Privacy Policy',
                                      style: GoogleFonts.inter(
                                        color: AppColors.vividRed,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                  )
                                ])),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: screeHeight * 0.04),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Consumer<AuthProvider>(
                                        builder: (context, authProvider, child) {
                                          return CustomAuthButton(
                                              title: authProvider.isLoading ? 'SignUp....' : 'SignUp',
                                              isLoading: authProvider.isLoading,
                                              // title: 'Sign Up',
                                              onPressed: () async {
                                                if (_formKey.currentState?.validate() ?? false) {

                                                  final result = await authProvider.signUp(_nameController.text, _emailController.text, _passwordController.text, _confirmPasswordController.text, context);
                                                  if (result != null) {
                                                    await SecurePreferencesUtil.saveUserName(result.data?.name ?? '');
                                                    await SecurePreferencesUtil.saveUserMail(result.data?.email ?? '');
                                                    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => AuthScreen()));
                                                  }
                                                }
                                              });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ),
        ));
  }
}
