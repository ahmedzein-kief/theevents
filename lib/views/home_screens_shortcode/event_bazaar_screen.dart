import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_events_bazaar/events_bazzar_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auto_slider_home.dart';
import '../../core/widgets/custom_home_views/custom_home_text_row.dart';
import '../../provider/locale_provider.dart';
import '../../provider/shortcode_events_bazaar_provider/events_bazaar_provider.dart';

class EventBazaarScreen extends StatefulWidget {
  const EventBazaarScreen({super.key, required this.data});

  final dynamic data;

  @override
  State<EventBazaarScreen> createState() => _EventBazaarViewState();
}

class _EventBazaarViewState extends State<EventBazaarScreen> {
  Future<void> fetchEvents(List<String> countries) async {
    Provider.of<EventBazaarProvider>(context, listen: false).fetchEvents(countries, context);
  }

  @override
  void initState() {
    super.initState();
    final String countriesString = widget.data['attributes']['countries'];

    final List<String> countries = countriesString.split(',');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEvents(countries);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final provider = Provider.of<EventBazaarProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);

    // Fixed calculation to show exactly 3 complete items
    const double screenHorizontalPadding = 16.0; // Main screen padding
    const double itemSpacing = 8.0; // Space between items (4 on each side of item)
    const double totalSpacingBetweenItems = itemSpacing * 2; // Total spacing between 3 items

    // Add extra 12 pixels to compensate for the missing space on the right
    final double availableWidth = screenWidth - 32 - 8;
    final double exactItemWidth = (availableWidth - totalSpacingBetweenItems) / 3;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.02),
          child: CustomTextRow(
            title: widget.data['attributes']['title'],
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => EventsBazaarDetailScreen(
                    title: widget.data['attributes']['title'],
                    imageUrls: provider.events
                        .map(
                          (event) => 'https://apistaging.theevents.ae/storage/flags/${event.iso!.toLowerCase()}.png',
                        )
                        .toList(),
                    titles: provider.events.map((event) => '${event.title} Bazaar').toList(),
                  ),
                ),
              );
            },
            seeAll: AppStrings.viewAll.tr,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 115,
            child: SimpleBazaarAutoSlider(
              itemWidth: exactItemWidth + itemSpacing,
              snapToItems: true, // Enable snapping to items
              items: provider.events.map((event) {
                final isRTL = localeProvider.isCurrentLocaleRTL;
                return Container(
                  width: exactItemWidth, // Use exact calculated width
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CachedNetworkImage(
                            imageUrl: 'https://apistaging.theevents.ae/storage/flags/${event.iso!.toLowerCase()}.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 80,
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.cover,
                              height: 80,
                              width: double.infinity,
                            ),
                            placeholder: (context, url) => Container(
                              height: 80,
                              width: double.infinity,
                              color: Colors.blueGrey[300],
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'assets/placeholder.png',
                                    fit: BoxFit.cover,
                                    height: 80,
                                    width: double.infinity,
                                  ),
                                  const CupertinoActivityIndicator(
                                    radius: 16,
                                    animating: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text.rich(
                        TextSpan(
                          style: homeEventsBazaarStyle(context).copyWith(fontSize: 12),
                          children: isRTL
                              ? [
                                  TextSpan(text: 'Bazaar'.tr),
                                  const WidgetSpan(child: SizedBox(width: 4)),
                                  TextSpan(text: event.title),
                                ]
                              : [
                                  TextSpan(text: event.title),
                                  const WidgetSpan(child: SizedBox(width: 4)),
                                  TextSpan(text: 'Bazaar'.tr),
                                ],
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
