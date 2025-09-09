import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/validators/validator.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_status/api_status.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../provider/login_profile_provider/change_password.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _changePasswordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();

  final FocusNode _currentPasswordFocusNode = FocusNode();
  final FocusNode _changePasswordFocusNode = FocusNode();
  final FocusNode _reEnterPasswordFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Consumer<ChangePasswordProvider>(
          builder: (context, provider, _) => Column(
            children: [
              BackAppBarStyle(
                icon: Icons.arrow_back_ios,
                text: AppStrings.myAccount.tr,
              ),
              SizedBox(height: screenHeight * 0.04),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CustomFieldProfileScreen(
                          isObscureText: true,
                          // Set this to true for password fields
                          hintText: AppStrings.enterCurrentPassword.tr,
                          controller: _currentPasswordController,
                          focusNode: _currentPasswordFocusNode,
                          nextFocusNode: _changePasswordFocusNode,
                          formFieldValidator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppStrings.currentPasswordCannotBeEmpty.tr;
                            }
                            return null;
                          },
                          labelText: AppStrings.currentPassword.tr,
                        ),
                        CustomFieldProfileScreen(
                          isObscureText: true,
                          // Set this to true for password fields
                          hintText: AppStrings.enterChangePassword.tr,
                          controller: _changePasswordController,
                          focusNode: _changePasswordFocusNode,
                          nextFocusNode: _reEnterPasswordFocusNode,
                          labelText: AppStrings.changePassword.tr,
                          formFieldValidator: Validator.signUpPasswordValidation,
                        ),
                        CustomFieldProfileScreen(
                          isObscureText: true,
                          // Set this to true for password fields
                          keyboardType: TextInputType.visiblePassword,
                          hintText: AppStrings.enterReEnterPassword.tr,
                          controller: _reEnterPasswordController,
                          focusNode: _reEnterPasswordFocusNode,
                          nextFocusNode: _reEnterPasswordFocusNode,
                          labelText: AppStrings.reEnterPassword.tr,
                          formFieldValidator: Validator.signUpPasswordValidation,
                        ),
                        SizedBox(height: screenHeight * 0.04),
                        AppCustomButton(
                          title: AppStrings.update.tr,
                          isLoading: context.watch<ChangePasswordProvider>().status ==
                              ApiStatus.loading, // Show loader if status is loading
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              await forChangePassword(
                                context,
                              ); // Call the password change function
                            } else {
                              CustomSnackbar.showError(
                                context,
                                AppStrings.pleaseEnterFields.tr,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> forChangePassword(BuildContext context) async {
    final provider = Provider.of<ChangePasswordProvider>(context, listen: false);
    final token = await SecurePreferencesUtil.getToken();
    final oldPassword = _currentPasswordController.text;
    final newPassword = _changePasswordController.text;
    final reEnterPassword = _reEnterPasswordController.text;

    final request = ChangePasswordRequest(
      oldPassword: oldPassword,
      password: newPassword,
      password_confirmation: reEnterPassword,
    );

    await provider.changePassword(token ?? '', request, context);
  }
}
