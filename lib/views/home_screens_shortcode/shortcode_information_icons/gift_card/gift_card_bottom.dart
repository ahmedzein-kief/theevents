import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/padded_network_banner.dart';

class GiftCardBottom extends StatelessWidget {
  const GiftCardBottom({super.key, this.imageUrl = ''});

  final String imageUrl;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: PaddedNetworkBanner(
          imageUrl: imageUrl,
          height: 120,
          fit: BoxFit.cover,
          width: double.infinity,
          padding: EdgeInsets.zero,
        ),
      );
}
