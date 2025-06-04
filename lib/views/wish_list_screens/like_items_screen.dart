import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
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
import '../../provider/store_provider/brand_store_provider.dart';
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
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted) return;
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.fetchWishlist(token ?? '', context);
  }

  Future<void> handleDelete(int itemId) async {
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    await provider.deleteWishlistItem(itemId, context, token);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final storeProvider = Provider.of<StoreProvider>(context, listen: false);

    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
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
                      Text(AppStrings.wishList, style: wishListText(context)),
                      CircleAvatar(
                        radius: 16.5,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : const AssetImage('assets/boy.png')
                                as ImageProvider,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: wishlistProvider.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 0.5),
                        )
                      : wishlistProvider.wishlist?.data?.products.isEmpty ??
                              true
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
                                    decoration: const BoxDecoration(
                                      color: AppColors.lightCoral,
                                    ),
                                    height: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(AppStrings.emptyWishList,
                                            style: wishListText(context))),
                                  ),
                                ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: wishlistProvider
                                      .wishlist?.data?.products.length ??
                                  0,
                              itemBuilder: (context, index) {
                                final product = wishlistProvider
                                    .wishlist?.data?.products[index];

                                /// Calculate the percentage off
                                final dynamic frontSalePrice =
                                    product?.frontSalePrice;
                                final dynamic price = product?.price;
                                String offPercentage = '';

                                if (frontSalePrice != null &&
                                    price != null &&
                                    price > 0) {
                                  final dynamic discount =
                                      100 - ((frontSalePrice / price) * 100);
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
                                      bottom: screenHeight * 0.035),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductDetailScreen(
                                            key: ValueKey(product.slug),
                                            slug: product.slug,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        // image: Image.network(product?.image.toString() ?? ''),
                                        // color: Theme.of(context).colorScheme.onErrorContainer,
                                        color: AppColors.itemContainerBack,
                                        // color: AppColors.peachyPink,
                                        boxShadow: [
                                          BoxShadow(
                                            offset: const Offset(0, 1),
                                            blurRadius: 0.5,
                                            spreadRadius: 0.5,
                                            color:
                                                Colors.white.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: screenWidth * 0.02,
                                            right: screenWidth * 0.02,
                                            top: screenHeight * 0.02,
                                            bottom: screenHeight * 0.02),
                                        child: IntrinsicHeight(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: screenWidth * 0.25,
                                                    height: screenHeight * 0.1,
                                                    child: CachedNetworkImage(
                                                      imageUrl: product.image,
                                                      fit: BoxFit.cover,
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      width: screenWidth * 0.25,
                                                      height:
                                                          screenHeight * 0.1,
                                                      placeholder:
                                                          (BuildContext context,
                                                                  String url) =>
                                                              Container(
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .height *
                                                                0.28,
                                                        width: double.infinity,
                                                        color: Colors.blueGrey[
                                                            300], // Background color
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            Image.asset(
                                                              'assets/placeholder.png', // Replace with your actual image path
                                                              fit: BoxFit
                                                                  .cover, // Adjust fit if needed
                                                              height: MediaQuery
                                                                          .sizeOf(
                                                                              context)
                                                                      .height *
                                                                  0.28,
                                                              width: double
                                                                  .infinity,
                                                            ),
                                                            const CupertinoActivityIndicator(
                                                              radius:
                                                                  16, // Adjust size of the loader
                                                              animating: true,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        product.name ?? '',
                                                        // "dd",
                                                        style: wishTopItemStyle(
                                                            context),
                                                      ),
                                                      Text(
                                                        'Sold By: ${product.store.name}',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                          fontSize: 8,
                                                        ),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                                'AED${product.price.toString()}',
                                                                style:
                                                                    wishTopItemStyle(
                                                                        context)),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              (product.frontSalePrice ??
                                                                          0) <
                                                                      (product.price ??
                                                                          0)
                                                                  ? (product
                                                                          .priceWithTaxes
                                                                          .toString() ??
                                                                      '')
                                                                  : '',
                                                              style:
                                                                  wishItemSalePrice(
                                                                      context),
                                                            ),
                                                          ),
                                                          // const SizedBox(width: 10),
                                                          Expanded(
                                                            child: Text(
                                                                offPercentage
                                                                        .isNotEmpty
                                                                    ? '$offPercentage%off'
                                                                    : '',
                                                                style:
                                                                    wishItemSaleOff()),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () async {
                                                              final token =
                                                                  await SecurePreferencesUtil
                                                                      .getToken();
                                                              if (token !=
                                                                  null) {
                                                                await cartProvider
                                                                    .addToCart(
                                                                        product
                                                                            .id,
                                                                        context,
                                                                        1);
                                                              }
                                                            },
                                                            child: Container(
                                                              color:
                                                                  Colors.black,
                                                              height: 20,
                                                              width: 80,
                                                              child: const Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .all(5),
                                                                    child: Icon(
                                                                      Icons
                                                                          .shopping_cart,
                                                                      size: 13,
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    AppStrings
                                                                        .addToCart,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          GestureDetector(
                                                            onTap: () async {
                                                              removeWishlistConfirmationDialog(
                                                                  context,
                                                                  product);
                                                            },
                                                            child: Icon(
                                                                CupertinoIcons
                                                                    .delete,
                                                                size: 22,
                                                                color: Colors
                                                                    .deepOrangeAccent
                                                                    .withOpacity(
                                                                        0.5)),
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
            // },
          ),
        ),
      ),
    );
  }

  void removeWishlistConfirmationDialog(
    BuildContext mainContext,
    Product product,
  ) {
    showDialog(
      context: mainContext,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Wishlist'),
        content: const Text('Are you sure you want to remove from wishlist?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Close the dialog
              await handleDelete(product.id);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.peachyPink, // Set the text color
              textStyle: const TextStyle(
                fontSize: 16.0, // Optional: Adjust font size
                fontWeight: FontWeight.bold, // Optional: Adjust font weight
              ),
            ),
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
