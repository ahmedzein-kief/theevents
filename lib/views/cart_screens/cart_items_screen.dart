import 'dart:io';

import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/models/cart_items_models/cart_items_models.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/cart_screens/save_address_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import '../../core/services/image_picker.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../../core/widgets/custom_items_views/custom_product_cart_items.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../product_detail_screens/product_detail_screen.dart';
import 'empty_cart_screen.dart';

class CartItemsScreen extends StatefulWidget {
  const CartItemsScreen({super.key});

  @override
  State<CartItemsScreen> createState() => _CartItemsScreensState();
}

class _CartItemsScreensState extends State<CartItemsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchCartData(context);
      _loadImage();
    });
  }

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

  Future<void> fetchCartData(BuildContext? context) async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted) return;
    final provider = Provider.of<CartProvider>(context!, listen: false);
    await provider.fetchCartData(token ?? '', context);
  }

  Future<Response?> fetchCheckoutData(
      BuildContext? context, String checkoutToken) async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted) return null;
    final provider = Provider.of<CartProvider>(context!, listen: false);
    return provider.fetchCheckoutData(token ?? '', context, checkoutToken);
  }

  Future<void> handleDelete(String rowId) async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted) return;
    final provider = Provider.of<CartProvider>(context, listen: false);
    await provider.deleteCartListItem(rowId, context, token ?? '');
  }

  Future<void> update(String rowId, int qty, List<Product>? products) async {
    final token = await SecurePreferencesUtil.getToken();
    if (token == null) return;
    final provider = Provider.of<CartProvider>(context, listen: false);

    final Map<String, String> items = {};

    if (products != null) {
      for (final entry in products) {
        final cartRowId = entry.cartItem.rowId;
        final quantity =
            cartRowId == rowId ? qty.toString() : entry.cartItem.qty.toString();

        items['items[$cartRowId][rowId]'] = cartRowId;
        items['items[$cartRowId][values][qty]'] = quantity;
      }
    }

    await provider.updateCart(token, context, items);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<CartProvider>(
          builder: (context, provider, child) {
            if (provider.checkoutResponse != null &&
                provider.checkoutResponse?.statusCode == 200) {}

            if (provider.cartResponse == null ||
                provider.cartResponse!.data.products.isEmpty) {
              return const EmptyCartScreen();
            }

            final cartData = provider.cartResponse?.data;

            return SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.02,
                        right: screenWidth * 0.02,
                        top: screenHeight * 0.02),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.myCart,
                            softWrap: true,
                            style: wishListText(context),
                          ),
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
                  ),
                  Expanded(
                    child: provider.cartLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Colors.black, strokeWidth: 0.5))
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: cartData?.products.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final productCart =
                                  provider.cartResponse?.data.products[index];
                              final cartItem =
                                  provider.cartResponse?.data.content[index];

                              /// Calculate the percentage off

                              final dynamic frontSalePrice =
                                  productCart?.product.prices.frontSalePrice;
                              final dynamic price =
                                  productCart?.product.prices.price;
                              String offPercentage = '';

                              if (frontSalePrice != null &&
                                  price != null &&
                                  price > 0) {
                                final dynamic discount =
                                    100 - ((frontSalePrice / price) * 100);
                                // offPercentage = discount.toStringAsFixed(0);
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
                                        key:
                                            ValueKey(productCart?.product.slug),
                                        slug: productCart?.product.slug,
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCartItems(
                                  brandName: productCart?.product.name ?? 'ih',
                                  imageUrl: productCart?.product.image,
                                  itemS: '${productCart?.cartItem.qty}',
                                  quantity:
                                      'Quantity: ${productCart?.cartItem.qty}',
                                  brandDescription:
                                      'Sold By ${productCart?.product.store?.name}',
                                  attributes: productCart
                                          ?.cartItem.options.attributes ??
                                      '',
                                  ceoData:
                                      productCart?.cartItem.options.options,
                                  offPrice: offPercentage.isNotEmpty
                                      ? '$offPercentage%off'
                                      : '',
                                  actualPrice:
                                      'AED ${productCart?.cartItem.price}',
                                  standardPrice: (productCart?.product.prices
                                                  .frontSalePrice ??
                                              0) <
                                          (productCart?.product.prices.price ??
                                              0)
                                      ? (productCart
                                              ?.product.prices.priceWithTaxes ??
                                          '')
                                      : '',
                                  onSubtractPressed: () async {
                                    final products =
                                        provider.cartResponse?.data.products;
                                    var qty = productCart?.cartItem.qty;

                                    if ((qty ?? 0) > 0) {
                                      qty = qty! - 1;
                                      await update(productCart!.cartItem.rowId,
                                          qty, products);
                                    }
                                  },
                                  onAddPressed: () async {
                                    final products =
                                        provider.cartResponse?.data.products;
                                    await update(productCart!.cartItem.rowId,
                                        productCart.cartItem.qty + 1, products);
                                  },
                                  onDeletePressed: () async {
                                    await handleDelete(
                                        productCart?.cartItem.rowId ?? '');
                                  },
                                ),
                              );
                            },
                          ),
                  ),

                  ///    SUBTOTALS OF THE ITEMs

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        // Radius for the top-left corner
                        topRight: Radius.circular(
                            8), // Radius for the top-right corner
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black,
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: screenWidth * 0.06,
                          top: screenHeight * 0.02,
                          bottom: screenHeight * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: screenWidth * 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    '${AppStrings.subTotal}${provider.cartResponse?.data.totalPrice}',
                                    style: cartSubtotal(context)),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.02),
                                  child: Text(
                                      "${AppStrings.tax}${provider.cartResponse?.data.formattedRawTax ?? ''}",
                                      style: cartSubtotal(context)),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                        '${AppStrings.total}${provider.cartResponse?.data.formattedFinalTotal}',
                                        style: cartTotal(context)),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(AppStrings.shippingFees,
                                      textAlign: TextAlign.start,
                                      style: shippingFeesText(context)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: screenHeight * 0.02,
                                bottom: screenHeight * 0.01),
                            child: CustomAppButton(
                              buttonText: AppStrings.proceedToCheckOut,
                              buttonColor: AppColors.lightCoral,
                              suffixIcon: CupertinoIcons.forward,
                              isLoading: provider.checkoutLoading,
                              onTap: () async {
                                final checkoutToken = provider
                                    .cartResponse?.data.tracked_start_checkout;

                                if (checkoutToken != null) {
                                  final response = await fetchCheckoutData(
                                      context, checkoutToken);

                                  if (response?.statusCode == 200) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (builder) => SaveAddressScreen(
                                          tracked_start_checkout: checkoutToken,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
