import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/api_endpoints/api_end_point.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../core/widgets/items_empty_view.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/product_package_provider/product_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/product_filters_screen.dart';
import '../../../filters/sort_an_filter_widget.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class ProductsView extends StatelessWidget {
  final String storeId;
  final int currentPage;
  final String selectedSortBy;
  final Map<String, List<int>> selectedFilters;
  final Function(String) onSortChanged;
  final Function(Map<String, List<int>>) onFiltersChanged;

  const ProductsView({
    super.key,
    required this.storeId,
    required this.currentPage,
    required this.selectedSortBy,
    required this.selectedFilters,
    required this.onSortChanged,
    required this.onFiltersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context);

    return Column(
      children: [
        Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            if (productProvider.isLoadingProducts && currentPage == 1) {
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
                            selectedSortBy: selectedSortBy,
                            onSortChanged: onSortChanged,
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
                                  onFiltersChanged(result);
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
                              if (CommonVariables.isFetchingMore) {
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
}
