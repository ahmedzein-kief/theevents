// Updated BaseHomeScreen with proper language change handling
import 'dart:async';

import 'package:event_app/core/constants/app_assets.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/provider/shortcode_vendor_type_by_provider/vendor_type_by_provider.dart';
import 'package:event_app/views/base_screens/user_profile_login.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_by_types_items_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/locale_provider.dart';
import '../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/shortcode_home_page_provider.dart';
import '../../views/base_screens/home_screen.dart';
import '../../views/base_screens/profile_screen.dart';
import '../../views/home_screens_shortcode/shorcode_featured_brands/featured_brands_view_all.dart';
import '../../views/home_screens_shortcode/shortcode_featured_categories/featured_categories_items_screen.dart';
import '../constants/app_strings.dart';
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
  Locale? _currentLocale;
  bool _isRefetching = false;
  Timer? _debounceTimer;

  final _controller = PersistentTabController(initialIndex: 2);

  @override
  void initState() {
    super.initState();
    _currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newLocale = Provider.of<LocaleProvider>(context).locale;
    if (_currentLocale != newLocale && !_isRefetching) {
      _currentLocale = newLocale;
      _refetchAllDataForNewLocale();
    }
  }

  Future<void> _loadInitialData() async {
    await _loadLoginState();
    await _fetchAllInitialData();
  }

  // NEW: Comprehensive data refetch for locale changes
  Future<void> _refetchAllDataForNewLocale() async {
    if (_isRefetching) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      setState(() => _isRefetching = true);

      try {
        // Clear all cached data first
        final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
        homePageProvider.clearHomePageCache();

        // Refresh all providers that depend on locale
        await Future.wait([
          _fetchHomePageData(),
          _fetchCelebritiesData(),
          _fetchFreshPicksData(),
          _fetchFeaturedCategoriesData(),
          // Add any other provider refreshes here
        ]);
      } catch (e) {
        debugPrint('Error refetching data on locale change: $e');
      } finally {
        if (mounted) {
          setState(() => _isRefetching = false);
        }
      }
    });
  }

  // NEW: Fetch all initial data
  Future<void> _fetchAllInitialData() async {
    await Future.wait([
      _fetchHomePageData(),
      _fetchCelebritiesData(),
      _fetchFreshPicksData(),
      _fetchFeaturedCategoriesData(),
    ]);
  }

  Future<void> _fetchHomePageData() async {
    final homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    await homePageProvider.fetchHomePageData(context, forceRefresh: true);
  }

  // NEW: Separate method for celebrities data
  Future<void> _fetchCelebritiesData() async {
    final typeId = widget.typeId ?? 2;
    final vendorProvider = Provider.of<VendorByTypeProvider>(context, listen: false);
    await vendorProvider.fetchVendorTypeById(typeId, context);
    await vendorProvider.fetchVendors(typeId: typeId, context);
  }

  // NEW: Separate method for fresh picks data
  Future<void> _fetchFreshPicksData() async {
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
    // Add your fresh picks refresh logic here if it exists
    // await freshPicksProvider.fetchFreshPicks(context);
  }

  // NEW: Separate method for featured categories data
  Future<void> _fetchFeaturedCategoriesData() async {
    final featuredCategoriesProvider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
    await featuredCategoriesProvider.fetchPageData(context);
    await featuredCategoriesProvider.fetchCategories(
      perPage: 12,
      context,
      page: 1,
      sortBy: 'default_sorting',
    );
  }

  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final isTempLoggedIn = (await SecurePreferencesUtil.getToken() ?? '').isNotEmpty;

    if (mounted) {
      setState(() {
        _isLoggedIn = prefs.getBool(SecurePreferencesUtil.loggedInKey) ?? false;
        _isTempLoggedIn = isTempLoggedIn;
      });
    }
  }

  Future _onTabTapped(int index) async {
    await _loadLoginState();

    // Only fetch vendor data when actually navigating to that tab
    if (index == 0) {
      await _fetchCelebritiesData();
    }

    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  Widget _buildNavItem({
    required int index,
    required String icon,
    required String? label,
    required ThemeData theme,
    required bool hasColorFilter,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              icon,
              colorFilter: hasColorFilter
                  ? ColorFilter.mode(
                      isSelected ? theme.colorScheme.onPrimary : theme.unselectedWidgetColor,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? theme.colorScheme.onPrimary : theme.unselectedWidgetColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
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
    return PopScope(
      canPop: _currentIndex == 2,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && _currentIndex != 2) {
          setState(() {
            _currentIndex = 2;
          });
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: Consumer<HomePageProvider>(
              builder: (context, homePageProvider, child) {
                return IndexedStack(
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
                      showIcons: false,
                      showText: false,
                    ),
                    const HomeScreen(),
                    FeaturedCategoriesItemsScreen(
                      showIcon: false,
                      showText: false,
                      data: homePageProvider.featuredCategoryTitle != null
                          ? {
                              'attributes': {
                                'title': homePageProvider.featuredCategoryTitle,
                              },
                            }
                          : {},
                    ),
                    if (_isLoggedIn || _isTempLoggedIn) const UserProfileLoginScreen() else const ProfileScreen(),
                  ],
                );
              },
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
              child: Builder(
                builder: (context) {
                  final theme = Theme.of(context);
                  final isDarkMode = theme.brightness == Brightness.dark;

                  return Container(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
                    color: Theme.of(context).bottomAppBarTheme.color,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _buildNavItem(
                            index: 0,
                            icon: AppAssets.celebrities,
                            label: AppStrings.celebrities.tr,
                            theme: theme,
                            hasColorFilter: true,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            index: 1,
                            icon: AppAssets.brands,
                            label: AppStrings.brands.tr,
                            theme: theme,
                            hasColorFilter: true,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            index: 2,
                            icon: isDarkMode ? AppAssets.eventsDark : AppAssets.events,
                            label: null,
                            theme: theme,
                            hasColorFilter: false,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            index: 3,
                            icon: AppAssets.categories,
                            label: AppStrings.categories.tr,
                            theme: theme,
                            hasColorFilter: true,
                          ),
                        ),
                        Expanded(
                          child: _buildNavItem(
                            index: 4,
                            icon: AppAssets.account,
                            label: AppStrings.account.tr,
                            theme: theme,
                            hasColorFilter: true,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),

          // Semi-transparent loading overlay when refetching due to locale change
          if (_isRefetching)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
