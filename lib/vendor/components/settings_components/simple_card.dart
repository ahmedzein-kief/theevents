import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';

class SimpleCard extends StatelessWidget {
  final Widget expandedContent;
  EdgeInsets? expandedContentPadding;
  final double? borderRadius;

  SimpleCard({super.key, this.borderRadius, required this.expandedContent, this.expandedContentPadding});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Material(
        elevation: 0.5,
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
        color: AppColors.bgColor,
        child: Container(
          margin: EdgeInsets.only(top: 0),
          padding: expandedContentPadding ?? EdgeInsets.all(20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(borderRadius ?? 8), border: Border.all(color: Color(0xffD9D9D9)), color: Colors.white),
          child: expandedContent,
        ),
      ),
    );
  }
}
