import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/vendor/vendor_sign_up_provider.dart';
import '../../core/styles/app_colors.dart';

class EmailVerificationScreen extends StatefulWidget {
  final void Function() onNext;

  const EmailVerificationScreen({super.key, required this.onNext});

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResendLoading = false;
  bool isVerifyLoading = false;

  Future<void> resendEmail() async {
    setState(() => isResendLoading = true);
    var provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    await provider.resendEmail(context);
    setState(() => isResendLoading = false);
  }

  Future<UserModel?> verifyEmail() async {
    setState(() => isVerifyLoading = true);
    var provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    return await provider.fetchUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1F1),
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Email Verification Pending!',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          Divider(color: Colors.grey.shade300, thickness: 1.0),
                          const SizedBox(height: 16.0),
                          Text(
                            'Please verify your email address! and tap on verify.',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'For verification of email address please check your inbox and spam folder!',
                            style: TextStyle(fontSize: 14.0, color: Colors.black87),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24.0),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade600,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  onPressed: () async {
                                    final resultVerified = await verifyEmail();
                                    setState(() {
                                      isVerifyLoading = false;
                                    });
                                    if (resultVerified != null) {
                                      if (resultVerified.isVerified == true) {
                                        CustomSnackbar.showSuccess(context, "Account has been verified.");
                                        final prefs = await SharedPreferences.getInstance();
                                        prefs.setBool(SharedPreferencesUtil.verified, true);
                                        setState(() {
                                          widget.onNext();
                                        });
                                      } else {
                                        CustomSnackbar.showError(context, "Email verification is pending.");
                                      }
                                    }
                                  },
                                  child: isVerifyLoading
                                      ? SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : Text(
                                          'Verify',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  ),
                                  onPressed: isResendLoading ? null : resendEmail,
                                  child: isResendLoading
                                      ? SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : Text(
                                          'Resend',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            if (mainProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
