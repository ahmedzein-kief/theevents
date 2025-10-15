import 'dart:io';

import 'package:camera_gallery_image_picker/camera_gallery_image_picker.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/router/app_routes.dart';
import 'package:event_app/core/services/image_picker.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/custom_text_styles.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/custom_profile_items.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/auth_provider/get_user_provider.dart';
import 'package:event_app/provider/auth_provider/user_auth_provider.dart';
import 'package:event_app/provider/customer/account_view_models/customer_upload_profile_pic_view_model.dart';
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

import '../../core/widgets/language_dropdown_item.dart';
import '../../core/widgets/padded_network_banner.dart';
import '../../core/widgets/theme_toggle_switch.dart';

class UserProfileLoginScreen extends StatefulWidget {
  const UserProfileLoginScreen({super.key});

  @override
  State<UserProfileLoginScreen> createState() => _UserProfileLoginScreenState();
}

class _UserProfileLoginScreenState extends State<UserProfileLoginScreen> {
  // Private state variables
  File? _imageFile;
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  bool _isConvertingToVendor = false;

  // Cached providers to avoid repeated lookups
  UserProvider? _userProvider;
  AuthProvider? _authProvider;

  // Computed properties instead of stored state
  bool get _isVendor => _userProvider?.user?.isVendor == 1;

  bool get _isPaid => _userProvider?.user?.step == 6;

  bool get _isVendorApprovedVerified {
    final user = _userProvider?.user;
    return user?.isVerified == true && user?.isApproved == true;
  }

  String get _avatarImage => _userProvider?.user?.avatar ?? '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  /// Initialize the widget with cached providers
  Future<void> _initialize() async {
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    await _onRefresh();
  }

  /// Refresh all data
  Future<void> _onRefresh() async {
    if (!mounted) return;

    try {
      await Future.wait([
        _fetchUserData(),
      ]);
    } catch (e) {
      _showErrorSnackBar('Failed to refresh profile data');
    } finally {
      if (mounted) setState(() {});
    }
  }

  /// Fetch user data from API
  Future<void> _fetchUserData() async {
    try {
      final provider = _userProvider ?? Provider.of<UserProvider>(context, listen: false);
      await provider.fetchUserData();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  /// Handle image selection and upload
  Future<void> _handleImageSelection() async {
    try {
      final selectedImage = await CameraGalleryImagePicker.pickImage(
        context: context,
        source: ImagePickerSource.both,
      );

      if (selectedImage != null && mounted) {
        setState(() {
          _imageFile = selectedImage;
        });
        await _uploadProfilePicture();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to select image');
    }
  }

  /// Upload profile picture with proper error handling
  Future<void> _uploadProfilePicture() async {
    if (_imageFile == null || !mounted) return;

    try {
      final uploadProvider = context.read<CustomerUploadProfilePicViewModel>();
      final success = await uploadProvider.customerUploadProfilePicture(
        file: _imageFile!,
        context: context,
      );

      if (success && mounted) {
        final imageUrl = uploadProvider.apiResponse.data?.data?.url;
        if (imageUrl != null) {
          await _imagePickerHelper.saveImageToPreferences(imageUrl);

          _showSuccessSnackBar('Profile picture updated successfully');
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to upload profile picture');
    } finally {
      if (mounted) setState(() {});
    }
  }

  /// Show become vendor confirmation dialog
  void _showBecomeVendorDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.becomeSeller.tr, // Add this to your strings
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.of(dialogContext).pop(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        content: Text(
          AppStrings.becomeSellerConfirmation.tr,
          // "Are you sure you want to become a seller? This action will convert your account to a vendor account."
          style: const TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.grey.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.cancel.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(dialogContext).pop();
                  await _handleBecomeVendor();
                },
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.peachyPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.yesBecomeSeller.tr, // "Yes, Become a Seller"
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Handle becoming a vendor
  /// Handle becoming a vendor
  Future<void> _handleBecomeVendor() async {
    if (!mounted) return;

    setState(() => _isConvertingToVendor = true);

    try {
      final userId = _userProvider?.user?.id;
      if (userId == null) {
        _showErrorSnackBar('User ID not found');
        return;
      }

      // Call the become vendor API using the provider method
      final success = await _userProvider!.becomeVendor(userId);

      if (success && mounted) {
        _navigateTo(const VendorStepperScreen());
      }
    } catch (error) {
      debugPrint(error.toString());
    } finally {
      setState(() => _isConvertingToVendor = false);
    }
  }

  /// Show error snackbar
  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show success snackbar
  void _showSuccessSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      body: SafeArea(
        child: Consumer2<UserProvider, AuthProvider>(
          builder: (context, userProvider, authProvider, child) {
            // Update cached providers
            _userProvider = userProvider;
            _authProvider = authProvider;

            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: Theme.of(context).colorScheme.onPrimary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: _buildMainContent(screenSize, userProvider.user),
                  ),
                ),
                if (userProvider.isLoading || authProvider.isLoading || _isConvertingToVendor) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Build main content
  Widget _buildMainContent(Size screenSize, user) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenSize.width * 0.05,
      ).copyWith(bottom: 40),
      child: Column(
        children: [
          _buildHeader(screenSize),
          _buildProfileSection(screenSize, user),
          _buildMenuSection(screenSize),
          _buildLogoutButton(screenSize),
        ],
      ),
    );
  }

  /// Build header section
  Widget _buildHeader(Size screenSize) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.04,
        bottom: screenSize.width * 0.02,
      ),
      child: Text(
        AppStrings.account.tr,
        style: accountTextStyle(context),
      ),
    );
  }

  /// Build profile section with avatar and user info
  Widget _buildProfileSection(Size screenSize, user) {
    return Row(
      children: [
        _buildProfileAvatar(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: screenSize.width * 0.03),
            child: _buildUserInfo(user),
          ),
        ),
      ],
    );
  }

  /// Build profile avatar with edit functionality
  Widget _buildProfileAvatar() {
    return Stack(
      children: [
        Consumer<CustomerUploadProfilePicViewModel>(
          builder: (context, provider, _) {
            final isUploading = provider.apiResponse.status == ApiStatus.LOADING;

            return Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                border: isUploading ? Border.all(color: AppColors.peachyPink, width: 0.2) : null,
                shape: BoxShape.circle,
                color: Colors.grey.shade300,
              ),
              child: isUploading ? AppUtils.pageLoadingIndicator(context: context) : _buildAvatarImage(),
            );
          },
        ),
        _buildEditButton(),
      ],
    );
  }

  /// Build avatar image with proper fallbacks
  Widget _buildAvatarImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(45),
      child: _avatarImage.isNotEmpty && !_avatarImage.startsWith('data:image')
          ? PaddedNetworkBanner(
              imageUrl: _avatarImage,
              width: 90,
              height: 90,
              fit: BoxFit.cover,
              padding: EdgeInsets.zero,
            )
          : Image.asset(
              'assets/boy.png',
              width: 90,
              height: 90,
              fit: BoxFit.cover,
            ),
    );
  }

  /// Build edit button for avatar
  Widget _buildEditButton() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: _handleImageSelection,
        child: Container(
          width: 25,
          height: 25,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: SvgPicture.asset('assets/camera_icon.svg'),
        ),
      ),
    );
  }

  /// Build user information section
  Widget _buildUserInfo(user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (user?.name?.toUpperCase() ?? '').isNotEmpty ? user!.name.toUpperCase() : 'Guest User',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: nameTextStyle(context),
        ),
        const SizedBox(height: 4),
        Text(
          user?.email ?? 'No email provided',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: mailTextStyle(context),
        ),
      ],
    );
  }

  /// Build menu section with all profile options
  Widget _buildMenuSection(Size screenSize) {
    return Padding(
      padding: EdgeInsets.only(
        top: screenSize.height * 0.04,
        bottom: screenSize.height * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.withAlpha((0.06 * 255).toInt()),
          borderRadius: BorderRadius.circular(screenSize.height * 0.01),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.05,
            vertical: screenSize.width * 0.05,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                top: screenSize.height * 0.02,
                left: screenSize.width * 0.02,
                right: screenSize.width * 0.02,
                bottom: screenSize.height * 0.02,
              ),
              child: Column(
                children: [
                  ..._buildMenuItems(screenSize),
                  const ThemeToggleSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build menu items list
  List<Widget> _buildMenuItems(Size screenSize) {
    return [
      _buildProfileItem(
          'assets/account_profile.svg', AppStrings.profile.tr, () => _navigateTo(const ProfileUpdateScreen())),
      _buildProfileItem('assets/orders.svg', AppStrings.orders.tr, () => _navigateTo(const OrderPageScreen())),
      _buildProfileItem('assets/Reviews.svg', AppStrings.reviews.tr, () => _navigateTo(const ProfileReviewScreen())),
      ProfileItem(
        imagePath: 'assets/gift_cards.svg',
        title: AppStrings.giftCards.tr,
        routeName: AppRoutes.giftCard,
        arguments: const {'title': 'Gift Card'},
      ),
      ProfileItem(
        imagePath: 'assets/wallet.svg',
        title: AppStrings.wallet.tr,
        routeName: AppRoutes.wallet,
        arguments: const {'title': 'Wallet'},
      ),
      _buildProfileItem('assets/Address.svg', AppStrings.address.tr, () => _navigateTo(const ProfileAddressScreen())),
      _buildProfileItem(
          'assets/change_password.svg', AppStrings.changePassword.tr, () => _navigateTo(ChangePasswordScreen())),
      _buildProfileItem(
          'assets/Privacy.svg', AppStrings.privacyPolicy.tr, () => _navigateTo(const PrivacyPolicyScreen()),
          width: 23, height: 23, textWidth: screenSize.width * 0.06),
      _buildProfileItem('assets/Info.svg', AppStrings.aboutUs.tr, () => _navigateTo(const AboutUsScreen()),
          width: 23, height: 23, textWidth: screenSize.width * 0.06),
      _buildProfileItem(
          'assets/termsandcon.svg', AppStrings.termsAndConditions.tr, () => _navigateTo(const TermsAndCondtionScreen()),
          width: 23, height: 23, textWidth: screenSize.width * 0.06),

      /// Vendor Section
      _buildVendorMenuItem(screenSize),

      const LanguageDropdownItem(),
    ];
  }

  /// Helper method to build profile items
  Widget _buildProfileItem(String imagePath, String title, VoidCallback onTap,
      {double? width, double? height, double? textWidth}) {
    return ProfileItem(
      imagePath: imagePath,
      title: title,
      onTap: onTap,
      width: width,
      height: height,
      textWidth: textWidth,
    );
  }

  /// Build vendor/seller menu item based on account status
  Widget _buildVendorMenuItem(Size screenSize) {
    // Don't show anything if user is verified vendor (shown in separate section)
    if (_isVendor && _isVendorApprovedVerified) {
      return _buildVendorItem(
        AppStrings.vendor.tr,
        () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const VendorDrawerScreen()),
        ),
      );
    }

    // Show "Join as Seller" for non-vendors or unverified vendors
    return _buildProfileItem(
      'assets/Join_seller.svg',
      _isVendor ? AppStrings.vendor.tr : AppStrings.joinAsSeller.tr,
      () => _handleVendorNavigation(),
      width: 23,
      height: 23,
      textWidth: screenSize.width * 0.06,
    );
  }

  /// Handle navigation based on vendor status
  void _handleVendorNavigation() {
    if (!_isVendor) {
      // Not a vendor yet - show confirmation dialog
      _showBecomeVendorDialog();
    } else if (_isPaid && !_isVendorApprovedVerified) {
      // Vendor but under review
      AppUtils.showToast(AppStrings.vendorAccountUnderReview.tr, long: true);
    } else {
      // Vendor but needs to complete steps
      _navigateTo(const VendorStepperScreen());
    }
  }

  /// Build vendor menu item (helper for dashboard access)
  Widget _buildVendorItem(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/Join_seller.svg',
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Text(title, style: profileItems(context)),
          ],
        ),
      ),
    );
  }

  /// Build logout button
  Widget _buildLogoutButton(Size screenSize) {
    return Align(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => _showLogoutDialog(),
        child: Container(
          width: screenSize.width * 0.4,
          height: 45,
          margin: EdgeInsets.only(top: screenSize.height * 0.01),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: Consumer<AuthProvider>(
            builder: (context, authProvider, _) {
              return authProvider.isLoading
                  ? Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: LoadingAnimationWidget.stretchedDots(
                          color: Theme.of(context).colorScheme.primary,
                          size: 25,
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(AppStrings.logout.tr, style: logoutTextStyle(context)),
                        Padding(
                          padding: EdgeInsets.only(left: screenSize.width * 0.04),
                          child: SvgPicture.asset(
                            'assets/logoutBtn.svg',
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  /// Build loading overlay
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withAlpha((0.5 * 255).toInt()),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
        ),
      ),
    );
  }

  /// Navigate to a screen
  void _navigateTo(Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Show logout confirmation dialog
  void _showLogoutDialog() {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text(AppStrings.confirmLogout.tr),
        content: Text(AppStrings.confirmLogoutMessage.tr),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink,
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(AppStrings.cancel.tr),
          ),
          TextButton(
            onPressed: () => _handleLogout(dialogContext),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink,
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(AppStrings.yes.tr),
          ),
        ],
      ),
    );
  }

  /// Handle logout process
  /// Handle logout process
  Future<void> _handleLogout(BuildContext dialogContext) async {
    // Capture navigator before closing dialog
    final dialogNavigator = Navigator.of(dialogContext);

    dialogNavigator.pop();

    if (!mounted) return;

    try {
      final token = await SecurePreferencesUtil.getToken();

      if (_authProvider != null && token != null) {
        if (!mounted) return;
        await _authProvider!.logout(context, token);
      }

      await SecurePreferencesUtil.logout();

      if (_userProvider != null) {
        _userProvider!.setUser(null);
      }

      await _onRefresh();
    } catch (e) {
      _showErrorSnackBar('Failed to logout. Please try again.');
    }
  }
}
