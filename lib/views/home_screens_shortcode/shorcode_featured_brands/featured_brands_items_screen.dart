import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../filters/product_filters_screen.dart';
import '../../filters/sort_an_filter_widget.dart';
import '../../product_detail_screens/product_detail_screen.dart';

class FeaturedBrandsItemsScreen extends StatefulWidget {
  const FeaturedBrandsItemsScreen({super.key, required this.slug});

  final String slug;

  @override
  State<FeaturedBrandsItemsScreen> createState() => _FeaturedBrandsItemsScreenState();
}

class _FeaturedBrandsItemsScreenState extends State<FeaturedBrandsItemsScreen> {
  String _currentTab = 'Products';
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

  ///  PACKAGES
  final int _currentPagePackages = 1;
  final bool _isFetchingMorePackages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTopBanner();
      fetchBrandProductItemsData();
      fetchWishListItems();
      _scrollController.addListener(_onScroll);
    });
  }

  ///  ++++++++++++++++++++++++++   TOP BANNER BRANDS  +++++++++++++++++++++++++++++
  Future<void> fetchTopBanner() async {
    final provider = Provider.of<FeaturedBrandsProvider>(context, listen: false);
    provider.fetchBrandData(widget.slug, context);
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  /// ------------   PRODUCTS SCROLLING FUNCTION   ------------
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
      fetchBrandProductItemsData();
    }
  }

  /// ------------   PRODUCTS DATA FUNCTION    ------------

  Future<void> fetchBrandProductItemsData() async {
    try {
      await Provider.of<FeaturedBrandsProvider>(context, listen: false).fetchBrandsProducts(
        context: context,
        slug: widget.slug,
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

  /// ------------   PRODUCTS SORTING  FUNCTION   ------------

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1;

        /// Reset to the first page
        Provider.of<FeaturedBrandsProvider>(context, listen: false).records.clear(); //
      });
    }
    fetchBrandProductItemsData();
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
              Consumer<FeaturedBrandsProvider>(
                builder: (context, brandProvider, child) {
                  if (brandProvider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  }
                  final brandData = brandProvider.brandModel;

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
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                              top: screenHeight * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///   -----   TOP BANNER IMAGE =================================================================
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: PaddedNetworkBanner(
                                        imageUrl: brandData?.coverImage ??
                                            brandData?.coverImageForMobile ??
                                            ApiConstants.placeholderImage,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        padding: EdgeInsets.zero,
                                      ),
                                    ),
                                    // Brand logo and name with better visibility
                                    Positioned(
                                      top: 16,
                                      left: 16,
                                      child: Column(
                                        children: [
                                          // Brand logo
                                          Container(
                                            width: 55,
                                            height: 55,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(
                                                color: Colors.grey.shade300,
                                                width: 1,
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: brandData?.image != null && brandData!.image.isNotEmpty
                                                  ? PaddedNetworkBanner(
                                                      imageUrl: brandData.image,
                                                      fit: BoxFit.cover,
                                                      width: 55,
                                                      height: 55,
                                                      padding: EdgeInsets.zero,
                                                    )
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[100],
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: const Center(
                                                        child: Icon(
                                                          Icons.business,
                                                          color: Colors.grey,
                                                          size: 20,
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          // Brand name
                                          Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 120,
                                              minWidth: 60,
                                            ),
                                            child: Text(
                                              brandData?.name ?? 'Brand Name',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                ///======  TAB BAR  =========================================

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
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                                // color: _currentTab == 'Products' ? Colors.grey[50] : Colors.transparent,
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
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(
                                                      AppStrings.packages.tr,
                                                      style: topTabBarStyle(context),
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
                                  _ProductsView(slug: widget.slug)
                                else
                                  _PackagesView(slug: widget.slug),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
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

  ///  ------------------------ BRANDS PRODUCTS VIEW --------------------------------
  Widget _ProductsView({required String slug}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<FeaturedBrandsProvider>(
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
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.0,
                  vertical: screenHeight * 0.01,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SortAndFilterWidget(
                      selectedSortBy: _selectedSortBy,
                      onSortChanged: (newSortBy) {
                        _onSortChanged(newSortBy);
                      },
                      onFilterPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => FilterBottomSheet(
                            filters: provider.productFilters,
                            selectedIds: selectedFilters,
                          ),
                        ).then((result) {
                          setState(() {
                            _currentPageProducts = 1;
                            selectedFilters = result;
                          });
                          fetchBrandProductItemsData();
                        });
                      },
                    ),
                    if (provider.records.isEmpty)
                      const ItemsEmptyView()
                    else
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemCount: provider.records.length + (_isFetchingMoreProducts ? 1 : 0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (_isFetchingMoreProducts && index == provider.records.length) {
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

                          final product = provider.records[index];

                          /// Calculate the percentage off
                          /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                          final dynamic frontSalePrice = product.prices?.frontSalePrice;
                          final dynamic price = product.prices?.price;
                          String offPercentage = '';

                          if (frontSalePrice != null && price != null && price > 0) {
                            // Calculate the discount percentage
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
                              itemsId: 0,
                              imageUrl: product.image,
                              frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                              name: product.name,
                              storeName: product.store?.name.toString(),
                              price: product.prices?.price.toString(),
                              optionalIcon: Icons.shopping_cart_checkout_rounded,
                              reviewsCount: product.review?.reviewsCount?.toInt(),
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

  ///  -------------------------  BRANDS PACKAGES VIEW --------------------------------

  Widget _PackagesView({required String slug}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Consumer<FeaturedBrandsProvider>(
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
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    top: screenHeight * 0.02,
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(color: AppColors.lightCoral),
                    height: 50,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(AppStrings.noRecordsFound.tr),
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSortBy,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _onSortChanged(newValue);
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
                      Column(
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
                                itemCount: provider.recordsPackages.length + (_isFetchingMorePackages ? 1 : 0),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (_isFetchingMorePackages && index == provider.recordsPackages.length) {
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

                                  final product = provider.recordsPackages[index];

                                  /// Calculate the percentage off
                                  /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                                  final dynamic frontSalePrice = product.prices?.frontSalePrice;
                                  final dynamic price = product.prices?.price;
                                  String offPercentage = '';

                                  if (frontSalePrice != null && price != null && price > 0) {
                                    // Calculate the discount percentage
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
                                            key: ValueKey(
                                              product.slug.toString(),
                                            ),
                                            slug: product.slug.toString(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: ProductCard(
                                      isOutOfStock: product.outOfStock ?? false,
                                      itemsId: 0,
                                      imageUrl: product.image,
                                      frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes,
                                      name: product.name,
                                      storeName: product.store?.name.toString(),
                                      price: product.prices?.frontSalePriceWithTaxes,
                                      reviewsCount: product.review!.reviewsCount!.toInt(),
                                      off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                      // Display the discount percentage
                                      priceWithTaxes:
                                          (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                                              ? product.prices!.priceWithTaxes
                                              : null,
                                      optionalIcon: Icons.shopping_cart_checkout_rounded,
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
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }
}
