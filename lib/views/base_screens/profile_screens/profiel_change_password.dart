import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:event_app/utils/validator/validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/login_profile_provider/change_password.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../utils/apiStatus/api_status.dart';

class ChangePasswordScreen extends StatelessWidget {
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
          builder: (context, provider, _) {
            return Column(
              children: [
                BackAppBarStyle(
                  icon: Icons.arrow_back_ios,
                  text: 'My Account',
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
                              hintText: "Enter Current Password",
                              controller: _currentPasswordController,
                              focusNode: _currentPasswordFocusNode,
                              nextFocusNode: _changePasswordFocusNode,
                              formFieldValidator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Current Password cannot be empty.';
                                }
                                return null;
                              },
                              labelText: "Current Password"),
                          CustomFieldProfileScreen(
                            isObscureText: true,
                            // Set this to true for password fields
                            hintText: "Enter Change Password",
                            controller: _changePasswordController,
                            focusNode: _changePasswordFocusNode,
                            nextFocusNode: _reEnterPasswordFocusNode,
                            labelText: "Change Password",
                            formFieldValidator: Validator.signUpPasswordValidation,
                          ),
                          CustomFieldProfileScreen(
                            isObscureText: true,
                            // Set this to true for password fields
                            keyboardType: TextInputType.visiblePassword,
                            hintText: "Enter Re-Enter Password",
                            controller: _reEnterPasswordController,
                            focusNode: _reEnterPasswordFocusNode,
                            nextFocusNode: _reEnterPasswordFocusNode,
                            labelText: "Re-Enter Password",
                            formFieldValidator: Validator.signUpPasswordValidation,
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          AppCustomButton(
                            title: 'Update',
                            isLoading: context.watch<ChangePasswordProvider>().status == ApiStatus.loading, // Show loader if status is loading
                            onPressed: () async {
                              if (_formKey.currentState?.validate() ?? false) {
                                await forChangePassword(context); // Call the password change function
                              } else {
                                CustomSnackbar.showError(context, "Please enter Fields");
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> forChangePassword(BuildContext context) async {
    final provider = Provider.of<ChangePasswordProvider>(context, listen: false);
    final token = await SharedPreferencesUtil.getToken();
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
