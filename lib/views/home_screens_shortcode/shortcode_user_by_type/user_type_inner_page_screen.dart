import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/product_detail_screens/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_end_point.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_items_views/custom_packages_view.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/home_shortcode_provider/users_by_type_provider.dart';
import '../../../provider/product_package_provider/product_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../filters/product_filters_screen.dart';
import '../../filters/sort_an_filter_widget.dart';

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
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
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
                    final String? listingType = userData?.listingType;
                    // print("StoreId${userData!.storeId}");
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: screenWidth * 0.02,
                                    right: screenWidth * 0.02,
                                    top: screenHeight * 0.02,
                                    bottom: screenHeight * 0.02,
                                  ),
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: screenHeight * 0.25,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: Theme.of(context).colorScheme.primary,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topRight: Radius.circular(8),
                                                topLeft: Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl: userData?.coverImage ?? '',
                                                height: screenHeight * 0.17,
                                                fit: BoxFit.fill,
                                                errorListener: (object) {
                                                  Image.asset(
                                                    'assets/placeholder.png', // Replace with your actual image path
                                                    fit: BoxFit.cover, // Adjust fit if needed
                                                    height: MediaQuery.sizeOf(
                                                          context,
                                                        ).height *
                                                        0.28,
                                                    width: double.infinity,
                                                  );
                                                },
                                                errorWidget: (context, object, error) => Image.asset(
                                                  'assets/placeholder.png', // Replace with your actual image path
                                                  fit: BoxFit.cover, // Adjust fit if needed
                                                  height: MediaQuery.sizeOf(context).height * 0.28,
                                                  width: double.infinity,
                                                ),
                                                placeholder: (
                                                  BuildContext context,
                                                  String url,
                                                ) =>
                                                    Container(
                                                  height: MediaQuery.sizeOf(context).height * 0.28,
                                                  width: double.infinity,
                                                  color: Colors.blueGrey[300], // Background color
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Image.asset(
                                                        'assets/placeholder.png',
                                                        // Replace with your actual image path
                                                        fit: BoxFit.cover, // Adjust fit if needed
                                                        height: MediaQuery.sizeOf(
                                                              context,
                                                            ).height *
                                                            0.28,
                                                        width: double.infinity,
                                                      ),
                                                      const CupertinoActivityIndicator(
                                                        radius: 16, // Adjust size of the loader
                                                        animating: true,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        right: 10,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Container(
                                              height: screenHeight * 0.12,
                                              width: screenHeight * 0.12,
                                              // Make it square
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                // Background color
                                                borderRadius: BorderRadius.circular(12),
                                                // Rounded corners
                                                border: Border.all(
                                                  width: 2,
                                                  color: Colors.white,
                                                ), // Optional: border for better visibility
                                              ),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                // Same radius as the container
                                                child: CachedNetworkImage(
                                                  imageUrl: userData?.avatar ?? '',
                                                  height: screenHeight * 0.15,
                                                  width: screenHeight * 0.15,
                                                  // Ensure it fills the container
                                                  fit: BoxFit.cover,
                                                  // Cover to maintain aspect ratio
                                                  errorListener: (object) {
                                                    Image.asset(
                                                      'assets/placeholder.png', // Replace with your actual image path
                                                      fit: BoxFit.cover, // Adjust fit if needed
                                                      height: MediaQuery.sizeOf(
                                                            context,
                                                          ).height *
                                                          0.28,
                                                      width: double.infinity,
                                                    );
                                                  },
                                                  errorWidget: (
                                                    context,
                                                    object,
                                                    error,
                                                  ) =>
                                                      Image.asset(
                                                    'assets/placeholder.png', // Replace with your actual image path
                                                    fit: BoxFit.cover, // Adjust fit if needed
                                                    height: MediaQuery.sizeOf(
                                                          context,
                                                        ).height *
                                                        0.28,
                                                    width: double.infinity,
                                                  ),

                                                  placeholder: (
                                                    BuildContext context,
                                                    String url,
                                                  ) =>
                                                      Container(
                                                    height: MediaQuery.sizeOf(
                                                          context,
                                                        ).height *
                                                        0.28,
                                                    width: double.infinity,
                                                    color: Colors.blueGrey[300], // Background color
                                                    child: Stack(
                                                      alignment: Alignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/placeholder.png',
                                                          // Replace with your actual image path
                                                          fit: BoxFit.cover, // Adjust fit if needed
                                                          height: MediaQuery.sizeOf(
                                                                context,
                                                              ).height *
                                                              0.28,
                                                          width: double.infinity,
                                                        ),
                                                        const CupertinoActivityIndicator(
                                                          radius: 16, // Adjust size of the loader
                                                          animating: true,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 10,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          userData?.name ?? '',
                                                          softWrap: true,
                                                          style: holderNameTextStyle(
                                                            context,
                                                          ),
                                                        ),
                                                        Text(
                                                          userData?.type ?? '',
                                                          softWrap: true,
                                                          style: holderTypeTextStyle(
                                                            context,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    // Align(
                                                    //   alignment: Alignment.bottomCenter,
                                                    //   // Align container at the bottom center
                                                    //   child: Container(
                                                    //     decoration: BoxDecoration(
                                                    //       borderRadius: BorderRadius.circular(12),
                                                    //       boxShadow: [
                                                    //         BoxShadow(
                                                    //           color: Colors.grey.withOpacity(0.5),
                                                    //           blurRadius: 10,
                                                    //           offset: Offset(0, 2),
                                                    //         ),
                                                    //       ],
                                                    //     ),
                                                    //     child: Icon(
                                                    //       CupertinoIcons.heart_fill,
                                                    //       color: Colors.white,
                                                    //       shadows: [
                                                    //         BoxShadow(
                                                    //           color: Colors.black.withOpacity(0.2),
                                                    //           spreadRadius: 1,
                                                    //           blurRadius: 5,
                                                    //           offset: const Offset(0, 2),
                                                    //         )
                                                    //       ],
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (listingType == 'both')
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 25,
                                      left: 10,
                                      right: 10,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentTab = 'Products';
                                                });
                                              },
                                              child: Container(
                                                // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: _currentTab == 'Products' ? Colors.grey : Colors.transparent,
                                                  ),
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      10,
                                                    ),
                                                    topLeft: Radius.circular(
                                                      10,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(
                                                        4,
                                                      ),
                                                      child: Text(
                                                        AppStrings.products.tr,
                                                        style: topTabBarStyle(
                                                          context,
                                                        ),
                                                      ),
                                                    ),
                                                    if (_currentTab == 'Products') Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentTab = 'Packages';
                                                });
                                              },
                                              child: Container(
                                                // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: _currentTab == 'Packages' ? Colors.grey : Colors.transparent,
                                                  ),
                                                  borderRadius: const BorderRadius.only(
                                                    topRight: Radius.circular(10),
                                                    topLeft: Radius.circular(10),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(
                                                        4,
                                                      ),
                                                      child: Text(
                                                        AppStrings.packages.tr,
                                                        style: topTabBarStyle(
                                                          context,
                                                        ),
                                                      ),
                                                    ),
                                                    if (_currentTab == 'Packages') const SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Container(
                                              color: Colors.grey,
                                              height: 1,
                                              width: double.infinity,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                ///======  TAB PAGES VIEW =================================
                                if (_currentTab == 'Products')
                                  _ProductsView(
                                    storeId: userData?.storeId.toString() ?? '',
                                  )
                                else
                                  _PackagesView(
                                    storeId: userData?.storeId.toString() ?? '',
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
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
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

  Widget _ProductsView({required String storeId}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.isLoadingProducts && _currentPage == 1) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: SortAndFilterWidget(
                            selectedSortBy: _selectedSortBy,
                            onSortChanged: (newSortBy) {
                              _onSortChanged(newSortBy);
                            },
                            onFilterPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => FilterBottomSheet(
                                  filters: productProvider.productFilters,
                                  selectedIds: selectedFilters,
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    _currentPage = 1;
                                    selectedFilters = result; // Store the selected filter IDs
                                  });
                                  fetchUserByTypeProducts();
                                }
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (productProvider.products.isEmpty)
                          const ItemsEmptyView()
                        else
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: productProvider.products.length + (CommonVariables.isFetchingMore ? 1 : 0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (CommonVariables.isFetchingMore
                                  // && index == productProvider.products.length
                                  ) {
                                return const Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: SizedBox(
                                          height: 25,
                                          width: 25,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              final product = productProvider.products[index];

                              /// Calculate the percentage off
                              /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                              final double? frontSalePrice = product.prices?.frontSalePrice?.toDouble();
                              final double? price = product.prices?.price?.toDouble();
                              String offPercentage = '';

                              if (frontSalePrice != null && price != null && price > 0) {
                                // Calculate the discount percentage
                                final double discount = 100 - ((frontSalePrice / price) * 100);
                                // offPercentage = discount.toStringAsFixed(0);
                                if (discount > 0) {
                                  offPercentage = discount.toStringAsFixed(0);
                                }
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(
                                        key: ValueKey(product.slug.toString()),
                                        slug: product.slug.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  isOutOfStock: product.outOfStock ?? false,
                                  off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                  // Display the discount percentage
                                  priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                                      ? product.prices!.priceWithTaxes
                                      : null,
                                  itemsId: product.id,
                                  imageUrl: product.image,
                                  frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                                  name: product.name,
                                  storeName: product.store!.name.toString(),
                                  price: product.prices!.price.toString(),
                                  optionalIcon: Icons.shopping_cart,
                                  onOptionalIconTap: () async {
                                    final token = await SecurePreferencesUtil.getToken();
                                    if (token != null) {
                                      await cartProvider.addToCart(
                                        product.id,
                                        context,
                                        1,
                                      );
                                    }
                                  },
                                  reviewsCount: product.review!.reviewsCount!.toInt(),
                                  isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                        (wishlistProduct) => wishlistProduct.id == product.id,
                                      ) ??
                                      false,
                                  onHeartTap: () async {
                                    final token = await SecurePreferencesUtil.getToken();
                                    final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                          (wishlistProduct) => wishlistProduct.id == product.id,
                                        ) ??
                                        false;
                                    if (isInWishlist) {
                                      await wishlistProvider.deleteWishlistItem(
                                        product.id ?? 0,
                                        context,
                                        token ?? '',
                                      );
                                    } else {
                                      await freshPicksProvider.handleHeartTap(
                                        context,
                                        product.id ?? 0,
                                      );
                                    }
                                    await wishlistProvider.fetchWishlist(
                                      token ?? '',
                                      context,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _PackagesView({required String storeId}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    return Column(
      children: [
        Consumer<ProductProvider>(
          builder: (context, packageProductProvider, child) {
            if (packageProductProvider.isLoadingPackages && _currentPagePackages == 1) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              );
            } else if (packageProductProvider.records.isEmpty && !CommonVariables.isFetchingMore) {
              return Padding(
                padding: EdgeInsets.only(
                  left: screenWidth * 0.02,
                  right: screenWidth * 0.02,
                  top: screenHeight * 0.02,
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.lightCoral,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  height: 50,
                  child: const Align(
                    alignment: Alignment.center,
                    child: Text('No records found!'),
                  ),
                ),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSortBy,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _onSortChangedPackages(newValue);
                            }
                          },
                          // Your refactored list of DropdownMenuItems
                          items: [
                            DropdownMenuItem(
                              value: 'default_sorting',
                              child: Text(
                                AppStrings.sortByDefault.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'date_asc',
                              child: Text(
                                AppStrings.sortByOldest.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'date_desc',
                              child: Text(
                                AppStrings.sortByNewest.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'name_asc',
                              child: Text(
                                AppStrings.sortByNameAz.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'name_desc',
                              child: Text(
                                AppStrings.sortByNameZa.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'price_asc',
                              child: Text(
                                AppStrings.sortByPriceLowToHigh.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'price_desc',
                              child: Text(
                                AppStrings.sortByPriceHighToLow.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'rating_asc',
                              child: Text(
                                AppStrings.sortByRatingLowToHigh.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'rating_desc',
                              child: Text(
                                AppStrings.sortByRatingHighToLow.tr,
                                style: sortingStyle(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ListView.builder(
                          itemCount: packageProductProvider.records.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (_isFetchingMorePackages) {
                              return const Align(
                                alignment: Alignment.center,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            final product = packageProductProvider.records[index];

                            final List<Color> colors = [
                              AppColors.packagesBackground,
                              AppColors.packagesBackground.withOpacity(0.01),
                              AppColors.packagesBackgroundS,
                              AppColors.packagesBackgroundS.withOpacity(0.09),
                            ];

                            final freshPicksProvider = Provider.of<FreshPicksProvider>(
                              context,
                              listen: false,
                            );
                            final wishlistProvider = Provider.of<WishlistProvider>(
                              context,
                              listen: false,
                            );

                            return GestureDetector(
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      key: ValueKey(product.slug),
                                      slug: product.slug,
                                    ),
                                  ),
                                );
                              },
                              child: CustomPackagesView(
                                colorIndex: index % colors.length,
                                containerColors: colors,
                                imageUrl: product.image,
                                productName: product.name.toString(),
                                price: product.prices?.price.toString() ?? '',
                                addInCart: () async {
                                  final token = await SecurePreferencesUtil.getToken();
                                  if (token != null) {
                                    await cartProvider.addToCart(
                                      product.id,
                                      context,
                                      1,
                                    );
                                  }
                                },
                                isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                      (wishlistProduct) => wishlistProduct.id == product.id,
                                    ) ??
                                    false,
                                // isHeartObscure: true,
                                onHeartTap: () async {
                                  final token = await SecurePreferencesUtil.getToken();
                                  final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                        (wishlistProduct) => wishlistProduct.id == product.id,
                                      ) ??
                                      false;

                                  if (isInWishlist) {
                                    // Remove from wishlist
                                    await wishlistProvider.deleteWishlistItem(
                                      product.id,
                                      context,
                                      token ?? '',
                                    );
                                  } else {
                                    // Add to wishlist
                                    await freshPicksProvider.handleHeartTap(
                                      context,
                                      product.id,
                                    );
                                  }

                                  // Refresh wishlist after action
                                  await wishlistProvider.fetchWishlist(
                                    token ?? '',
                                    context,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ],
    );
  }
}
