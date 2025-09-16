import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class FeaturedPackagesGrid extends StatelessWidget {
  const FeaturedPackagesGrid({
    super.key,
    required this.slug,
    required this.selectedSortBy,
    required this.onSortChanged,
    required this.currentPage,
    required this.isFetchingMore,
  });

  final String slug;
  final String selectedSortBy;
  final Function(String) onSortChanged;
  final int currentPage;
  final bool isFetchingMore;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    return Center(
      child: Consumer<FeaturedCategoriesDetailProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingPackages && currentPage == 1) {
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
                    value: selectedSortBy,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        onSortChanged(newValue);
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
}
