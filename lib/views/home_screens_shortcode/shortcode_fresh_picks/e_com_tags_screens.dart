import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/provider/shortcode_fresh_picks_provider/eCom_Tags_brands_Provider.dart';
import 'package:event_app/core/widgets/items_empty_view.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/cart_item_provider/cart_item_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/eCom_tags_provider.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_items_views/product_card.dart';
import '../../../utils/storage/shared_preferences_helper.dart';
import '../../filters/items_sorting.dart';
import '../../filters/product_filters_screen.dart';
import '../../filters/product_sorting.dart';
import '../../product_detail_screens/product_detail_screen.dart';
import '../shorcode_featured_brands/featured_brands_items_screen.dart';

class EComTagsScreens extends StatefulWidget {
  final dynamic slug;

  const EComTagsScreens({
    super.key,
    required this.slug,
  });

  @override
  State<EComTagsScreens> createState() => _EComTagsScreensState();
}

class _EComTagsScreensState extends State<EComTagsScreens> {
  Map<String, List<int>> selectedFilters = {'Categories': [], 'Brands': [], 'Tags': [], 'Prices': [], 'Colors': []};

  String _currentTab = "Brands";
  final ScrollController _scrollController = ScrollController();
  int _currentPageBrand = 1;
  bool _isFetchingMoreBrand = false;
  String _selectedSortBy = 'default_sorting';

  ///   FOR PACKAGES

  bool _isFetchingMorePackages = false; // default to false
  int _currentPagePackages = 1;

  void _onScrollPackages() {
    if (_isFetchingMorePackages) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _currentPagePackages++;
      _isFetchingMorePackages = true;
      fetchNewProductsItems();
    }
  }

  Future<void> fetchPackages() async {
    try {
      setState(() {
        _isFetchingMorePackages = true;
      });
      await Provider.of<EComTagProvider>(context, listen: false).fetchEComPackagesNew(
        slug: widget.slug,
        context,
        perPage: 12,
        page: _currentPagePackages,
        sortBy: _selectedSortBy,
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

  void _onSortChangedPackages(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPagePackages = 1; // Reset to the first page
      Provider.of<EComTagProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  /// ------------------------------FOR PRODUCTS -------------------------------------
  bool _isFetchingMoreProducts = false; // default to false
  int _currentPageProduct = 1;

  /// ------------------------------FOR PRODUCTS -------------------------------------

  void _onScrollProduct() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _currentPageProduct++;
      _isFetchingMoreProducts = true;
      fetchNewProductsItems();
    }
  }

  /// ------------------------------FOR PRODUCTS -------------------------------------

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMoreProducts = true;
      });
      await Provider.of<EComTagProvider>(context, listen: false).fetchEComProductsNew(
        slug: widget.slug,
        context,
        perPage: 12,
        page: _currentPageProduct,
        sortBy: _selectedSortBy,
        filters: selectedFilters,
      );
      setState(() {
        _isFetchingMoreProducts = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _isFetchingMoreProducts = false;
        });
      }
    }
  }

  /// ------------------------------FOR PRODUCTS -------------------------------------

  void _onSortChangedProduct(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPageProduct = 1; // Reset to the first page
      // Provider.of<FiftyPercentDiscountProvider>(context, listen: false)
      Provider.of<EComTagProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  ///  INIT STATE APP
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBrandsItemsBanner();
      fetchWishListItems();

      fetchBrands();
      _scrollController.addListener(_onScroll);

      fetchNewProductsItems();
      _scrollController.addListener(_onScrollProduct);

      fetchPackages();
      _scrollController.addListener(_onScrollPackages);
    });
  }

  ///  ------------  FOR TAKING THE  ICON HEART AS THEIR STATE RED ON WISHLIST ADD BASIS ------------

  Future<void> fetchWishListItems() async {
    final token = await SecurePreferencesUtil.getToken();
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist(token ?? '', context);
  }

  ///  TOP BANNER
  Future<void> fetchBrandsItemsBanner() async {
    final provider = await Provider.of<EComTagProvider>(context, listen: false);
    await provider.fetchEcomTagData(widget.slug, context);

    /// fetch brand at here
    fetchBrands();
    // _scrollController.addListener(_onScroll);
  }

  /// ----------------------  BRANDS HERE --------------------------------
  Future<void> fetchBrands() async {
    final brandId = Provider.of<EComTagProvider>(context, listen: false).ecomTag;
    try {
      setState(() {
        _isFetchingMoreBrand = true; // Start loading state
      });
      await Provider.of<EComBrandsProvider>(context, listen: false).fetchBrands(
        id: brandId?.id,
        context,
        perPage: 12,
        page: _currentPageBrand,
        sortBy: _selectedSortBy,
      );
      _isFetchingMoreBrand = false;
    } catch (ERROR) {
      if (mounted) {
        setState(() {
          _isFetchingMoreBrand = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_isFetchingMoreBrand) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && _scrollController.position.outOfRange) {
      _currentPageBrand++;
      _isFetchingMoreBrand = true;
      fetchBrands();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPageBrand = 1; // Reset to the first page
    });
    Provider.of<EComBrandsProvider>(context, listen: false).reset();

    fetchBrands();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Clear previous data or trigger data refresh
    fetchBrands();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(child: Consumer<EComTagProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              );
            } else {
              final data = provider.ecomTag;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomSearchBar(hintText: "Search cakes"),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: data?.coverImage ?? '',
                                height: screenHeight * 0.14,
                                fit: BoxFit.cover,
                                width: screenWidth,
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
                          ),

                          ///  -------  TAB BAR BRANDS , PRODUCTS AND PACKAGES --------------------------------
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTab = 'Brands';
                                          // _currentPageBrand = 1; // Reset the page
                                          // _isFetchingMoreBrand = false; // Reset fetching state
                                        });
                                        // fetchBrands(); // Fetch data for Brands when the tab is selected
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(color: _currentTab == 'Brands' ? Colors.grey : Colors.transparent),
                                            borderRadius: const BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: Text(
                                                'Brands',
                                                style: topTabBarStyle(context),
                                              ),
                                            ),
                                            if (_currentTab == 'Brands') Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _currentTab = 'Products';
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: _currentTab == 'Products' ? Colors.grey : Colors.transparent,
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
                                                'Products',
                                                style: topTabBarStyle(context),
                                              ),
                                            ),
                                            if (_currentTab == 'Products') const SizedBox.shrink(),
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
                                Container(
                                  color: Colors.grey,
                                  height: 1,
                                  width: double.infinity,
                                )
                              ],
                            ),
                          ),

                          _currentTab == 'Brands'
                              ? _brandTab(id: data?.id)
                              : _currentTab == "Products"
                                  ? _productsTab(slug: widget.slug)
                                  : _currentTab == 'Packages'
                                      ? _packagesTab(slug: widget.slug)
                                      : Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        )),
      ),
    );
  }

  Widget _brandTab({required int id}) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      child: Consumer<EComBrandsProvider>(
        builder: (context, provider, child) {
          if (provider.isMoreLoadingBrands && _currentPageBrand == 1) {
            return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ItemsSortingDropDown(
                    selectedSortBy: _selectedSortBy,
                    onSortChanged: (newValue) {
                      _onSortChanged(newValue);
                    },
                  ),
                ],
              ),
              provider.records.isEmpty
                  ? ItemsEmptyView()
                  : Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.8, mainAxisSpacing: 2, crossAxisSpacing: 10),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        // itemCount: provider.records.length + (_isFetchingMoreBrand ? 1 : 0),
                        itemCount: provider.records.length,
                        itemBuilder: (context, index) {
                          final record = provider.records[index];
                          if (_isFetchingMoreBrand && index == provider.records.length) {
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
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 0.1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (builder) => FeaturedBrandsItemsScreen(slug: record.slug)));
                                  },
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: record.image,
                                        height: 120,
                                        fit: BoxFit.fitWidth,
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
                                      Text(
                                        maxLines: 2,
                                        record.name,
                                        style: twoSliderAdsTextStyle(),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _productsTab({required String slug}) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context, listen: false);
    return Center(
      child: Consumer<EComTagProvider>(
        builder: (ctx, provider, child) {
          if (provider.isMoreLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text('title', style: boldHomeTextStyle()),
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
                                filters: provider.productFilters,
                                selectedIds: selectedFilters,
                              ), // Show the filter bottom sheet
                            ).then((result) {
                              setState(() {
                                _currentPageProduct = 1;
                                selectedFilters = result; // Store the selected filter IDs
                              });
                              fetchNewProductsItems();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      provider.products.isEmpty
                          ? ItemsEmptyView()
                          : GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                              itemCount: provider.products.length + (_isFetchingMoreProducts ? 1 : 0),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (_isFetchingMoreProducts && index == provider.products.length) {
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
                                final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);
                                final cartProvider = Provider.of<CartProvider>(context, listen: false);

                                /// Calculate the percentage off
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
                                    optionalIcon: Icons.shopping_cart,
                                    onOptionalIconTap: () async {
                                      final token = await SecurePreferencesUtil.getToken();
                                      if (token != null) {
                                        await cartProvider.addToCart(product.id, context, 1);
                                      }
                                    },
                                    frontSalePriceWithTaxes: product.review?.average?.toString() ?? '0',
                                    name: product.name,
                                    storeName: product.store!.name.toString(),
                                    price: product.prices!.price.toString(),
                                    reviewsCount: product.review!.reviewsCount!.toInt(),
                                    isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                    onHeartTap: () async {
                                      final token = await SecurePreferencesUtil.getToken();
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
                              })
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

  Widget _packagesTab({required String slug}) {
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      child: Consumer<EComTagProvider>(
        builder: (ctx, provider, child) {
          if (provider.isPackagesLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
          } else if (provider.packages.isEmpty) {
            return Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.lightCoral,
                    ),
                    height: 50,
                    child: const Align(alignment: Alignment.center, child: Text('No records found!'))));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
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

                //      products of best seller

                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.6, mainAxisSpacing: 10, crossAxisSpacing: 10),
                          itemCount: provider.packages.length + (_isFetchingMorePackages ? 1 : 0),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (_isFetchingMorePackages && index == provider.packages.length) {
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

                            final product = provider.packages[index];
                            final wishlistProvider = Provider.of<WishlistProvider>(context, listen: false);

                            /// Calculate the percentage off
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
                                optionalIcon: Icons.shopping_cart,
                                onOptionalIconTap: () async {
                                  final token = await SecurePreferencesUtil.getToken();
                                  final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                  if (token != null) {
                                    await cartProvider.addToCart(product.id, context, 1);
                                  }
                                },
                                itemsId: product.id,
                                imageUrl: product.image,
                                frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes.toString() ?? '',
                                name: product.name,
                                storeName: product.store!.name.toString(),
                                price: product.prices!.price.toString(),
                                reviewsCount: product.review!.reviewsCount!.toInt(),
                                isHeartObscure: wishlistProvider.wishlist?.data?.products.any((wishlistProduct) => wishlistProduct.id == product.id) ?? false,
                                onHeartTap: () async {
                                  final token = await SecurePreferencesUtil.getToken();
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
                          })
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
    return Container(
      child: Text(slug),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }
}
