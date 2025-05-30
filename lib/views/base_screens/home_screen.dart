import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../provider/cart_item_provider/cart_item_provider.dart';
import '../../provider/shortcode_fresh_picks_provider/fresh_picks_provider.dart';
import '../../provider/shortcode_home_page_provider.dart';
import '../../provider/wishlist_items_provider/wishlist_provider.dart';
import '../../core/styles/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/custom_app_views/search_bar.dart';
import '../home_screens_shortcode/banner_ads_screen.dart';
import '../home_screens_shortcode/event_bazaar_screen.dart';
import '../home_screens_shortcode/featured_categories_screen.dart';
import '../home_screens_shortcode/shorcode_featured_brands/featured_brands_screen.dart';
import '../home_screens_shortcode/shortcode_fresh_picks/fresh_picks_screen.dart';
import '../home_screens_shortcode/shortcode_information_icons/information_icons.dart';
import '../home_screens_shortcode/shortcode_slider_with_two_ads/slider_two_tags_withad_screen.dart';
import '../home_screens_shortcode/shortcode_user_by_type/users_by_type_screen.dart';
import '../home_screens_shortcode/simple_slider_screen.dart';
import 'base_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenViewState();
}

class _HomeScreenViewState extends State<HomeScreen> {
  // KEY FOR STORE THE USERNAME
  String? userName;

  late bool _isLoggedIn = false;

  // FUNCTION FOR STORE The Name of user
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = ModalRoute.of(context)!.settings.arguments as String? ?? prefs.getString('userName');
    });
  }

  Future<void> _loadLoginState() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  final String assetName = 'assets/applogo.svg';

  Future<void> fetchHomePageData(BuildContext context) async {
    final provider = Provider.of<HomePageProvider>(context, listen: false);
    await provider.fetchHomePageData();
  }

  Future<void> _refreshHomePage() async {
    await fetchHomePageData(context);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.wait([
        // _loadUserName(),
        _loadLoginState(),
        fetchHomePageData(context),
      ]);
      // _loadUserName();
      // fetchHomePageData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String displayName = userName ?? "";
    final wishlistProvider = Provider.of<WishlistProvider>(context, listen: true);
    final mainProvider = Provider.of<HomePageProvider>(context, listen: true);
    final freshListProvider = Provider.of<FreshPicksProvider>(context, listen: true);
    final cartProvider = Provider.of<CartProvider>(context, listen: true);
    return BaseAppBar(
      firstRightIconPath: AppStrings.firstRightIconPath,
      secondRightIconPath: AppStrings.secondRightIconPath,
      thirdRightIconPath: AppStrings.thirdRightIconPath,
      body: RefreshIndicator(
        color: Theme.of(context).colorScheme.onPrimary,
        onRefresh: () async {
          _refreshHomePage();
        },
        child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      CustomSearchBar(
                        hintText: 'Search Events',
                      ),
                      Expanded(
                        child: Consumer<HomePageProvider>(
                          builder: (context, provider, _) {
                            if (mainProvider.isLoading) {
                              // return _buildShimmerLoading();
                              return Container();
                            } else if (provider.extractedData.isEmpty) {
                              return Center(
                                  child: IconButton(
                                icon: const Icon(Icons.refresh, size: 40, color: AppColors.peachyPink),
                                onPressed: _refreshHomePage,
                              ));
                            } else {
                              return SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: provider.extractedData.map((data) {
                                          switch (data['shortcode']) {
                                            case 'shortcode-simple-slider':
                                              return SimpleSlider(data: data);
                                            case 'shortcode-featured-categories':
                                              return FeaturedCategoriesScreen(data: data);
                                            case 'shortcode-information-icons':
                                              return ShortcodeInformationIconsScreen(data: data);
                                            case 'shortcode-events-bazaar':
                                              return EventBazaarScreen(data: data);
                                            case 'shortcode-vendors-by-type':
                                              return UsersByTypeScreen(data: data);
                                            case 'shortcode-ads':
                                              return BannerAdsScreen(data: data);
                                            case 'shortcode-fresh-picks':
                                              return FreshPicksScreen(data: data);
                                            case 'shortcode-users-by-type':
                                              return UsersByTypeScreen(data: data);
                                            case 'shortcode-featured-brands':
                                              return FeaturedBrandsScreen(data: data);
                                            case 'shortcode-two-tags-blocks-with-ad':
                                              return SliderTwoTagsWithAdScreen(data: data);
                                            default:
                                              return const SizedBox.shrink();
                                          }
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (mainProvider.isLoading || wishlistProvider.isLoading || freshListProvider.isLoading || cartProvider.isLoading)
                    Container(
                      color: Colors.black.withOpacity(0.5), // Semi-transparent background
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.peachyPink),
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ),
    );
  }
}

//    this is one of the
