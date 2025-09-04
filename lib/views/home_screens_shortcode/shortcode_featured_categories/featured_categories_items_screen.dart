import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_home_views/custom_grid_items.dart';
import '../../../provider/locale_provider.dart';
import '../../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import '../../filters/items_sorting_drop_down.dart';
import 'featured_categories_viewall_inner.dart';

class FeaturedCategoriesItemsScreen extends StatefulWidget {
  const FeaturedCategoriesItemsScreen({
    super.key,
    required this.data,
    this.showText = true,
    this.showIcon = true,
  });

  final dynamic data;
  final bool showText;
  final bool showIcon;

  @override
  State<FeaturedCategoriesItemsScreen> createState() => _HomeAllGiftItemsState();
}

class _HomeAllGiftItemsState extends State<FeaturedCategoriesItemsScreen> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;
  int _currentPage = 1;
  Locale? _currentLocale;
  bool _isRefreshing = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _fetchAllData();
      _scrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Listen for locale changes and refresh data
    final newLocale = Provider.of<LocaleProvider>(context).locale;
    if (_currentLocale != newLocale && !_isRefreshing) {
      _currentLocale = newLocale;
      _refetchDataForLocaleChange();
    }
  }

  // NEW: Handle locale change with proper data refresh
  Future<void> _refetchDataForLocaleChange() async {
    if (_isRefreshing) return;

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (mounted) {
        setState(() => _isRefreshing = true);
      }

      try {
        // Reset pagination and clear existing data
        _currentPage = 1;
        final provider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
        provider.categories.clear(); // Clear existing categories

        // Fetch fresh data for new locale
        await _fetchAllData();
      } catch (e) {
        debugPrint('Error refetching categories data on locale change: $e');
      } finally {
        if (mounted) {
          setState(() => _isRefreshing = false);
        }
      }
    });
  }

  // NEW: Comprehensive data fetch
  Future<void> _fetchAllData() async {
    await Future.wait([
      fetchBannerTopData(),
      fetchCategories(),
    ]);
  }

  Future<void> fetchBannerTopData() async {
    final provider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
    await provider.fetchPageData(context);
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });

      final provider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
      await provider.fetchCategories(
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
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchCategories();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<FeaturedCategoriesProvider>(context, listen: false).categories.clear();
    });
    fetchCategories();
  }

  Future<void> _refreshHomePage() async {
    setState(() {
      _currentPage = 1;
      _isFetchingMore = false;
    });

    // Clear existing data before refresh
    final provider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
    provider.categories.clear();

    await _fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return BaseAppBar(
      textBack: widget.showText ? AppStrings.back.tr : null,
      customBackIcon: widget.showIcon ? const Icon(Icons.arrow_back_ios_sharp, size: 16) : null,
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Consumer<FeaturedCategoriesProvider>(
                builder: (context, provider, child) {
                  if (provider.loading && provider.categories.isEmpty) {
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
                            icon: const Icon(
                              Icons.refresh,
                              size: 40,
                              color: AppColors.peachyPink,
                            ),
                            onPressed: () async {
                              await _fetchAllData();
                            },
                          ),
                          Text(provider.errorMessage!),
                        ],
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      color: Theme.of(context).colorScheme.onPrimary,
                      onRefresh: _refreshHomePage,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomSearchBar(hintText: AppStrings.searchGifts.tr),
                          Expanded(
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: screenWidth * 0.02,
                                      right: screenWidth * 0.02,
                                      top: screenHeight * 0.02,
                                    ),
                                    child: SizedBox(
                                      height: 100,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: provider.pageData?.coverImage ?? '',
                                        height: 10,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorWidget: (context, _, error) => Container(
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
                                        placeholder: (BuildContext context, String url) => Container(
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
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.04,
                                      right: screenWidth * 0.04,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.data != null && widget.data['attributes'] != null
                                              ? widget.data['attributes']['title'] ?? AppStrings.giftsByOccasion.tr
                                              : AppStrings.giftsByOccasion.tr,
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
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.04,
                                      bottom: screenHeight * 0.02,
                                      right: screenWidth * 0.04,
                                    ),
                                    child: GridView.builder(
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 8.0,
                                        mainAxisSpacing: 8.0,
                                        childAspectRatio: 0.95,
                                      ),
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: provider.categories.length + (_isFetchingMore ? 1 : 0),
                                      itemBuilder: (context, index) {
                                        if (_isFetchingMore && index == provider.categories.length) {
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
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          // Loading overlay when refreshing due to locale change
          if (_isRefreshing)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black.withOpacity(0.1),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
