import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_fresh_picks/widgets/ecom_brands_tab_widget.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_fresh_picks/widgets/ecom_packages_tab_widget.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_fresh_picks/widgets/ecom_products_tab_widget.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_fresh_picks/widgets/ecom_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../provider/shortcode_fresh_picks_provider/ecom_tags_provider.dart';
import '../../../provider/wishlist_items_provider/wishlist_provider.dart';

class EComTagsScreens extends StatefulWidget {
  const EComTagsScreens({
    super.key,
    required this.slug,
  });

  final dynamic slug;

  @override
  State<EComTagsScreens> createState() => _EComTagsScreensState();
}

class _EComTagsScreensState extends State<EComTagsScreens> {
  String _currentTab = 'Brands';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    await _fetchBannerData();
    await _fetchWishListItems();
  }

  Future<void> _fetchWishListItems() async {
    final provider = Provider.of<WishlistProvider>(context, listen: false);
    provider.fetchWishlist();
  }

  Future<void> _fetchBannerData() async {
    final provider = Provider.of<EComTagProvider>(context, listen: false);
    await provider.fetchEcomTagData(widget.slug, context);
  }

  void _onTabChanged(String tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        body: SafeArea(
          child: Consumer<EComTagProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.5,
                  ),
                );
              }

              final data = provider.ecomTag;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CustomSearchBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Banner Section
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                              top: screenHeight * 0.02,
                            ),
                            child: PaddedNetworkBanner(
                              imageUrl: (data?.coverImageForMobile?.isNotEmpty ?? false)
                                  ? data!.coverImageForMobile!
                                  : ApiConstants.placeholderImage,
                              fit: BoxFit.cover,
                              width: screenWidth,
                              padding: EdgeInsets.zero,
                            ),
                          ),

                          // Tab Bar Section
                          EComTabBarWidget(
                            currentTab: _currentTab,
                            onTabChanged: _onTabChanged,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),

                          // Tab Content
                          if (_currentTab == 'Brands' && data != null)
                            EComBrandsTabWidget(id: data.id)
                          else if (_currentTab == 'Products')
                            EComProductsTabWidget(slug: widget.slug)
                          else if (_currentTab == 'Packages')
                            EComPackagesTabWidget(slug: widget.slug)
                          else
                            Container(),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
