import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../provider/auth_provider/get_user_provider.dart';
import '../../provider/vendor/vendor_sign_up_provider.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key, required this.onNext});

  final void Function() onNext;

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isResendLoading = false;
  bool isVerifyLoading = false;

  Future<void> resendEmail() async {
    setState(() => isResendLoading = true);
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    await provider.resendEmail(context);
    setState(() => isResendLoading = false);
  }

  Future<UserModel?> verifyEmail() async {
    setState(() => isVerifyLoading = true);
    final provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final userData = await provider.fetchUserData(context);

    // Update the user in UserProvider
    if (userData != null) {
      userProvider.setUser(userData);
    }

    return userData;
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<VendorSignUpProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Consumer<VendorSignUpProvider>(
              builder: (context, provider, child) {
                final isDark = Theme.of(context).brightness == Brightness.dark;

                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey.shade900 : Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withAlpha((0.5 * 255).toInt())
                                : Colors.grey.withAlpha((0.2 * 255).toInt()),
                            blurRadius: 10.0,
                            spreadRadius: 2.0,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 24.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            VendorAppStrings.emailVerificationPending.tr,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16.0),
                          Divider(
                            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                            thickness: 1.0,
                          ),
                          const SizedBox(height: 16.0),
                          Text(
                            VendorAppStrings.pleaseVerifyEmail.tr,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.red.shade400 : Colors.red.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            VendorAppStrings.checkInboxSpam.tr,
                            style: TextStyle(
                              fontSize: 14.0,
                              color: isDark ? Colors.grey.shade300 : Colors.black87,
                            ),
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                  ),
                                  onPressed: () async {
                                    final resultVerified = await verifyEmail();
                                    setState(() {
                                      isVerifyLoading = false;
                                    });
                                    if (resultVerified != null) {
                                      if (resultVerified.isVerified == true) {
                                        AppUtils.showToast(VendorAppStrings.accountVerified.tr, isSuccess: true);

                                        // Keep this for backward compatibility if needed
                                        SecurePreferencesUtil.setBool(
                                          SecurePreferencesUtil.verified,
                                          true,
                                        );

                                        widget.onNext();
                                      } else {
                                        AppUtils.showToast(VendorAppStrings.emailVerificationPendingStatus.tr);
                                      }
                                    }
                                  },
                                  child: isVerifyLoading
                                      ? const SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : Text(
                                          VendorAppStrings.verify.tr,
                                          style: const TextStyle(
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
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                    ),
                                  ),
                                  onPressed: isResendLoading ? null : resendEmail,
                                  child: isResendLoading
                                      ? const SizedBox(
                                          height: 16.0,
                                          width: 16.0,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.0,
                                          ),
                                        )
                                      : Text(
                                          VendorAppStrings.resend.tr,
                                          style: const TextStyle(
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
}
