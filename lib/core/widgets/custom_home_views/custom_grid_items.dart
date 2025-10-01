import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../padded_network_banner.dart';

class GridItemsHomeSeeAll extends StatelessWidget {
  const GridItemsHomeSeeAll({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.onTap,
    required this.textStyle,
  });

  final String imageUrl;
  final String name;
  final VoidCallback onTap;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: PaddedNetworkBanner(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                height: 80,
                padding: EdgeInsets.zero,
              ),
            ),
            Builder(
              builder: (context) => Text(
                name,
                softWrap: true,
                style: textStyle,
                maxLines: 1,
              ),
            ),
            // SizedBox(height: screenHeight * 0.02,)
          ],
        ),
      );
}
