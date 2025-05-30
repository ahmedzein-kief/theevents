import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../styles/custom_text_styles.dart';

class CustomTextRow extends StatelessWidget {
  final String title;
  final String? seeAll;
  final Function()? onTap;

  const CustomTextRow({super.key, required this.title, this.seeAll, this.onTap});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.sizeOf(context).height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.only(left: screenWidth * 0.04, right: screenWidth * 0.04, bottom: screenHeight * 0.01),
      child: Container(
        height: 40,
        // color: Colors.green,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title.toUpperCase(),
              style: boldHomeTextStyle(),
            ),
            GestureDetector(
              onTap: onTap,
              child: Text(seeAll!, style: homeSeeAllTextStyle()),
            ),
          ],
        ),
      ),
    );
  }
}
