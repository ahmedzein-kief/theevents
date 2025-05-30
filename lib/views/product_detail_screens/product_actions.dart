import 'package:event_app/models/wishlist_models/wish_list_response_models.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/product_package_provider/product_details_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_items_views/custom_toast.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../auth_screens/auth_page_view.dart';

class ProductActions extends StatefulWidget {
  final void Function(List<Map<String, dynamic>> extraOptionErrorData) onExtraOptionsError;
  final void Function(bool loader) updateLoader;
  final int mainProductID;
  final int productVariationID;
  final WishlistProvider wishlistProvider;
  final FreshPicksProvider freshPicksProvider;
  final ProductItemsProvider productItemsProvider;
  final double screenWidth;
  final Map<String, dynamic> selectedExtraOptions;
  final List<Map<String, dynamic>?> selectedAttributes;

  const ProductActions({
    Key? key,
    required this.onExtraOptionsError,
    required this.productVariationID,
    required this.mainProductID,
    required this.wishlistProvider,
    required this.freshPicksProvider,
    required this.productItemsProvider,
    required this.screenWidth,
    required this.selectedExtraOptions,
    required this.selectedAttributes,
    required this.updateLoader,
  }) : super(key: key);

  @override
  _ProductActionsState createState() => _ProductActionsState();
}

class _ProductActionsState extends State<ProductActions> {
  bool _isLoading = false;
  var inWishList = false;

  Future<bool> _isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(SharedPreferencesUtil.tokenKey) != null;
  }

  void _handleAddToCart(BuildContext context) async {
    List<Map<String, dynamic>> extraOptionErrorData = [];
    if (widget.productItemsProvider.apiResponse?.data?.record?.options.isNotEmpty == true) {
      widget.productItemsProvider.apiResponse?.data?.record?.options.forEach(
        (action) {
          var selectedOption = widget.selectedExtraOptions['${action.id}'];
          var optionData = (selectedOption is Map<String, dynamic>) ? selectedOption : null;

          if (optionData == null && action.optionType.toLowerCase() != 'textarea') {
            var errorData = {
              'option_id': action.id,
              'error': true,
            };
            extraOptionErrorData.add(errorData);
          } else if (optionData?['values'] == null && action.optionType.toLowerCase() != 'textarea') {
            var errorData = {
              'option_id': action.id,
              'error': true,
            };
            extraOptionErrorData.add(errorData);
          } else if ((optionData?['values'] == null || optionData?['values'] == "null") && action.optionType.toLowerCase() == 'datepicker') {
            var errorData = {
              'option_id': action.id,
              'error': true,
            };
            extraOptionErrorData.add(errorData);
          } else {
            var errorData = {
              'option_id': action.id,
              'error': false,
            };
            extraOptionErrorData.add(errorData);
          }
        },
      );
    }

    if (extraOptionErrorData.every((errorData) => errorData['error'] == false)) {
      widget.onExtraOptionsError(extraOptionErrorData);
    } else {
      widget.onExtraOptionsError(extraOptionErrorData);
      return;
    }

    bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      PersistentNavBarNavigator.pushNewScreen(
        context,
        screen: AuthScreen(),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.fade,
      );
      CustomToast customToast = CustomToast(context);
      customToast.showToast(
        context: context,
        textHint: "Please Log-In to add items to Your Cart.",
        onDismiss: () {
          customToast.removeToast();
        },
      );
    } else {
      final token = await SharedPreferencesUtil.getToken();
      if (token != null) {
        setState(() {
          _isLoading = true;
        });
        await context.read<CartProvider>().addToCart(
              widget.productVariationID,
              context,
              1,
              selectedExtraOptions: widget.selectedExtraOptions,
              selectedAttributes: widget.selectedAttributes,
            );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<WishlistResponseModels?> addRemoveWishList(BuildContext context, bool isInWishlist) async {
    return await widget.freshPicksProvider.addRemoveWishList(context, widget.mainProductID);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);

    var isOutOfStock = widget.productItemsProvider.apiResponse?.data?.record?.outOfStock ?? false;
    var inCart = widget.productItemsProvider.apiResponse?.data?.record?.inCart ?? false;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!isOutOfStock)
              Expanded(
                child: AppCustomButton(
                  isLoading: _isLoading || cartProvider.isLoading,
                  onPressed: () => _handleAddToCart(context),
                  title: "ADD TO CART",
                ),
              ),
            SizedBox(width: widget.screenWidth * 0.04),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  bool loggedIn = await _isLoggedIn();
                  if (!loggedIn) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AuthScreen(),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.fade,
                    );
                    CustomToast customToast = CustomToast(context);
                    customToast.showToast(
                      context: context,
                      textHint: "Please Log-In to add items to your Wishlist.",
                      onDismiss: () {
                        customToast.removeToast();
                      },
                    );
                    return null;
                  }
                  widget.updateLoader(true);
                  final wishResult = await addRemoveWishList(context, inWishList);
                  if (wishResult != null) {
                    final mainProvider = Provider.of<ProductItemsProvider>(context, listen: false);
                    mainProvider.updateWishListData(wishResult.data?.added ?? false);
                    // setState(() {
                    //   inWishList = wishResult.data?.added ?? false;
                    // });
                    setState(() {});
                    final token = await SharedPreferencesUtil.getToken();
                    await wishlistProvider.fetchWishlist(token ?? '', context);
                  }
                  widget.updateLoader(false);
                },
                child: Consumer<ProductItemsProvider>(
                  builder: (context, provider, child) {
                    inWishList = provider.apiResponse?.data?.record?.inWishList ?? false;
                    return Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
                      padding: const EdgeInsets.all(10),
                      height: 45,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            inWishList ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                            color: inWishList ? Colors.red : Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: Text(
                              "WISHLIST",
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: addToWiShListText(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
