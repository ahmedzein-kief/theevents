import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_home_views/custom_grid_items.dart';
import '../../filters/items_sorting.dart';
import 'featured_categories_viewall_inner.dart';

class FeaturedCategoriesItemsScreen extends StatefulWidget {
  final dynamic data;
  final bool showText;
  final bool showIcon;

  const FeaturedCategoriesItemsScreen({super.key, required this.data, this.showText = true, this.showIcon = true});

  @override
  State<FeaturedCategoriesItemsScreen> createState() => _HomeAllGiftItemsState();
}

class _HomeAllGiftItemsState extends State<FeaturedCategoriesItemsScreen> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((callback) async {

      await fetchBannerTopData();
      await fetchCategories();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
  }

  Future<void> fetchBannerTopData() async {
    Provider.of<FeaturedCategoriesProvider>(context, listen: false).fetchPageData(context);
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<FeaturedCategoriesProvider>(context, listen: false).fetchCategories(
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
      fetchCategories();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<FeaturedCategoriesProvider>(context, listen: false).products.clear(); // Clear existing products
    });
    fetchCategories();
  }

  Future<void> _refreshHomePage() async {
    setState(() {
      _currentPage = 1; // Reset to the first page
      _isFetchingMore = false; // Reset fetching status
    });
    await fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;
    return BaseAppBar(
      textBack: widget.showText ? AppStrings.back : null,
      customBackIcon: widget.showIcon ? const Icon(Icons.arrow_back_ios_sharp, size: 16) : null,
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(
          child: Consumer<FeaturedCategoriesProvider>(
            builder: (context, provider, child) {
              if (provider.loading) {
                return const Align(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.5,
                  ),
                );
              } else if (provider.errorMessage != null) {
                return Center(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.refresh, size: 40, color: AppColors.peachyPink),
                      onPressed: () async {
                        await fetchBannerTopData();
                        // await fetchGiftOccasionData();
                        await fetchCategories();
                      },
                    ),
                    Text(provider.errorMessage!),
                  ],
                ));
              } else {

                return RefreshIndicator(
                  color: Theme.of(context).colorScheme.onPrimary,
                  onRefresh: () async {
                    _refreshHomePage();
                  },
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                    CustomSearchBar(hintText: "Search Gifts"),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                              child: SizedBox(
                                height: 100,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                    imageUrl: provider.pageData?.coverImage ?? '',
                                    height: 10,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorWidget: (context,_,error){
                                      return Container(
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
                                      );
                                    },
                                    errorListener: (object){
                                      Container(
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
                                      );
                                    },
                                    placeholder: (BuildContext context, String url) {
                                      return Container(
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
                                      );
                                    }),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.data != null && widget.data['attributes'] != null ? widget.data['attributes']['title'] ?? 'Gifts by occasion' : 'Gifts by occasion',
                                    style: boldHomeTextStyle(),
                                  ),
                                  Row(
                                    children: [
                                      ItemsSortingDropDown(
                                        selectedSortBy: _selectedSortBy,
                                        onSortChanged: (newValue) {
                                          _onSortChanged(newValue);
                                        },
                                      ),
                                    ],
                                  ),

                                  // const Icon(Icons.sort)
                                ],
                              ),
                            ),
                            Container(
                              child: Padding(
                                padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04, bottom: screenHeight * 0.02, right: screenWidth * 0.04),
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, childAspectRatio: 0.95),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: provider.categories.length + (_isFetchingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (_isFetchingMore && index == provider.products.length) {
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

                                    final category = provider.categories[index];

                                    return GridItemsHomeSeeAll(
                                      imageUrl: category.image ?? '',
                                      name: category.name ?? '',
                                      textStyle: homeItemsStyle(context),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => FeaturedCategoriesViewAllInner(
                                                      data: category,
                                                    )));
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
