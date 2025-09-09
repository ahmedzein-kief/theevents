import 'dart:async';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/app_colors.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/locale_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/shortcode_home_page_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../home_screens_shortcode/banner_ads_screen.dart';
import '../home_screens_shortcode/event_bazaar_screen.dart';
import '../home_screens_shortcode/featured_categories_screen.dart';
import '../home_screens_shortcode/shorcode_featured_brands/featured_brands_screen.dart';
import '../home_screens_shortcode/shortcode_fresh_picks/fresh_picks_screen.dart';
import '../home_screens_shortcode/shortcode_information_icons/information_icons.dart';
import '../home_screens_shortcode/shortcode_slider_with_two_ads/slider_two_tags_withad_screen.dart';
import '../home_screens_shortcode/shortcode_user_by_type/users_by_type_screen.dart';
import '../home_screens_shortcode/simple_slider_screen.dart';
import 'base_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreen> {
  String? userName;
  late bool _isLoggedIn = false;
  Locale? _currentLocale;
  bool _isRefreshing = false;
  Timer? _debounceTimer;

  final String assetName = 'assets/applogo.svg';
  late final TextEditingController _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    _currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        _loadLoginState(),
        _fetchAllHomePageData(),
      ]);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen for locale changes and refresh ALL data
    final newLocale = Provider.of<LocaleProvider>(context).locale;
    if (_currentLocale != newLocale) {
      _currentLocale = newLocale;
      _refetchAllDataForLocaleChange();
    }
  }

  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      });
    }
  }

  // NEW: Comprehensive data refresh for locale changes
  Future<void> _refetchAllDataForLocaleChange() async {
    if (_isRefreshing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (mounted) {
        setState(() => _isRefreshing = true);
      }

      try {
        await _fetchAllHomePageData();
      } catch (e) {
        debugPrint('Error refetching home page data: $e');
      } finally {
        if (mounted) {
          setState(() => _isRefreshing = false);
        }
      }
    });
  }

  // NEW: Fetch all home page related data
  Future<void> _fetchAllHomePageData() async {
    final provider = Provider.of<HomePageProvider>(context, listen: false);
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);

    await Future.wait([
      provider.fetchHomePageData(context, forceRefresh: true),
      // Add fresh picks refresh if method exists
      // freshPicksProvider.fetchFreshPicks(context),
    ]);
  }

  Future<void> _refreshHomePage() async {
    await _fetchAllHomePageData();
  }

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

  Widget _buildContent(HomePageProvider provider) {
    if (provider.isLoading && provider.extractedData.isEmpty) {
      return _buildShimmerLoading();
    } else if (provider.extractedData.isEmpty) {
      return Center(
        child: IconButton(
          icon: const Icon(
            Icons.refresh,
            size: 40,
            color: AppColors.peachyPink,
          ),
          onPressed: _refreshHomePage,
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: provider.extractedData.map((data) {
                  return _buildShortcodeWidget(data);
                }).toList(),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildShortcodeWidget(Map<String, dynamic> data) {
    switch (data['shortcode']) {
      case 'shortcode-simple-slider':
        return SimpleSlider(data: data);
      case 'shortcode-featured-categories':
        return FeaturedCategoriesScreen(data: data);
      case 'shortcode-information-icons':
        return ShortcodeInformationIconsScreen(data: data);
      case 'shortcode-events-bazaar':
        return EventBazaarScreen(data: data);
      case 'shortcode-vendors-by-type':
        return UsersByTypeScreen(data: data);
      case 'shortcode-ads':
        return BannerAdsScreen(data: data);
      case 'shortcode-fresh-picks':
        return FreshPicksScreen(data: data);
      case 'shortcode-users-by-type':
        return UsersByTypeScreen(data: data);
      case 'shortcode-featured-brands':
        return FeaturedBrandsScreen(data: data);
      case 'shortcode-two-tags-blocks-with-ad':
        return SliderTwoTagsWithAdScreen(data: data);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          height: 200,
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(12),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final mainProvider = Provider.of<HomePageProvider>(context);
    final freshListProvider = Provider.of<FreshPicksProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    final isLoading = mainProvider.isLoading ||
        wishlistProvider.isLoading ||
        freshListProvider.isLoading ||
        cartProvider.isLoading ||
        _isRefreshing;

    return BaseAppBar(
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      // Enable search bar integration
      showSearchBar: true,
      searchController: _searchController,
      searchHintText: AppStrings.searchEvents.tr,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: _refreshHomePage,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Stack(
              children: [
                // Remove the separate search bar since it's now integrated in the app bar
                Consumer<HomePageProvider>(
                  builder: (context, provider, _) {
                    return _buildContent(provider);
                  },
                ),
                if (isLoading) _buildLoadingOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
