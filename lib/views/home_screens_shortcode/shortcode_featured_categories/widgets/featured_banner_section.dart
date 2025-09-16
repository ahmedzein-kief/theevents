import 'package:flutter/material.dart';

import '../../../../core/network/api_endpoints/api_contsants.dart';
import '../../../../core/widgets/padded_network_banner.dart';

class FeaturedBannerSection extends StatelessWidget {
  const FeaturedBannerSection({
    super.key,
    required this.bannerImageUrl,
  });

  final String? bannerImageUrl;

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.sizeOf(context).height;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth * 0.02,
        right: screenWidth * 0.02,
        top: screenHeight * 0.02,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: PaddedNetworkBanner(
          imageUrl: bannerImageUrl ?? ApiConstants.placeholderImage,
          fit: BoxFit.cover,
          height: 160,
          width: double.infinity,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
