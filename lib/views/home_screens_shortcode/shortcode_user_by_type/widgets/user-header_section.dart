import 'package:flutter/material.dart';

import '../../../../core/network/api_endpoints/api_contsants.dart';
import '../../../../core/styles/custom_text_styles.dart';
import '../../../../core/widgets/padded_network_banner.dart';

class UserHeaderSection extends StatelessWidget {
  final dynamic userData;
  final double screenHeight;
  final double screenWidth;

  const UserHeaderSection({
    super.key,
    required this.userData,
    required this.screenHeight,
    required this.screenWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.02,
        bottom: screenHeight * 0.02,
      ),
      child: Stack(
        children: [
          Container(
            height: screenHeight * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    topLeft: Radius.circular(8),
                  ),
                  child: PaddedNetworkBanner(
                    imageUrl: userData?.coverImage ?? ApiConstants.placeholderImage,
                    height: screenHeight * 0.17,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: screenHeight * 0.12,
                  width: screenHeight * 0.12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: Colors.white,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: PaddedNetworkBanner(
                      imageUrl: userData?.avatar ?? ApiConstants.placeholderImage,
                      height: screenHeight * 0.15,
                      width: screenHeight * 0.15,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              userData?.name ?? '',
                              softWrap: true,
                              style: holderNameTextStyle(context),
                            ),
                            Text(
                              userData?.type ?? '',
                              softWrap: true,
                              style: holderTypeTextStyle(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
