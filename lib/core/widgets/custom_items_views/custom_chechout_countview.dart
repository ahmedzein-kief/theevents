import 'package:flutter/material.dart';

import '../../styles/custom_text_styles.dart';

class CustomRowCheckOut extends StatelessWidget {
  const CustomRowCheckOut({
    super.key,

    /// +++++++++ second +++++++++++++++++
    required this.sContainerSize,
    required this.sContainerColor,
    required this.sContainerText,
    required this.sContainerTextColor,
    required this.sRightText,
    required this.sRightTextColor,
    required this.sContainerMinusColor,

    /// +++++++++ third +++++++++++++++++++++

    required this.tContainerSize,
    required this.tContainerColor,
    required this.tContainerText,
    required this.tContainerTextColor,
    required this.tRightText,
    required this.tRightTextColor,
    required this.containerColor,
    required this.containerMinusColor,
    required this.containerText,
    required this.containerTextColor,
    required this.containerSize,
    required this.minusTextColor,
    required this.rightText,
    required this.rightTextColor,
  });
  final Color containerColor;
  final String containerText;
  final Color containerTextColor;
  final double containerSize;
  final Color minusTextColor;
  final String rightText;
  final Color rightTextColor;
  final Color containerMinusColor;

  ///  second
  final double sContainerSize;
  final Color sContainerColor;
  final String sContainerText;
  final Color sContainerTextColor;
  final String sRightText;
  final Color sRightTextColor;
  final Color sContainerMinusColor;

  /// THIRD
  final double tContainerSize;
  final Color tContainerColor;
  final String tContainerText;
  final Color tContainerTextColor;
  final String tRightText;
  final Color tRightTextColor;

  @override
  Widget build(BuildContext context) => Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Circular container with text
            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: containerColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                containerText,
                style: TextStyle(
                  color: containerTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(rightText, style: mainHead(context)),
            Container(
              color: containerMinusColor,
              height: 2,
              width: 8,
            ),

            ///  =====================  SECOND CONTAINER =================

            Container(
              width: containerSize,
              height: containerSize,
              decoration: BoxDecoration(
                color: sContainerColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                sContainerText,
                style: TextStyle(
                  color: sContainerTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Text(sRightText, style: mainHead(context)),
            Container(
              color: sContainerMinusColor,
              height: 2,
              width: 8,
            ),

            ///     THIRD CONTAINER =======

            Container(
              width: tContainerSize,
              height: tContainerSize,
              decoration: BoxDecoration(
                color: tContainerColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                tContainerText,
                style: TextStyle(
                  color: tContainerTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Text(tRightText, style: mainHead(context)),
          ],
        ),
      );
}
