import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/views/home_screens_shortcode/shortcode_events_bazaar/events_bazzar_items_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_strings.dart';
import '../../core/styles/custom_text_styles.dart';
import '../../core/widgets/custom_auto_slider_home.dart';
import '../../core/widgets/custom_home_views/custom_home_text_row.dart';
import '../../provider/shortcode_events_bazaar_provider/events_bazaar_provider.dart';

class EventBazaarScreen extends StatefulWidget {
  const EventBazaarScreen({super.key, required this.data});
  final dynamic data;

  @override
  State<EventBazaarScreen> createState() => _EventBazaarViewState();
}

class _EventBazaarViewState extends State<EventBazaarScreen> {
  Future<void> fetchEvents(List<String> countries) async {
    Provider.of<EventBazaarProvider>(context, listen: false)
        .fetchEvents(countries, context);
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

    return Consumer<EventBazaarProvider>(
      builder: (context, provider, _) => Column(
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
                          .map((event) =>
                              'https://api.staging.theevents.ae/storage/flags/${event.value!.toLowerCase()}.png')
                          .toList(),
                      titles: provider.events
                          .map((event) => '${event.title} Bazaar')
                          .toList(),
                    ),
                  ),
                );
              },
              seeAll: AppStrings.viewAll,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height *
                (115 / MediaQuery.of(context).size.height),
            child: AutoScrollingSlider(
              itemWidth: 110,
              children: [
                ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.events.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final events = provider.events[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        'https://api.staging.theevents.ae/storage/flags/${events.value!.toLowerCase()}.png',
                                    fit: BoxFit.cover,
                                    width: screenWidth * (110 / screenWidth),
                                    height: screenHeight *
                                        (115 / screenHeight) *
                                        0.75,
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
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                  '${events.title} Bazaar' ?? 'No Title',
                                  style: homeEventsBazaarStyle(context)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
