import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/home_shortcode_provider/simple_slider_provider.dart';

class SimpleSlider extends StatefulWidget {
  final dynamic data;

  const SimpleSlider({super.key, required this.data});

  @override
  _SimpleSliderState createState() => _SimpleSliderState();
}

class _SimpleSliderState extends State<SimpleSlider> {
  int currentIndexCarousel = 0;
  final CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      fetchSliderData();
    });
  }

  Future<void> fetchSliderData() async {
    await Provider.of<TopSliderProvider>(context, listen: false).fetchSliders(data: widget.data, context);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.sizeOf(context).width;

    final sliderProvider = Provider.of<TopSliderProvider>(context);
    final homeBanner = sliderProvider.homeBanner;
    final slides = homeBanner?.data?.slides ?? [];

    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            child: widget.data['attributes']['title'] != null ? Text(style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 22), widget.data['attributes']['title']) : null,
          ),
          Column(
            children: [
              InkWell(
                onTap: () {
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CarouselSlider(
                      items: slides.map((slide) {
                        if (slide.image != null) {
                          return CachedNetworkImage(
                            cacheKey: slide.image,
                            imageUrl: "${slide.image}?v=${DateTime.now().millisecondsSinceEpoch}",
                            alignment: Alignment.center,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            filterQuality: FilterQuality.high,
                            errorWidget: (context,error,object){
                              return Image.asset('assets/placeholder.png', // Replace with your actual image path
                                fit: BoxFit.cover, // Adjust fit if needed
                                height: MediaQuery.sizeOf(context).height * 0.28,
                                width: double.infinity,
                              );
                            },
                            errorListener: (object){
                                  Image.asset('assets/placeholder.png', // Replace with your actual image path
                                    fit: BoxFit.cover, // Adjust fit if needed
                                    height: MediaQuery.sizeOf(context).height * 0.28,
                                    width: double.infinity,
                                  );
                            },
                            placeholder: (BuildContext context, String url) {
                              return Container(
                                height: MediaQuery.sizeOf(context).height * 0.28,
                                width: double.infinity,
                                color: Colors.blueGrey[100], // Background color
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const CupertinoActivityIndicator(
                                      radius: 16, // Adjust size of the loader
                                      animating: true,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      }).toList(),
                      options: CarouselOptions(
                        scrollPhysics: const BouncingScrollPhysics(),
                        // Bouncy effect when swiping
                        autoPlay: true,
                        // Auto-play slides
                        autoPlayInterval: const Duration(seconds: 5),
                        // Adjust interval between slides
                        autoPlayCurve: Curves.linearToEaseOut,
                        // Smooth and natural transition
                        autoPlayAnimationDuration: const Duration(milliseconds: 800),
                        // Slower movement
                        enableInfiniteScroll: true,
                        // Infinite loop of slides
                        pauseAutoPlayOnTouch: true,
                        // Pause auto-play when the user interacts
                        enlargeCenterPage: false,
                        // Avoid zooming the current slide
                        viewportFraction: 1,
                        // Show one slide at a time
                        aspectRatio: screenWidth / (screenHeight / 6),
                        // Adjust aspect ratio
                        onPageChanged: (index, reason) {
                          setState(() {
                            currentIndexCarousel = index; // Update indicator
                          });
                        },
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: slides.asMap().entries.map((entry) {
                    return Container(
                      width: currentIndexCarousel == entry.key ? 21 : 7,
                      height: 7,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          // Shadow color
                          spreadRadius: 1,
                          // Spread radius
                          blurRadius: 2,
                          // Blur radius
                          offset: const Offset(0, 01), // Offset for shadow position
                        ),
                      ], borderRadius: BorderRadius.circular(14), color: currentIndexCarousel == entry.key ? Colors.white.withOpacity(0.7) : Colors.white.withOpacity(0.7)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
