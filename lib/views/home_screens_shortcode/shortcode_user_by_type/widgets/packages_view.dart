import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/network/api_endpoints/api_end_point.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_items_views/custom_packages_view.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/product_package_provider/product_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class PackagesView extends StatefulWidget {
  final String storeId;
  final int currentPagePackages;
  final String selectedSortBy;
  final bool isFetchingMorePackages;
  final Function(String) onSortChanged;

  const PackagesView({
    super.key,
    required this.storeId,
    required this.currentPagePackages,
    required this.selectedSortBy,
    required this.isFetchingMorePackages,
    required this.onSortChanged,
  });

  @override
  State<PackagesView> createState() => _PackagesViewState();
}

class _PackagesViewState extends State<PackagesView> {
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

    return Column(
      children: [
        Consumer<ProductProvider>(
          builder: (context, packageProductProvider, child) {
            if (packageProductProvider.isLoadingPackages && widget.currentPagePackages == 1) {
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
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(AppStrings.noRecord.tr),
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
                          value: widget.selectedSortBy,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              widget.onSortChanged(newValue);
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
                            if (widget.isFetchingMorePackages) {
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
                              AppColors.packagesBackground.withAlpha((0.01 * 255).toInt()),
                              AppColors.packagesBackgroundS,
                              AppColors.packagesBackgroundS.withAlpha((0.09 * 255).toInt()),
                            ];

                            final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
                            final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

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
                                addInCart: () => _handleAddToCart(product.id),
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
                                    // Remove from wishlist
                                    await wishlistProvider.deleteWishlistItem(product.id, context);
                                  } else {
                                    // Add to wishlist
                                    await freshPicksProvider.handleHeartTap(context, product.id);
                                  }

                                  // Refresh wishlist after action
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
            }
          },
        ),
      ],
    );
  }
}
