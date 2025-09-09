// Fixed BaseHomeScreen with proper widget lifecycle management
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

import '../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../provider/locale_provider.dart';
import '../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import '../../provider/shortcode_home_page_provider.dart';
import '../../views/base_screens/home_screen.dart';
import '../../views/base_screens/profile_screen.dart';
import '../../views/home_screens_shortcode/shorcode_featured_brands/featured_brands_view_all.dart';
import '../../views/home_screens_shortcode/shortcode_featured_categories/featured_categories_items_screen.dart';
import '../constants/app_strings.dart';
import '../router/app_routes.dart';
import '../services/shared_preferences_helper.dart';
import '../utils/app_utils.dart';

class BaseHomeScreen extends StatefulWidget {
  const BaseHomeScreen({
    super.key,
    this.data,
    this.typeId,
    this.shouldNavigateToOrders = false,
  });

  final dynamic data;
  final int? typeId;
  final bool shouldNavigateToOrders;

  @override
  State<BaseHomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<BaseHomeScreen> {
  late bool _isLoggedIn = false;
  late bool _isTempLoggedIn = false;
  int _currentIndex = 2;
  Locale? _currentLocale;
  bool _isReFetching = false;
  Timer? _debounceTimer;

  // Store context reference for safe async operations
  BuildContext? _lastValidContext;

  final _controller = PersistentTabController(initialIndex: 2);

  @override
  void initState() {
    super.initState();
    _currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;
    _loadInitialData();

    // Handle navigation to orders page with delay
    if (widget.shouldNavigateToOrders) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          // Show success toast immediately after build
          AppUtils.showToast(
            AppStrings.orderPlacedSuccessfully.tr,
            isSuccess: true,
          );

          // Delay ONLY the navigation to orders page
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              debugPrint('Navigating to orders page after delay');
              Navigator.pushNamed(context, AppRoutes.orderPage);
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _lastValidContext = null; // Clear context reference
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Store valid context reference
    _lastValidContext = context;

    final newLocale = Provider.of<LocaleProvider>(context).locale;
    if (_currentLocale != newLocale && !_isReFetching) {
      _currentLocale = newLocale;
      _reFetchAllDataForNewLocale();
    }
  }

  Future<void> _loadInitialData() async {
    await _loadLoginState();
  }

  // Enhanced data reFetch with better error handling
  Future<void> _reFetchAllDataForNewLocale() async {
    if (_isReFetching || !mounted) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted) return; // Additional check before starting

      setState(() => _isReFetching = true);

      try {
        // Use stored context reference for provider access
        final contextToUse = _lastValidContext ?? context;
        if (!mounted) return;

        // Clear all cached data first
        final homePageProvider = Provider.of<HomePageProvider>(contextToUse, listen: false);
        homePageProvider.clearHomePageCache();

        // Refresh all providers that depend on locale with mounted checks
        await Future.wait([
          _fetchHomePageDataSafely(),
          _fetchCelebritiesDataSafely(),
          _fetchBrandsDataSafely(),
          _fetchFeaturedCategoriesDataSafely(),
        ]);
      } catch (e) {
        debugPrint('Error reFetching data on locale change: $e');
        // Only show error if widget is still mounted and context is available
        if (mounted && _lastValidContext != null) {
          // You can add your error handling here, but make sure to check mounted state
          // CustomSnackbar.showError(_lastValidContext!, 'Failed to refresh data');
        }
      } finally {
        if (mounted) {
          setState(() => _isReFetching = false);
        }
      }
    });
  }

  Future<void> _fetchHomePageDataSafely() async {
    if (!mounted) return;
    final contextToUse = _lastValidContext ?? context;
    final homePageProvider = Provider.of<HomePageProvider>(contextToUse, listen: false);
    await homePageProvider.fetchHomePageData(contextToUse, forceRefresh: true);
  }

  Future<void> _fetchCelebritiesDataSafely() async {
    if (!mounted) return;
    final contextToUse = _lastValidContext ?? context;

    final typeId = widget.typeId ?? 2;
    final vendorProvider = Provider.of<VendorByTypeProvider>(contextToUse, listen: false);
    await vendorProvider.fetchVendorTypeById(typeId, contextToUse);

    if (!mounted) return;
    await vendorProvider.fetchVendors(typeId: typeId, contextToUse);
  }

  Future<void> _fetchFeaturedCategoriesDataSafely() async {
    if (!mounted) return;
    final contextToUse = _lastValidContext ?? context;

    final featuredCategoriesProvider = Provider.of<FeaturedCategoriesProvider>(contextToUse, listen: false);
    await featuredCategoriesProvider.fetchPageData(contextToUse);

    if (!mounted) return;
    await featuredCategoriesProvider.fetchCategories(
      perPage: 12,
      contextToUse,
      page: 1,
      sortBy: 'default_sorting',
    );
  }

  Future<void> _fetchBrandsDataSafely() async {
    if (!mounted) return;
    final contextToUse = _lastValidContext ?? context;

    final provider = Provider.of<FeaturedBrandsProvider>(contextToUse, listen: false);
    await provider.fetchFeaturedBrands(contextToUse);

    if (!mounted) return;
    await Provider.of<FeaturedBrandsProvider>(contextToUse, listen: false).fetchBrandsItems(
      perPage: 12,
      contextToUse,
      page: 1,
      sortBy: 'default_sorting',
    );
  }

  // Legacy methods kept for backward compatibility but made safe
  Future<void> _fetchHomePageData() async {
    await _fetchHomePageDataSafely();
  }

  Future<void> _fetchCelebritiesData() async {
    await _fetchCelebritiesDataSafely();
  }

  Future<void> _fetchFeaturedCategoriesData() async {
    await _fetchFeaturedCategoriesDataSafely();
  }

  Future<void> _fetchBrandsData() async {
    await _fetchBrandsDataSafely();
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
    if (!mounted) return; // Safety check

    await _loadLoginState();

    // Only fetch vendor data when actually navigating to that tab
    if (index == 0) {
      await _fetchCelebritiesDataSafely();
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
          if (_isReFetching)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
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
