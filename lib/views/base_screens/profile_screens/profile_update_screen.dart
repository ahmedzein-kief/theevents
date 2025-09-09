import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_status/api_status.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../provider/auth_provider/get_user_provider.dart';
import '../../../provider/login_profile_provider/profile_update.dart';
import '../../auth_screens/auth_page_view.dart';

class ProfileUpdateScreen extends StatefulWidget {
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameFocusNode = FocusNode();
  final fullEmailFocusNode = FocusNode();
  final phoneNumberFocusNode = FocusNode();

  final _fullNameController = TextEditingController();
  final _fullEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchUserData();
    });
  }

  Future<void> fetchUserData() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<UserProvider>(context, listen: false);
    provider.fetchUserData(token ?? '', context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final mainProvider = Provider.of<UserProvider>(context, listen: true);

    final user = mainProvider.user;
    _fullNameController.text = user?.name ?? '';
    _fullEmailController.text = user?.email ?? '';
    _phoneNumberController.text = user?.phone ?? '';

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                BackAppBarStyle(
                  icon: Icons.arrow_back_ios,
                  text: AppStrings.myAccount.tr,
                ),
                SizedBox(height: screenHeight * 0.04),
                Expanded(
                  child: SingleChildScrollView(
                    child: Consumer<UserProvider>(
                      builder: (
                        BuildContext context,
                        UserProvider provider,
                        Widget? child,
                      ) {
                        final user = provider.user;
                        if (user == null) return Container();
                        return Column(
                          children: [
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomFieldProfileScreen(
                                    displayName: user.name,
                                    hintText: AppStrings.enterYourName.tr,
                                    controller: _fullNameController,
                                    focusNode: fullNameFocusNode,
                                    nextFocusNode: fullEmailFocusNode,
                                    labelText: AppStrings.fullName.tr,
                                    formFieldValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppStrings.nameCannotBeEmpty.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomFieldProfileScreen(
                                    displayName: user.email,
                                    hintText: AppStrings.enterEmailAddress.tr,
                                    controller: _fullEmailController,
                                    focusNode: fullEmailFocusNode,
                                    isEditable: false,
                                    nextFocusNode: phoneNumberFocusNode,
                                    labelText: AppStrings.email.tr,
                                    formFieldValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppStrings.emailCannotBeEmpty.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  CustomFieldProfileScreen(
                                    displayName: user.phone,
                                    hintText: AppStrings.enterPhoneNumber.tr,
                                    controller: _phoneNumberController,
                                    focusNode: phoneNumberFocusNode,
                                    labelText: AppStrings.phone.tr,
                                    formFieldValidator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return AppStrings.phoneCannotBeEmpty.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: screenHeight * 0.04),
                                  AppCustomButton(
                                    title: AppStrings.update.tr,
                                    isLoading: context.watch<ProfileUpdateProvider>().status == ApiStatus.loading,
                                    onPressed: () async {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        await forUpdateProfile(context);
                                        final provider = Provider.of<UserProvider>(
                                          context,
                                          listen: false,
                                        );
                                        await provider.fetchUserData(
                                          user.token ?? '',
                                          context,
                                        );
                                      } else {
                                        CustomSnackbar.showError(
                                          context,
                                          AppStrings.pleaseFillAllFields.tr,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),
                            const Divider(thickness: 1, color: Colors.grey),
                            SizedBox(height: screenHeight * 0.02),
                            TextButton(
                              onPressed: () => _showDeleteAccountWarning(context),
                              child: Text(
                                AppStrings.deleteMyAccount.tr,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
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

  Future<void> forUpdateProfile(BuildContext context) async {
    final provider = Provider.of<ProfileUpdateProvider>(context, listen: false);
    final token = await SecurePreferencesUtil.getToken();
    final fullName = _fullNameController.text;
    final fullEmail = _fullEmailController.text;
    final phoneNumber = _phoneNumberController.text;

    final request = ProfileUpdateResponse(
      fullName: fullName,
      fullEmail: fullEmail,
      phoneNumber: phoneNumber,
    );

    await provider.editProfileDetails(token ?? '', request, context);
  }

  void _showDeleteAccountWarning(BuildContext mainContext) {
    showDialog(
      context: mainContext,
      builder: (BuildContext context) => AlertDialog(
        title: Text(AppStrings.deleteAccount.tr),
        content: Text(AppStrings.deleteAccountWarning.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              AppStrings.cancel.tr,
              style: const TextStyle(color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteAccount(mainContext);
            },
            child: Text(
              AppStrings.delete.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final provider = Provider.of<ProfileUpdateProvider>(context, listen: false);
    final token = await SecurePreferencesUtil.getToken();

    final isDeleted = await provider.deleteAccount(token ?? '', context);

    if (isDeleted) {
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(builder: (context) => AuthScreen()),
      );
    }
  }
}
