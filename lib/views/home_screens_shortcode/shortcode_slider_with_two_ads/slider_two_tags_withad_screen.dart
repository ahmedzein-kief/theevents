import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/widgets/custom_home_views/custom_home_text_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/custom_auto_slider_home.dart';
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

  List<int> extractSlotIds(String slotString) =>
      slotString.split(',').map((e) => int.parse(e.trim())).toList();

  Future<void> fetchSliderData() async {
    await Provider.of<BottomSliderProvider>(context, listen: false)
        .fetchSliders(data: widget.data, context);
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
            seeAll: AppStrings.viewAll,
            onTap: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => FreshPicksDetailScreen(
                          data: widget.data['attributes']['title'])));
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
                      if (slide.image != null) {
                        return CachedNetworkImage(
                          imageUrl: slide.image ?? '',
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          errorListener: (object) {
                            Image.asset(
                              'assets/placeholder.png', // Replace with your actual image path
                              fit: BoxFit.cover, // Adjust fit if needed
                              height: MediaQuery.sizeOf(context).height * 0.28,
                              width: double.infinity,
                            );
                          },
                          errorWidget: (context, object, error) => Image.asset(
                            'assets/placeholder.png', // Replace with your actual image path
                            fit: BoxFit.cover, // Adjust fit if needed
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                          ),
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                            color: Colors.blueGrey[300], // Background color
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/placeholder.png', // Replace with your actual image path
                                  fit: BoxFit.cover, // Adjust fit if needed
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                ),
                                const CupertinoActivityIndicator(
                                  radius: 16, // Adjust size of the loader
                                  animating: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return CachedNetworkImage(
                          imageUrl: 'assets/containing.png',
                          alignment: Alignment.center,
                          fit: BoxFit.fill,
                          width: screenWidth,
                          errorListener: (object) {
                            Image.asset(
                              'assets/placeholder.png', // Replace with your actual image path
                              fit: BoxFit.cover, // Adjust fit if needed
                              height: MediaQuery.sizeOf(context).height * 0.28,
                              width: double.infinity,
                            );
                          },
                          errorWidget: (context, object, error) => Image.asset(
                            'assets/placeholder.png', // Replace with your actual image path
                            fit: BoxFit.cover, // Adjust fit if needed
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                          ),
                          placeholder: (BuildContext context, String url) =>
                              Container(
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                            color: Colors.blueGrey[300], // Background color
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/placeholder.png', // Replace with your actual image path
                                  fit: BoxFit.cover, // Adjust fit if needed
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                ),
                                const CupertinoActivityIndicator(
                                  radius: 16, // Adjust size of the loader
                                  animating: true,
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    }).toList(),
                    // carouselController: carouselController,
                    options: CarouselOptions(
                      scrollPhysics: const BouncingScrollPhysics(),
                      autoPlay: true,
                      // aspectRatio: 1.9,
                      aspectRatio: screenWidth / (screenHeight / 6),
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
                          color: Colors.black.withOpacity(0.3), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 2, // Blur radius
                          offset:
                              const Offset(0, 01), // Offset for shadow position
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
        // _brandsItems(context)
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
  State<BrandsSlots> createState() => _BrandsSliderState();
}

class _BrandsSliderState extends State<BrandsSlots> {
  Future<void> fetchBrandsSliderData() async {
    await Provider.of<FeaturedBrandsItemsProvider>(context, listen: false)
        .fetchHomeBrands(widget.slotIds, context);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchBrandsSliderData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Consumer<FeaturedBrandsItemsProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(
              child: CircularProgressIndicator(
                  color: Colors.black, strokeWidth: 0.5));
        } else if (provider.hasError) {
          return Center(
              child: Text('Error fetching data: ${provider.hasError}'));
        } else if (provider.homeBrandsTypes != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Container(
                  height: screenHeight * 0.16,
                  padding: EdgeInsets.only(
                    // left: screenWidth * 0.04, // 4% of screen width
                    top: screenHeight * 0.0,
                    // bottom: screenHeight * 0.04
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.infoBackGround,
                  ),
                  child: AutoScrollingSlider(
                    itemWidth: 114,
                    children: provider.homeBrandsTypes!.data!.records!
                        .asMap()
                        .entries
                        .map((entry) {
                      final int index = entry.key;
                      final record = entry.value;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EComTagsScreens(slug: record.slug)));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: screenHeight * 0.01,
                                  top: screenHeight * 0.01),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: record.image ?? '',
                                    width: 110,
                                    height: 80,
                                    fit: BoxFit.contain,
                                    errorListener: (object) {
                                      Image.asset(
                                        'assets/placeholder.png', // Replace with your actual image path
                                        fit: BoxFit
                                            .cover, // Adjust fit if needed
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.28,
                                        width: double.infinity,
                                      );
                                    },
                                    errorWidget: (context, object, error) =>
                                        Image.asset(
                                      'assets/placeholder.png', // Replace with your actual image path
                                      fit: BoxFit.cover, // Adjust fit if needed
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.28,
                                      width: double.infinity,
                                    ),
                                    placeholder:
                                        (BuildContext context, String url) =>
                                            Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.28,
                                      width: double.infinity,
                                      color: Colors
                                          .blueGrey[300], // Background color
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/placeholder.png', // Replace with your actual image path
                                            fit: BoxFit
                                                .cover, // Adjust fit if needed
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.28,
                                            width: double.infinity,
                                          ),
                                          const CupertinoActivityIndicator(
                                            radius:
                                                16, // Adjust size of the loader
                                            animating: true,
                                          ),
                                        ],
                                      ),
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
        } else {
          return const Center(child: Text('Load...'));
        }
      },
    );
  }
}
