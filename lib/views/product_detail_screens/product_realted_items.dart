import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/product_detail_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints/api_end_point.dart';
import '../../core/utils/app_utils.dart';
import '../../core/widgets/custom_items_views/product_card.dart';
import '../../models/product_packages_models/product_models.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';

class ProductRelatedItemsScreen extends StatefulWidget {
  const ProductRelatedItemsScreen({
    super.key,
    required this.screenWidth,
    required this.relatedProducts,
    required this.offPercentage,
    required this.onBackNavigation,
    required this.onActionUpdate,
  });

  final double screenWidth;
  final List<RecordProduct> relatedProducts;
  final String offPercentage;
  final Function() onBackNavigation;
  final Function(bool loader) onActionUpdate;

  @override
  State<ProductRelatedItemsScreen> createState() => _ProductRelatedItemsScreenState();
}

class _ProductRelatedItemsScreenState extends State<ProductRelatedItemsScreen> {
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
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    Provider.of<CartProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            AppStrings.relatedProducts.tr, // Title for the list
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Horizontal list view
        SizedBox(
          height: 200, // Adjust the height of the list view
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.relatedProducts.length,
            itemBuilder: (context, index) {
              final product = widget.relatedProducts[index];

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                ), // Add horizontal padding
                child: SizedBox(
                  width: widget.screenWidth * 0.4, // Set a fixed width for each item
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            key: ValueKey(product.slug.toString()),
                            slug: product.slug.toString(),
                          ),
                        ),
                      ).then((_) {
                        // Refresh the data when coming back to this screen
                        widget.onBackNavigation();
                      });
                    },
                    child: ProductCard(
                      isOutOfStock: product.outOfStock ?? false,
                      off: widget.offPercentage.isNotEmpty ? '${widget.offPercentage}% ${AppStrings.off.tr}' : '',
                      priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                          ? product.prices!.priceWithTaxes
                          : null,
                      itemsId: product.id,
                      imageUrl: (product.image != null && product.image!.isNotEmpty)
                          ? (ApiEndpoints.imageBaseURL + product.image!)
                          : '',
                      frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                      name: product.name,
                      storeName: product.store!.name.toString(),
                      price: product.prices!.price.toString(),
                      optionalIcon: Icons.shopping_cart,
                      onOptionalIconTap: () => _handleAddToCart(product.id),
                      reviewsCount: product.review?.reviewsCount?.toInt(),
                      isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                            (wishlistProduct) => wishlistProduct.id == product.id,
                          ) ??
                          false,
                      onHeartTap: () async {
                        widget.onActionUpdate(true);
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
                        widget.onActionUpdate(false);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
