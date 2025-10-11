import 'dart:io';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/wishlist_models/wishlist_items_models.dart';
import 'package:event_app/provider/cart_item_provider/cart_item_provider.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/services/image_picker.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/utils/app_utils.dart';
import '../../core/widgets/padded_network_banner.dart';
import '../../core/widgets/price_row.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../product_detail_screens/product_detail_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  File? _selectedImage;

  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();

  // Load the saved image from SharedPreferences
  Future<void> _loadImage() async {
    final String? imagePath = await _imagePickerHelper.getSavedImage();
    if (imagePath != null) {
      setState(() {
        _selectedImage = File(imagePath);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchItems(context);
      _loadImage();
    });
  }

  Future<void> fetchItems(BuildContext context) async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.fetchWishlist();
  }

  Future<void> handleDelete(int itemId) async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.deleteWishlistItem(itemId, context);
  }

  // Helper method to get appropriate colors based on theme
  Color _getItemContainerColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.grey[850]! : AppColors.itemContainerBack;
  }

  Color _getAddToCartButtonColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Theme.of(context).colorScheme.primary : Colors.black;
  }

  Color _getAddToCartTextColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.white : Colors.white;
  }

  Color _getEmptyWishlistColor(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? Colors.grey[800]! : AppColors.lightCoral;
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) => Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight * 0.030,
                    left: screenWidth * 0.02,
                    right: screenWidth * 0.02,
                    top: screenHeight * 0.030,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.wishList.tr,
                        style: wishListText(context).copyWith(
                          color: isDarkMode ? Colors.white : null,
                        ),
                      ),
                      CircleAvatar(
                        radius: 16.5,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : const AssetImage('assets/boy.png') as ImageProvider,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: wishlistProvider.isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: isDarkMode ? Colors.white : Colors.black,
                            strokeWidth: 0.5,
                          ),
                        )
                      : wishlistProvider.wishlist?.data?.products.isEmpty ?? true
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: screenWidth * 0.02,
                                  left: screenWidth * 0.02,
                                  right: screenWidth * 0.02,
                                  top: screenWidth * 0.010,
                                ),
                                child: Center(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: _getEmptyWishlistColor(context),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    height: 50,
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppStrings.emptyWishList.tr,
                                        style: wishListText(context).copyWith(
                                          color: isDarkMode ? Colors.white : null,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: wishlistProvider.wishlist?.data?.products.length ?? 0,
                              itemBuilder: (context, index) {
                                final product = wishlistProvider.wishlist?.data?.products[index];

                                /// Calculate the percentage off
                                final dynamic frontSalePrice = product?.frontSalePrice;
                                final dynamic price = product?.price;
                                String offPercentage = '';

                                if (frontSalePrice != null && price != null && price > 0) {
                                  final dynamic discount = 100 - ((frontSalePrice / price) * 100);
                                  if (discount > 0) {
                                    offPercentage = discount.toStringAsFixed(0);
                                  }
                                }

                                if (product == null) {
                                  return const SizedBox.shrink();
                                }

                                /// wishlist product widget
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: screenHeight * 0.035,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
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
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: _getItemContainerColor(context),
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 0.5,
                                            spreadRadius: 0.5,
                                            color: isDarkMode
                                                ? Colors.grey[700]!.withAlpha((0.3 * 255).toInt())
                                                : Colors.white.withAlpha((0.3 * 255).toInt()),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: screenWidth * 0.02,
                                          right: screenWidth * 0.02,
                                          top: screenHeight * 0.02,
                                          bottom: screenHeight * 0.02,
                                        ),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                    height: screenHeight * 0.1,
                                                    child: PaddedNetworkBanner(
                                                      imageUrl: product.image,
                                                      fit: BoxFit.cover,
                                                      alignment: Alignment.centerLeft,
                                                      width: screenWidth * 0.25,
                                                      height: screenHeight * 0.1,
                                                      padding: EdgeInsets.zero,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                    left: screenWidth * 0.03,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        product.name ?? '',
                                                        style: wishTopItemStyle(
                                                          context,
                                                        ).copyWith(
                                                          color: isDarkMode ? Colors.white : null,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${AppStrings.soldBy.tr}: ${product.store.name}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Expanded(
                                                            child: PriceRow(
                                                              price: product.price.toString(),
                                                              style: wishTopItemStyle(
                                                                context,
                                                              ).copyWith(
                                                                color: isDarkMode ? Colors.white : null,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: PriceRow(
                                                              price:
                                                                  (product.frontSalePrice ?? 0) < (product.price ?? 0)
                                                                      ? (product.priceWithTaxes.toString())
                                                                      : '',
                                                              style: wishItemSalePrice(
                                                                context,
                                                              ).copyWith(
                                                                color: isDarkMode ? Colors.grey[400] : null,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                                              style: wishItemSaleOff().copyWith(
                                                                color: isDarkMode ? Colors.green[300] : null,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () => _handleAddToCart(product.id),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                color: _getAddToCartButtonColor(
                                                                  context,
                                                                ),
                                                                borderRadius: BorderRadius.circular(
                                                                  4,
                                                                ),
                                                              ),
                                                              height: 24,
                                                              width: 85,
                                                              child: Row(
                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets.only(
                                                                      right: 4,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons.shopping_cart,
                                                                      size: 13,
                                                                      color: _getAddToCartTextColor(
                                                                        context,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    AppStrings.addToCart,
                                                                    style: TextStyle(
                                                                      fontSize: 10,
                                                                      color: _getAddToCartTextColor(
                                                                        context,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              removeWishlistConfirmationDialog(
                                                                context,
                                                                product,
                                                              );
                                                            },
                                                            child: Icon(
                                                              CupertinoIcons.delete,
                                                              size: 22,
                                                              color: isDarkMode
                                                                  ? Colors.red[300]
                                                                  : Colors.deepOrangeAccent
                                                                      .withAlpha((0.5 * 255).toInt()),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void removeWishlistConfirmationDialog(
    BuildContext mainContext,
    Product product,
  ) {
    final isDarkMode = Theme.of(mainContext).brightness == Brightness.dark;

    showDialog(
      context: mainContext,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[850] : Colors.white,
        title: Text(
          AppStrings.removeWishlistTitle.tr,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        content: Text(
          AppStrings.removeWishlistMessage.tr,
          style: TextStyle(
            color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.blue[300] : AppColors.peachyPink,
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(AppStrings.cancel.tr),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await handleDelete(product.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: isDarkMode ? Colors.red[300] : AppColors.peachyPink,
              textStyle: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Text(AppStrings.yes.tr),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: CircularProgressIndicator(
          color: isDarkMode ? Colors.white : Colors.black,
          strokeWidth: 0.5,
        ),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
