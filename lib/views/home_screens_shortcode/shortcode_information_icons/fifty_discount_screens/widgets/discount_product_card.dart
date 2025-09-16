import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/shared_preferences_helper.dart';
import '../../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../../product_detail_screens/product_detail_screen.dart';

class DiscountProductCard extends StatelessWidget {
  final dynamic product; // Replace with your actual Product model type

  const DiscountProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer3<WishlistProvider, FreshPicksProvider, CartProvider>(
      builder: (context, wishlistProvider, freshPicksProvider, cartProvider, child) {
        final String offPercentage = _calculateDiscountPercentage();
        final bool isInWishlist = _isProductInWishlist(wishlistProvider);

        return GestureDetector(
          onTap: () => _navigateToProductDetail(context),
          child: ProductCard(
            isOutOfStock: product.outOfStock ?? false,
            off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
            priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                ? product.prices!.priceWithTaxes
                : null,
            itemsId: 0,
            imageUrl: product.image,
            frontSalePriceWithTaxes: product.review?.average ?? '0',
            name: product.name,
            storeName: product.store?.name.toString(),
            price: product.prices?.price.toString(),
            reviewsCount: product.review?.reviewsCount?.toInt(),
            optionalIcon: Icons.shopping_cart,
            onOptionalIconTap: () => _handleCartTap(context, cartProvider),
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
    final double? frontSalePrice = product.prices?.frontSalePrice?.toDouble();
    final double? price = product.prices?.price?.toDouble();

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
          (wishlistProduct) => wishlistProduct.id == product.id,
        ) ??
        false;
  }

  void _navigateToProductDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailScreen(
          key: ValueKey(product.slug.toString()),
          slug: product.slug.toString(),
        ),
      ),
    );
  }

  Future<void> _handleCartTap(BuildContext context, CartProvider cartProvider) async {
    final token = await SecurePreferencesUtil.getToken();
    if (token != null) {
      await cartProvider.addToCart(
        product.id,
        context,
        1,
      );
    }
  }

  Future<void> _handleWishlistTap(
    BuildContext context,
    WishlistProvider wishlistProvider,
    FreshPicksProvider freshPicksProvider,
    bool isInWishlist,
  ) async {
    final token = await SecurePreferencesUtil.getToken();

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
  }
}
