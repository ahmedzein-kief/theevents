import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../core/widgets/items_empty_view.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/sort_an_filter_widget.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class FeaturedProductsGrid extends StatefulWidget {
  const FeaturedProductsGrid({
    super.key,
    required this.slug,
    required this.selectedSortBy,
    required this.onSortChanged,
    required this.onFilterPressed,
    required this.currentPage,
    required this.isFetchingMore,
  });

  final String slug;
  final String selectedSortBy;
  final Function(String) onSortChanged;
  final VoidCallback onFilterPressed;
  final int currentPage;
  final bool isFetchingMore;

  @override
  State<FeaturedProductsGrid> createState() => _FeaturedProductsGridState();
}

class _FeaturedProductsGridState extends State<FeaturedProductsGrid> {
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
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<FeaturedCategoriesDetailProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingProducts && widget.currentPage == 1) {
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
                      selectedSortBy: widget.selectedSortBy,
                      onSortChanged: widget.onSortChanged,
                      onFilterPressed: widget.onFilterPressed,
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
                        itemCount: provider.recordsProducts.length + (widget.isFetchingMore ? 1 : 0),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (widget.isFetchingMore && index == provider.recordsProducts.length) {
                            return const Align(
                              alignment: Alignment.center,
                              child: Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
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
                              priceWithTaxes: (product.prices.frontSalePrice ?? 0) < (product.prices.price ?? 0)
                                  ? product.prices.priceWithTaxes
                                  : null,
                              itemsId: product.id,
                              imageUrl: product.image,
                              frontSalePriceWithTaxes: product.review.rating?.toString() ?? '0',
                              name: product.name,
                              storeName: product.store?.name.toString() ?? '',
                              price: product.prices.frontSalePrice.toString(),
                              reviewsCount: product.review.reviewsCount.toInt(),
                              optionalIcon: Icons.shopping_cart,
                              onOptionalIconTap: () => _handleAddToCart(product.id),
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
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
