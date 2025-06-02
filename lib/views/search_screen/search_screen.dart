import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/filters/product_sorting.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/search_bar_provider/search_bar_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../core/styles/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_items_views/product_card.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../base_screens/base_app_bar.dart';
import '../filters/product_filters_screen.dart';
import '../product_detail_screens/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final dynamic query;

  const SearchScreen({super.key, this.query});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNewProductsItems();
      fetchWishListItems();
      _scrollController.addListener(_onScroll);
    });
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      setState(() {
        _currentPage++;
        _isFetchingMore = true;
      });
      fetchNewProductsItems();
    }
  }

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<SearchBarProvider>(context, listen: false).fetchProductsNew(
        query: widget.query,
        context,
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

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<SearchBarProvider>(context, listen: false).products.clear();
    });
    fetchNewProductsItems();
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  @override
  Widget build(BuildContext context) {
    final searchProvider = Provider.of<SearchBarProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final freshListProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: searchProvider.isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5))
            : SafeArea(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 1, left: 10, right: 10),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.start, children: [
                          SortAndFilterDropdown(
                            selectedSortBy: _selectedSortBy,
                            onSortChanged: (newSortBy) {
                              _onSortChanged(newSortBy);
                            },
                            onFilterPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => FilterBottomSheet(
                                  filters: searchProvider.productFilters,
                                  selectedIds: selectedFilters, // Pass previously selected IDs
                                ),
                              ).then((result) {
                                if (result != null) {
                                  setState(() {
                                    _currentPage = 1;
                                    selectedFilters = result; // Store the selected filter IDs
                                  });
                                  fetchNewProductsItems();
                                  // You can use selectedFilters to fetch products or apply other logic
                                }
                              });
                            },
                          ),
                          SizedBox(
                            child: searchProvider.products.isEmpty
                                ? ItemsEmptyView()
                                : GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                                    itemCount: searchProvider.products.length + (_isFetchingMore ? 1 : 0),
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      if (_isFetchingMore && index == searchProvider.products.length) {
                                        return Align(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Loading...',
                                                style: TextStyle(color: AppColors.peachyPink),
                                              ),
                                              Center(
                                                child: CircularProgressIndicator(
                                                  color: Colors.black,
                                                  // strokeWidth: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }

                                      final product = searchProvider.products[index];

                                      final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                                      final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                      final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);

                                      /// Calculate the percentage off
                                      /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                                      double? frontSalePrice = product.prices?.frontSalePrice?.toDouble();
                                      double? price = product.prices?.price?.toDouble();
                                      String offPercentage = '';

                                      if (frontSalePrice != null && price != null && price > 0) {
                                        // Calculate the discount percentage
                                        double discount = 100 - ((frontSalePrice / price) * 100);
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
                                          itemsId: product.id,
                                          imageUrl: product.image,
                                          frontSalePriceWithTaxes: product.review?.average ?? '0',
                                          name: product.name,
                                          storeName: product.store!.name.toString(),
                                          price: product.prices!.price.toString(),
                                          reviewsCount: product.review!.reviewsCount!.toInt(),
                                          off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                          // Display the discount percentage
                                          priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0) ? product.prices!.priceWithTaxes : null,
                                          optionalIcon: Icons.shopping_cart,
                                          onOptionalIconTap: () async {
                                            final token = await SecurePreferencesUtil.getToken();
                                            if (token != null) {
                                              await cartProvider.addToCart(product.id, context, 1);
                                            }
                                          },
                                          isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                          onHeartTap: () async {
                                            final token = await SecurePreferencesUtil.getToken();
                                            bool isInWishlist = wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false;
                                            if (isInWishlist) {
                                              await wishlistProvider.deleteWishlistItem(product.id ?? 0, context, token ?? '');
                                            } else {
                                              await freshPicksProvider.handleHeartTap(context, product.id ?? 0);
                                            }
                                            await wishlistProvider.fetchWishlist(token ?? '', context);
                                          },
                                        ),
                                      );
                                    }),
                          )
                        ]),
                      ),
                    ),
                    if (wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading)
                      Container(
                        color: Colors.black.withOpacity(0.5), // Semi-transparent background
                        child: Center(
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
