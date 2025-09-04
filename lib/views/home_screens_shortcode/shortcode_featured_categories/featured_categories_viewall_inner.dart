import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/filters/product_filters_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../filters/sort_an_filter_widget.dart';
import '../../product_detail_screens/product_detail_screen.dart';

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
  bool _isFetchingMoreProducts = false; // Default to false
  int _currentPageProducts = 1;
  String _selectedSortBy = 'default_sorting';

  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  /// packages var
  int _currentPagePackages = 1;
  bool _isFetchingMorePackages = false; // default to false

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      fetchDataOfBanner();

      /// fetchNewPackagesItems();
      ///   CALL PRODUCTS SCROLLING  ---------------------------------------------------------------------
      fetchProductItemsData();
      _scrollController.addListener(_onScroll);

      /// packages
      fetchNewPackagesItems();
      _scrollController.addListener(_onScrollPackages);
    });
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  ///  FETCH TOP PAGE BANNER ---------------------------------------------------------------------
  Future<void> fetchDataOfBanner() async {
    fetchWishListItems();
    try {
      await Provider.of<FeaturedCategoriesDetailProvider>(
        context,
        listen: false,
      ).fetchFeaturedCategoryBanner(slug: widget.data.slug, context);
    } catch (error) {}
  }

  ///  PRODUCTS SORTING FUNCTION ----------------------------------------------------------------

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1; // Reset to the first page
        Provider.of<FeaturedCategoriesDetailProvider>(context, listen: false)
            .recordsProducts
            .clear(); // Clear existing products
      });
    }
    fetchProductItemsData();
  }

  ///   PRODUCTS DATA FETCH

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

  ///  PRODUCTS  SCROLLING FETCH  ----------------------------------------------------------------

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

  ///  SCROLLING FOR THE PACKAGES ----------------------------------------------------------------

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPagePackages++;
      _isFetchingMorePackages = true;
      fetchNewPackagesItems();
    }
  }

  ///  FETCH PACKAGES ITEMS ----------------------------------------------------------------

  Future<void> fetchNewPackagesItems() async {
    try {
      print(
        '=================:Inside fetch new package items:=================',
      );
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

  ///  SORTING FOR PACKAGES ----------------------------------------------------------------

  void _onSortChangedPackages(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPagePackages = 1; // Reset to the first page
      Provider.of<FeaturedCategoriesDetailProvider>(context, listen: false)
          .recordsProducts
          .clear(); // Clear existing products
    });
    fetchNewPackagesItems();
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
              Consumer<FeaturedCategoriesDetailProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  }
                  final bannerData = provider.productCategoryBanner;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomSearchBar(
                        hintText: AppStrings.searchEvents.tr,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///  -------------------------------------------------------- TOP BANNER HERE   --------------------------------------------------------

                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth * 0.02,
                                  right: screenWidth * 0.02,
                                  top: screenHeight * 0.02,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: bannerData?.data.coverImage ?? '',
                                  fit: BoxFit.fill,
                                  height: 100,
                                  errorWidget: (context, object, _) => Image.asset(
                                    'assets/placeholder.png', // Replace with your actual image path
                                    fit: BoxFit.cover, // Adjust fit if needed
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                  ),
                                  errorListener: (object) {
                                    Image.asset(
                                      'assets/placeholder.png', // Replace with your actual image path
                                      fit: BoxFit.cover, // Adjust fit if needed
                                      height: MediaQuery.sizeOf(context).height * 0.28,
                                      width: double.infinity,
                                    );
                                  },
                                  placeholder: (BuildContext context, String url) => Container(
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                    color: Colors.blueGrey[300], // Background color
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/placeholder.png', // Replace with your actual image path
                                          fit: BoxFit.cover, // Adjust fit if needed
                                          height: MediaQuery.sizeOf(context).height * 0.28,
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

                              ///  TAB BAR HERE   --------------------------------------------------------
                              Padding(
                                padding: EdgeInsets.only(
                                  left: screenWidth * 0.02,
                                  right: screenWidth * 0.02,
                                  top: screenHeight * 0.02,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentTab = 'Products';
                                            });
                                          },
                                          child: Container(
                                            // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: currentTab == 'Products' ? Colors.grey : Colors.transparent,
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
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text(
                                                    AppStrings.products.tr,
                                                    style: topTabBarStyle(context),
                                                  ),
                                                ),
                                                if (currentTab == 'Products') Container(),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              currentTab = 'Packages';
                                            });
                                          },
                                          child: Container(
                                            // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: currentTab == 'Packages' ? Colors.grey : Colors.transparent,
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
                                                  padding: const EdgeInsets.all(4),
                                                  child: Text(
                                                    AppStrings.packages.tr,
                                                    style: topTabBarStyle(context),
                                                  ),
                                                ),
                                                if (currentTab == 'Packages') const SizedBox.shrink(),
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

                              ///   ----------------  CALL PRODUCTS AND PACKAGES TAB HERE ---------------------------------------------------------

                              if (currentTab == 'Products')
                                _ProductsView(slug: widget.data.slug)
                              else
                                _PackagesView(slug: widget.data.slug),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
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

  ///   PRODUCTS TAB FUNCTION HERE --------------------------------------------------------

  Widget _ProductsView({required String slug}) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<FeaturedCategoriesDetailProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingProducts && _currentPageProducts == 1) {
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
                  top: screenHeight * 0.02,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SortAndFilterWidget(
                      selectedSortBy: _selectedSortBy,
                      onSortChanged: _onSortChanged,
                      onFilterPressed: () {
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
                      },
                    ),
                    if (provider.recordsProducts.isEmpty)
                      const ItemsEmptyView()
                    else
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: provider.recordsProducts.length + (_isFetchingMoreProducts ? 1 : 0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (_isFetchingMoreProducts && index == provider.recordsProducts.length) {
                            return const Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    // strokeWidth: 0.5,
                                  ),
                                ),
                              ),
                            );
                          }
                          final product = provider.recordsProducts[index];
                          final dynamic frontSalePrice = product.prices.frontSalePrice;
                          final dynamic price = product.prices.price;
                          String offPercentage = '';

                          if (frontSalePrice != null && price != null && price > 0) {
                            final dynamic discount = 100 - ((frontSalePrice / price) * 100);
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
                                    slug: product.slug.toString(),
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              isOutOfStock: product.outOfStock ?? false,
                              off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                              // Display the discount percentage
                              priceWithTaxes: (product.prices.frontSalePrice ?? 0) < (product.prices.price ?? 0)
                                  ? product.prices.priceWithTaxes
                                  : null,
                              itemsId: product.id,

                              imageUrl: product.image,
                              // priceWithTaxes: product.prices.priceWithTaxes,
                              // frontSalePriceWithTaxes: product.prices.frontSalePriceWithTaxes,
                              frontSalePriceWithTaxes: product.review.rating?.toString() ?? '0',
                              name: product.name,
                              storeName: product.store?.name.toString() ?? '',
                              price: product.prices.frontSalePrice.toString(),
                              reviewsCount: product.review.reviewsCount.toInt(),
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
              );
            }
          },
        ),
      ],
    );
  }

  ///   PACKAGES TAB FUNCTION HERE --------------------------------------------------------

  Widget _PackagesView({required String slug}) {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    return Center(
      child: Consumer<FeaturedCategoriesDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingPackages && _currentPagePackages == 1) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 0.5,
              ),
            );
          } else if (provider.recordsPackages.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: Container(
                width: screenWidth,
                height: 50,
                decoration: const BoxDecoration(color: AppColors.lightCoral),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(AppStrings.noRecordsFound.tr),
                ),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: provider.recordsPackages.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final product = provider.recordsPackages[index];

                              final dynamic frontSalePrice = product.prices.frontSalePrice;
                              final dynamic price = product.prices.price;
                              String offPercentage = '';

                              if (frontSalePrice != null && price != null && price > 0) {
                                final dynamic discount = 100 - ((frontSalePrice / price) * 100);
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
                                        slug: product.slug.toString(),
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCard(
                                  isOutOfStock: product.outOfStock ?? false,
                                  off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                  // Display the discount percentage
                                  priceWithTaxes: (product.prices.frontSalePrice ?? 0) < (product.prices.price ?? 0)
                                      ? product.prices.priceWithTaxes
                                      : null,
                                  itemsId: product.id,
                                  imageUrl: product.image,
                                  frontSalePriceWithTaxes: product.review.rating?.toString() ?? '0',
                                  name: product.name,
                                  storeName: product.store?.name.toString(),
                                  price: product.prices.price.toString(),
                                  optionalIcon: Icons.shopping_cart_checkout_rounded,
                                  reviewsCount: product.review.reviewsCount?.toInt(),
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
                                  isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                        (wishlistProduct) => wishlistProduct.id == product.id,
                                      ) ??
                                      false,
                                  // isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
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
                ),
              ],
            );
          }
        },
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
