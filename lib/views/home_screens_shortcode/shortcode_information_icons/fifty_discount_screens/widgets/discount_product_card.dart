import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/app_utils.dart';
import '../../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../../product_detail_screens/product_detail_screen.dart';

class DiscountProductCard extends StatefulWidget {
  final dynamic product; // Replace with your actual Product model type

  const DiscountProductCard({
    super.key,
    required this.product,
  });

  @override
  State<DiscountProductCard> createState() => _DiscountProductCardState();
}

class _DiscountProductCardState extends State<DiscountProductCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<WishlistProvider, FreshPicksProvider, CartProvider>(
      builder: (context, wishlistProvider, freshPicksProvider, cartProvider, child) {
        final String offPercentage = _calculateDiscountPercentage();
        final bool isInWishlist = _isProductInWishlist(wishlistProvider);

        return GestureDetector(
          onTap: () => _navigateToProductDetail(context),
          child: ProductCard(
            isOutOfStock: widget.product.outOfStock ?? false,
            off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
            priceWithTaxes: (widget.product.prices?.frontSalePrice ?? 0) < (widget.product.prices?.price ?? 0)
                ? widget.product.prices!.priceWithTaxes
                : null,
            itemsId: 0,
            imageUrl: widget.product.image,
            frontSalePriceWithTaxes: widget.product.review?.average ?? '0',
            name: widget.product.name,
            storeName: widget.product.store?.name.toString(),
            price: widget.product.prices?.price.toString(),
            reviewsCount: widget.product.review?.reviewsCount?.toInt(),
            optionalIcon: Icons.shopping_cart,
            onOptionalIconTap: () => _handleAddToCart(widget.product.id),
            isHeartObscure: isInWishlist,
            onHeartTap: () => _handleWishlistTap(
              context,
              wishlistProvider,
              freshPicksProvider,
              isInWishlist,
            ),
          ),
        );
      },
    );
  }

  String _calculateDiscountPercentage() {
    final double? frontSalePrice = widget.product.prices?.frontSalePrice?.toDouble();
    final double? price = widget.product.prices?.price?.toDouble();

    if (frontSalePrice != null && price != null && price > 0) {
      final double discount = 100 - ((frontSalePrice / price) * 100);
      if (discount > 0) {
        return discount.toStringAsFixed(0);
      }
    }
    return '';
  }

  bool _isProductInWishlist(WishlistProvider wishlistProvider) {
    return wishlistProvider.wishlist?.data?.products.any(
          (wishlistProduct) => wishlistProduct.id == widget.product.id,
        ) ??
        false;
  }

  void _navigateToProductDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          key: ValueKey(widget.product.slug.toString()),
          slug: widget.product.slug.toString(),
        ),
      ),
    );
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

  Future<void> _handleWishlistTap(
    BuildContext context,
    WishlistProvider wishlistProvider,
    FreshPicksProvider freshPicksProvider,
    bool isInWishlist,
  ) async {
    if (isInWishlist) {
      await wishlistProvider.deleteWishlistItem(
        widget.product.id ?? 0,
        context,
      );
    } else {
      await freshPicksProvider.handleHeartTap(
        context,
        widget.product.id ?? 0,
      );
    }

    await wishlistProvider.fetchWishlist();
  }
}
