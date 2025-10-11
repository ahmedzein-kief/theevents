import 'dart:async';
import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../core/widgets/custom_home_views/custom_home_text_row.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../models/dashboard/fresh_picks_models/fresh_picks_model.dart';
import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../product_detail_screens/product_detail_screen.dart';
import 'fresh_picks_detail_screen.dart';

class FreshPicksScreen extends StatefulWidget {
  const FreshPicksScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<FreshPicksScreen> createState() => _FreshPicksViewState();
}

class _FreshPicksViewState extends State<FreshPicksScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await safeAsyncCall(() => fetchDataFreshPicks());
      await safeAsyncCall(() => fetchWishListItems());
    });
  }

  /// دالة مساعدة لتنفيذ العمليات غير المتزامنة بأمان
  Future<void> safeAsyncCall(Future<void> Function() callback) async {
    if (!mounted) return;
    try {
      await callback();
    } catch (e) {
      if (mounted) {
        log('Async operation error: $e');
      }
    }
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------
  Future<void> fetchWishListItems() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist();
  }

  ///   --------------- FRESH  PICKS   MAIN 12 ITEMS DATA HOME PAGE --------------------
  Future<void> fetchDataFreshPicks() async {
    if (!mounted) return;

    await Provider.of<FreshPicksProvider>(context, listen: false).fetchData(context, perPage: 12, page: 1, random: 1);
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<FreshPicksProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        final List<Records>? records = provider.records;
        final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
        return Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) => Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: CustomTextRow(
                  title: widget.data['attributes']['title'],
                  seeAll: AppStrings.viewAll.tr,
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FreshPicksDetailScreen(
                          data: widget.data['attributes']['title'],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (provider.records?.isEmpty ?? true)
                const SizedBox.shrink()
              else
                Container(
                  color: AppColors.infoBackGround,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.02,
                      right: screenWidth * 0.02,
                      top: screenHeight * 0.02,
                      bottom: screenHeight * 0.02,
                    ),
                    child: SizedBox(
                      child: GridView.builder(
                        itemCount: records?.length ?? 0,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final Records? record = records?[index];
                          final item = freshPicksProvider.records?[index];

                          /// Calculate the percentage off
                          /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                          final dynamic frontSalePrice = record?.prices?.frontSalePrice;
                          final dynamic price = record?.prices?.price;
                          String offPercentage = '';

                          if (frontSalePrice != null && price != null && price > 0) {
                            // Calculate the discount percentage
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
                                    key: ValueKey(item?.slug?.toString()),
                                    slug: item?.slug?.toString(),
                                  ),
                                ),
                              );
                            },
                            child: ProductCard(
                              isOutOfStock: record?.outOfStock ?? false,
                              off: offPercentage.isNotEmpty ? '$offPercentage${AppStrings.percentOff.tr}' : '',
                              priceWithTaxes: (record?.prices?.frontSalePrice ?? 0) < (record?.prices?.price ?? 0)
                                  ? record?.prices!.priceWithTaxes
                                  : null,
                              imageUrl: record?.image,
                              name: record?.name,
                              frontSalePriceWithTaxes: record?.review?.rating?.toString() ?? '0',
                              storeName: record?.store?.name,
                              price: record?.prices!.frontSalePrice.toString(),
                              reviewsCount: record?.review?.reviewsCount,
                              itemsId: record?.id ?? 0,
                              optionalIcon: Icons.shopping_cart,
                              onOptionalIconTap: () => _handleAddToCart(record?.id),
                              isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                    (wishlistProduct) => wishlistProduct.id == item?.id,
                                  ) ??
                                  false,
                              onHeartTap: () => safeAsyncCall(() async {
                                final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                      (wishlistProduct) => wishlistProduct.id == item?.id,
                                    ) ??
                                    false;

                                if (isInWishlist) {
                                  await wishlistProvider.deleteWishlistItem(item?.id ?? 0, context);
                                } else {
                                  await freshPicksProvider.handleHeartTap(
                                    context,
                                    item?.id ?? 0,
                                  );
                                }

                                if (mounted) {
                                  await wishlistProvider.fetchWishlist();
                                }
                              }),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
