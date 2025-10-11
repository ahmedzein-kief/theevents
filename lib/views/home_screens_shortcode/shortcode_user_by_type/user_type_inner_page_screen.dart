import 'dart:async';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/widgets/user_header_section.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_end_point.dart';
import '../../../core/styles/app_colors.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/home_shortcode_provider/users_by_type_provider.dart';
import '../../../provider/product_package_provider/product_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import 'widgets/packages_view.dart';
import 'widgets/products_view.dart';
import 'widgets/tab_navigation_section.dart';

class UserTypeInnerPageScreen extends StatefulWidget {
  const UserTypeInnerPageScreen({
    super.key,
    this.typeId,
    this.title,
    this.storeId,
    this.id,
  });

  final dynamic typeId;
  final dynamic title;
  final dynamic id;
  final dynamic storeId;

  @override
  State<UserTypeInnerPageScreen> createState() => _UserTypeInnerPageScreenState();
}

class _UserTypeInnerPageScreenState extends State<UserTypeInnerPageScreen> {
  TextEditingController controller = TextEditingController();
  String _currentTab = 'Products';

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;

  int _currentPagePackages = 1;
  bool _isFetchingMorePackages = false;
  String _selectedSortBy = 'default_sorting';

  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDataVendor();
    });
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist();
  }

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _currentPagePackages++;
        _isFetchingMorePackages = false;
      });
      fetchUserByTypeProducts();
    }
  }

  Future<void> fetchUserByTypePackages() async {
    try {
      final userTypeProvider = Provider.of<UsersByTypeProvider>(context, listen: false);
      final userData = userTypeProvider.userData;

      await Provider.of<ProductProvider>(context, listen: false).fetchPackages(
        storeId: userData!.storeId,
        context,
        perPage: 12,
        page: _currentPage,
        sortBy: CommonVariables.selectedSortBy,
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
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPagePackages = 1;
        Provider.of<ProductProvider>(context, listen: false).records.clear();
      });
    }
    // Clear existing products
    fetchUserByTypePackages();
  }

  void _onScroll() {
    if (CommonVariables.isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      CommonVariables.currentPage++;
      CommonVariables.isFetchingMore = true;
      fetchUserByTypeProducts();
    }
  }

  Future<void> fetchUserByTypeProducts() async {
    try {
      setState(() {
        CommonVariables.isFetchingMore = true;
      });
      final userTypeProvider = Provider.of<UsersByTypeProvider>(context, listen: false);
      final userData = userTypeProvider.userData;

      await Provider.of<ProductProvider>(context, listen: false).fetchProducts(
        storeId: userData!.storeId,
        context,
        perPage: 12,
        page: _currentPage,
        sortBy: CommonVariables.selectedSortBy,
        filters: selectedFilters,
      );
      setState(() {
        CommonVariables.isFetchingMore = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          CommonVariables.isFetchingMore = false;
        });
      }
    }
  }

  void _onSortChanged(String newValue) {
    CommonVariables.selectedSortBy = newValue;
    CommonVariables.currentPage = 1;
    Provider.of<ProductProvider>(context, listen: false).products.clear(); // Clear existing products
    fetchUserByTypeProducts();
  }

  ///  TODO : LIST TYPE
  Future<void> fetchDataVendor() async {
    final userTypeProvider = Provider.of<UsersByTypeProvider>(context, listen: false);
    await userTypeProvider.fetchUserData(context, widget.id);

    /// -----++++++  FETCH THE DATA OF THE PRODUCTS  --------------------+++++++++++++
    fetchUserByTypeProducts();
    fetchWishListItems();
    _scrollController.addListener(_onScroll);

    /// -----++++++  FETCH THE DATA OF THE PACKAGES  --------------------+++++++++++++
    fetchUserByTypePackages();
    _scrollController.addListener(_onScrollPackages);

    ///  Set the current tab based on the fetched user data
    final userData = userTypeProvider.userData;
    if (userData != null) {
      setState(() {
        if (userData.listingType == 'products') {
          _currentTab = 'Products';
        } else if (userData.listingType == 'packages') {
          _currentTab = 'Packages';
        } else {
          _currentTab = 'Products';
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
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
              Consumer<UsersByTypeProvider>(
                builder: (context, userTypeProvider, child) {
                  if (userTypeProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  } else {
                    final userData = userTypeProvider.userData;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                // User Header Section
                                UserHeaderSection(
                                  userData: userData,
                                  screenHeight: screenHeight,
                                  screenWidth: screenWidth,
                                ),

                                // Tab Navigation (only show if both types)
                                if (userData?.listingType == 'both')
                                  TabNavigationSection(
                                    currentTab: _currentTab,
                                    onTabChanged: (tab) {
                                      setState(() {
                                        _currentTab = tab;
                                      });
                                    },
                                  ),

                                // Content View based on current tab
                                if (_currentTab == 'Products')
                                  ProductsView(
                                    storeId: userData?.storeId.toString() ?? '',
                                    currentPage: _currentPage,
                                    selectedSortBy: _selectedSortBy,
                                    selectedFilters: selectedFilters,
                                    onSortChanged: _onSortChanged,
                                    onFiltersChanged: (filters) {
                                      setState(() {
                                        _currentPage = 1;
                                        selectedFilters = filters;
                                      });
                                      fetchUserByTypeProducts();
                                    },
                                  )
                                else
                                  PackagesView(
                                    storeId: userData?.storeId.toString() ?? '',
                                    currentPagePackages: _currentPagePackages,
                                    selectedSortBy: _selectedSortBy,
                                    isFetchingMorePackages: _isFetchingMorePackages,
                                    onSortChanged: _onSortChangedPackages,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              if (wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading)
                Container(
                  color: Colors.black.withAlpha((0.5 * 255).toInt()), // Semi-transparent background
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
