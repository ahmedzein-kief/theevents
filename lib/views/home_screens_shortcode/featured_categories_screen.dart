import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_featured_categories/featured_categories_items_screen.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_featured_categories/featured_categories_viewall_inner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auto_slider_home.dart'; // For SimpleBazaarAutoSlider
import '../../core/widgets/custom_home_views/custom_home_text_row.dart';
import '../../core/widgets/padded_network_banner.dart';
import '../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';

class FeaturedCategoriesScreen extends StatefulWidget {
  const FeaturedCategoriesScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<FeaturedCategoriesScreen> createState() => _GiftByOccasionViewState();
}

class _GiftByOccasionViewState extends State<FeaturedCategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGiftData();
    });
  }

  Future<void> fetchGiftData() async {
    final provider = Provider.of<FeaturedCategoriesProvider>(context, listen: false);
    await provider.fetchGiftsByOccasion(data: widget.data, context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<FeaturedCategoriesProvider>(
      builder: (context, provider, child) {
        if (provider.gifts != null && provider.gifts?.data != null) {
          // Fixed calculation to show exactly 3 complete items
          const double screenHorizontalPadding = 16.0; // Main screen padding
          const double itemMargin = 5.0; // Each item margin on both sides
          const double totalItemMargins = itemMargin * 6; // 3 items × 2 margins each

          final double availableWidth = screenWidth - (screenHorizontalPadding * 2) - totalItemMargins;
          final double exactItemWidth = availableWidth / 3;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: CustomTextRow(
                  title: widget.data['attributes']['title'],
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => FeaturedCategoriesItemsScreen(
                          data: widget.data,
                        ),
                      ),
                    );
                  },
                  seeAll: AppStrings.viewAll.tr,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  height: 115,
                  child: SimpleBazaarAutoSlider(
                    itemWidth: exactItemWidth + (itemMargin * 2),
                    snapToItems: true,
                    items: provider.gifts!.data!.map((gift) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeaturedCategoriesViewAllInner(
                                data: gift,
                                isCategory: true,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: itemMargin),
                          width: exactItemWidth,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: PaddedNetworkBanner(
                                    imageUrl: gift.image ?? ApiConstants.placeholderImage,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 80,
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  gift.name ?? AppStrings.name.tr,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: homeItemsStyle(context).copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        } else {
          return const Center(child: Text(''));
        }
      },
    );
  }
}
