import 'package:flutter/material.dart';

class DiscountContentWrapper extends StatelessWidget {
  final Widget child;
  final ScrollController? scrollController;

  const DiscountContentWrapper({
    super.key,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.sizeOf(context).width;
    final double screenHeight = MediaQuery.sizeOf(context).height;

    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.02,
        ),
        child: child,
      ),
    );
  }
}
