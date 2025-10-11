import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/views/home_screens_shortcode/shorcode_featured_brands/featured_brands_view_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_auto_slider_home.dart';
import '../../../core/widgets/custom_home_views/custom_home_text_row.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import 'featured_brands_items_screen.dart';

class FeaturedBrandsScreen extends StatefulWidget {
  const FeaturedBrandsScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<FeaturedBrandsScreen> createState() => _TopBrandsState();
}

class _TopBrandsState extends State<FeaturedBrandsScreen> {
  Future<void> fetchTopBrands() async {
    final provider = Provider.of<FeaturedBrandsProvider>(context, listen: false);
    await provider.fetchTopBrands(context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      fetchTopBrands();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<FeaturedBrandsProvider>(
      builder: (context, provider, child) {
        final brands = provider.topBrands?.data ?? [];

        // Fixed calculation to show exactly 3 complete items
        const double screenHorizontalPadding = 16.0; // Main screen padding
        const double containerHorizontalPadding = 8.0; // Container internal padding
        const double itemMargin = 6.0; // Each item margin on both sides
        const double totalItemMargins = itemMargin * 6; // 3 items × 2 margins each

        final double availableWidth =
            screenWidth - (screenHorizontalPadding * 2) - (containerHorizontalPadding * 2) - totalItemMargins;
        final double exactItemWidth = availableWidth / 3;

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: CustomTextRow(
                title: widget.data['attributes']['title'],
                seeAll: AppStrings.viewAll.tr,
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FeaturedBrandsScreenViewAll(
                        data: widget.data['attributes']['title'],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                color: AppColors.lightPink,
                alignment: Alignment.center,
                height: screenHeight * 0.16,
                child: SimpleBazaarAutoSlider(
                  itemWidth: exactItemWidth + (itemMargin * 2),
                  snapToItems: true,
                  items: brands.map((brand) {
                    return Container(
                      width: exactItemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: itemMargin),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.02,
                              ),
                              child: ClipRRect(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => FeaturedBrandsItemsScreen(
                                          slug: brand.slug.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: PaddedNetworkBanner(
                                    imageUrl: brand.logo ?? 'https://via.placeholder.com/110x80',
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
