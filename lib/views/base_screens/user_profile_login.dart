import 'dart:io';

import 'package:camera_gallery_image_picker/camera_gallery_image_picker.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/router/app_routes.dart';
import 'package:event_app/core/services/image_picker.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/custom_text_styles.dart';
import 'package:event_app/core/widgets/custom_auth_views/custom_profile_items.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/auth_provider/get_user_provider.dart';
import 'package:event_app/provider/auth_provider/user_auth_provider.dart';
import 'package:event_app/provider/customer/account_view_models/customer_upload_profile_pic_view_model.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_stepper_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_drawer_screen.dart';
import 'package:event_app/views/base_screens/profile_screens/profiel_change_password.dart';
import 'package:event_app/views/base_screens/profile_screens/profile_address_screen.dart';
import 'package:event_app/views/base_screens/profile_screens/profile_review_screen.dart';
import 'package:event_app/views/base_screens/profile_screens/profile_update_screen.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import 'package:event_app/views/profile_page_screens/about_us_screen.dart';
import 'package:event_app/views/profile_page_screens/privacy_policy_screen.dart';
import 'package:event_app/views/profile_page_screens/terms_and_condtion_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileLoginScreen extends StatefulWidget {
  const UserProfileLoginScreen({super.key});

  @override
  State<UserProfileLoginScreen> createState() => _UserProfileLoginScreenState();
}

class _UserProfileLoginScreenState extends State<UserProfileLoginScreen> {
  String? userName;
  String? userMail;
  bool isLoggedIn = false;
  bool isVendorApprovedVerified = false;
  bool isVendor = false;
  File? _imageFile;
  String? _selectedImageUrl;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _onRefresh();
    });
    super.initState();
  }

  Future _onRefresh() async {
    await checkLoginData();
    _loadImage();
    await fetchUserData();
    setState(() {});
  }

  Future checkLoginData() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isVerified =
        prefs.getBool(SecurePreferencesUtil.verified) ?? false;
    final bool isApproved =
        prefs.getBool(SecurePreferencesUtil.approved) ?? false;
    final int vendor = prefs.getInt(SecurePreferencesUtil.vendor) ?? 0;

    if (vendor == 1) {
      isVendor = true;
      if (isVerified && isApproved) {
        isVendorApprovedVerified = true;
      } else {
        isVendorApprovedVerified = false;
      }
    } else {
      isVendor = false;
    }
  }

  // Load the saved image from SharedPreferences and show
  Future<void> _loadImage() async {
    final String? imagePath = await _imagePickerHelper.getSavedImage();
    if (imagePath != null) {
      setState(() {
        _selectedImageUrl = imagePath;
      });
    }
  }

  /// Implement upload profile picture functionality
  Future<void> _onUploadProfilePicture() async {
    if (_imageFile != null) {
      final uploadProfilePictureProvider =
          context.read<CustomerUploadProfilePicViewModel>();
      final result = await uploadProfilePictureProvider
          .customerUploadProfilePicture(file: _imageFile!, context: context);
      if (result) {
        await _imagePickerHelper.saveImageToPreferences(
            uploadProfilePictureProvider.apiResponse.data?.data?.url ?? '');
        await _loadImage();
      }
    }
    setState(() {});
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
    final authProvider = Provider.of<AuthProvider>(context, listen: true);
    final userProvider = Provider.of<UserProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: 40),
                child: Consumer<UserProvider>(
                  builder: (BuildContext context, UserProvider provider,
                      Widget? child) {
                    final user = provider.user;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.04,
                              bottom: screenWidth * 0.02),
                          child: Align(
                              alignment: Alignment.center,
                              child: Text(AppStrings.account,
                                  style: accountTextStyle(context))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                Consumer<CustomerUploadProfilePicViewModel>(
                                  builder: (context, provider, _) {
                                    final uploading =
                                        provider.apiResponse.status ==
                                            ApiStatus.LOADING;
                                    return Container(
                                      width: 90,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        border: uploading
                                            ? Border.all(
                                                color: AppColors.peachyPink,
                                                width: 0.2)
                                            : null,
                                        shape: BoxShape.circle,
                                        color: Colors.grey.shade300,
                                        image: uploading
                                            ? null
                                            : DecorationImage(
                                                image: (_selectedImageUrl !=
                                                            null &&
                                                        _selectedImageUrl
                                                                ?.isNotEmpty ==
                                                            true)
                                                    ? NetworkImage(
                                                        _selectedImageUrl!)
                                                    : const AssetImage(
                                                            'assets/boy.png')
                                                        as ImageProvider,
                                              ),
                                      ),
                                      child: uploading
                                          ? Utils.pageLoadingIndicator(
                                              context: context)
                                          : null,
                                    );
                                  },
                                ),

                                // Edit Icon
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: GestureDetector(
                                    onTap: () async {
                                      _imageFile =
                                          await CameraGalleryImagePicker
                                              .pickImage(
                                        context: context,
                                        source: ImagePickerSource.both,
                                      );
                                      _onUploadProfilePicture();
                                    },
                                    child: Container(
                                      width: 25,
                                      height: 25,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: SvgPicture.asset(
                                        'assets/camera_icon.svg',
                                      ),

                                      // SvgPicture.asset('assets/camera_icon.svg')
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: screenWidth * 0.01),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(user?.name.toUpperCase() ?? '',
                                        maxLines: 1,
                                        softWrap: true,
                                        style: nameTextStyle(context)),
                                    Text(user?.email ?? '',
                                        maxLines: 2,
                                        softWrap: true,
                                        style: mailTextStyle(context)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: screenHeight * 0.04,
                              bottom: screenHeight * 0.02),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.06),
                                borderRadius:
                                    BorderRadius.circular(screenHeight * 0.01)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenWidth * 0.05),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: screenHeight * 0.02,
                                              left: screenWidth * 0.02,
                                              bottom: screenHeight * 0.02),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ProfileItem(
                                                imagePath:
                                                    'assets/account_profile.svg',
                                                // imagePath: AppStrings.userFill,
                                                title: 'Profile',
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProfileUpdateScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                imagePath: 'assets/orders.svg',
                                                title: 'Orders',
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const OrderPageScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                imagePath: 'assets/Reviews.svg',
                                                title: 'Reviews',
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProfileReviewScreen()));
                                                },
                                              ),
                                              const ProfileItem(
                                                imagePath:
                                                    'assets/gift_cards.svg',
                                                title: 'Gift Cards',
                                                routeName: AppRoutes.giftCard,
                                                arguments: {
                                                  'title': 'Gift Card'
                                                }, // Optional argument
                                              ),
                                              ProfileItem(
                                                imagePath: 'assets/Address.svg',
                                                title: 'Address',
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProfileAddressScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                imagePath:
                                                    'assets/change_password.svg',
                                                title:
                                                    AppStrings.changePassword,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ChangePasswordScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                width: 23,
                                                height: 23,
                                                textWidth: screenWidth * 0.06,
                                                imagePath: 'assets/Privacy.svg',
                                                title: AppStrings.privacyPolicy,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const PrivacyPolicyScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                width: 23,
                                                height: 23,
                                                textWidth: screenWidth * 0.06,
                                                imagePath: 'assets/Info.svg',
                                                title: AppStrings.aboutUs,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AboutUsScreen()));
                                                },
                                              ),
                                              ProfileItem(
                                                width: 23,
                                                height: 23,
                                                textWidth: screenWidth * 0.06,
                                                imagePath:
                                                    'assets/termsandcon.svg',
                                                title:
                                                    AppStrings.termsConditions,
                                                onTap: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const TermsAndCondtionScreen()));
                                                },
                                              ),
                                              if (isVendor &&
                                                  isVendorApprovedVerified) ...{
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  VendorDrawerScreen()));
                                                      // Navigator.pushNamed(context, AppRoutes.vendorLogin);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/Join_seller.svg',
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
                                                        const SizedBox(
                                                            width: 16),
                                                        Text(AppStrings.vendor,
                                                            style: profileItems(
                                                                context)),

                                                        // Icon(iconData, color: iconColor, size: iconSize,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              },
                                              if (isVendor &&
                                                  !isVendorApprovedVerified)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const VendorStepperScreen()));
                                                      // Navigator.pushNamed(context, AppRoutes.vendorLogin);
                                                    },
                                                    child: Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            'assets/Join_seller.svg',
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onPrimary),
                                                        const SizedBox(
                                                            width: 16),
                                                        Text(
                                                            AppStrings
                                                                .joinAsSeller,
                                                            style: profileItems(
                                                                context)),

                                                        // Icon(iconData, color: iconColor, size: iconSize,),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              showLogoutConfirmationDialog(
                                  context, authProvider);
                            },
                            child: SizedBox(
                              width: screenWidth * 0.4,
                              child: Container(
                                height: 45,
                                margin:
                                    EdgeInsets.only(top: screenHeight * 0.01),
                                decoration: const BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: authProvider.isLoading
                                    ? Center(
                                        child: SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: LoadingAnimationWidget
                                              .stretchedDots(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            size: 25,
                                          ),
                                        ),
                                      )
                                    : Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text('Logout',
                                              style: logoutTextStyle(context)),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: screenWidth * 0.04),
                                            child: SvgPicture.asset(
                                                'assets/logoutBtn.svg',
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            if (userProvider.isLoading || authProvider.isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                // Semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showLogoutConfirmationDialog(
      BuildContext mainContext, AuthProvider authProvider) {
    showDialog(
      context: mainContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Close the dialog
              Navigator.of(context).pop();
              final SharedPreferences sp =
                  await SharedPreferences.getInstance();
              final token = sp.getString('token') ?? '';
              await authProvider.logout(mainContext, token);
              final provider = Provider.of<UserProvider>(context, listen: true);
              provider.setUser(null);
              _onRefresh();

              /// refreshing the page
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
}
