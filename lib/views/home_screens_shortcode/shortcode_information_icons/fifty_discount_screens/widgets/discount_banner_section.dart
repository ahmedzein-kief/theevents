import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/network/api_endpoints/api_contsants.dart';
import '../../../../../core/styles/custom_text_styles.dart';
import '../../../../../core/widgets/padded_network_banner.dart';

class DiscountBannerSection extends StatelessWidget {
  final String? coverImage;
  final String? name;

  const DiscountBannerSection({
    super.key,
    this.coverImage,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ========= BANNER IMAGE =========
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: PaddedNetworkBanner(
            imageUrl: coverImage?.isNotEmpty == true ? coverImage! : ApiConstants.placeholderImage,
            height: 160,
            fit: BoxFit.cover,
            width: screenWidth,
            padding: EdgeInsets.zero,
          ),
        ),

        /// ========= NAME ARGUMENTS HERE =========
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            name ?? AppStrings.discount50.tr,
            style: boldHomeTextStyle(),
          ),
        ),
      ],
    );
  }
}
