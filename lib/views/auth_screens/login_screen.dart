import 'package:event_app/navigation/bottom_navigation_bar.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:event_app/vendor/components/vendor_stepper_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/auth_provider/user_auth_provider.dart';
import '../../core/styles/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auth_views/custom_auth_button.dart';
import '../../core/widgets/custom_auth_views/custom_text_fields.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../../vendor/vendor_home/vendor_drawer_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passShowNot = true;
  final _formKey = GlobalKey<FormState>();
  bool isCheck = true;
  bool _rememberMe = true; // Added for Remember Me functionality

  String mobileLogin = "mobileLogin";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
              child: Container(
                  alignment: Alignment.center,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: screeHeight * 0.04),
                          child: RichText(
                            text: TextSpan(
                              style: loginTextStyle(context),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05),
                              child: CustomTextFields(
                                  hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Theme.of(context).colorScheme.onSecondary),
                                  formFieldValidator: Validator.email,
                                  textEditingController: _emailController,
                                  inputType: TextInputType.emailAddress,
                                  hintText: 'Enter your Email',
                                  leftIcon: SvgPicture.asset(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    AppStrings.emailIcon,
                                    height: screeHeight * 0.02,
                                  )),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: 10),
                              child: CustomTextFields(
                                hintStyle: GoogleFonts.inter(fontWeight: FontWeight.w400, fontSize: 16, color: Theme.of(context).colorScheme.onSecondary),
                                leftIcon: SvgPicture.asset(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  AppStrings.passwordIcon,
                                  height: screeHeight * 0.025,
                                ),
                                formFieldValidator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password is required.";
                                  }

                                  return null;
                                },
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
                                isObsecureText: _passShowNot,
                                textEditingController: _passwordController,
                                inputType: TextInputType.visiblePassword,
                                hintText: 'Enter your Password',
                              ),
                            ),
                            /*Padding(
                              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value!;
                                          });
                                        },
                                        activeColor: AppColors.peachyPink,
                                      ),
                                      Text(
                                        'Remember Me',
                                        style: GoogleFonts.inter(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: Theme.of(context).colorScheme.onSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),*/
                            Padding(
                              padding: EdgeInsets.only(
                                top: screeHeight * 0.05,
                                left: screenWidth * 0.05,
                                right: screenWidth * 0.05,
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Consumer<AuthProvider>(
                                  builder: (context, authProvider, child) {
                                    return CustomAuthButton(
                                      title: authProvider.isLoading ? 'Continue...' : 'Continue',
                                      isLoading: authProvider.isLoading,
                                      onPressed: () async {
                                        if (_formKey.currentState?.validate() ?? false) {
                                          final userData = await authProvider.login(
                                            context,
                                            _emailController.text,
                                            _passwordController.text,
                                            _rememberMe,
                                            TokenName: mobileLogin,
                                          );

                                          if (userData?.data != null) {
                                            await SharedPreferencesUtil.setVendorData(
                                              approved: userData?.data?.isApproved ?? false,
                                              verified: userData?.data?.isVerified ?? false,
                                              vendor: userData?.data?.isVendor ?? 0,
                                            );

                                            if (userData?.data?.isVendor == 1) {
                                              await SharedPreferencesUtil.saveToken("Bearer ${userData?.data!.token}");
                                              if (_rememberMe) {
                                                await SharedPreferencesUtil.setBool(SharedPreferencesUtil.isLoggedInKey, true);
                                              }
                                              if (userData?.data?.isApproved == true && userData?.data?.isVerified == true) {
                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => VendorDrawerScreen()),);
                                              } else {
                                                Navigator.of(context).popUntil((route) => route.isFirst);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => BaseHomeScreen()),);
                                                Navigator.of(context).push(MaterialPageRoute(builder: (_) => VendorStepperScreen()),);
                                              }
                                            } else {
                                              await SharedPreferencesUtil.saveToken("Bearer ${userData?.data!.token}");
                                              if (_rememberMe) {await SharedPreferencesUtil.setBool(SharedPreferencesUtil.isLoggedInKey, true);}
                                              Navigator.of(context).popUntil((route) => route.isFirst);
                                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => BaseHomeScreen()),
                                              );
                                            }
                                          }
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: screeHeight * 0.04, left: screenWidth * 0.05, right: screenWidth * 0.05),
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(text: 'Have trouble logging in? ', style: loginTermsConditionStyle(context)),
                                TextSpan(
                                    text: 'Get help',
                                    style: GoogleFonts.inter(
                                      color: AppColors.vividRed,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    )),
                              ])),
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: screeHeight * 0.01, left: screenWidth * 0.05, right: screenWidth * 0.05),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, CupertinoPageRoute(builder: (context) => ForgotPasswordScreen()));
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.inter(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
