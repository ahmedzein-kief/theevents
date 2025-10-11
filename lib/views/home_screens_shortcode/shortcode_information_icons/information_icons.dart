import 'dart:async';

import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/views/auth_screens/auth_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/router/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';

class ShortcodeInformationIconsScreen extends StatefulWidget {
  const ShortcodeInformationIconsScreen({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<ShortcodeInformationIconsScreen> createState() => _ShortcodeInformationIconsScreenState();
}

class _ShortcodeInformationIconsScreenState extends State<ShortcodeInformationIconsScreen> {
  late ScrollController _scrollController;
  late double _itemWidth;
  Timer? _snapTimer;
  bool _isUserScrolling = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _snapTimer?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.isScrollingNotifier.value) {
      _isUserScrolling = true;

      // Cancel previous snap timer
      _snapTimer?.cancel();

      // Start new snap timer
      _snapTimer = Timer(const Duration(milliseconds: 150), () {
        if (mounted && _isUserScrolling) {
          _snapToNearestItem();
          _isUserScrolling = false;
        }
      });
    }
  }

  List<Map<String, String>> _getItems() {
    final List<Map<String, String>> items = [];

    widget.data['attributes'].forEach((key, value) {
      if (key.startsWith('title')) {
        final String index = key.replaceAll('title', '');
        final String title = value;
        final String link = widget.data['attributes']['link$index'] ?? '';
        final String icon = widget.data['attributes']['icon$index'] ?? '';

        items.add({
          'title': title,
          'link': link,
          'icon': 'https://apistaging.theevents.ae/storage/$icon',
        });
      }
    });

    return items;
  }

  void _snapToNearestItem() {
    if (!_scrollController.hasClients) return;

    final double currentScroll = _scrollController.position.pixels;
    final double nearestItemPosition = (currentScroll / _itemWidth).round() * _itemWidth;

    _scrollController.animateTo(
      nearestItemPosition,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final List<Map<String, String>> items = _getItems();

    // Calculate item width to show 4 items at once
    _itemWidth = screenWidth / 4;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.infoBackGround,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha((0.2 * 255).toInt()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.width * (145 / MediaQuery.of(context).size.width),
            child: ListView.builder(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              // Better for snapping
              itemCount: items.length,
              itemBuilder: (context, index) {
                final String icon = items[index]['icon']!;

                return SizedBox(
                  width: _itemWidth,
                  child: GestureDetector(
                    onTap: () async {
                      // Capture navigator before any async operations
                      final navigator = Navigator.of(context);

                      String routeName;

                      switch (index) {
                        case 0:
                          final bool isLoggedIn = await SecurePreferencesUtil.isLoggedIn();
                          if (!isLoggedIn) {
                            navigator.push(
                              CupertinoPageRoute(
                                builder: (context) => const AuthScreen(),
                                fullscreenDialog: true,
                              ),
                            );
                            return;
                          }
                          routeName = AppRoutes.orderPage;
                          break;
                        case 1:
                          routeName = AppRoutes.newProduct;
                          break;
                        case 2:
                          routeName = AppRoutes.giftCard;
                          break;
                        case 3:
                          routeName = AppRoutes.eventBrand;
                          break;
                        case 4:
                          routeName = AppRoutes.bestSeller;
                          break;
                        case 5:
                          routeName = AppRoutes.discountScreen;
                          break;
                        default:
                          routeName = '';
                      }

                      if (routeName.isNotEmpty) {
                        navigator.pushNamed(
                          routeName,
                          arguments: {'title': items[index]['title']},
                        );
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: screenHeight * 0.02,
                        top: screenHeight * 0.02,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withAlpha((0.2 * 255).toInt()),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.network(
                                icon,
                                height: screenWidth * 0.1,
                                width: screenWidth * 0.1,
                                errorBuilder: (context, error, object) => Image.asset(
                                  'assets/placeholder.png',
                                  fit: BoxFit.cover,
                                  height: screenWidth * 0.1,
                                  width: screenWidth * 0.1,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            items[index]['title']!,
                            style: shotCodeInfoTextStyle(context),
                            softWrap: true,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
