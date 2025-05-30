import 'package:event_app/models/auth_models/get_user_models.dart';
import 'package:event_app/provider/auth_provider/get_user_provider.dart';
import 'package:event_app/provider/vendor/vendor_sign_up_provider.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/vendor/Components/vendor_text_style.dart';
import 'package:event_app/vendor/vendor_home/dashboard_screen.dart';
import 'package:event_app/vendor/vendor_home/vendor_coupons/vendor_coupon_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_drawer_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_order_returns/vendor_orders_returns_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_orders/vendor_orders_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_packages/vendor_packages_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_products_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_revenue/vendor_revenues_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_reviews/vendor_reviews_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_settings/vendor_profile_settings_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_withdrawals/vendor_withdrawals_view.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/pdf_downloader.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class VendorDrawerScreen extends StatefulWidget {
  int? selectedIndex;

  VendorDrawerScreen({Key? key, this.selectedIndex}) : super(key: key);

  @override
  State<VendorDrawerScreen> createState() => _VendorDrawerScreenState();
}

class _VendorDrawerScreenState extends State<VendorDrawerScreen> {
  int _selectedIndex = 0;
  UserModel? userModel;

  Future<UserModel?> getProfileData() async {
    var provider = Provider.of<VendorSignUpProvider>(context, listen: false);
    final result = await provider.fetchUserData(context);
    setState(() {
      userModel = result;
    });

    return userModel;
  }

  Future<void> generateAgreement(BuildContext? context, String invoice) async {
    if (!mounted) return;
    if (context == null) return;
    try {
      final provider = Provider.of<UserProvider>(context, listen: false);
      final binaryData = await provider.downloadAgreement(context);
      var filename = invoice;

      // Save binary data as a PD
      final result = await PDFDownloader().saveFileInDownloadsUint(context, binaryData, filename);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$result'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
        ),
      );
    } finally {}
  }

  late List<Widget> _screens = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await getProfileData();
    });

    _screens = [
      VendorDashBoardScreen(
        onIndexUpdate: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      const VendorProductsView(),
      const VendorPackagesView(),
      const VendorOrdersView(),
      const VendorOrdersReturnsView(),
      const VendorCouponView(),
      const VendorWithdrawalsView(),
      const VendorReviewsView(),
      const VendorRevenuesView(),
      VendorProfileSettingsView(),
      // Add more screens as needed
    ];

    super.initState();
  }

  final List<String> _titles = [
    'Dashboard',
    'Products',
    'Packages',
    'Orders',
    'Order Returns',
    'Coupons',
    'Withdrawals',
    'Reviews',
    'Revenues',
    'Settings',
    // Add more titles as needed
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Consumer<UserProvider>(
        builder: (BuildContext context, UserProvider provider, Widget? child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  title: Text(
                    _titles[_selectedIndex],
                    style: vendorName(context),
                  ),
                ),
                body: _screens[_selectedIndex],
                endDrawer: VendorDrawerView(
                  selectedIndex: _selectedIndex,
                  onItemTapped: _onItemTapped,
                  userModel: userModel, // Use userModel from provider
                  onSubtitleTap: () async {
                    Navigator.pop(context);
                    String formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
                    print(formattedDate); // Example: 2025-02-25 14:30:00
                    var invoice = "Vendor_Agreement_$formattedDate";
                    await generateAgreement(context, invoice);
                  },
                ),
              ),
              if (provider.isLoading) // Show loading indicator in center
                Container(
                  color: Colors.black.withOpacity(0.5), // Optional dim background
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ), // Loading spinner
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
