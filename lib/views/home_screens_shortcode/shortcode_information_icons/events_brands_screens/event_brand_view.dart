import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/product_detail_screens/product_detail_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../../core/widgets/items_empty_view.dart';
import '../../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../../provider/home_information_icon_events_brands/events_brand_banner_provider.dart';
import '../../../../provider/home_information_icon_events_brands/product_packages_events_brand.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../filters/product_filters_screen.dart';
import '../../../filters/sort_an_filter_widget.dart';

class EventBrandScreen extends StatefulWidget {
  const EventBrandScreen({super.key});

  @override
  State<EventBrandScreen> createState() => _EventBrandScreenState();
}

class _EventBrandScreenState extends State<EventBrandScreen> {
  String _currentTab = 'Products';
  int _currentPageProducts = 1;
  String _selectedSortBy = 'default_sorting';
  bool _isFetchingMoreProducts = false;
  final ScrollController _scrollController = ScrollController();
  Map<String, List<int>> selectedFilters = {
    'Categories': [],
    'Brands': [],
    'Tags': [],
    'Prices': [],
    'Colors': [],
  };

  /// packages var
  int _currentPagePackages = 1;
  bool _isFetchingMorePackages = false; // default to false

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTopBanner();
      fetchBrandProductItemsData();
      _scrollController.addListener(_onScroll);
      fetchWishListItems();

      /// packages
      fetchNewPackagesItems();
      _scrollController.addListener(_onScrollPackages);
    });

    super.initState();
  }

  ///  SCROLLING FOR THE PACKAGES ----------------------------------------------------------------

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPagePackages++;
      _isFetchingMorePackages = true;
      fetchNewPackagesItems();
    }
  }

  ///  FETCH PACKAGES ITEMS ----------------------------------------------------------------

  Future<void> fetchNewPackagesItems() async {
    try {
      setState(() {
        _isFetchingMorePackages = true;
      });
      await Provider.of<EventsBrandProductProvider>(context, listen: false).fetchBrandsPackages(
        perPage: 12,
        page: _currentPagePackages,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
        context: context,
      );
      setState(() {
        _isFetchingMorePackages = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMorePackages = false;
        });
      }
    }
  }

  ///  SORTING FOR PACKAGES ----------------------------------------------------------------

  void _onSortChangedPackages(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPagePackages = 1; // Reset to the first page
      Provider.of<EventsBrandProductProvider>(context, listen: false)
          .recordsPackages
          .clear(); // Clear existing products
    });
    fetchNewPackagesItems();
  }

  ///  ++++++++++++++++++++++++++   TOP BANNER BRANDS  +++++++++++++++++++++++++++++

  Future<void> fetchTopBanner() async {
    final provider = Provider.of<EventsBrandProvider>(context, listen: false);
    provider.fetchEventsBrand(context);
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  /// ------------   PRODUCTS SORTING  FUNCTION   ------------

  void _onSortChanged(String newValue) {
    if (mounted) {
      setState(() {
        _selectedSortBy = newValue;
        _currentPageProducts = 1;

        /// Reset to the first page
        Provider.of<EventsBrandProductProvider>(context, listen: false).records.clear(); //
      });
    }
    fetchBrandProductItemsData();
  }

  /// ------------   PRODUCTS SCROLLING FUNCTION   ------------
  void _onScroll() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
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
      await Provider.of<EventsBrandProductProvider>(context, listen: false).fetchBrandsProducts(
        perPage: 12,
        page: _currentPageProducts,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
        context: context,
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final freshListProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Consumer<EventsBrandProvider>(
                builder: (
                  BuildContext context,
                  EventsBrandProvider provider,
                  Widget? child,
                ) {
                  final event = provider.eventsBrand?.data;

                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.black,
                        strokeWidth: 0.5,
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const CustomSearchBar(
                        hintText: 'Search Events',
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.02,
                              vertical: screenHeight * 0.02,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///   -----   TOP BANNER IMAGE =================================================================
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: event?.coverImage ?? '',
                                    height: 100,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    placeholder: (BuildContext context, String url) => Container(
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
                                    ),
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
                                                border: Border.all(
                                                  color: _currentTab == 'Products' ? Colors.grey : Colors.transparent,
                                                ),
                                                borderRadius: const BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(
                                                    10,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(4),
                                                    child: Text(
                                                      AppStrings.products.tr,
                                                      style: topTabBarStyle(
                                                        context,
                                                      ),
                                                    ),
                                                  ),
                                                  if (_currentTab == 'Products') Container(),
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
                                                      AppStrings.packages.tr,
                                                      style: topTabBarStyle(
                                                        context,
                                                      ),
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
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                ///======  TAB PAGES VIEW =================================
                                if (_currentTab == 'Products') _ProductsView() else _PackagesView(),
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
                  color: Colors.black.withAlpha((0.5 * 255).toInt()), // Semi-transparent background
                  child: const Center(
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
  Widget _ProductsView() {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Consumer<EventsBrandProductProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingProducts && _currentPageProducts == 1) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.0,
                  vertical: screenHeight * 0.01,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SortAndFilterWidget(
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
                          ),
                        ).then((result) {
                          if (result != null) {
                            setState(() {
                              _currentPageProducts = 1;
                              selectedFilters = result;
                            });
                            fetchBrandProductItemsData();
                          }
                        });
                      },
                    ),
                    if (provider.records.isEmpty)
                      const ItemsEmptyView()
                    else
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
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
                          final dynamic frontSalePrice = product.prices?.frontSalePrice;
                          final dynamic price = product.prices?.price;
                          String offPercentage = '';

                          if (frontSalePrice != null && price != null && price > 0) {
                            // Calculate the discount percentage
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
                              priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                                  ? product.prices!.priceWithTaxes
                                  : null,
                              itemsId: 0,
                              imageUrl: product.image,
                              frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                              name: product.name,
                              storeName: product.store?.name.toString(),
                              price: product.prices?.price.toString(),
                              optionalIcon: Icons.shopping_cart_checkout_rounded,
                              reviewsCount: product.review?.reviewsCount?.toInt(),
                              onOptionalIconTap: () async {
                                final token = await SecurePreferencesUtil.getToken();
                                if (token != null) {
                                  await cartProvider.addToCart(
                                    product.id,
                                    context,
                                    1,
                                  );
                                }
                              },
                              isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                    (wishlistProduct) => wishlistProduct.id == product.id,
                                  ) ??
                                  false,
                              // isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                              onHeartTap: () async {
                                final token = await SecurePreferencesUtil.getToken();
                                final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                      (wishlistProduct) => wishlistProduct.id == product.id,
                                    ) ??
                                    false;
                                if (isInWishlist) {
                                  await wishlistProvider.deleteWishlistItem(
                                    product.id ?? 0,
                                    context,
                                    token ?? '',
                                  );
                                } else {
                                  await freshPicksProvider.handleHeartTap(
                                    context,
                                    product.id ?? 0,
                                  );
                                }
                                await wishlistProvider.fetchWishlist(
                                  token ?? '',
                                  context,
                                );
                              },
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _PackagesView() {
    final dynamic screenWidth = MediaQuery.sizeOf(context).width;
    final dynamic screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

    return Center(
      child: Consumer<EventsBrandProductProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingPackages && _currentPagePackages == 1) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 0.5,
              ),
            );
          } else if (provider.recordsPackages.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.02,
                right: screenWidth * 0.02,
              ),
              child: Container(
                width: screenWidth,
                height: 50,
                decoration: const BoxDecoration(color: AppColors.lightCoral),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(AppStrings.noRecordsFound.tr),
                ),
              ),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedSortBy,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        _onSortChangedPackages(newValue);
                      }
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'default_sorting',
                        child: Text(
                          AppStrings.sortByDefault.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'date_asc',
                        child: Text(
                          AppStrings.sortByOldest.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'date_desc',
                        child: Text(
                          AppStrings.sortByNewest.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'name_asc',
                        child: Text(
                          AppStrings.sortByNameAz.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'name_desc',
                        child: Text(
                          AppStrings.sortByNameZa.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price_asc',
                        child: Text(
                          AppStrings.sortByPriceLowToHigh.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'price_desc',
                        child: Text(
                          AppStrings.sortByPriceHighToLow.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'rating_asc',
                        child: Text(
                          AppStrings.sortByRatingLowToHigh.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'rating_desc',
                        child: Text(
                          AppStrings.sortByRatingHighToLow.tr,
                          style: sortingStyle(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.6,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemCount: provider.recordsPackages.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final product = provider.recordsPackages[index];
                              final dynamic frontSalePrice = product.prices?.frontSalePrice;
                              final dynamic price = product.prices?.price;
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
                                  priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0)
                                      ? product.prices!.priceWithTaxes
                                      : null,
                                  itemsId: 0,
                                  imageUrl: product.image,
                                  frontSalePriceWithTaxes: product.review?.rating?.toString() ?? '0',
                                  name: product.name,
                                  storeName: product.store?.name.toString(),
                                  price: product.prices?.price.toString(),
                                  optionalIcon: Icons.shopping_cart_checkout_rounded,
                                  reviewsCount: product.review?.reviewsCount?.toInt(),
                                  onOptionalIconTap: () async {
                                    final token = await SecurePreferencesUtil.getToken();
                                    if (token != null) {
                                      await cartProvider.addToCart(
                                        product.id,
                                        context,
                                        1,
                                      );
                                    }
                                  },
                                  isHeartObscure: wishlistProvider.wishlist?.data?.products.any(
                                        (wishlistProduct) => wishlistProduct.id == product.id,
                                      ) ??
                                      false,
                                  // isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                  onHeartTap: () async {
                                    final token = await SecurePreferencesUtil.getToken();
                                    final bool isInWishlist = wishlistProvider.wishlist?.data?.products.any(
                                          (wishlistProduct) => wishlistProduct.id == product.id,
                                        ) ??
                                        false;
                                    if (isInWishlist) {
                                      await wishlistProvider.deleteWishlistItem(
                                        product.id ?? 0,
                                        context,
                                        token ?? '',
                                      );
                                    } else {
                                      await freshPicksProvider.handleHeartTap(
                                        context,
                                        product.id ?? 0,
                                      );
                                    }
                                    await wishlistProvider.fetchWishlist(
                                      token ?? '',
                                      context,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
