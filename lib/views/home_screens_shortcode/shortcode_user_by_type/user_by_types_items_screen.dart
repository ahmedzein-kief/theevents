import 'dart:async';

import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_type_inner_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../core/widgets/user_by_type_view/custom_user_type_container.dart';
import '../../../provider/locale_provider.dart';
import '../../../provider/shortcode_vendor_type_by_provider/vendor_type_by_provider.dart';
import '../../filters/items_sorting_drop_down.dart';

class UserByTypeItemsScreen extends StatefulWidget {
  const UserByTypeItemsScreen({
    super.key,
    required this.title,
    required this.typeId,
    this.showText = true,
    this.showIcon = true,
  });

  final bool showText;
  final bool showIcon;
  final String title;
  final int typeId;

  @override
  State<UserByTypeItemsScreen> createState() => _UserByTypeItemsScreenState();
}

class _UserByTypeItemsScreenState extends State<UserByTypeItemsScreen> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // default to false
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
      await _fetchAllData();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    _scrollController.dispose();
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
        final provider = Provider.of<VendorByTypeProvider>(context, listen: false);
        provider.vendors.clear(); // Clear existing categories
        provider.resetVendorTypeData();

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
      fetchVendorByType(),
      fetchVendors(),
    ]);
  }

  Future<void> fetchVendorByType() async {
    final provider = Provider.of<VendorByTypeProvider>(context, listen: false);
    provider.fetchVendorTypeById(widget.typeId, context);
  }

  Future<void> fetchVendors() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });

      await Provider.of<VendorByTypeProvider>(context, listen: false).fetchVendors(
        typeId: widget.typeId,
        context,
        sortBy: _selectedSortBy,
        perPage: 12,
        page: _currentPage,
      );
    } finally {
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
      _isFetchingMore = true; // Prevent duplicate fetches
      fetchVendors();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      // REMOVE THIS LINE THEN LIST OF ITEMS ALL WILL BE PREFETCH
      Provider.of<VendorByTypeProvider>(context, listen: false).vendors.clear(); // Clear existing products
      _isFetchingMore = false;
    });
    fetchVendors();
  }

  Future<void> _refresh() async {
    setState(() {
      _currentPage = 1; // Reset to the first page
      _isFetchingMore = false; // Reset fetching status
    });
    await fetchVendors(); // Fetch brands with current sorting
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
      showSearchBar: true,
      searchController: _searchController,
      body: Stack(
        children: [
          RefreshIndicator(
            color: Theme.of(context).colorScheme.onPrimary,
            onRefresh: () async {
              _refresh();
            },
            child: Scaffold(
              body: SafeArea(
                child: Consumer<VendorByTypeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading && _currentPage == 1) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 0.5,
                        ),
                      );
                    }
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                              top: screenHeight * 0.02,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: PaddedNetworkBanner(
                                imageUrl: provider.vendorTypeData?.coverImageForMobile ??
                                    provider.vendorTypeData?.coverImage ??
                                    ApiConstants.placeholderImage,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                padding: EdgeInsets.zero,
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
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  widget.title,
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
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                              bottom: screenHeight * 0.02,
                              top: screenHeight * 0.01,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 20,
                                mainAxisExtent: screenHeight * 0.16,
                              ),
                              itemCount: provider.vendors.length + (_isFetchingMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (_isFetchingMore && index == provider.vendors.length) {
                                  return const Column(
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
                                  );
                                }
                                final vendor = provider.vendors[index];
                                return UserByTypeSeeAll(
                                  imageUrl: vendor.avatar,
                                  name: vendor.name,
                                  textStyle: homeItemsStyle(context),
                                  onTap: () {
                                    /// User Type Details
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UserTypeInnerPageScreen(
                                          typeId: widget.typeId,
                                          id: vendor.id,
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
                    );
                  },
                ),
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
