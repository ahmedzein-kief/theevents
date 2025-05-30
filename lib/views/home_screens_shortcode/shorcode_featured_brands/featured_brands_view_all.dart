import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/widgets/custom_app_views/search_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../base_screens/base_app_bar.dart';
import '../../filters/items_sorting.dart';
import 'featured_brands_items_screen.dart';

class FeaturedBrandsScreenViewAll extends StatefulWidget {
  final dynamic data;
  final bool showIcons; // New parameter to control icon visibility
  final bool showText; // New parameter to control icon visibility

  const FeaturedBrandsScreenViewAll({
    super.key,
    this.data,
    this.showIcons = true,
    this.showText = true,
  });

  @override
  State<FeaturedBrandsScreenViewAll> createState() => _FeaturedCategoriesScreenState();
}

class _FeaturedCategoriesScreenState extends State<FeaturedBrandsScreenViewAll> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // Default to false
  int _currentPage = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchTopBanner();
      await fetchBrandsTypes();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
  }

  Future<void> fetchTopBanner() async {
    final provider = Provider.of<FeaturedBrandsProvider>(context, listen: false);
    await provider.fetchFeaturedBrands(context);
  }

  Future<void> fetchBrandsTypes() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<FeaturedBrandsProvider>(context, listen: false).fetchBrandsItems(
        perPage: 12,
        context,
        page: _currentPage,
        sortBy: _selectedSortBy,
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

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchBrandsTypes();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1; // Reset to the first page
      Provider.of<FeaturedBrandsProvider>(context, listen: false).brands.clear(); // Clear existing products
      _isFetchingMore = false;
    });
    fetchBrandsTypes();
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1; // Reset to the first page
      _isFetchingMore = false; // Reset fetching status
    });
    await fetchBrandsTypes(); // Fetch brands with current sorting
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    return BaseAppBar(
      textBack: widget.showText ? AppStrings.back : "",
      customBackIcon: widget.showIcons ? const Icon(Icons.arrow_back_ios_sharp, size: 16) : null,
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(child: Consumer<FeaturedBrandsProvider>(builder: (context, provider, _) {
          if (provider.isLoading && _currentPage == 1) {
            return const Align(
              alignment: Alignment.center,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 0.5,
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: _refresh,
              color: Theme.of(context).colorScheme.onPrimary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomSearchBar(hintText: "Search Brands"),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                            child: SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: CachedNetworkImage(
                                  imageUrl: provider.featuredBrandsBanner?.data.coverImage ?? '',
                                  fit: BoxFit.fill,
                                  errorListener: (object){
                                    Container(
                                      height: screenHeight,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.grey, Colors.black],
                                        ),
                                      ),
                                      child: const CupertinoActivityIndicator(
                                        color: Colors.black,
                                        radius: 10,
                                        animating: true,
                                      ),
                                    );
                                  },
                                  errorWidget: (context,object,error){
                                   return Container(
                                      height: screenHeight,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.grey, Colors.black],
                                        ),
                                      ),
                                      child: const CupertinoActivityIndicator(
                                        color: Colors.black,
                                        radius: 10,
                                        animating: true,
                                      ),
                                    );
                                  },
                                  placeholder: (BuildContext context, String url) {
                                    return Container(
                                      height: screenHeight,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.grey, Colors.black],
                                        ),
                                      ),
                                      child: const CupertinoActivityIndicator(
                                        color: Colors.black,
                                        radius: 10,
                                        animating: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
                            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Text(
                                widget.data ?? "",
                                softWrap: true,
                                style: featuredBrandText(context),
                              ),
                              Row(
                                children: [
                                  ItemsSortingDropDown(
                                    selectedSortBy: _selectedSortBy,
                                    onSortChanged: (newValue) {
                                      _onSortChanged(newValue);
                                    },
                                  )
                                ],
                              ),
                            ]),
                          ),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04, bottom: screenHeight * 0.02, right: screenWidth * 0.04),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, childAspectRatio: 0.95),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: provider.brands.length + (_isFetchingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_isFetchingMore && index == provider.brands.length) {
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

                                  final brand = provider.brands[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => FeaturedBrandsItemsScreen(slug: brand.slug)));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).colorScheme.primary,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: const Offset(0, 3), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: CachedNetworkImage(
                                              alignment: Alignment.center,
                                              imageUrl: brand.image,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorListener: (object){
                                                Center(
                                                    child: Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                    colors: [Colors.grey, Colors.black],
                                                ),
                                                ),
                                                child: const CupertinoActivityIndicator(
                                                color: Colors.black,
                                                radius: 10,
                                                animating: true,
                                                ),
                                                ));
                                              },
                                              errorWidget: (context,object,error){
                                               return Center(
                                                    child: Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                    gradient: LinearGradient(
                                                    colors: [Colors.grey, Colors.black],
                                                ),
                                                ),
                                                child: const CupertinoActivityIndicator(
                                                color: Colors.black,
                                                radius: 10,
                                                animating: true,
                                                ),
                                                ));
                                              },
                                              placeholder: (BuildContext context, String url) {
                                                return Center(
                                                  child: Container(
                                                    height: 100,
                                                    width: double.infinity,
                                                    decoration: const BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [Colors.grey, Colors.black],
                                                      ),
                                                    ),
                                                    child: const CupertinoActivityIndicator(
                                                      color: Colors.black,
                                                      radius: 10,
                                                      animating: true,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          // Text(brand.name,
                                          //     style: twoSliderAdsTextStyle())
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        })),
      ),
    );
  }
}
