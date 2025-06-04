import 'package:event_app/provider/shortcode_vendor_type_by_provider/vendor_type_by_provider.dart';
import 'package:event_app/views/base_screens/user_profile_login.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_by_types_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/shortcode_home_page_provider.dart';
import '../../views/base_screens/home_screen.dart';
import '../../views/base_screens/profile_screen.dart';
import '../../views/home_screens_shortcode/shorcode_featured_brands/featured_brands_view_all.dart';
import '../../views/home_screens_shortcode/shortcode_featured_categories/featured_categories_items_screen.dart';
import '../services/shared_preferences_helper.dart';

class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({
    super.key,
    this.data,
    this.typeId,
  });
  final dynamic data;
  final int? typeId;

  @override
  State<BaseHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BaseHomeScreen> {
  late bool _isLoggedIn = false;
  late bool _isTempLoggedIn = false;
  int _currentIndex = 2;

  final _controller = PersistentTabController(initialIndex: 2);

  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isTempLoggedIn =
        (await SecurePreferencesUtil.getToken() ?? '').isNotEmpty;

    setState(() {
      _isLoggedIn = prefs.getBool(SecurePreferencesUtil.loggedInKey) ?? false;
      // _isTempLoggedIn =
      //     (prefs.getString(SecurePreferencesUtil.tokenKey) ?? '').isNotEmpty;
      _isTempLoggedIn = isTempLoggedIn;
    });
  }

  final String assetName = 'assets/applogo.svg';
  final String brandOutLine = 'assets/brandsOutLine.svg';
  final String brandFill = 'assets/brandsFill.svg';
  final String categoryFill = 'assets/categoryFill.svg';
  final String categoryOutline = 'assets/categoryOutline.svg';
  final String userOutline = 'assets/accountOutline.svg';
  final String accountFill = 'assets/accountOutline.svg';
  final String userFill = 'assets/userFill.svg';
  final String celebrityOutLine = 'assets/celebritiesOutline.svg';
  final String celebrityFill = 'assets/celebrityFill.svg';

  Future _onTabTapped(int index) async {
    await _loadLoginState();
    setState(() {
      _currentIndex = index;
      if (index == 0) {
        final typeId = widget.typeId ?? 2;
        Provider.of<VendorByTypeProvider>(context, listen: false)
            .fetchVendorTypeById(typeId, context);
        Provider.of<VendorByTypeProvider>(context, listen: false)
            .fetchVendors(typeId: typeId, context);
      }
    });
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex != 2) {
      setState(() {
        _currentIndex = 2;
      });
      return false;
    }
    return true;
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final homePageProvider =
          Provider.of<HomePageProvider>(context, listen: false);
      await homePageProvider.fetchHomePageData();
      // Trigger initial vendor fetch if needed
      //  function is used to fetch the data of typeId second
      final typeId = widget.typeId ?? 2;
      Provider.of<VendorByTypeProvider>(context, listen: false)
          .fetchVendorTypeById(typeId, context);
      Provider.of<VendorByTypeProvider>(context, listen: false)
          .fetchVendors(typeId: typeId, context);
    });
    super.initState();
  }

  Widget _getUserByCelebrities(String shortcode, data, int? typeId) {
    final int validTypeId = typeId ?? 2;
    switch (shortcode) {
      case 'shortcode-users-by-type':
        return UserByTypeItemsScreen(
          showText: false,
          showIcon: false,
          title: data?['attributes']['title'] ?? '',
          typeId: validTypeId,
        );
      default:
        return const HomeScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final homePageProvider = Provider.of<HomePageProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            _getUserByCelebrities(
              homePageProvider.extractedData.firstWhere(
                    (item) => item['shortcode'] == 'shortcode-users-by-type',
                    orElse: () => {'attributes': {}},
                  )['shortcode'] ??
                  '',
              homePageProvider.extractedData.firstWhere(
                (item) => item['shortcode'] == 'shortcode-users-by-type',
                orElse: () => {'attributes': {}},
              ),
              widget.typeId,
            ),
            FeaturedBrandsScreenViewAll(
              data: homePageProvider.featuredBrandsTitle ?? '',
              showIcons: false, // Set to false to hide icons
              showText: false,
            ),
            const HomeScreen(),
            FeaturedCategoriesItemsScreen(
              showIcon: false,
              showText: false,
              data: homePageProvider.featuredCategoryTitle != null
                  ? {
                      'attributes': {
                        'title': homePageProvider.featuredCategoryTitle
                      },
                    }
                  : {},
            ),
            if (_isLoggedIn || _isTempLoggedIn)
              const UserProfileLoginScreen()
            else
              const ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Your BottomNavigationBar
              BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
                selectedLabelStyle:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                selectedItemColor: Colors.red,
                unselectedItemColor: Colors.purpleAccent,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.white,
                enableFeedback: true,
                showSelectedLabels: true,
                items: [
                  BottomNavigationBarItem(
                    icon: Tooltip(
                      message: 'Celebrities',
                      child: SvgPicture.asset(
                        _currentIndex == 0 ? celebrityFill : celebrityOutLine,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Tooltip(
                      message: 'Brands',
                      child: SvgPicture.asset(
                        _currentIndex == 1 ? brandFill : brandOutLine,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Tooltip(
                        message: 'EVENTS', child: SvgPicture.asset(assetName)),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Tooltip(
                      message: 'Categories',
                      child: SvgPicture.asset(
                        _currentIndex == 3 ? categoryFill : categoryOutline,
                      ),
                    ),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Tooltip(
                      message: 'Account',
                      child: SvgPicture.asset(
                        _currentIndex == 4 ? userFill : userOutline,
                      ),
                    ),
                    label: '',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
