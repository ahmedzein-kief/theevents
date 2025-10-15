import 'package:event_app/core/constants/app_assets.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/widgets/bottom_navigation_bar.dart';
import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:event_app/vendor/components/vendor_dashboard_appbar.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../models/dashboard/vendor_permissions.dart';

/// Vendor Drawer
class VendorDrawerView extends StatelessWidget {
  // Callback function for subtitle text tap

  const VendorDrawerView({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.userModel,
    this.onSubtitleTap,
    required this.vendorPermissions,
  });

  final int selectedIndex; // To hold the current selected index
  final ValueChanged<int> onItemTapped; // Callback to handle item taps
  final UserModel? userModel;
  final VoidCallback? onSubtitleTap;
  final VendorPermissions vendorPermissions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBarVendor(
                  imageUrl: userModel?.avatar,
                  titleText: userModel?.name,
                  subtitleText: VendorAppStrings.downloadAgreement.tr,
                  onSubtitleTap: onSubtitleTap,
                  isShowBack: true,
                ),
                //SizedBox(height: screenHeight * 0.03),
                Column(
                  children: [
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.dashboard.tr,
                      assetAddress: 'assets/vendor_assets/drawer/home.svg',
                      isSelected: selectedIndex == 0,
                      onTap: () => onItemTapped(0),
                    ),
                    _divider(screenWidth),
                    if (vendorPermissions.allowProducts) ...[
                      _buildDrawerItem(
                        context,
                        title: VendorAppStrings.products.tr,
                        assetAddress: 'assets/vendor_assets/drawer/products.svg',
                        isSelected: selectedIndex == 1,
                        onTap: () => onItemTapped(1),
                      ),
                      _divider(screenWidth),
                    ],
                    if (vendorPermissions.allowPackages) ...[
                      _buildDrawerItem(
                        context,
                        title: VendorAppStrings.packages.tr,
                        assetAddress: 'assets/vendor_assets/drawer/packages.svg',
                        isSelected: selectedIndex == 2,
                        onTap: () => onItemTapped(2),
                      ),
                      _divider(screenWidth),
                    ],
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.orders.tr,
                      assetAddress: 'assets/vendor_assets/drawer/orders.svg',
                      isSelected: selectedIndex == 3,
                      onTap: () => onItemTapped(3),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.orderReturns.tr,
                      assetAddress: 'assets/vendor_assets/drawer/order_returns.svg',
                      isSelected: selectedIndex == 4,
                      onTap: () => onItemTapped(4),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.coupons.tr,
                      assetAddress: 'assets/vendor_assets/drawer/coupon.svg',
                      isSelected: selectedIndex == 5,
                      onTap: () => onItemTapped(5),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.withdrawals.tr,
                      assetAddress: 'assets/vendor_assets/drawer/withdrawal.svg',
                      isSelected: selectedIndex == 6,
                      onTap: () => onItemTapped(6),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.reviews.tr,
                      assetAddress: 'assets/vendor_assets/drawer/reviews.svg',
                      isSelected: selectedIndex == 7,
                      onTap: () => onItemTapped(7),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.revenues.tr,
                      assetAddress: 'assets/vendor_assets/drawer/revenues.svg',
                      isSelected: selectedIndex == 8,
                      onTap: () => onItemTapped(8),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.settings.tr,
                      assetAddress: 'assets/vendor_assets/drawer/settings.svg',
                      isSelected: selectedIndex == 9,
                      onTap: () => onItemTapped(9),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: VendorAppStrings.logoutFromVendor.tr,
                      assetAddress: 'assets/vendor_assets/drawer/logout.svg',
                      isSelected: false,
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BaseHomeScreen(),
                          ),
                        );
                      },
                    ),
                    _divider(screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const BaseHomeScreen(),
                              ),
                              (route) => false);
                        },
                        child: SvgPicture.asset(
                          isDarkMode ? AppAssets.eventsDarkLogo : AppAssets.eventsLogo,
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(VendorAppStrings.copyrightText.tr),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required String assetAddress,
    required bool isSelected,
    required VoidCallback onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 20),
          padding: EdgeInsets.only(bottom: 3, left: kPadding, right: kPadding),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade400)),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                assetAddress,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.peachyPink : Theme.of(context).colorScheme.onPrimary,
                  BlendMode.srcIn,
                ),
                width: 24,
                height: 24,
              ),
              kSmallSpace,
              Expanded(
                child: Text(
                  title,
                  style: vendorDrawer(context).copyWith(
                    fontSize: 14,
                    color: isSelected ? AppColors.peachyPink : Theme.of(context).colorScheme.onPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _divider(double width) {
    // return Container(
    //   color: Colors.grey,
    //   height: 1,
    //   width: width,
    // );
    return kShowVoid;
  }
}
