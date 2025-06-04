import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/dashboard/user_by_type_model/home_celebraties_models.dart';
import '../../styles/custom_text_styles.dart';
import 'custom_home_text_row.dart';

class CustomUserByTypeBox extends StatelessWidget {
  const CustomUserByTypeBox({
    super.key,
    required this.fetchData,
    required this.isLoading,
    required this.items,
    required this.title,
    required this.seeAllText,
    required this.onTap,
    required this.onSeeAllTap,
  });
  final Future<void> Function(BuildContext context) fetchData;
  final bool isLoading;
  final List<Records> items;
  final String title;
  final String seeAllText;
  final void Function() onSeeAllTap;
  final void Function(Records item) onTap;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3),
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: CustomTextRow(
                title: title, seeAll: seeAllText, onTap: onSeeAllTap),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: GridView.builder(
            itemCount: items.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 8,
              mainAxisExtent: screenHeight * 0.15,
              crossAxisSpacing: 5,
            ),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () => onTap(item),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: screenHeight * 0.15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).colorScheme.primary,
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 1),
                            blurRadius: 0.5,
                            spreadRadius: 0.5,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: screenHeight * 0.12,
                            width: screenWidth * 0.23,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  topLeft: Radius.circular(5)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    item.avatar ?? 'assets/Background.png',
                                fit: BoxFit.cover,
                                height: screenHeight * 0.12,
                                width: screenWidth * 0.23,
                                placeholder:
                                    (BuildContext context, String url) =>
                                        Container(
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.28,
                                  width: double.infinity,
                                  color:
                                      Colors.blueGrey[300], // Background color
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/placeholder.png', // Replace with your actual image path
                                        fit: BoxFit
                                            .cover, // Adjust fit if needed
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.28,
                                        width: double.infinity,
                                      ),
                                      const CupertinoActivityIndicator(
                                        radius: 16, // Adjust size of the loader
                                        animating: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(item.name ?? '',
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: homeItemsStyle(context)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

//    =================================================================

//  SUPERTYPE  APIS BOTTOM BANNER

//    https://api.staging.theevents.ae/api/v1/vendor-data/62

//     https://api.staging.theevents.ae/api/v1/vendor-data/64

//   THIS IS FOR PACKAGES

// THIS IS PRODUCT AND PACKAGES LIST COMES IN THE API UPPER URL

// https://api.staging.theevents.ae/api/v1/packages?per-page=12&page=1&sort-by=default_sorting&store_id=39

//  THIS IS FOR PRODUCTS

// https://api.staging.theevents.ae/api/v1/products?per-page=12&page=1&sort-by=default_sorting&store_id=39
