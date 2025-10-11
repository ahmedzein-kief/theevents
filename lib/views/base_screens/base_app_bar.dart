import 'package:event_app/provider/wishlist_items_provider/wishlist_provider.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_information_icons/order_pages_screens/order_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/styles/app_colors.dart';
import '../../core/widgets/custom_app_views/app_bar.dart';
import '../../core/widgets/custom_slider_route.dart';
import '../../core/widgets/padded_network_banner.dart';
import '../../models/dashboard/feature_categories_model/product_category_model.dart';
import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/search_suggestions_provider.dart';
import '../cart_screens/cart_items_screen.dart';
import '../search_screen/search_screen.dart';
import '../wish_list_screens/like_items_screen.dart';

class BaseAppBar extends StatefulWidget {
  const BaseAppBar({
    super.key,
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
    this.iconsColor,
    this.leftTextStyle,
    this.showSearchBar = false,
    this.searchController,
    this.searchHintText = 'Search Events',
  });

  final Color? iconsColor;
  final Widget? body;
  final String? leftIconPath;
  final String? firstRightIconPath;
  final String? secondRightIconPath;
  final String? thirdRightIconPath;
  final Widget? leftWidget;
  final VoidCallback? onFirstRightIconPressed;
  final VoidCallback? onSecondRightIconPressed;
  final VoidCallback? onThirdRightIconPressed;
  final VoidCallback? onBackPressed;
  final Color? color;
  final String? leftText;
  final String? textBack;
  final Widget? customBackIcon;
  final String? title;
  final TextStyle? leftTextStyle;
  final bool showSearchBar;
  final TextEditingController? searchController;
  final String searchHintText;

  @override
  State<BaseAppBar> createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseAppBar> {
  bool _showSuggestions = false;
  List<Records>? _lastSuggestions;
  FocusNode? _searchFocusNode;

  @override
  void initState() {
    super.initState();

    // Defer API calls until after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCartItemCount();
      _fetchWishListCount();
    });

    if (widget.showSearchBar) {
      _searchFocusNode = FocusNode();
      _searchFocusNode!.addListener(() {
        if (!_searchFocusNode!.hasFocus) {
          if (widget.searchController?.text.isEmpty ?? true) {
            setState(() => _showSuggestions = false);
          }
        }
      });

      widget.searchController?.addListener(_onSearchChanged);
    }
  }

  @override
  void dispose() {
    _searchFocusNode?.dispose();
    widget.searchController?.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onSearchChanged() {
    if (!widget.showSearchBar) return;

    final provider = Provider.of<SearchSuggestionsProvider>(context, listen: false);
    final value = widget.searchController?.text ?? '';

    if (value.isNotEmpty) {
      provider.fetchSearchBarSuggestion(value);
      if (!_showSuggestions) {
        setState(() => _showSuggestions = true);
      }
    } else {
      provider.clearSearchSuggestions();
      setState(() => _showSuggestions = false);
    }
  }

  /// +++++++++++++++++++ FUNCTION to fetch the cart item count   =================================================================
  Future<void> _fetchCartItemCount() async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    await cartProvider.fetchCartData();
  }

  /// +++++++++++++++++++ FUNCTION FOR  FETCH THE WISH LIST ITEM COUNT  =================================================================

  Future<void> _fetchWishListCount() async {
    final cartProvider = Provider.of<WishlistProvider>(context, listen: false);
    await cartProvider.fetchWishlist();
  }

  Widget _buildSuggestionsOverlay() {
    if (!_showSuggestions || !widget.showSearchBar) return const SizedBox.shrink();

    return Consumer<SearchSuggestionsProvider>(
      builder: (context, provider, child) {
        final List<Records>? suggestions = provider.suggestionsList ?? _lastSuggestions;

        if (provider.suggestionsList != null) {
          _lastSuggestions = provider.suggestionsList;
        }

        if (provider.isLoadingSuggestions && suggestions == null) {
          return Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.searchBackground,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const SizedBox(
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
          );
        }

        if (suggestions == null || suggestions.isEmpty) {
          return Positioned(
            top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.searchBackground,
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.1 * 255).toInt()),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const SizedBox(
                  height: 60,
                  child: Center(child: Text('No results found')),
                ),
              ),
            ),
          );
        }

        // Limit to 12 items
        final limitedSuggestions = suggestions.take(12).toList();
        final hasMoreResults = suggestions.length > 12;
        final currentQuery = widget.searchController?.text ?? '';

        return Positioned(
          top: kToolbarHeight + MediaQuery.of(context).padding.top + 10,
          left: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.searchBackground,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha((0.1 * 255).toInt()),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4, // Increased for "See all" button
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Suggestions list
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: limitedSuggestions.length,
                      separatorBuilder: (_, __) => Divider(
                        height: 1,
                        color: AppColors.semiTransparentBlack.withAlpha((0.1 * 255).toInt()),
                      ),
                      itemBuilder: (context, index) {
                        final suggestion = limitedSuggestions[index];
                        return ListTile(
                          dense: true,
                          leading: suggestion.image != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: PaddedNetworkBanner(
                                    imageUrl: suggestion.image!,
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                    padding: EdgeInsets.zero,
                                    borderRadius: 6,
                                  ),
                                )
                              : const Icon(Icons.shopping_bag_outlined),
                          title: Text(
                            suggestion.name ?? 'No Name',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: suggestion.store?.name != null
                              ? Text(
                                  suggestion.store!.name!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.6 * 255).toInt()),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : null,
                          trailing: suggestion.prices?.frontSalePrice != null
                              ? Text(
                                  'AED ${suggestion.prices!.frontSalePrice}',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                )
                              : const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                          onTap: () {
                            widget.searchController?.text = suggestion.name ?? '';
                            setState(() => _showSuggestions = false);
                            _searchFocusNode?.unfocus();

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SearchScreen(
                                  query: suggestion.name ?? '',
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  // "See all results" button - only show if there are more than 12 results
                  if (hasMoreResults && currentQuery.isNotEmpty) ...[
                    Divider(
                      height: 1,
                      color: AppColors.semiTransparentBlack.withAlpha((0.2 * 255).toInt()),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() => _showSuggestions = false);
                        _searchFocusNode?.unfocus();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SearchScreen(
                              query: currentQuery,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: AppColors.searchBackground.withAlpha((0.3 * 255).toInt()),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              size: 18,
                              color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.7 * 255).toInt()),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'See all results',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.8 * 255).toInt()),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Theme.of(context).colorScheme.onPrimary.withAlpha((0.7 * 255).toInt()),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    /// -----------  ITEMS COUNT CART =================================
    final cartProvider = Provider.of<CartProvider>(context);
    final cartItemCount = cartProvider.cartResponse?.data.count ?? 0;

    /// -----------  ITEMS COUNT WISHLIST =================================
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final wishlistItemCount = wishlistProvider.wishlist?.data?.count ?? 0;

    return GestureDetector(
      // Add gesture detector to handle tapping outside
      onTap: () {
        if (_showSuggestions) {
          setState(() => _showSuggestions = false);
          _searchFocusNode?.unfocus();
        }
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: CustomAppBar(
              iconsColor: widget.iconsColor,
              firstRightIconPath: widget.firstRightIconPath,
              secondRightIconPath: widget.secondRightIconPath,
              thirdRightIconPath: widget.thirdRightIconPath,
              leftText: widget.textBack,
              leftTextStyle: widget.leftTextStyle,
              customBackIcon: widget.customBackIcon,
              onBackIconPressed: widget.onBackPressed ??
                  () {
                    Navigator.pop(context);
                  },
              onFirstRightIconPressed: _navigateToNotifications,
              onSecondRightIconPressed: _navigateToWishList,
              onThirdRightIconPressed: _navigateToCart,

              backgroundColor: widget.color ?? Colors.transparent,

              /// -----------  CART ITEMS COUNT =================================
              cartItemCount: cartItemCount,
              wishlistItemCount: wishlistItemCount,
              title: widget.title ?? '',

              // Search bar properties
              showSearchBar: widget.showSearchBar,
              searchController: widget.searchController,
              searchHintText: widget.searchHintText,
            ),
            body: GestureDetector(
              // Add gesture detector to body to handle tapping outside suggestions
              onTap: () {
                if (_showSuggestions) {
                  setState(() => _showSuggestions = false);
                  _searchFocusNode?.unfocus();
                }
              },
              child: widget.body,
            ),
            backgroundColor: widget.color,
          ),
          // Suggestions overlay positioned outside the app bar
          if (widget.showSearchBar) _buildSuggestionsOverlay(),
        ],
      ),
    );
  }

  ///  navigate to notification screen
  void _navigateToNotifications() {
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: const OrderPageScreen()),
      (Route<dynamic> route) => route.isFirst,
    ).then((_) {
      // Reset navigation flag if needed
    });
  }

  void _navigateToWishList() {
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: const WishListScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
  }

  void _navigateToCart() {
    Navigator.pushAndRemoveUntil(
      context,
      SlidePageRoute(page: const CartItemsScreen()),
      (Route<dynamic> route) => route.isFirst,
    );
  }
}
