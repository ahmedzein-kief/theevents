import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/cart_items_models/cart_items_models.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/cart_screens/stepper_payment_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/shared_preferences_helper.dart';
import '../../core/styles/app_colors.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/PriceRow.dart';
import '../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../../core/widgets/custom_items_views/custom_product_cart_items.dart';
import '../../provider/auth_provider/get_user_provider.dart';
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
      final user = Provider.of<UserProvider>(context, listen: false).user;
      avatarImage = user?.avatar ?? '';

      // _loadImage();
    });
  }

  String avatarImage = '';

  // File? _selectedImage;

  // final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  //
  // // Load the saved image from SharedPreferences
  // Future<void> _loadImage() async {
  //   final String? imagePath = await _imagePickerHelper.getSavedImage();
  //   if (imagePath != null) {
  //     setState(() {
  //       _selectedImage = File(imagePath);
  //     });
  //   }
  // }

  Future<void> fetchCartData(BuildContext? context) async {
    final token = await SecurePreferencesUtil.getToken();
    if (!mounted) return;
    final provider = Provider.of<CartProvider>(context!, listen: false);
    await provider.fetchCartData(token ?? '', context);
  }

  Future<dynamic> fetchCheckoutData(
    BuildContext? context,
    String checkoutToken,
  ) async {
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

    // Create the request body in the required JSON format
    final List<Map<String, dynamic>> items = [];

    if (products != null) {
      for (final entry in products) {
        final cartRowId = entry.cartItem.rowId;
        final quantity = cartRowId == rowId ? qty : int.parse(entry.cartItem.qty.toString());

        items.add({
          'rowId': cartRowId,
          'values': {
            'qty': quantity,
          }
        });
      }
    }

    final Map<String, dynamic> requestBody = {
      'items': items,
    };

    await provider.updateCart(token, context, requestBody);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Consumer<CartProvider>(
          builder: (context, provider, child) {
            if (provider.checkoutResponse != null && provider.checkoutResponse?.statusCode == 200) {}

            if (provider.cartResponse == null || provider.cartResponse!.data.products.isEmpty) {
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
                      top: screenHeight * 0.02,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: screenWidth * 0.03),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.myCart.tr,
                            softWrap: true,
                            style: wishListText(context),
                          ),
                          CircleAvatar(
                            radius: 16.5,
                            backgroundImage: (avatarImage.isNotEmpty && !avatarImage.startsWith('data:image'))
                                ? NetworkImage(avatarImage)
                                : const AssetImage('assets/boy.png'),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: provider.cartLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 0.5,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: cartData?.products.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final productCart = provider.cartResponse?.data.products[index];
                              final cartItem = provider.cartResponse?.data.content[index];

                              /// Calculate the percentage off

                              final dynamic frontSalePrice = productCart?.product.prices.frontSalePrice;
                              final dynamic price = productCart?.product.prices.price;
                              String offPercentage = '';

                              if (frontSalePrice != null && price != null && price > 0) {
                                final dynamic discount = 100 - ((frontSalePrice / price) * 100);
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
                                        key: ValueKey(productCart?.product.slug),
                                        slug: productCart?.product.slug,
                                      ),
                                    ),
                                  );
                                },
                                child: ProductCartItems(
                                  brandName: productCart?.product.name ?? 'ih',
                                  imageUrl: productCart?.product.image,
                                  itemS: '${productCart?.cartItem.qty}',
                                  quantity: '${AppStrings.quantity.tr} ${productCart?.cartItem.qty}',
                                  brandDescription: '${AppStrings.soldBy.tr} ${productCart?.product.store?.name}',
                                  attributes: productCart?.cartItem.options.attributes ?? '',
                                  ceoData: productCart?.cartItem.options.options,
                                  offPrice: offPercentage.isNotEmpty ? '$offPercentage${AppStrings.percentOff.tr}' : '',
                                  actualPrice: '${productCart?.cartItem.price}',
                                  standardPrice: (productCart?.product.prices.frontSalePrice ?? 0) <
                                          (productCart?.product.prices.price ?? 0)
                                      ? (productCart?.product.prices.priceWithTaxes ?? '')
                                      : '',
                                  onSubtractPressed: () async {
                                    final products = provider.cartResponse?.data.products;
                                    var qty = productCart?.cartItem.qty;

                                    if ((qty ?? 0) > 0) {
                                      qty = qty! - 1;
                                      await update(
                                        productCart!.cartItem.rowId,
                                        qty,
                                        products,
                                      );
                                    }
                                  },
                                  onAddPressed: () async {
                                    final products = provider.cartResponse?.data.products;
                                    await update(
                                      productCart!.cartItem.rowId,
                                      productCart.cartItem.qty + 1,
                                      products,
                                    );
                                  },
                                  onDeletePressed: () async {
                                    await handleDelete(
                                      productCart?.cartItem.rowId ?? '',
                                    );
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
                          8,
                        ), // Radius for the top-right corner
                      ),
                      // boxShadow: const [
                      //   BoxShadow(
                      //     color: Colors.black,
                      //     spreadRadius: 1,
                      //     blurRadius: 5,
                      //     offset: Offset(0, 3),
                      //   ),
                      // ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth * 0.06,
                        left: screenWidth * 0.06,
                        top: screenHeight * 0.02,
                        bottom: screenHeight * 0.01,
                      ),
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
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppStrings.subTotalColon.tr,
                                      style: cartSubtotal(context),
                                    ),
                                    PriceRow(
                                      currencySize: 12,
                                      currencyColor: AppColors.totalItemsText,
                                      price: provider.cartResponse?.data.totalPrice,
                                      style: cartSubtotal(context),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        AppStrings.taxColon.tr,
                                        style: cartSubtotal(context),
                                      ),
                                      PriceRow(
                                        currencySize: 12,
                                        currencyColor: AppColors.totalItemsText,
                                        price: provider.cartResponse?.data.formattedRawTax,
                                        style: cartSubtotal(context),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      AppStrings.totalColon.tr,
                                      style: cartTotal(context),
                                    ),
                                    PriceRow(
                                      currencySize: 12,
                                      currencyColor: AppColors.totalItemsText,
                                      price: provider.cartResponse?.data.formattedFinalTotal,
                                      style: cartTotal(context),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    AppStrings.shippingFees.tr,
                                    textAlign: TextAlign.start,
                                    style: shippingFeesText(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              bottom: screenHeight * 0.01,
                            ),
                            child: CustomAppButton(
                              buttonText: AppStrings.proceedToCheckOut.tr,
                              buttonColor: AppColors.lightCoral,
                              suffixIcon: CupertinoIcons.forward,
                              isLoading: provider.checkoutLoading,
                              onTap: () async {
                                final checkoutToken = provider.cartResponse?.data.tracked_start_checkout;

                                if (checkoutToken != null) {
                                  final response = await fetchCheckoutData(
                                    context,
                                    checkoutToken,
                                  );

                                  if (response?.statusCode == 200) {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (builder) {
                                          return StepperScreen(
                                            tracked_start_checkout: checkoutToken,
                                            amount: provider.cartResponse?.data.finalTotal.toString() ?? '',
                                            isNewAddress: false,
                                          );
                                        },
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
