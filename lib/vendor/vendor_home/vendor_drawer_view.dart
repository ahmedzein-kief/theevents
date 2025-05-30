import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:event_app/navigation/bottom_navigation_bar.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/vendor/components/vendor_dashboard_appbar.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Vendor Drawer
class VendorDrawerView extends StatelessWidget {
  final int selectedIndex; // To hold the current selected index
  final ValueChanged<int> onItemTapped; // Callback to handle item taps
  final UserModel? userModel;
  final VoidCallback? onSubtitleTap; // Callback function for subtitle text tap

  const VendorDrawerView({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.userModel,
    required this.onSubtitleTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Drawer(
      width: screenWidth * 0.75,
      backgroundColor: VendorColors.vendorAppBackground,
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
                  subtitleText: "Download Agreement",
                  onSubtitleTap: onSubtitleTap,
                  isShowBack: true,
                ),
                SizedBox(height: screenHeight * 0.03),
                Column(
                  children: [
                    _buildDrawerItem(
                      context,
                      title: 'Dashboard',
                      assetAddress: "assets/vendor_assets/drawer/home.svg",
                      isSelected: selectedIndex == 0,
                      onTap: () => onItemTapped(0),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Products',
                      assetAddress: "assets/vendor_assets/drawer/products.svg",
                      isSelected: selectedIndex == 1,
                      onTap: () => onItemTapped(1),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Packages',
                      assetAddress: "assets/vendor_assets/drawer/packages.svg",
                      isSelected: selectedIndex == 2,
                      onTap: () => onItemTapped(2),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Orders',
                      assetAddress: "assets/vendor_assets/drawer/orders.svg",
                      isSelected: selectedIndex == 3,
                      onTap: () => onItemTapped(3),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Order Returns',
                      assetAddress: "assets/vendor_assets/drawer/order_returns.svg",
                      isSelected: selectedIndex == 4,
                      onTap: () => onItemTapped(4),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Coupons',
                      assetAddress: "assets/vendor_assets/drawer/coupon.svg",
                      isSelected: selectedIndex == 5,
                      onTap: () => onItemTapped(5),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Withdrawals',
                      assetAddress: "assets/vendor_assets/drawer/withdrawal.svg",
                      isSelected: selectedIndex == 6,
                      onTap: () => onItemTapped(6),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Reviews',
                      assetAddress: "assets/vendor_assets/drawer/reviews.svg",
                      isSelected: selectedIndex == 7,
                      onTap: () => onItemTapped(7),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Revenues',
                      assetAddress: "assets/vendor_assets/drawer/revenues.svg",
                      isSelected: selectedIndex == 8,
                      onTap: () => onItemTapped(8),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Settings',
                      assetAddress: "assets/vendor_assets/drawer/settings.svg",
                      isSelected: selectedIndex == 9,
                      onTap: () => onItemTapped(9),
                    ),
                    _divider(screenWidth),
                    _buildDrawerItem(
                      context,
                      title: 'Logout from Vendor',
                      assetAddress: "assets/vendor_assets/drawer/logout.svg",
                      isSelected: false,
                      onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BaseHomeScreen()));
                      },
                    ),
                    _divider(screenWidth),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(AppStrings.appLogo, width: 60, height: 60),
                    const Padding(
                      padding: EdgeInsets.only(left: 15, top: 8),
                      child: Text("© 2025 The Events. All Rights Reserved."),
                    ),
                  ],
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
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(bottom: 3, left: kPadding, right: kPadding),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade400))),
        child: Row(
          children: [
            SvgPicture.asset(
              assetAddress,
              colorFilter: ColorFilter.mode(
                isSelected ? AppColors.peachyPink : Colors.black,
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
                color: isSelected ? AppColors.peachyPink : AppColors.neutralGray,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.normal,
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget _divider(double width) {
    // return Container(
    //   color: Colors.grey,
    //   height: 1,
    //   width: width,
    // );
    return kShowVoid;
  }
}
