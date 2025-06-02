import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/provider/information_icons_provider/new_products_provider.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../core/widgets/items_empty_view.dart';
import '../../../utils/storage/shared_preferences_helper.dart';
import '../../filters/product_filters_screen.dart';
import '../../filters/product_sorting.dart';
import '../../product_detail_screens/product_detail_screen.dart';

class NewProductPageScreen extends StatefulWidget {
  const NewProductPageScreen({super.key});

  @override
  State<NewProductPageScreen> createState() => _NewProductPageScreenState();
}

class _NewProductPageScreenState extends State<NewProductPageScreen> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // default to false
  int _currentPage = 1;
  Map<String, List<int>> selectedFilters = {'Categories': [], 'Brands': [], 'Tags': [], 'Prices': [], 'Colors': []};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNewProducts();
      fetchNewProductsItems();
      fetchWishListItems();
      _scrollController.addListener(_onScroll);
    });
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchNewProductsItems();
    }
  }

  Future<void> fetchNewProducts() async {
    final product = Provider.of<NewProductsProvider>(context, listen: false);
    product.fetchProducts(context);
  }

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<NewProductsProvider>(context, listen: false).fetchProductsNew(
        context: context,
        perPage: 12,
        page: _currentPage,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
      );
      setState(() {
        _isFetchingMore = false;
      });
    } catch (error) {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<NewProductsProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    final provider = Provider.of<NewProductsProvider>(context);

    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<NewProductsProvider>(
                builder: (ctx, provider, child) {
                  if (provider.isLoading && _currentPage == 1) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  } else if (provider.errorMessage != null) {
                    return Center(child: Text(provider.errorMessage!));
                  } else if (provider.product != null) {
                    final product = provider.product!;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSearchBar(hintText: "Search ${product.name.toString()}"),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: product.coverImage,
                                    fit: BoxFit.fill,
                                    height: 100,
                                    placeholder: (BuildContext context, String url) {
                                      return Container(
                                        height: MediaQuery.sizeOf(context).height * 0.28,
                                        width: double.infinity,
                                        color: Colors.blueGrey[300], // Background color
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/placeholder.png', // Replace with your actual image path
                                              fit: BoxFit.cover, // Adjust fit if needed
                                              height: MediaQuery.sizeOf(context).height * 0.28,
                                              width: double.infinity,
                                            ),
                                            const CupertinoActivityIndicator(
                                              radius: 16, // Adjust size of the loader
                                              animating: true,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: SortAndFilterDropdown(
                                          selectedSortBy: _selectedSortBy,
                                          onSortChanged: (newSortBy) {
                                            _onSortChanged(newSortBy);
                                          },
                                          onFilterPressed: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder: (context) => FilterBottomSheet(
                                                filters: freshPicksProvider.productFilters,
                                                selectedIds: selectedFilters,
                                              ), // Show the filter bottom sheet
                                            ).then((result) {
                                              if (result != null) {
                                                setState(() {
                                                  _currentPage = 1;
                                                  selectedFilters = result; // Store the selected filter IDs
                                                });
                                                fetchNewProductsItems();
                                              }
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      provider.products.isEmpty
                                          ? ItemsEmptyView()
                                          : GridView.builder(
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                                              itemCount: provider.products.length + (_isFetchingMore ? 1 : 0),
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                if (_isFetchingMore && index == provider.products.length) {
                                                  return const Align(
                                                    alignment: Alignment.center,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Center(
                                                          child: SizedBox(
                                                            height: 25,
                                                            width: 25,
                                                            child: CircularProgressIndicator(
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }

                                                final product = provider.products[index];

                                                /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                                                double? frontSalePrice = product.prices?.frontSalePrice?.toDouble();
                                                double? price = product.prices?.price?.toDouble();
                                                String offPercentage = '';

                                                if (frontSalePrice != null && price != null && price > 0) {
                                                  // Calculate the discount percentage
                                                  double discount = 100 - ((frontSalePrice / price) * 100);
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
                                                                  slug: product.slug.toString(),
                                                                )));
                                                  },
                                                  child: ProductCard(
                                                    isOutOfStock: product.outOfStock ?? false,
                                                    off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                                    // Display the discount percentage
                                                    priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0) ? product.prices!.priceWithTaxes : null,
                                                    itemsId: 0,
                                                    imageUrl: product.image,
                                                    frontSalePriceWithTaxes: product.review?.average ?? '0',
                                                    name: product.name,
                                                    storeName: product.store!.name.toString(),
                                                    price: product.prices?.frontSalePrice.toString(),
                                                    // price: product.prices!.price.toString(),
                                                    reviewsCount: product.review!.reviewsCount!.toInt(),

                                                    optionalIcon: Icons.shopping_cart,
                                                    onOptionalIconTap: () async {
                                                      final token = await SecurePreferencesUtil.getToken();
                                                      if (token != null) {
                                                        await cartProvider.addToCart(product.id, context, 1);
                                                      }
                                                    },
                                                    isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                                    onHeartTap: () async {
                                                      final token = await SecurePreferencesUtil.getToken();
                                                      bool isInWishlist =
                                                          wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false;
                                                      if (isInWishlist) {
                                                        await wishlistProvider.deleteWishlistItem(product.id ?? 0, context, token ?? '');
                                                      } else {
                                                        await freshPicksProvider.handleHeartTap(context, product.id ?? 0);
                                                      }
                                                      await wishlistProvider.fetchWishlist(token ?? '', context);
                                                    },
                                                  ),
                                                );
                                              })
                                    ],
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              ),
              if (wishlistProvider.isLoading || freshPicksProvider.isLoading || cartProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5), // Semi-transparent background
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
