import 'package:flutter/material.dart';

class CustomAllProductHeading extends StatelessWidget {
  final String text1;
  final String text2;
  final String text3;
  final String text4;

  const CustomAllProductHeading({
    Key? key,
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.01, left: screenWidth * 0.03, right: screenHeight * 0.02),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text1,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  text2,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  text3,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  text4,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Container(color: Colors.grey.shade200, height: 2, width: screenWidth)
        ],
      ),
    );
  }
}
