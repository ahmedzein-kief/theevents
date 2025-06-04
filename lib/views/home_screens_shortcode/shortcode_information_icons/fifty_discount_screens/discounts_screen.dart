// import 'package:event_app/views/base_screens/base_app_bar.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../provider/information_icons_provider/fifty_discount_provider.dart';
// import '../../../../resources/styles/app_strings.dart';
// import '../../../../resources/styles/custom_text_styles.dart';
// import '../../../../resources/widgets/custom_app_views/search_bar.dart';
// import 'discount_packages.dart';
// import 'discounts_products.dart';
//
// class DiscountScreen extends StatefulWidget {
//   const DiscountScreen({super.key});
//
//   @override
//   State<DiscountScreen> createState() => _DiscountScreenState();
// }
//
// class _DiscountScreenState extends State<DiscountScreen> {
//   String _currentTab = 'Products';
//   int _currentPage = 1;
//   String _selectedSortBy = 'default_sorting';
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       fetchHalfDiscountBanner();
//     });
//   }
//
//   //   BANNER OF FIFTY PERCENT DISCOUNTS
//   Future<void> fetchHalfDiscountBanner() async {
//     final provider =
//     Provider.of<FiftyPercentDiscountProvider>(context, listen: false);
//     provider.fetchBannerFiftyPercentDiscount();
//   }
//
//   Future<void> fetchNewProductsItems() async {
//     try {
//       await Provider.of<FiftyPercentDiscountProvider>(context, listen: false)
//           .fetchProductsNew(
//         perPage: 12,
//         page: _currentPage,
//         sortBy: _selectedSortBy,
//       );
//     } catch (error) {
//       print('Error: $error');
//     }
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     double screenWidth = MediaQuery.sizeOf(context).width;
//     double screenHeight = MediaQuery.sizeOf(context).height;
//     return BaseAppBar(
//       firstRightIconPath: AppStrings.firstRightIconPath,
//       secondRightIconPath: AppStrings.secondRightIconPath,
//       thirdRightIconPath: AppStrings.thirdRightIconPath,
//       body: Scaffold(
//         body: SafeArea(child: Consumer<FiftyPercentDiscountProvider>(
//           builder: (context, provider, child) {
//             if (provider.isLoading) {
//               return const Center(
//                   child: CircularProgressIndicator(
//                     color: Colors.black,
//                     strokeWidth: 0.5,
//                   ));
//             } else {
//               final data = provider.halfDiscountModels?.data;
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   CustomSearchBar(
//                     hintText: "Search ${data?.name.toString()}",
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(
//                         left: screenWidth * 0.02,
//                         right: screenWidth * 0.02,
//                         top: screenHeight * 0.02),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child: Image.network(
//                               data!.coverImage,
//                               height: screenHeight * 0.14,
//                               fit: BoxFit.cover,
//                               width: screenWidth,
//                               errorBuilder: (BuildContext context, Object error,
//                                   StackTrace? stackTrace) {
//                                 return Container(
//                                     height: screenHeight * 0.14,
//                                     width: double.infinity,
//                                     decoration: const BoxDecoration(
//                                         gradient: LinearGradient(
//                                             colors: [Colors.grey, Colors.black])),
//                                     child: const CupertinoActivityIndicator(
//                                         color: Colors.black,
//                                         radius: 10,
//                                         animating: true));
//                               },
//                             ),
//                           ),
//                           Padding(
//                               padding: const EdgeInsets.only(top: 10),
//                               child: Text(data.name, style: boldHomeTextStyle())),
//                           Padding(
//                             padding: const EdgeInsets.only(top: 20),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: <Widget>[
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _currentTab = 'Products';
//                                         });
//                                       },
//                                       child: Container(
//                                         // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
//                                         decoration: BoxDecoration(
//                                             border: Border.all(
//                                                 color: _currentTab == 'Products'
//                                                     ? Colors.grey
//                                                     : Colors.transparent),
//                                             borderRadius: const BorderRadius.only(
//                                               topRight: Radius.circular(10),
//                                               topLeft: Radius.circular(10),
//                                             )),
//                                         child: Column(
//                                           // mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(4),
//                                               child: Text(
//                                                 'Products',
//                                                 style: topTabBarStyle(context),
//                                               ),
//                                             ),
//                                             if (_currentTab == 'Products')
//                                               Container()
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                     GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _currentTab = 'Packages';
//                                         });
//                                       },
//                                       child: Container(
//                                         // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                                         decoration: BoxDecoration(
//                                           border: Border.all(
//                                             color: _currentTab == 'Packages'
//                                                 ? Colors.grey
//                                                 : Colors.transparent,
//                                           ),
//                                           borderRadius: const BorderRadius.only(
//                                             topRight: Radius.circular(10),
//                                             topLeft: Radius.circular(10),
//                                           ),
//                                         ),
//                                         child: Column(
//                                           // mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             Padding(
//                                               padding: const EdgeInsets.all(4),
//                                               child: Text(
//                                                 'Packages',
//                                                 style: topTabBarStyle(context),
//                                               ),
//                                             ),
//                                             if (_currentTab == 'Packages')
//                                               const SizedBox.shrink(),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 Column(
//                                   children: [
//                                     Container(
//                                       color: Colors.grey,
//                                       height: 1,
//                                       // width: double.infinity,
//                                     )
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: _currentTab == 'Products'
//                         ? const DiscountsProducts()
//                         : const DiscountPackages(),
//                   ),
//                 ],
//               );
//             }
//           },
//         )),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/information_icons_provider/fifty_discount_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/product_filters_screen.dart';
import '../../../filters/product_sorting.dart';
import '../../../product_detail_screens/product_detail_screen.dart';
import 'discount_packages.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  String _currentTab = 'Products';
  int _currentPage = 1;
  String _selectedSortBy = 'default_sorting';
  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHalfDiscountBanner();

      fetchWishListItems();
      fetchNewProductsItems();
      _scrollController.addListener(_onScroll);
    });
  }

  ///   BANNER OF FIFTY PERCENT DISCOUNTS  --------------------------------
  Future<void> fetchHalfDiscountBanner() async {
    final provider =
        Provider.of<FiftyPercentDiscountProvider>(context, listen: false);
    provider.fetchBannerFiftyPercentDiscount(context);
  }

  bool _isFetchingMore = false; // default to false
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent
        // && !_scrollController.position.outOfRange
        ) {
      _currentPage++;
      _isFetchingMore = true;
      fetchNewProductsItems();
    }
  }

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<FiftyPercentDiscountProvider>(context, listen: false)
          .fetchProductsNew(
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
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
        });
      }
    }
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  @override
  void dispose() {
    _scrollController
        .removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1; // Reset to the first page
      Provider.of<FiftyPercentDiscountProvider>(context, listen: false)
          .products
          .clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    final wishlistProvider =
        Provider.of<WishlistProvider>(context, listen: true);
    final freshListProvider =
        Provider.of<FreshPicksProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);

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
              Consumer<FiftyPercentDiscountProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  } else {
                    final data = provider.halfDiscountModels?.data;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const CustomSearchBar(
                          hintText: 'Search Discounts',
                        ),

                        // Scrollable Content
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.02,
                                  vertical: screenHeight * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  /// ========= BANNER  IMAGE =========

                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: data?.coverImage ?? '',
                                      height: screenHeight * 0.14,
                                      fit: BoxFit.cover,
                                      width: screenWidth,
                                      placeholder:
                                          (BuildContext context, String url) =>
                                              Container(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.28,
                                        width: double.infinity,
                                        color: Colors
                                            .blueGrey[300], // Background color
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/placeholder.png', // Replace with your actual image path
                                              fit: BoxFit
                                                  .cover, // Adjust fit if needed
                                              height: MediaQuery.sizeOf(context)
                                                      .height *
                                                  0.28,
                                              width: double.infinity,
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

                                  /// ========= NAME ARGUMENTS HERE =========
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(data?.name ?? '50% Discount',
                                        style: boldHomeTextStyle()),
                                  ),

                                  /// ======  TAB HERE ========

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentTab = 'Products';
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: _currentTab ==
                                                              'Products'
                                                          ? Colors.grey
                                                          : Colors.transparent),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Text(
                                                    'Products',
                                                    style:
                                                        topTabBarStyle(context),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _currentTab = 'Packages';
                                                });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: _currentTab ==
                                                            'Packages'
                                                        ? Colors.grey
                                                        : Colors.transparent,
                                                  ),
                                                  borderRadius:
                                                      const BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(10),
                                                    topLeft:
                                                        Radius.circular(10),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: Text(
                                                    'Packages',
                                                    style:
                                                        topTabBarStyle(context),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          color: Colors.grey,
                                          height: 1,
                                        ),
                                      ],
                                    ),
                                  ),

                                  /// ======= PRODUCTS AND PACKAGES =========

                                  // _currentTab == 'Products'
                                  //     ? const DiscountsProducts()
                                  //     : const DiscountPackages(),

                                  if (_currentTab == 'Products')
                                    _productsView()
                                  else
                                    const DiscountPackages(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
              if (wishlistProvider.isLoading ||
                  freshListProvider.isLoading ||
                  cartProvider.isLoading)
                Container(
                  color: Colors.black
                      .withOpacity(0.5), // Semi-transparent background
                  child: const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productsView() {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    return Center(
      child: Consumer<FiftyPercentDiscountProvider>(
        builder: (ctx, provider, child) {
          if (provider.isLoadingProducts) {
            return const Center(
                child: CircularProgressIndicator(
                    color: Colors.black, strokeWidth: 0.5));
          } else {
            return SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SortAndFilterDropdown(
                    selectedSortBy: _selectedSortBy,
                    onSortChanged: (newSortBy) {
                      _onSortChanged(newSortBy);
                    },
                    onFilterPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => FilterBottomSheet(
                          filters: provider.productFilters,
                          selectedIds: selectedFilters,
                        ), // Show the filter bottom sheet
                      ).then((result) {
                        setState(() {
                          _currentPage = 1;
                          selectedFilters =
                              result; // Store the selected filter IDs
                        });
                        fetchNewProductsItems();
                      });
                    },
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (provider.products.isEmpty)
                        const ItemsEmptyView()
                      else
                        GridView.builder(
                          scrollDirection: Axis.vertical,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.6,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                          itemCount: provider.products.length +
                              (_isFetchingMore ? 1 : 0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (_isFetchingMore &&
                                index == provider.products.length) {
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
                            final double? frontSalePrice =
                                product.prices?.frontSalePrice?.toDouble();
                            final double? price =
                                product.prices?.price?.toDouble();
                            String offPercentage = '';

                            if (frontSalePrice != null &&
                                price != null &&
                                price > 0) {
                              /// Calculate the discount percentage
                              final double discount =
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
                                      key: ValueKey(product.slug.toString()),
                                      slug: product.slug.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: ProductCard(
                                isOutOfStock: product.outOfStock ?? false,
                                off: offPercentage.isNotEmpty
                                    ? '$offPercentage%off'
                                    : '',
                                // Display the discount percentage
                                priceWithTaxes:
                                    (product.prices?.frontSalePrice ?? 0) <
                                            (product.prices?.price ?? 0)
                                        ? product.prices!.priceWithTaxes
                                        : null,
                                itemsId: 0,
                                imageUrl: product.image,
                                frontSalePriceWithTaxes:
                                    product.review?.average ?? '0',
                                name: product.name,
                                storeName: product.store?.name.toString(),
                                price: product.prices?.price.toString(),
                                reviewsCount:
                                    product.review?.reviewsCount?.toInt(),
                                optionalIcon: Icons.shopping_cart,
                                onOptionalIconTap: () async {
                                  final token =
                                      await SecurePreferencesUtil.getToken();
                                  if (token != null) {
                                    await cartProvider.addToCart(
                                        product.id, context, 1);
                                  }
                                },
                                isHeartObscure: wishlistProvider
                                        .wishlist?.data?.products
                                        .any((wishlistProduct) =>
                                            wishlistProduct.id == product.id) ??
                                    false,
                                onHeartTap: () async {
                                  final token =
                                      await SecurePreferencesUtil.getToken();
                                  final bool isInWishlist = wishlistProvider
                                          .wishlist?.data?.products
                                          .any((wishlistProduct) =>
                                              wishlistProduct.id ==
                                              product.id) ??
                                      false;
                                  if (isInWishlist) {
                                    await wishlistProvider.deleteWishlistItem(
                                        product.id ?? 0, context, token ?? '');
                                  } else {
                                    await freshPicksProvider.handleHeartTap(
                                        context, product.id ?? 0);
                                  }
                                  await wishlistProvider.fetchWishlist(
                                      token ?? '', context);
                                },
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
