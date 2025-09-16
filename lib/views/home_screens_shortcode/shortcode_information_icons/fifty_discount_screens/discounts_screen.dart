import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/widgets/discount_banner_section.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/widgets/discount_content_wrapper.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/widgets/discount_loading_overlay.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/widgets/discount_products_grid.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/fifty_discount_screens/widgets/discount_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/information_icons_provider/fifty_discount_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import 'discount_packages.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  String _currentTab = 'Products';
  int _currentPage = 1;
  String _selectedSortBy = 'default_sorting';
  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    await fetchHalfDiscountBanner();
    await fetchWishListItems();
    await fetchNewProductsItems();
    _scrollController.addListener(_onScroll);
  }

  /// BANNER OF FIFTY PERCENT DISCOUNTS
  Future<void> fetchHalfDiscountBanner() async {
    final provider = Provider.of<FiftyPercentDiscountProvider>(context, listen: false);
    provider.fetchBannerFiftyPercentDiscount(context);
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent) {
      _currentPage++;
      _isFetchingMore = true;
      fetchNewProductsItems();
    }
  }

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<FiftyPercentDiscountProvider>(context, listen: false).fetchProductsNew(
        context: context,
        perPage: 12,
        page: _currentPage,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
      );
      setState(() {
        _isFetchingMore = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  /// FOR TAKING THE ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS
  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  void _onTabChanged(String newTab) {
    setState(() {
      _currentTab = newTab;
    });
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<FiftyPercentDiscountProvider>(context, listen: false).products.clear();
    });
    fetchNewProductsItems();
  }

  void _onFiltersChanged(Map<String, List<int>> newFilters) {
    setState(() {
      _currentPage = 1;
      selectedFilters = newFilters;
    });
    fetchNewProductsItems();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final freshListProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<FiftyPercentDiscountProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  }

                  final data = provider.halfDiscountModels?.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomSearchBar(
                        hintText: AppStrings.searchDiscounts.tr,
                      ),
                      Expanded(
                        child: DiscountContentWrapper(
                          scrollController: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              DiscountBannerSection(
                                coverImage: data?.coverImage,
                                name: data?.name,
                              ),
                              DiscountTabBar(
                                currentTab: _currentTab,
                                onTabChanged: _onTabChanged,
                              ),
                              if (_currentTab == 'Products')
                                DiscountProductsGrid(
                                  selectedSortBy: _selectedSortBy,
                                  selectedFilters: selectedFilters,
                                  onSortChanged: _onSortChanged,
                                  onFiltersChanged: _onFiltersChanged,
                                  isFetchingMore: _isFetchingMore,
                                )
                              else
                                const DiscountPackages(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              DiscountLoadingOverlay(
                isVisible: wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
