import 'package:event_app/provider/wishlist_items_provider/wishlist_provider.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../core/widgets/custom_app_views/app_bar.dart';
import '../../core/widgets/custom_slider_route.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../cart_screens/cart_items_screen.dart';
import '../wish_list_screens/like_items_screen.dart';

class BaseAppBar extends StatefulWidget {
  final Widget? body;
  final String? leftIconPath;
  final String? firstRightIconPath;
  final String? secondRightIconPath;
  final String? thirdRightIconPath;
  final Widget? leftWidget;
  final VoidCallback? onFirstRightIconPressed;
  final VoidCallback? onSecondRightIconPressed;
  final VoidCallback? onThirdRightIconPressed;
  VoidCallback? onBackPressed;
  final Color? color;
  final String? leftText;
  final String? textBack;
  final Widget? customBackIcon;
  final String? title;

  BaseAppBar({
    this.body,
    this.leftIconPath,
    this.leftWidget,
    this.customBackIcon,
    this.leftText,
    this.firstRightIconPath,
    this.secondRightIconPath,
    this.thirdRightIconPath,
    this.onFirstRightIconPressed,
    this.onSecondRightIconPressed,
    this.onThirdRightIconPressed,
    this.onBackPressed,
    this.color,
    this.textBack,
    this.title,
  });

  @override
  State<BaseAppBar> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseAppBar> {
  late bool _isLoggedIn = false;

  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  /// +++++++++++++++++++ FUNCTION to fetch the cart item count   =================================================================
  Future<void> _fetchCartItemCount() async {
    final token = await SecurePreferencesUtil.getToken();
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.fetchCartData(token ?? '', context);
  }

  /// +++++++++++++++++++ FUNCTION FOR  FETCH THE WISH LIST ITEM COUNT  =================================================================

  Future<void> _fetchWishListCount() async {
    final token = await SecurePreferencesUtil.getToken();
    final cartProvider = Provider.of<WishlistProvider>(context, listen: false);
    await cartProvider.fetchWishlist(token ?? '', context); // Ensure the provider fetches cart data
  }

  @override
  void initState() {
    super.initState();
    _fetchCartItemCount();
    _fetchWishListCount();
    _loadLoginState();
  }

  @override
  Widget build(BuildContext context) {
    /// -----------  ITEMS COUNT CART =================================
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemCount = cartProvider.cartResponse?.data.count ?? 0;

    /// -----------  ITEMS COUNT WISHLIST =================================

    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemCount = wishlistProvider.wishlist?.data?.count ?? 0;

    if (widget.onBackPressed == null) {
      widget.onBackPressed = () {
        Navigator.pop(context);
      };
    }

    return Scaffold(
      appBar: CustomAppBar(
        firstRightIconPath: widget.firstRightIconPath,
        secondRightIconPath: widget.secondRightIconPath,
        thirdRightIconPath: widget.thirdRightIconPath,
        leftText: widget.textBack,
        customBackIcon: widget.customBackIcon,
        onBackIconPressed: widget.onBackPressed,
        onFirstRightIconPressed: _navigateToNotifications,
        onSecondRightIconPressed: _navigateToWishList,
        onThirdRightIconPressed: _navigateToCart,

        backgroundColor: widget.color ?? Colors.transparent,
        // Pass the color here
        /// -----------  CART ITEMS COUNT =================================
        cartItemCount: cartItemCount,
        wishlistItemCount: wishlistItemCount,
        title: widget.title ?? "",
      ),
      body: widget.body,
      backgroundColor: widget.color,
    );
  }

  bool _isNavigating = false;

  ///  navigate to notification screen
  void _navigateToNotifications() {
    // if (_isNavigating) return;
    // _isNavigating = true; // Set the flag to true
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: OrderPageScreen()),
      (Route<dynamic> route) => route.isFirst,
    ).then((_) {
      // _isNavigating = false; // Reset the flag after navigation completes
    });
  }

  void _navigateToWishList() {
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: WishListScreen()),
      (Route<dynamic> route) => route.isFirst, // Keep only the first screen
    );
  }

  void _navigateToCart() {
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: CartItemsScreen()),
      (Route<dynamic> route) => route.isFirst, // Keep only the first screen
    );
  }
}
