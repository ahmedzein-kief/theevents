import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/filters/product_filters_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import 'widgets/featured_content_wrapper.dart';
import 'widgets/featured_loading_overlay.dart';
import 'widgets/featured_packages_grid.dart';
import 'widgets/featured_products_grid.dart';

class FeaturedCategoriesViewAllInner extends StatefulWidget {
  const FeaturedCategoriesViewAllInner({
    super.key,
    required this.data,
    this.isCategory = false,
  });

  final dynamic data;
  final bool isCategory;

  @override
  State<FeaturedCategoriesViewAllInner> createState() => _FeaturedCategoriesViewallInnerState();
}

class _FeaturedCategoriesViewallInnerState extends State<FeaturedCategoriesViewAllInner> {
  String currentTab = 'Products';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMoreProducts = false;
  int _currentPageProducts = 1;
  String _selectedSortBy = 'default_sorting';

  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  int _currentPagePackages = 1;
  bool _isFetchingMorePackages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchDataOfBanner();
      fetchProductItemsData();
      fetchNewPackagesItems();
      _scrollController.addListener(_onScroll);
      _scrollController.addListener(_onScrollPackages);
    });
  }

  Future<void> fetchWishListItems() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist();
  }

  Future<void> fetchDataOfBanner() async {
    fetchWishListItems();
    try {
      await Provider.of<FeaturedCategoriesDetailProvider>(
        context,
        listen: false,
      ).fetchFeaturedCategoryBanner(slug: widget.data.slug, context);
    } catch (error) {
      log('Error fetching banner data: $error');
    }
  }

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1;
        Provider.of<FeaturedCategoriesDetailProvider>(context, listen: false).recordsProducts.clear();
      });
    }
    fetchProductItemsData();
  }

  Future<void> fetchProductItemsData() async {
    try {
      await Provider.of<FeaturedCategoriesDetailProvider>(
        context,
        listen: false,
      ).fetchCategoryProducts(
        slug: widget.data.slug,
        context,
        perPage: 12,
        page: _currentPageProducts,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
      );
      if (mounted) {
        setState(() {
          _isFetchingMoreProducts = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMoreProducts = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (mounted) {
        setState(() {
          _currentPageProducts++;
          _isFetchingMoreProducts = true;
        });
      }
      fetchProductItemsData();
    }
  }

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPagePackages++;
      _isFetchingMorePackages = true;
      fetchNewPackagesItems();
    }
  }

  Future<void> fetchNewPackagesItems() async {
    try {
      setState(() {
        _isFetchingMorePackages = true;
      });
      await Provider.of<FeaturedCategoriesDetailProvider>(
        context,
        listen: false,
      ).fetchCategoryPackages(
        slug: widget.data.slug,
        context,
        perPage: 12,
        page: _currentPagePackages,
        sortBy: _selectedSortBy,
      );
      setState(() {
        _isFetchingMorePackages = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMorePackages = false;
        });
      }
    }
  }

  void _onSortChangedPackages(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPagePackages = 1;
      Provider.of<FeaturedCategoriesDetailProvider>(context, listen: false).recordsProducts.clear();
    });
    fetchNewPackagesItems();
  }

  void _onTabChanged(String tab) {
    setState(() {
      currentTab = tab;
    });
  }

  void _onFilterPressed() {
    final provider = Provider.of<FeaturedCategoriesDetailProvider>(context, listen: false);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FilterBottomSheet(
        filters: provider.productFilters,
        isCategory: widget.isCategory,
        selectedIds: selectedFilters,
      ),
    ).then((result) {
      setState(() {
        _currentPageProducts = 1;
        selectedFilters = result ?? {};
      });
      fetchProductItemsData();
    });
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
              FeaturedContentWrapper(
                scrollController: _scrollController,
                currentTab: currentTab,
                onTabChanged: _onTabChanged,
                productsView: FeaturedProductsGrid(
                  slug: widget.data.slug,
                  selectedSortBy: _selectedSortBy,
                  onSortChanged: _onSortChanged,
                  onFilterPressed: _onFilterPressed,
                  currentPage: _currentPageProducts,
                  isFetchingMore: _isFetchingMoreProducts,
                ),
                packagesView: FeaturedPackagesGrid(
                  slug: widget.data.slug,
                  selectedSortBy: _selectedSortBy,
                  onSortChanged: _onSortChangedPackages,
                  currentPage: _currentPagePackages,
                  isFetchingMore: _isFetchingMorePackages,
                ),
              ),
              FeaturedLoadingOverlay(
                isLoading: wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.removeListener(_onScrollPackages);
    _scrollController.dispose();
    super.dispose();
  }
}
