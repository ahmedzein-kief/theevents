import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../provider/information_icons_provider/best_seller_provider.dart';
import '../../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/custom_items_views/product_card.dart';
import '../../../product_detail_screens/product_detail_screen.dart';

class BestSellersPackages extends StatefulWidget {
  const BestSellersPackages({super.key});

  @override
  State<BestSellersPackages> createState() => _FeaturedBrandsProductsScreenState();
}

class _FeaturedBrandsProductsScreenState extends State<BestSellersPackages> {
  bool _isFetchingMoreProducts = false; // default to false
  final ScrollController _scrollController = ScrollController();
  int _currentPageProducts = 1;
  String _selectedSortBy = 'default_sorting';

  void _onScroll() {
    if (_isFetchingMoreProducts) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _currentPageProducts++;
      _isFetchingMoreProducts = true;
      fetchNewProductsItems();
    }
  }

  Future<void> fetchNewProductsItems() async {
    try {
      setState(() {
        _isFetchingMoreProducts = true;
      });
      await Provider.of<BestSellerProvider>(context, listen: false).fetchPackagesNew(
        context,
        perPage: 12,
        page: _currentPageProducts,
        sortBy: _selectedSortBy,
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

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll); // Remove the listener in dispose
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNewProductsItems();
      _scrollController.addListener(_onScroll);
    });
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPageProducts = 1; // Reset to the first page
      Provider.of<BestSellerProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchNewProductsItems();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    final freshPicksProvider = Provider.of<FreshPicksProvider>(context);
    return Center(
      child: Consumer<BestSellerProvider>(
        builder: (ctx, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.black, strokeWidth: 0.5));
          } else if (provider.packages.isEmpty) {
            return Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.02, right: screenWidth * 0.02),
                child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: const BoxDecoration(color: AppColors.lightCoral),
                    child: const Align(alignment: Alignment.center, child: Text('No records found!'))));
          } else {
            final collection = provider.collection!.data;
            return Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
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

                    //      products of best seller

                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GridView.builder(
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
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                            strokeWidth: 0.5,
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
                                    onOptionalIconTap: () {},
                                    off: offPercentage.isNotEmpty ? '$offPercentage%off' : '',
                                    // Display the discount percentage
                                    priceWithTaxes: (product.prices?.frontSalePrice ?? 0) < (product.prices?.price ?? 0) ? product.prices!.priceWithTaxes : null,
                                    itemsId: 0,
                                    imageUrl: product.image,
                                    frontSalePriceWithTaxes: product.prices?.frontSalePriceWithTaxes.toString() ?? '',
                                    name: product.name,
                                    storeName: product.store!.name.toString(),
                                    price: product.prices!.price.toString(),
                                    optionalIcon: Icons.shopping_cart_checkout_rounded,
                                    reviewsCount: product.review!.reviewsCount!.toInt(),
                                    isHeartObscure: true,
                                    onHeartTap: () async {},
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
