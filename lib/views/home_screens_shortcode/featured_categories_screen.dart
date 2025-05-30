import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_featured_categories/featured_categories_items_screen.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_featured_categories/featured_categories_viewall_inner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/shortcode_featured_categories_provider/featured_categories_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auto_slider_home.dart';
import '../../core/widgets/custom_home_views/custom_home_text_row.dart';

class FeaturedCategoriesScreen extends StatefulWidget {
  final dynamic data;

  const FeaturedCategoriesScreen({super.key, required this.data});

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
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;

    return Consumer<FeaturedCategoriesProvider>(
      builder: (context, provider, child) {
        if (provider.gifts != null && provider.gifts?.data != null) {
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: CustomTextRow(
                  title: widget.data['attributes']['title'],
                  onTap: () {
                    Navigator.push(context, CupertinoPageRoute(builder: (context) => FeaturedCategoriesItemsScreen(data: widget.data)));
                  },
                  seeAll: AppStrings.viewAll,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * (115 / MediaQuery.of(context).size.height),
                child: AutoScrollingSlider(
                  itemWidth: 110,
                  children: provider.gifts!.data!.map((gift) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeaturedCategoriesViewAllInner(
                                      // FeaturedCategoryDetailScreen(
                                      data: gift, isCategory: true,
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: gift.image ?? '',
                                fit: BoxFit.cover,
                                width: screenWidth * (110 / screenWidth),
                                height: screenHeight * (115 / screenHeight) * 0.75,
                                errorWidget: (context,object,_){
                                  return Image.asset(
                                    'assets/placeholder.png', // Replace with your actual image path
                                    fit: BoxFit.cover, // Adjust fit if needed
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                  );
                                },
                                errorListener: (object){
                                   Image.asset(
                                    'assets/placeholder.png', // Replace with your actual image path
                                    fit: BoxFit.cover, // Adjust fit if needed
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                  );
                                },
                                placeholder: (BuildContext context, String url) {
                                  return Container(
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                    color: Colors.blueGrey[300], // Background color
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/placeholder.png', // Replace with your actual image path
                                          fit: BoxFit.cover, // Adjust fit if needed
                                          height: MediaQuery.sizeOf(context).height * 0.28,
                                          width: double.infinity,
                                        ),
                                        const CupertinoActivityIndicator(
                                          radius: 16, // Adjust size of the loader
                                          animating: true,
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(gift.name ?? 'Name', overflow: TextOverflow.ellipsis, softWrap: true, textAlign: TextAlign.center, style: homeItemsStyle(context)),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
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
