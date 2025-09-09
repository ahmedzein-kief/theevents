import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_user_by_type/user_type_inner_page_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/user_by_type_view/custom_user_type_container.dart';
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

  @override
  void initState() {
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // fetchVendorByType();
      fetchVendors();
      _scrollController.addListener(_onScroll);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
      body: RefreshIndicator(
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
                          child: Image.network(
                            fit: BoxFit.cover,
                            provider.vendorTypeData?.coverImage ?? '',
                            errorBuilder: (context, provider, error) => const SizedBox.shrink(),
                            loadingBuilder: (context, child, loadingProcessor) {
                              if (loadingProcessor == null) {
                                return child;
                              }
                              return Container(
                                height: 100,
                                width: double.infinity,
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
                      Container(
                        // color: AppColors.infoBackGround,
                        child: Padding(
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
                                imageUrl: vendor.avatar ?? '',
                                name: vendor.name ?? '',
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
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
