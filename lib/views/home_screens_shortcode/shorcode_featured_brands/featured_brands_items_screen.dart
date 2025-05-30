import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../utils/storage/shared_preferences_helper.dart';
import '../../filters/product_filters_screen.dart';
import '../../filters/product_sorting.dart';
import '../../product_detail_screens/product_detail_screen.dart';

class FeaturedBrandsItemsScreen extends StatefulWidget {
  final String slug;

  const FeaturedBrandsItemsScreen({super.key, required this.slug});

  @override
  State<FeaturedBrandsItemsScreen> createState() => _FeaturedBrandsItemsScreenState();
}

class _FeaturedBrandsItemsScreenState extends State<FeaturedBrandsItemsScreen> {
  String _currentTab = 'Products';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMoreProducts = false;
  int _currentPageProducts = 1;
  String _selectedSortBy = 'default_sorting';
  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  ///  PACKAGES
  int _currentPagePackages = 1;
  bool _isFetchingMorePackages = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTopBanner();
      fetchBrandProductItemsData();
      fetchWishListItems();
      _scrollController.addListener(_onScroll);
    });
  }

  ///  ++++++++++++++++++++++++++   TOP BANNER BRANDS  +++++++++++++++++++++++++++++
  Future<void> fetchTopBanner() async {
    final provider = Provider.of<FeaturedBrandsProvider>(context, listen: false);
    provider.fetchBrandData(widget.slug, context);
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SharedPreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  /// ------------   PRODUCTS SCROLLING FUNCTION   ------------
  void _onScroll() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      if (mounted) {
        setState(() {
          _currentPageProducts++;
          _isFetchingMoreProducts = true;
        });
      }
      fetchBrandProductItemsData();
    }
  }

  /// ------------   PRODUCTS DATA FUNCTION    ------------

  Future<void> fetchBrandProductItemsData() async {
    try {
      await Provider.of<FeaturedBrandsProvider>(context, listen: false).fetchBrandsProducts(
        context: context,
        slug: widget.slug,
        perPage: 12,
        page: _currentPageProducts,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
      );
      if (mounted) {
        setState(() {
          _isFetchingMoreProducts = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMoreProducts = false;
        });
      }
    }
  }

  /// ------------   PRODUCTS SORTING  FUNCTION   ------------

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1;

        /// Reset to the first page
        Provider.of<FeaturedBrandsProvider>(context, listen: false).records.clear(); //
      });
    }
    fetchBrandProductItemsData();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final freshListProvider = Provider.of<FreshPicksProvider>(context, listen: true);
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
              Consumer<FeaturedBrandsProvider>(
                builder: (context, brandProvider, child) {
                  if (brandProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
                  }
                  final brandData = brandProvider.brandModel;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomSearchBar(hintText: "Search ${widget.slug.replaceAll("-", " ")}"),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///   -----   TOP BANNER IMAGE =================================================================
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: brandData?.coverImage ?? '',
                                    height: 100,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorListener: (object){
                                      Image.asset(
                                        'assets/placeholder.png', // Replace with your actual image path
                                        fit: BoxFit.cover, // Adjust fit if needed
                                        height: MediaQuery.sizeOf(context).height * 0.28,
                                        width: double.infinity,
                                      );
                                    },
                                    errorWidget: (context,object,error){
                                      return Image.asset(
                                        'assets/placeholder.png', // Replace with your actual image path
                                        fit: BoxFit.cover, // Adjust fit if needed
                                        height: MediaQuery.sizeOf(context).height * 0.28,
                                        width: double.infinity,
                                      );
                                    },
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

                                ///======  TAB BAR  =========================================

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _currentTab = 'Products';
                                              });
                                            },
                                            child: Container(
                                              // padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: _currentTab == 'Products' ? Colors.grey : Colors.transparent),
                                                  borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(
                                                      'Products',
                                                      style: topTabBarStyle(context),
                                                    ),
                                                  ),
                                                  if (_currentTab == 'Products') Container()
                                                ],
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
                                              // padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: _currentTab == 'Packages' ? Colors.grey : Colors.transparent,
                                                ),
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(
                                                      'Packages',
                                                      style: topTabBarStyle(context),
                                                    ),
                                                  ),
                                                  if (_currentTab == 'Packages') const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Container(
                                          color: Colors.grey,
                                          height: 1,
                                          width: double.infinity,
                                        )
                                      ],
                                    )
                                  ],
                                ),

                                ///======  TAB PAGES VIEW =================================
                                _currentTab == 'Products' ? _ProductsView(slug: widget.slug) : _PackagesView(slug: widget.slug),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading)
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

  ///  ------------------------ BRANDS PRODUCTS VIEW --------------------------------
  Widget _ProductsView({required String slug}) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<FeaturedBrandsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingProducts && _currentPageProducts == 1) {
              return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.0, vertical: screenHeight * 0.01),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
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
                            _currentPageProducts = 1;
                            selectedFilters = result; // Store the selected filter IDs
                          });
                          fetchBrandProductItemsData();
                        });
                      },
                    ),
                    provider.records.isEmpty
                        ? ItemsEmptyView()
                        : GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                            itemCount: provider.records.length + (_isFetchingMoreProducts ? 1 : 0),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (_isFetchingMoreProducts && index == provider.records.length) {
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

                              final product = provider.records[index];

                              /// Calculate the percentage off
                              /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                              dynamic frontSalePrice = product.prices?.frontSalePrice;
                              dynamic price = product.prices?.price;
                              String offPercentage = '';

                              if (frontSalePrice != null && price != null && price > 0) {
                                // Calculate the discount percentage
                                dynamic discount = 100 - ((frontSalePrice / price) * 100);
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
                                  off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                  // Display the discount percentage
                                  priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0) ? product.prices!.priceWithTaxes : null,
                                  itemsId: 0,
                                  imageUrl: product.image,
                                  frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                                  name: product.name,
                                  storeName: product.store?.name.toString(),
                                  price: product.prices?.price.toString(),
                                  optionalIcon: Icons.shopping_cart_checkout_rounded,
                                  reviewsCount: product.review?.reviewsCount?.toInt(),
                                  onOptionalIconTap: () async {
                                    final token = await SharedPreferencesUtil.getToken();
                                    if (token != null) {
                                      await cartProvider.addToCart(product.id, context, 1);
                                    }
                                  },
                                  isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                  onHeartTap: () async {
                                    final token = await SharedPreferencesUtil.getToken();
                                    bool isInWishlist = wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false;
                                    if (isInWishlist) {
                                      await wishlistProvider.deleteWishlistItem(product.id ?? 0, context, token ?? '');
                                    } else {
                                      await freshPicksProvider.handleHeartTap(context, product.id ?? 0);
                                    }
                                    await wishlistProvider.fetchWishlist(token ?? '', context);
                                  },
                                ),
                              );
                            }),
                  ],
                ),
              );
            }
          },
        )
      ],
    );
  }

  ///  -------------------------  BRANDS PACKAGES VIEW --------------------------------

  Widget _PackagesView({required String slug}) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Consumer<FeaturedBrandsProvider>(
            builder: (context, provider, child) {
              if (provider.isLoadingPackages && _currentPagePackages == 1) {
                return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
              } else if (provider.recordsPackages.isEmpty) {
                return Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                    child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(color: AppColors.lightCoral),
                        height: 50,
                        child: const Align(alignment: Alignment.center, child: Text('No records found!'))));
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSortBy,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              _onSortChanged(newValue);
                            }
                          },
                          items: [
                            DropdownMenuItem(value: 'default_sorting', child: Text('Default Sorting', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'date_asc', child: Text('Oldest', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'date_desc', child: Text('Newest', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'name_asc', child: Text('Name: A-Z', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'name_desc', child: Text('Name: Z-A', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'price_asc', child: Text('Price: low to high', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'price_desc', child: Text('Price: high to low', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'rating_asc', child: Text('Rating: low to high', style: sortingStyle(context))),
                            DropdownMenuItem(value: 'rating_desc', child: Text('Rating: high to low', style: sortingStyle(context))),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Column(
                            children: [
                              GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                                  itemCount: provider.recordsPackages.length + (_isFetchingMorePackages ? 1 : 0),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    if (_isFetchingMorePackages && index == provider.recordsPackages.length) {
                                      return const Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.black,
                                                strokeWidth: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }

                                    final product = provider.recordsPackages[index];

                                    /// Calculate the percentage off
                                    /// Check if both frontSalePrice and price are non-null and non-zero to avoid division by zero
                                    dynamic frontSalePrice = product.prices?.frontSalePrice;
                                    dynamic price = product.prices?.price;
                                    String offPercentage = '';

                                    if (frontSalePrice != null && price != null && price > 0) {
                                      // Calculate the discount percentage
                                      dynamic discount = 100 - ((frontSalePrice / price) * 100);
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
                                        itemsId: 0,
                                        imageUrl: product.image,
                                        frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes,
                                        name: product.name,
                                        storeName: product.store?.name.toString(),
                                        price: product.prices?.frontSalePriceWithTaxes,
                                        reviewsCount: product.review!.reviewsCount!.toInt(),
                                        off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                        // Display the discount percentage
                                        priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0) ? product.prices!.priceWithTaxes : null,
                                        optionalIcon: Icons.shopping_cart_checkout_rounded,
                                        onOptionalIconTap: () async {
                                          final token = await SharedPreferencesUtil.getToken();
                                          if (token != null) {
                                            await cartProvider.addToCart(product.id, context, 1);
                                          }
                                        },

                                        isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                        onHeartTap: () async {
                                          final token = await SharedPreferencesUtil.getToken();
                                          bool isInWishlist = wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false;
                                          if (isInWishlist) {
                                            await wishlistProvider.deleteWishlistItem(product.id ?? 0, context, token ?? '');
                                          } else {
                                            await freshPicksProvider.handleHeartTap(context, product.id ?? 0);
                                          }
                                          await wishlistProvider.fetchWishlist(token ?? '', context);
                                        },
                                      ),
                                    );
                                  }),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }
}
