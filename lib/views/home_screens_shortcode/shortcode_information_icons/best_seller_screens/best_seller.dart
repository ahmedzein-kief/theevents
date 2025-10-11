import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/best_seller_screens/sellers_packages.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../core/widgets/padded_network_banner.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/information_icons_provider/best_seller_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/product_filters_screen.dart';
import '../../../filters/sort_an_filter_widget.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class BestSellerScreen extends StatefulWidget {
  const BestSellerScreen({super.key});

  @override
  State<BestSellerScreen> createState() => _BestSellerScreenState();
}

class _BestSellerScreenState extends State<BestSellerScreen> {
  String currentTab = 'Products';

  bool _isFetchingMore = false; // default to false
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  String _selectedSortBy = 'default_sorting';
  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
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
      await Provider.of<BestSellerProvider>(context, listen: false).fetchProductsNew(
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1; // Reset to the first page
      Provider.of<BestSellerProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  ///   SELLER START HERE
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBannerBestSeller();
      fetchWishListItems();
      fetchNewProductsItems();
      _scrollController.addListener(_onScroll);
    });
  }

  Future<void> fetchBannerBestSeller() async {
    final provider = Provider.of<BestSellerProvider>(context, listen: false);
    provider.fetchBannerBestSeller(context);
  }

  ///  FOR HEART ICON STATE =================================================================

  Future<void> fetchWishListItems() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist();
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
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
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
              Consumer<BestSellerProvider>(
                builder: (ctx, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  } else if (provider.collection == null) {
                    return Center(
                      child: Text(
                        '${AppStrings.loading.tr}...',
                        style: const TextStyle(color: AppColors.peachyPink),
                      ),
                    );
                  } else {
                    final collection = provider.collection!.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CustomSearchBar(
                          hintText: AppStrings.searchEvents.tr,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.02,
                                vertical: screenHeight * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  ///  TOP BANNER  ----------------------------------------------------------------
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: PaddedNetworkBanner(
                                      imageUrl: collection.coverImage,
                                      height: 160,
                                      fit: BoxFit.cover,
                                      width: screenWidth,
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),

                                  ///  SELLER NAME --------------------------------
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          collection.name,
                                          style: boldHomeTextStyle(),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///   TAB BAR HERE --------------------------------
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
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
                                                    if (currentTab == 'Packages') const SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 1,
                                          width: double.infinity,
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// PRODUCTS AND PACKAGES --------------------------------
                                  if (currentTab == 'Products') _bestSellerProducts() else const BestSellersPackages(),
                                ],
                              ),
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

  Widget _bestSellerProducts() {
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);

    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return Center(
      child: Consumer<BestSellerProvider>(
        builder: (ctx, provider, child) {
          if (provider.isLoadingProducts) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 0.5,
              ),
            );
          } else {
            // final collection = provider.collection!.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
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
                        _currentPage = 1;
                        selectedFilters = result;
                      });
                      fetchNewProductsItems();
                    });
                  },
                ),
                if (provider.products.isEmpty)
                  const ItemsEmptyView()
                else
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: provider.products.length + (_isFetchingMore ? 1 : 0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (_isFetchingMore && index == provider.products.length) {
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

                      final product = provider.products[index];

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
                          frontSalePriceWithTaxes: product.review?.average ?? '0',
                          name: product.name,
                          storeName: product.store!.name.toString(),
                          price: product.prices!.price.toString(),
                          reviewsCount: product.review!.reviewsCount!.toInt(),
                          optionalIcon: Icons.shopping_cart,

                          onOptionalIconTap: () => _handleAddToCart(product.id),
                          isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                (wishListProduct) => wishListProduct.id == product.id,
                              ) ??
                              false,
                          onHeartTap: () async {
                            final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                  (wishListProduct) => wishListProduct.id == product.id,
                                ) ??
                                false;
                            if (isInWishlist) {
                              await wishlistProvider.deleteWishlistItem(
                                product.id ?? 0,
                                context,
                              );
                            } else {
                              await freshPicksProvider.handleHeartTap(
                                context,
                                product.id ?? 0,
                              );
                            }
                            await wishlistProvider.fetchWishlist();
                          },
                        ),
                      );
                    },
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}

//
