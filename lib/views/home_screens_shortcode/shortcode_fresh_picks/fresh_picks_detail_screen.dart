import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/widgets/custom_app_views/search_bar.dart';
import 'package:event_app/views/base_screens/base_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../filters/items_sorting_drop_down.dart';
import 'e_com_tags_screens.dart';

class FreshPicksDetailScreen extends StatefulWidget {
  const FreshPicksDetailScreen({super.key, required this.data});

  final String data;

  @override
  State<FreshPicksDetailScreen> createState() => _FreshPicksDetailScreenState();
}

class _FreshPicksDetailScreenState extends State<FreshPicksDetailScreen> {
  String _selectedSortBy = 'default_sorting';
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false; // default to false
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchData();
      fetchCategories();
      _scrollController.addListener(_onScroll);
    });
  }

  Future<void> fetchData() async {
    final getTagsData = Provider.of<FreshPicksProvider>(context, listen: false);
    await getTagsData.fetchTags();
  }

  Future<void> fetchCategories() async {
    try {
      setState(() {
        _isFetchingMore = true;
      });
      await Provider.of<FreshPicksProvider>(context, listen: false).fetchEcomTags(
        perPage: 20,
        page: _currentPage,
        sortBy: _selectedSortBy,
      );
      setState(() {
        _isFetchingMore = false;
      });
    } catch (error) {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_isFetchingMore) return;
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      _currentPage++;
      _isFetchingMore = true;
      fetchCategories();
    }
  }

  void _onSortChanged(String newValue) {
    setState(() {
      _selectedSortBy = newValue;
      _currentPage = 1;
      Provider.of<FreshPicksProvider>(context, listen: false).recordsData.clear(); // Clear existing products
    });
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;
    return BaseAppBar(
      textBack: AppStrings.back.tr,
      customBackIcon: const Icon(Icons.arrow_back_ios_sharp, size: 16),
      firstRightIconPath: AppStrings.firstRightIconPath.tr,
      secondRightIconPath: AppStrings.secondRightIconPath.tr,
      thirdRightIconPath: AppStrings.thirdRightIconPath.tr,
      body: Scaffold(
        body: SafeArea(
          child: Consumer<FreshPicksProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading && _currentPage == 1) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 0.5,
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomSearchBar(
                      hintText: AppStrings.searchEvents.tr,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.02,
                                right: screenWidth * 0.02,
                                top: screenHeight * 0.02,
                              ),
                              child: SizedBox(
                                height: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(5),
                                  child: CachedNetworkImage(
                                    imageUrl: provider.tagsModel?.data?.coverImage ?? '',
                                    fit: BoxFit.fill,
                                    errorListener: (object) {
                                      Image.asset(
                                        'assets/placeholder.png',
                                        // Replace with your actual image path
                                        fit: BoxFit.cover,
                                        // Adjust fit if needed
                                        height: MediaQuery.sizeOf(context).height * 0.28,
                                        width: double.infinity,
                                      );
                                    },
                                    errorWidget: (context, object, error) => Image.asset(
                                      'assets/placeholder.png',
                                      // Replace with your actual image path
                                      fit: BoxFit.cover,
                                      // Adjust fit if needed
                                      height: MediaQuery.sizeOf(context).height * 0.28,
                                      width: double.infinity,
                                    ),
                                    placeholder: (BuildContext context, String url) => Container(
                                      height: MediaQuery.sizeOf(context).height * 0.28,
                                      width: double.infinity,
                                      color: Colors.blueGrey[300],
                                      // Background color
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/placeholder.png',
                                            // Replace with your actual image path
                                            fit: BoxFit.cover,
                                            // Adjust fit if needed
                                            height: MediaQuery.sizeOf(context).height * 0.28,
                                            width: double.infinity,
                                          ),
                                          const CupertinoActivityIndicator(
                                            radius: 16,
                                            // Adjust size of the loader
                                            animating: true,
                                          ),
                                        ],
                                      ),
                                    ),
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    widget.data,
                                    style: boldHomeTextStyle(),
                                  ),
                                  ItemsSortingDropDown(
                                    selectedSortBy: _selectedSortBy,
                                    onSortChanged: (newValue) {
                                      _onSortChanged(newValue);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                left: screenWidth * 0.02,
                                right: screenWidth * 0.02,
                                top: screenHeight * 0.01,
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 20,
                                  mainAxisExtent: screenHeight * 0.16,
                                ),
                                itemCount: provider.recordsData.length + (_isFetchingMore ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (_isFetchingMore && index == provider.recordsData.length) {
                                    return const Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                  final record = provider.recordsData[index];
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (builder) => EComTagsScreens(
                                            slug: record.slug,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          flex: 4,
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              color: AppColors.freshItemsBack,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: record.image,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              errorListener: (object) {
                                                Image.asset(
                                                  'assets/placeholder.png',
                                                  // Replace with your actual image path
                                                  fit: BoxFit.cover,
                                                  // Adjust fit if needed
                                                  height: MediaQuery.sizeOf(context).height * 0.28,
                                                  width: double.infinity,
                                                );
                                              },
                                              errorWidget: (context, object, error) => Image.asset(
                                                'assets/placeholder.png',
                                                // Replace with your actual image path
                                                fit: BoxFit.cover,
                                                // Adjust fit if needed
                                                height: MediaQuery.sizeOf(context).height * 0.28,
                                                width: double.infinity,
                                              ),
                                              placeholder: (
                                                BuildContext context,
                                                String url,
                                              ) =>
                                                  Container(
                                                height: MediaQuery.sizeOf(context).height * 0.28,
                                                width: double.infinity,
                                                color: Colors.blueGrey[300],
                                                // Background color
                                                child: Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/placeholder.png',
                                                      // Replace with your actual image path
                                                      fit: BoxFit.cover,
                                                      // Adjust fit if needed
                                                      height: MediaQuery.sizeOf(
                                                            context,
                                                          ).height *
                                                          0.28,
                                                      width: double.infinity,
                                                    ),
                                                    const CupertinoActivityIndicator(
                                                      radius: 16,
                                                      // Adjust size of the loader
                                                      animating: true,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Builder(
                                            builder: (context) => Text(
                                              record.name,
                                              style: eventsBazaarDetail(
                                                context,
                                              ),
                                              maxLines: 1,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
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
