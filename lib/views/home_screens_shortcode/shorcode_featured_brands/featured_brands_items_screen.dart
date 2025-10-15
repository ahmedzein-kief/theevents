import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/core/widgets/loading_indicator.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/utils/app_utils.dart';
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
      _fetchTopBanner();
      _fetchBrandProductItemsData();
      _fetchWishListItems();
      _scrollController.addListener(_onScroll);
    });
  }

  ///  ++++++++++++++++++++++++++   TOP BANNER BRANDS  +++++++++++++++++++++++++++++
  Future<void> _fetchTopBanner() async {
    if (!mounted) return;
    final provider = context.read<FeaturedBrandsProvider>();
    provider.fetchBrandData(widget.slug, context);
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------
  Future<void> _fetchWishListItems() async {
    if (!mounted) return;
    final provider = context.read<WishlistProvider>();
    provider.fetchWishlist();
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
      _fetchBrandProductItemsData();
    }
  }

  /// ------------   PRODUCTS DATA FUNCTION    ------------
  Future<void> _fetchBrandProductItemsData() async {
    try {
      await context.read<FeaturedBrandsProvider>().fetchBrandsProducts(
            context: context,
            slug: widget.slug,
            perPage: 12,
            page: _currentPageProducts,
            sortBy: _selectedSortBy,
            filters: selectedFilters,
          );

      setState(() {
        _isFetchingMoreProducts = false;
      });
    } catch (error) {
      setState(() {
        _isFetchingMoreProducts = false;
      });
    }
  }

  /// ------------   PRODUCTS SORTING  FUNCTION   ------------
  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1;

        /// Reset to the first page
        context.read<FeaturedBrandsProvider>().records.clear();
      });
    }
    _fetchBrandProductItemsData();
  }

  /// Handle add to cart with proper error handling
  Future<void> _handleAddToCart(int productId) async {
    final result = await context.read<CartProvider>().addToCart(productId, 1);

    if (result.success) {
      AppUtils.showToast(result.message, isSuccess: true);
    } else {
      AppUtils.showToast(result.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

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
                    return const LoadingIndicator();
                  }
                  final brandData = brandProvider.brandModel;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomSearchBar(hintText: AppStrings.searchEvents.tr),
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
                                ///   -----   TOP BANNER IMAGE
                                _buildTopBanner(brandData),

                                ///======  TAB BAR
                                _buildTabBar(screenWidth, screenHeight),

                                ///======  TAB PAGES VIEW
                                if (_currentTab == 'Products')
                                  _productsView(slug: widget.slug)
                                else
                                  _packagesView(slug: widget.slug),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              _buildLoadingOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBanner(brandData) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: PaddedNetworkBanner(
              imageUrl: brandData?.coverImageForMobile ?? brandData?.coverImage ?? ApiConstants.placeholderImage,
              fit: BoxFit.cover,
              width: double.infinity,
              padding: EdgeInsets.zero,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
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
                              width: 50,
                              height: 50,
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
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 120,
                      minWidth: 60,
                    ),
                    child: Text(
                      brandData?.name ?? 'Brand Name',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
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
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(double screenWidth, double screenHeight) {
    return Padding(
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
              _buildTabButton('Products', AppStrings.products.tr),
              _buildTabButton('Packages', AppStrings.packages.tr),
            ],
          ),
          Container(
            color: Colors.grey,
            height: 1,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String tabName, String label) {
    final isSelected = _currentTab == tabName;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentTab = tabName;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.grey : Colors.transparent,
          ),
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10),
            topLeft: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Text(
            label,
            style: topTabBarStyle(context),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Consumer3<WishlistProvider, FreshPicksProvider, CartProvider>(
      builder: (context, wishlistProvider, freshPicksProvider, cartProvider, child) {
        if (wishlistProvider.isLoading || freshPicksProvider.isLoading || cartProvider.isLoading) {
          return Container(
            color: Colors.black.withAlpha((0.5 * 255).toInt()),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  ///  ------------------------ BRANDS PRODUCTS VIEW --------------------------------
  Widget _productsView({required String slug}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

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
            }

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
                    onSortChanged: _onSortChanged,
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
                        _fetchBrandProductItemsData();
                      });
                    },
                  ),
                  if (provider.records.isEmpty) const ItemsEmptyView() else _buildProductGrid(provider),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProductGrid(FeaturedBrandsProvider provider) {
    return GridView.builder(
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
          return const Center(
            child: SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(color: Colors.black),
            ),
          );
        }

        final product = provider.records[index];
        final offPercentage = _calculateDiscount(
          product.prices?.frontSalePrice,
          product.prices?.price,
        );

        return Consumer2<WishlistProvider, FreshPicksProvider>(
          builder: (context, wishlistProvider, freshPicksProvider, child) {
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
                onOptionalIconTap: () => _handleAddToCart(product.id),
                isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                      (wishlistProduct) => wishlistProduct.id == product.id,
                    ) ??
                    false,
                onHeartTap: () => _handleWishlistToggle(
                  product.id ?? 0,
                  wishlistProvider,
                  freshPicksProvider,
                ),
              ),
            );
          },
        );
      },
    );
  }

  ///  -------------------------  BRANDS PACKAGES VIEW --------------------------------
  Widget _packagesView({required String slug}) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

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
              }

              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildSortDropdown(),
                    _buildPackagesGrid(provider),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortDropdown() {
    return DropdownButtonHideUnderline(
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
            child: Text(AppStrings.sortByDefault.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'date_asc',
            child: Text(AppStrings.sortByOldest.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'date_desc',
            child: Text(AppStrings.sortByNewest.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'name_asc',
            child: Text(AppStrings.sortByNameAz.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'name_desc',
            child: Text(AppStrings.sortByNameZa.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'price_asc',
            child: Text(AppStrings.sortByPriceLowToHigh.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'price_desc',
            child: Text(AppStrings.sortByPriceHighToLow.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'rating_asc',
            child: Text(AppStrings.sortByRatingLowToHigh.tr, style: sortingStyle(context)),
          ),
          DropdownMenuItem(
            value: 'rating_desc',
            child: Text(AppStrings.sortByRatingHighToLow.tr, style: sortingStyle(context)),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesGrid(FeaturedBrandsProvider provider) {
    return GridView.builder(
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
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        final product = provider.recordsPackages[index];
        final offPercentage = _calculateDiscount(
          product.prices?.frontSalePrice,
          product.prices?.price,
        );

        return Consumer2<WishlistProvider, FreshPicksProvider>(
          builder: (context, wishlistProvider, freshPicksProvider, child) {
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
                itemsId: 0,
                imageUrl: product.image,
                frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes,
                name: product.name,
                storeName: product.store?.name.toString(),
                price: product.prices?.frontSalePriceWithTaxes,
                reviewsCount: product.review?.reviewsCount?.toInt() ?? 0,
                off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                    ? product.prices!.priceWithTaxes
                    : null,
                optionalIcon: Icons.shopping_cart_checkout_rounded,
                onOptionalIconTap: () => _handleAddToCart(product.id),
                isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                      (wishlistProduct) => wishlistProduct.id == product.id,
                    ) ??
                    false,
                onHeartTap: () => _handleWishlistToggle(
                  product.id ?? 0,
                  wishlistProvider,
                  freshPicksProvider,
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// Calculate discount percentage
  String _calculateDiscount(frontSalePrice, price) {
    if (frontSalePrice != null && price != null && price > 0) {
      final dynamic discount = 100 - ((frontSalePrice / price) * 100);
      if (discount > 0) {
        return discount.toStringAsFixed(0);
      }
    }
    return '';
  }

  /// Handle wishlist toggle
  Future<void> _handleWishlistToggle(
    int productId,
    WishlistProvider wishlistProvider,
    FreshPicksProvider freshPicksProvider,
  ) async {
    final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
          (wishlistProduct) => wishlistProduct.id == productId,
        ) ??
        false;

    if (isInWishlist) {
      await wishlistProvider.deleteWishlistItem(productId, context);
    } else {
      await freshPicksProvider.handleHeartTap(context, productId);
    }

    await wishlistProvider.fetchWishlist();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}
