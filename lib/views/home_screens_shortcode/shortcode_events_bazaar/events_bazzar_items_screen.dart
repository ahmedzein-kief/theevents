import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../core/widgets/custom_app_views/search_bar.dart';
import '../../../core/widgets/custom_home_views/custom_grid_items.dart';
import '../../../core/widgets/padded_network_banner.dart';
import '../../../provider/shortcode_events_bazaar_provider/events_bazaar_provider.dart';

class EventsBazaarDetailScreen extends StatefulWidget {
  const EventsBazaarDetailScreen({
    super.key,
    required this.imageUrls,
    required this.titles,
    required this.title,
  });

  final String title;
  final List<String> imageUrls;
  final List<String> titles;

  @override
  State<EventsBazaarDetailScreen> createState() => _EventsBazaarDetailScreenState();
}

class _EventsBazaarDetailScreenState extends State<EventsBazaarDetailScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
        _isLoading = false;
      });
    }
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
                            hintText: AppStrings.searchEvents.tr,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              left: screenWidth * 0.02,
                              right: screenWidth * 0.02,
                              top: screenHeight * 0.02,
                            ),
                            child: SizedBox(
                              height: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: PaddedNetworkBanner(
                                  imageUrl: data ?? ApiConstants.placeholderImage,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.02,
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                            ),
                            child: Text(
                              widget.title,
                              style: boldHomeTextStyle(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: screenHeight * 0.005,
                              left: screenWidth * 0.04,
                              right: screenWidth * 0.04,
                            ),
                            child: GridView.builder(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 15,
                                childAspectRatio: 0.8,
                              ),
                              itemCount: widget.imageUrls.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) => GridItemsHomeSeeAll(
                                imageUrl: widget.imageUrls[index],
                                name: widget.titles[index],
                                textStyle: eventsBazaarDetail(context),
                                onTap: () {},
                              ),
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
