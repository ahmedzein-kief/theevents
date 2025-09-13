import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../../provider/locale_provider.dart';
import '../../base_screens/base_app_bar.dart';
import '../../filters/items_sorting_drop_down.dart';
import 'featured_brands_items_screen.dart';

class FeaturedBrandsScreenViewAll extends StatefulWidget {
  // New parameter to control icon visibility

  const FeaturedBrandsScreenViewAll({
    super.key,
    this.data,
    this.showIcons = true,
    this.showText = true,
  });

  final dynamic data;
  final bool showIcons; // New parameter to control icon visibility
  final bool showText;

  @override
  State<FeaturedBrandsScreenViewAll> createState() => _FeaturedCategoriesScreenState();
}

class _FeaturedCategoriesScreenState extends State<FeaturedBrandsScreenViewAll> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // Default to false
  int _currentPage = 1;
  late final TextEditingController _searchController;

  Locale? _currentLocale;
  bool _isRefreshing = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    _searchController = TextEditingController();

    _currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchTopBanner();
      await fetchBrandsTypes();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
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

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

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
        final provider = Provider.of<FeaturedBrandsProvider>(context, listen: false);
        provider.brands.clear(); // Clear existing brands
        provider.resetTopBrands();

        // Fetch fresh data for new locale
        await _fetchAllData();
      } catch (e) {
        debugPrint('Error refetching brands data on locale change: $e');
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
      fetchTopBanner(),
      fetchBrandsTypes(),
    ]);
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
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
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
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return BaseAppBar(
      textBack: widget.showText ? AppStrings.back.tr : '',
      customBackIcon: widget.showIcons ? const Icon(Icons.arrow_back_ios_sharp, size: 16) : null,
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      showSearchBar: true,
      searchController: _searchController,
      searchHintText: AppStrings.searchBrands.tr,
      body: Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Consumer<FeaturedBrandsProvider>(
                builder: (context, provider, _) {
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
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.02,
                                right: screenWidth * 0.02,
                                top: screenHeight * 0.02,
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0),
                                child: CachedNetworkImage(
                                  imageUrl: provider.featuredBrandsBanner?.data.coverImage ?? '',
                                  fit: BoxFit.cover,
                                  errorListener: (object) {
                                    Container(
                                      height: screenHeight,
                                      width: screenWidth,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Colors.grey,
                                            Colors.black,
                                          ],
                                        ),
                                      ),
                                      child: const CupertinoActivityIndicator(
                                        color: Colors.black,
                                        radius: 10,
                                        animating: true,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, object, error) => Container(
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
                                  ),
                                  placeholder: (BuildContext context, String url) => Container(
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
                                    widget.data ?? '',
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
                                  childAspectRatio: 0.85,
                                ),
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FeaturedBrandsItemsScreen(
                                            slug: brand.slug,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withAlpha((0.1 * 255).toInt()),
                                            spreadRadius: 1,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          // Image container with rounded top corners
                                          SizedBox(
                                            height: 100, // Fixed height for consistency

                                            child: CachedNetworkImage(
                                              imageUrl: brand.image,
                                              fit: BoxFit.contain,
                                              // Changed to contain to maintain aspect ratio
                                              width: double.infinity,
                                              height: double.infinity,
                                              errorWidget: (context, object, error) => Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(8.0),
                                                    topRight: Radius.circular(8.0),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 24,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (BuildContext context, String url) => Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[100],
                                                  borderRadius: const BorderRadius.only(
                                                    topLeft: Radius.circular(8.0),
                                                    topRight: Radius.circular(8.0),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: CupertinoActivityIndicator(
                                                    color: Colors.grey,
                                                    radius: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          // Brand name section
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: Text(
                                              brand.name,
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const SizedBox(height: 8)
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
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
                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
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
