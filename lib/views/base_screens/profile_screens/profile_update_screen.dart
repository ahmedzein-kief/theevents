import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/auth_provider/get_user_provider.dart';
import '../../../provider/login_profile_provider/profile_update.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';
import '../../../utils/apiStatus/api_status.dart';
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
  WidgetsBinding.instance.addPostFrameCallback((_)async {
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
    var screenWidth = MediaQuery.sizeOf(context).width;
    var screenHeight = MediaQuery.sizeOf(context).height;
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
                  text: 'My Account',
                ),
                SizedBox(height: screenHeight * 0.04),
                Expanded(
                  child: SingleChildScrollView(child: Consumer<UserProvider>(
                    builder: (BuildContext context, UserProvider provider, Widget? child) {
                      final user = provider.user;
                      if (user == null) return Container();
                      return Column(
                        children: [
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                CustomFieldProfileScreen(
                                  displayName: user?.name,
                                  hintText: "Enter your Name",
                                  controller: _fullNameController,
                                  focusNode: fullNameFocusNode,
                                  nextFocusNode: fullEmailFocusNode,
                                  labelText: "Full Name",
                                  formFieldValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Name cannot be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                CustomFieldProfileScreen(
                                  displayName: user?.email,
                                  hintText: "Enter email Address",
                                  controller: _fullEmailController,
                                  focusNode: fullEmailFocusNode,
                                  isEditable: false,
                                  nextFocusNode: phoneNumberFocusNode,
                                  labelText: "Email",
                                  formFieldValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Email cannot be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                CustomFieldProfileScreen(
                                  displayName: user?.phone,
                                  hintText: "Enter Phone Number",
                                  controller: _phoneNumberController,
                                  focusNode: phoneNumberFocusNode,
                                  labelText: "Phone",
                                  formFieldValidator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Phone Number cannot be empty.';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: screenHeight * 0.04),
                                AppCustomButton(
                                  title: 'Update',
                                  isLoading: context.watch<ProfileUpdateProvider>().status == ApiStatus.loading,
                                  onPressed: () async {
                                    if (_formKey.currentState?.validate() ?? false) {
                                      await forUpdateProfile(context);
                                      final provider = Provider.of<UserProvider>(context, listen: false);
                                      await provider.fetchUserData(user?.token ?? '', context);
                                    } else {
                                      CustomSnackbar.showError(context, "Please fill all fields.");
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),
                          Divider(thickness: 1, color: Colors.grey),
                          SizedBox(height: screenHeight * 0.02),
                          TextButton(
                            onPressed: () => _showDeleteAccountWarning(context),
                            child: Text(
                              "Delete My Account",
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
                ),
              ],
            ),
            if (mainProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Account"),
          content: Text("Are you sure you want to delete your account? This action cannot be undone."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _deleteAccount(mainContext);
              },
              child: Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final provider = Provider.of<ProfileUpdateProvider>(context, listen: false);
    final token = await SecurePreferencesUtil.getToken();

    final isDeleted = await provider.deleteAccount(token ?? '', context);

    if (isDeleted) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => AuthScreen()));
    }
  }
}
