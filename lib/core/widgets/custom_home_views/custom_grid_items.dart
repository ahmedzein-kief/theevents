import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GridItemsHomeSeeAll extends StatelessWidget {
  const GridItemsHomeSeeAll(
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
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                height: 80,
                errorListener: (object) {
                  Image.asset(
                    'assets/placeholder.png', // Replace with your actual image path
                    fit: BoxFit.cover, // Adjust fit if needed
                    height: MediaQuery.sizeOf(context).height * 0.28,
                    width: double.infinity,
                  );
                },
                errorWidget: (context, _, error) => Image.asset(
                  'assets/placeholder.png', // Replace with your actual image path
                  fit: BoxFit.cover, // Adjust fit if needed
                  height: MediaQuery.sizeOf(context).height * 0.28,
                  width: double.infinity,
                ),
                placeholder: (BuildContext context, String url) => Container(
                  height: MediaQuery.sizeOf(context).height * 0.28,
                  width: double.infinity,
                  color: Colors.blueGrey[300], // Background color
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/placeholder.png', // Replace with your actual image path
                        fit: BoxFit.cover, // Adjust fit if needed
                        height: MediaQuery.sizeOf(context).height * 0.28,
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
