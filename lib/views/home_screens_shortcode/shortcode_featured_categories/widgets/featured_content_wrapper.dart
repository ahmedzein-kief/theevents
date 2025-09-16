import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../../provider/shortcode_featured_categories_provider/featured_categories_detail_provider.dart';
import 'featured_banner_section.dart';
import 'featured_tab_bar.dart';

class FeaturedContentWrapper extends StatelessWidget {
  const FeaturedContentWrapper({
    super.key,
    required this.scrollController,
    required this.currentTab,
    required this.onTabChanged,
    required this.productsView,
    required this.packagesView,
  });

  final ScrollController scrollController;
  final String currentTab;
  final Function(String) onTabChanged;
  final Widget productsView;
  final Widget packagesView;

  @override
  Widget build(BuildContext context) {
    return Consumer<FeaturedCategoriesDetailProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        }

        final bannerData = provider.productCategoryBanner;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomSearchBar(
              hintText: AppStrings.searchEvents.tr,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FeaturedBannerSection(
                      bannerImageUrl: bannerData?.data.coverImageForMobile ?? bannerData?.data.coverImage,
                    ),
                    FeaturedTabBar(
                      currentTab: currentTab,
                      onTabChanged: onTabChanged,
                    ),
                    if (currentTab == 'Products') productsView else packagesView,
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
