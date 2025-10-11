import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../core/widgets/items_empty_view.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/ecom_tags_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/product_filters_screen.dart';
import '../../../filters/sort_an_filter_widget.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class EComProductsTabWidget extends StatefulWidget {
  const EComProductsTabWidget({
    super.key,
    required this.slug,
  });

  final String slug;

  @override
  State<EComProductsTabWidget> createState() => _EComProductsTabWidgetState();
}

class _EComProductsTabWidgetState extends State<EComProductsTabWidget> {
  final ScrollController _scrollController = ScrollController();
  int _currentPageProduct = 1;
  bool _isFetchingMoreProducts = false;
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
      _fetchNewProductsItems();
      _scrollController.addListener(_onScrollProduct);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollProduct);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMoreProducts = true;
      });
      await Provider.of<EComTagProvider>(context, listen: false).fetchEComProductsNew(
        slug: widget.slug,
        context,
        perPage: 12,
        page: _currentPageProduct,
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

  void _onScrollProduct() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPageProduct++;
      _isFetchingMoreProducts = true;
      _fetchNewProductsItems();
    }
  }

  void _onSortChangedProduct(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPageProduct = 1;
      Provider.of<EComTagProvider>(context, listen: false).products.clear();
    });
    _fetchNewProductsItems();
  }

  void _onFiltersApplied(Map<String, List<int>> filters) {
    setState(() {
      _currentPageProduct = 1;
      selectedFilters = filters;
    });
    _fetchNewProductsItems();
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
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);

    return Consumer<EComTagProvider>(
      builder: (ctx, provider, child) {
        if (provider.isMoreLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
                top: screenHeight * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: SortAndFilterWidget(
                      selectedSortBy: _selectedSortBy,
                      onSortChanged: _onSortChangedProduct,
                      onFilterPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => FilterBottomSheet(
                            filters: provider.productFilters,
                            selectedIds: selectedFilters,
                          ),
                        ).then((result) {
                          if (result != null) {
                            _onFiltersApplied(result);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (provider.products.isEmpty)
                    const ItemsEmptyView()
                  else
                    GridView.builder(
                      controller: _scrollController,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: provider.products.length + (_isFetchingMoreProducts ? 1 : 0),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (_isFetchingMoreProducts && index == provider.products.length) {
                          return const Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        }

                        final product = provider.products[index];
                        final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

                        // Calculate percentage discount
                        final double? frontSalePrice = product.prices?.frontSalePrice?.toDouble();
                        final double? price = product.prices?.price?.toDouble();
                        String offPercentage = '';

                        if (frontSalePrice != null && price != null && price > 0) {
                          final double discount = 100 - ((frontSalePrice / price) * 100);
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
                            priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                                ? product.prices!.priceWithTaxes
                                : null,
                            itemsId: 0,
                            imageUrl: product.image,
                            optionalIcon: Icons.shopping_cart,
                            onOptionalIconTap: () => _handleAddToCart(product.id),
                            frontSalePriceWithTaxes: product.review?.average?.toString() ?? '0',
                            name: product.name,
                            storeName: product.store!.name.toString(),
                            price: product.prices!.price.toString(),
                            reviewsCount: product.review!.reviewsCount!.toInt(),
                            isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                  (wishlistProduct) => wishlistProduct.id == product.id,
                                ) ??
                                false,
                            onHeartTap: () async {
                              final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                    (wishlistProduct) => wishlistProduct.id == product.id,
                                  ) ??
                                  false;
                              if (isInWishlist) {
                                await wishlistProvider.deleteWishlistItem(product.id ?? 0, context);
                              } else {
                                await freshPicksProvider.handleHeartTap(context, product.id ?? 0);
                              }
                              await wishlistProvider.fetchWishlist();
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
      },
    );
  }
}
