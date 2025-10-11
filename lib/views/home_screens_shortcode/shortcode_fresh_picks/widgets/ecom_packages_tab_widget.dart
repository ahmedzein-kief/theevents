import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/ecom_tags_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class EComPackagesTabWidget extends StatefulWidget {
  const EComPackagesTabWidget({
    super.key,
    required this.slug,
  });

  final String slug;

  @override
  State<EComPackagesTabWidget> createState() => _EComPackagesTabWidgetState();
}

class _EComPackagesTabWidgetState extends State<EComPackagesTabWidget> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMorePackages = false;
  int _currentPagePackages = 1;
  String _selectedSortBy = 'default_sorting';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPackages();
      _scrollController.addListener(_onScrollPackages);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollPackages);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPackages() async {
    try {
      setState(() {
        _isFetchingMorePackages = true;
      });
      await Provider.of<EComTagProvider>(context, listen: false).fetchEComPackagesNew(
        slug: widget.slug,
        context,
        perPage: 12,
        page: _currentPagePackages,
        sortBy: _selectedSortBy,
      );
      if (mounted) {
        setState(() {
          _isFetchingMorePackages = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMorePackages = false;
        });
      }
    }
  }

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPagePackages++;
      _isFetchingMorePackages = true;
      _fetchPackages();
    }
  }

  void _onSortChangedPackages(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPagePackages = 1;
      Provider.of<EComTagProvider>(context, listen: false).packages.clear();
    });
    _fetchPackages();
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<EComTagProvider>(
      builder: (ctx, provider, child) {
        if (provider.isPackagesLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        if (provider.packages.isEmpty) {
          return Padding(
            padding: EdgeInsets.only(
              left: screenWidth * 0.02,
              right: screenWidth * 0.02,
              top: screenHeight * 0.02,
            ),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.lightCoral,
              ),
              height: 50,
              child: Align(
                alignment: Alignment.center,
                child: Text(AppStrings.noRecordsFound.tr),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedSortBy,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    _onSortChangedPackages(newValue);
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
              padding: EdgeInsets.only(
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
                top: screenHeight * 0.02,
              ),
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: provider.packages.length + (_isFetchingMorePackages ? 1 : 0),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  if (_isFetchingMorePackages && index == provider.packages.length) {
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  }

                  final product = provider.packages[index];
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
                      optionalIcon: Icons.shopping_cart,
                      onOptionalIconTap: () => _handleAddToCart(product.id),
                      itemsId: product.id,
                      imageUrl: product.image,
                      frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes.toString() ?? '',
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
            ),
          ],
        );
      },
    );
  }
}
