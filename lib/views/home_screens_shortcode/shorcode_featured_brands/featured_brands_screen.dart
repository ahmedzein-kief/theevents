import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/views/home_screens_shortcode/shorcode_featured_brands/featured_brands_view_all.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/home_shortcode_provider/featured_brands_provider.dart';
import '../../../core/widgets/custom_auto_slider_home.dart';
import '../../../core/widgets/custom_home_views/custom_home_text_row.dart';
import 'featured_brands_items_screen.dart';

class FeaturedBrandsScreen extends StatefulWidget {
  final dynamic data;

  const FeaturedBrandsScreen({required this.data});

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
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Consumer<FeaturedBrandsProvider>(builder: (context, provider, child) {
      final brands = provider.topBrands?.data ?? [];
      final brandWidgets = brands.map((brand) {
        return Container(
          color: AppColors.infoBackGround,
          height: 200,
          child: Column(
            children: [
              // Text(brand.slug.toString()),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4, vertical: screenHeight * 0.02),
                  child: ClipRRect(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => FeaturedBrandsItemsScreen(slug: brand.slug.toString())));
                      },
                      child: CachedNetworkImage(
                        imageUrl: brand.logo ?? 'https://via.placeholder.com/110x80',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorListener: (object){
                          Image.asset(
                            'assets/placeholder.png', // Replace with your actual image path
                            fit: BoxFit.cover, // Adjust fit if needed
                            height: MediaQuery.sizeOf(context).height * 0.28,
                            width: double.infinity,
                          );
                        },
                        errorWidget: (context,object,error){
                          return Image.asset(
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
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList();

      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CustomTextRow(
              title: widget.data['attributes']['title'],
              seeAll: AppStrings.viewAll,
              onTap: () {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => FeaturedBrandsScreenViewAll(
                              data: widget.data['attributes']['title'],
                            )));
              },
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: screenHeight * 0.16,
            // color: Colors.red,
            child: AutoScrollingSlider(
              itemWidth: 100,
              children: brandWidgets, // 110 + 2*2 (width of image + margin)
            ),
          ),
        ],
      );
    });
  }
}
