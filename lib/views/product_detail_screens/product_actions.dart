import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/custom_items_views/custom_add_to_cart_button.dart';
import 'package:event_app/models/wishlist_models/wish_list_response_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/helper/functions/functions.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/utils/app_utils.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/product_package_provider/product_details_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';

class ProductActions extends StatefulWidget {
  const ProductActions({
    super.key,
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
  });

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

  @override
  State<ProductActions> createState() => _ProductActionsState();
}

class _ProductActionsState extends State<ProductActions> {
  bool _isAddingToCart = false;
  bool _isWishlistLoading = false;
  var inWishList = false;

  @override
  void initState() {
    super.initState();
    // Initialize wishlist state from provider
    inWishList = widget.productItemsProvider.apiResponse?.data?.record?.inWishList ?? false;
  }

  /// Validate extra options before adding to cart
  bool _validateExtraOptions() {
    final List<Map<String, dynamic>> extraOptionErrorData = [];

    if (widget.productItemsProvider.apiResponse?.data?.record?.options.isNotEmpty == true) {
      widget.productItemsProvider.apiResponse?.data?.record?.options.forEach(
        (action) {
          final selectedOption = widget.selectedExtraOptions['${action.id}'];
          final optionData = (selectedOption is Map<String, dynamic>) ? selectedOption : null;

          bool hasError = false;

          if (action.optionType.toLowerCase() == 'textarea') {
            // Textarea options are optional, no validation needed
            hasError = false;
          } else if (action.optionType.toLowerCase() == 'datepicker') {
            // Date picker validation
            hasError = optionData == null ||
                optionData['values'] == null ||
                optionData['values'] == 'null' ||
                optionData['values'].toString().isEmpty;
          } else {
            // Other option types validation
            hasError = optionData == null || optionData['values'] == null;
          }

          extraOptionErrorData.add({
            'option_id': action.id,
            'error': hasError,
          });
        },
      );
    }

    widget.onExtraOptionsError(extraOptionErrorData);

    // Check if all options are valid
    final hasErrors = extraOptionErrorData.any((errorData) => errorData['error'] == true);

    if (hasErrors) {
      _showErrorSnackbar('pleaseSelectRequiredOptions'.tr);
      return false;
    }

    return true;
  }

  /// Show error snackbar
  void _showErrorSnackbar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'dismiss'.tr,
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  /// Handle add to cart functionality
  /// Handle add to cart functionality
  Future<void> _handleAddToCart() async {
    // First check if user is logged in
    final bool loggedIn = await isLoggedIn();
    if (!loggedIn) {
      if (!mounted) return;
      navigateToLogin(context, AppStrings.pleaseLogInToCart);
      return;
    }

    // Validate extra options
    if (!_validateExtraOptions()) {
      return;
    }

    // Proceed with adding to cart
    setState(() {
      _isAddingToCart = true;
    });

    try {
      if (!mounted) return;
      final cartProvider = context.read<CartProvider>();

      final result = await cartProvider.addToCart(
        widget.productVariationID,
        1,
        selectedExtraOptions: widget.selectedExtraOptions,
        selectedAttributes: widget.selectedAttributes,
      );

      // Handle the result in UI
      if (mounted) {
        if (result.success) {
          AppUtils.showToast(result.message, isSuccess: true);

          // Optionally refresh user data if needed
          // context.read<UserProvider>().fetchUserData();
        } else {
          AppUtils.showToast(result.message);
        }
      }
    } catch (e) {
      // Handle unexpected errors
      if (mounted) {
        _showErrorSnackbar('Failed to add item to cart. Please try again.'.tr);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  /// Handle wishlist functionality
  Future<void> _handleWishlistToggle() async {
    // First check if user is logged in
    final bool loggedIn = await isLoggedIn();
    if (!loggedIn) {
      if (!mounted) return;
      navigateToLogin(context, AppStrings.pleaseLogInToWishList);
      return;
    }

    setState(() {
      _isWishlistLoading = true;
    });

    widget.updateLoader(true);

    try {
      final wishResult = await _addRemoveWishList();

      if (wishResult != null && mounted) {
        final mainProvider = context.read<ProductItemsProvider>();
        mainProvider.updateWishListData(wishResult.data?.added ?? false);

        // Refresh wishlist data
        await widget.wishlistProvider.fetchWishlist();

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e) {
      // Handle any errors
      if (mounted) {
        _showErrorSnackbar('Failed to update wishlist. Please try again.'.tr);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWishlistLoading = false;
        });
        widget.updateLoader(false);
      }
    }
  }

  Future<WishlistResponseModels?> _addRemoveWishList() async {
    return widget.freshPicksProvider.addRemoveWishList(context, widget.mainProductID);
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final isOutOfStock = widget.productItemsProvider.apiResponse?.data?.record?.outOfStock ?? false;

    return Container(
      color: isDarkMode ? theme.scaffoldBackgroundColor : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Add to Cart Button (only show if not out of stock)
            if (!isOutOfStock) ...[
              Expanded(
                child: AppCustomButton(
                  isLoading: _isAddingToCart || cartProvider.isLoading,
                  onPressed: _handleAddToCart,
                  title: AppStrings.addToCart.tr,
                ),
              ),
              SizedBox(width: widget.screenWidth * 0.04),
            ],

            // Wishlist Button
            Expanded(
              child: _buildWishlistButton(isDarkMode),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistButton(bool isDarkMode) {
    return GestureDetector(
      onTap: _isWishlistLoading ? null : _handleWishlistToggle,
      child: Consumer<ProductItemsProvider>(
        builder: (context, provider, child) {
          inWishList = provider.apiResponse?.data?.record?.inWishList ?? false;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              border: Border.all(
                color: isDarkMode
                    ? (inWishList ? Colors.red : Colors.grey[600]!)
                    : (inWishList ? Colors.red : Colors.grey[400]!),
                width: inWishList ? 2.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(10),
            height: 45,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isWishlistLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDarkMode ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ),
                  )
                else
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      key: ValueKey(inWishList),
                      inWishList ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: inWishList ? Colors.red : (isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    AppStrings.wishlist.tr,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: addToWiShListText(context).copyWith(
                      color: isDarkMode
                          ? (inWishList ? Colors.red : Colors.grey[300])
                          : (inWishList ? Colors.red : Colors.grey[700]),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
