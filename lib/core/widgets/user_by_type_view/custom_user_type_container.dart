import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../padded_network_banner.dart';

///****************************     SCREEN FOR CUSTOM VIEW USER BY TYPES =============================================================        *//

class UserByTypeSeeAll extends StatelessWidget {
  const UserByTypeSeeAll(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.onTap,
      required this.textStyle,});
  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8),),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
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
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4),),
                child: PaddedNetworkBanner(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.003,
                top: screenHeight * 0.003,
              ),
              child: Text(
                name,
                softWrap: true,
                style: textStyle,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
