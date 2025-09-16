import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/custom_home_views/custom_home_text_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/widgets/custom_auto_slider_home.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../provider/home_shortcode_provider/featured_brands_items_provider.dart';
import '../../../provider/home_shortcode_provider/simple_slider_provider.dart';
import '../shortcode_fresh_picks/e_com_tags_screens.dart';
import '../shortcode_fresh_picks/fresh_picks_detail_screen.dart';

class SliderTwoTagsWithAdScreen extends StatefulWidget {
  const SliderTwoTagsWithAdScreen({super.key, required this.data});

  final dynamic data;

  @override
  _SimpleSliderState createState() => _SimpleSliderState();
}

class _SimpleSliderState extends State<SliderTwoTagsWithAdScreen> {
  int currentIndexCarousel = 0;
  final CarouselController carouselController = CarouselController();

  late List<int> slotIds1;
  List<int>? slotIds2;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchSliderData();
    });
    slotIds1 = extractSlotIds(widget.data['attributes']['slot_1']);
    if (widget.data['attributes'].containsKey('slot_2')) {
      slotIds2 = extractSlotIds(widget.data['attributes']['slot_2']);
    }
  }

  List<int> extractSlotIds(String slotString) => slotString.split(',').map((e) => int.parse(e.trim())).toList();

  Future<void> fetchSliderData() async {
    await Provider.of<BottomSliderProvider>(context, listen: false).fetchSliders(data: widget.data, context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final sliderProvider = Provider.of<BottomSliderProvider>(context);
    final homeBanner = sliderProvider.homeBanner;
    final slides = homeBanner?.data?.slides ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: CustomTextRow(
            title: widget.data['attributes']['title'],
            seeAll: AppStrings.viewAll.tr,
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => FreshPicksDetailScreen(
                    data: widget.data['attributes']['title'],
                  ),
                ),
              );
            },
          ),
        ),
        Stack(
          children: [
            InkWell(
              onTap: () {
                // print(currentIndexCarousel);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CarouselSlider(
                    items: slides.map((slide) {
                      return PaddedNetworkBanner(
                        imageUrl: slide.mobileImage ?? 'assets/containing.png',
                        height: 160,
                        width: screenWidth,
                        fit: BoxFit.cover,
                        padding: EdgeInsets.zero,
                        borderRadius: 8,
                        alignment: Alignment.center,
                        gradientColors: const [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
                        cacheKey: slide.mobileImage != null ? 'slide_${slide.mobileImage.hashCode}' : null,
                      );
                    }).toList(),
                    options: CarouselOptions(
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      height: 160,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndexCarousel = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: slides
                .asMap()
                .entries
                .map(
                  (entry) => Container(
                    width: currentIndexCarousel == entry.key ? 21 : 7,
                    height: 7,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: const Offset(0, 01),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(14),
                      color: currentIndexCarousel == entry.key
                          ? Colors.white.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        BrandsSlots(slotIds: slotIds1),
        if (slotIds2 != null) BrandsSlots(slotIds: slotIds2!),
      ],
    );
  }
}

class BrandsSlots extends StatefulWidget {
  const BrandsSlots({super.key, required this.slotIds});

  final List<int> slotIds;

  @override
  State<BrandsSlots> createState() => _BrandsSlotsState();
}

class _BrandsSlotsState extends State<BrandsSlots> {
  Future<void> fetchBrandsSliderData() async {
    await Provider.of<FeaturedBrandsItemsProvider>(context, listen: false).fetchHomeBrands(widget.slotIds, context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBrandsSliderData();
    });
  }

  final List<LinearGradient> cardGradients = [
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3A4042), Color(0xFF1F2223)], // dark grey
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFE9A676), Color(0xFF6A3B28)], // peach/brown
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFFB06060), Color(0xFF3D1F1F)], // pink/maroon
    ),
    const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF3B1F5E), Color(0xFF1A0D2E)], // purple
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<FeaturedBrandsItemsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
              strokeWidth: 0.5,
            ),
          );
        } else if (provider.hasError) {
          return Center(
            child: Text(
              '${AppStrings.errorFetchingData.tr}: ${provider.hasError}',
            ),
          );
        } else if (provider.homeBrandsTypes != null) {
          // Fixed calculation to show exactly 4 complete items
          const double screenHorizontalPadding = 16.0;
          const double itemMargin = 4.0;
          const double totalItemMargins = itemMargin * 8; // 4 items × 2 margins

          final double availableWidth = screenWidth - (screenHorizontalPadding * 2) - totalItemMargins;
          final double exactItemWidth = availableWidth / 4;

          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SizedBox(
                    height: 100,
                    child: SimpleBazaarAutoSlider(
                      itemWidth: exactItemWidth + (itemMargin * 2),
                      snapToItems: true,
                      items: provider.homeBrandsTypes!.data!.records!.map((record) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EComTagsScreens(slug: record.slug),
                              ),
                            );
                          },
                          child: Container(
                            width: exactItemWidth,
                            margin: const EdgeInsets.symmetric(horizontal: itemMargin),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: cardGradients[(record.id ?? 0) % cardGradients.length],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha((0.1 * 255).toInt()),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: PaddedNetworkBanner(
                                      imageUrl: record.image ?? ApiConstants.placeholderImage,
                                      height: 60,
                                      // you can tweak this to fit your layout
                                      width: exactItemWidth,
                                      fit: BoxFit.contain,
                                      borderRadius: 0,
                                      // keeps image square inside the card
                                      gradientColors: const [
                                        Colors.transparent,
                                        Colors.transparent, // no gradient overlay for brand logos
                                      ],
                                      cacheKey: record.image != null ? 'brand_${record.image.hashCode}' : null,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    record.name ?? '',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
              ),
            ],
          );
        } else {
          return Center(child: Text('${AppStrings.loading.tr}...'));
        }
      },
    );
  }
}
