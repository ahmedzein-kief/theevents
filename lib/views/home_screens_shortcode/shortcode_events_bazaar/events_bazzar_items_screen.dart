import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/shortcode_events_bazaar_provider/events_bazaar_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_home_views/custom_grid_items.dart';

class EventsBazaarDetailScreen extends StatefulWidget {
  final String title;
  final List<String> imageUrls;
  final List<String> titles;

  const EventsBazaarDetailScreen({
    super.key,
    required this.imageUrls,
    required this.titles,
    required this.title,
  });

  @override
  State<EventsBazaarDetailScreen> createState() => _EventsBazaarDetailScreenState();
}

class _EventsBazaarDetailScreenState extends State<EventsBazaarDetailScreen> {
  late bool _isLoggedIn = false;

  bool _isLoading = true;
  bool _hasError = false;
  late List<String> _fetchImageUrls;
  late List<String> _fetchedTitles;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchBannerData();
    });
  }

  Future<void> fetchBannerData() async {
    final provider = Provider.of<EventBazaarProvider>(context, listen: false);
    try {
      await provider.fetchEventBazaarData(context);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      setState(() {
        _fetchImageUrls = widget.imageUrls;
        _fetchedTitles = widget.titles;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return BaseAppBar(
      textBack: AppStrings.back,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.5,
                  ),
                )
              : Consumer<EventBazaarProvider>(
                  builder: (context, provider, child) {
                    final data = provider.eventBazaarBanner?.data?.coverImage;
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CustomSearchBar(
                            hintText: "Search ${widget.title}",
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: screenWidth * 0.02, right: screenWidth * 0.02, top: screenHeight * 0.02),
                            child: SizedBox(
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  data ?? "",
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, provider, error) {
                                    return const SizedBox.shrink();
                                  },
                                  loadingBuilder: (context, child, loadingProcessor) {
                                    if (loadingProcessor == null) return child;
                                    return Container(
                                      height: 100,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Colors.grey, Colors.black])),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.04, right: screenWidth * 0.04),
                              child: Text(
                                widget.title,
                                style: boldHomeTextStyle(),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: screenHeight * 0.005, left: screenWidth * 0.04, right: screenWidth * 0.04),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 18, mainAxisSpacing: 15, childAspectRatio: 0.8),
                              itemCount: widget.imageUrls.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return GridItemsHomeSeeAll(
                                  imageUrl: widget.imageUrls[index],
                                  name: widget.titles[index],
                                  textStyle: eventsBazaarDetail(context),
                                  onTap: () {
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
