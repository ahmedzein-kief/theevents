import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/padded_network_banner.dart';

class OrderPageBannerScreen extends StatelessWidget {
  const OrderPageBannerScreen({super.key, required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: PaddedNetworkBanner(
        imageUrl: imageUrl,
        height: 160,
        width: screenWidth,
        fit: BoxFit.cover,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
