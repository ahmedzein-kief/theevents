import 'package:flutter/material.dart';

@immutable
class SimpleCard extends StatelessWidget {
  const SimpleCard({
    super.key,
    this.borderRadius,
    required this.expandedContent,
    this.expandedContentPadding,
    this.color,
  });

  final Widget expandedContent;
  final EdgeInsets? expandedContentPadding;
  final double? borderRadius;
  final Color? color;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Material(
          elevation: 0.5,
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          child: Container(
            margin: const EdgeInsets.only(top: 0),
            padding: expandedContentPadding ?? const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius ?? 8),
              border: Border.all(color: const Color(0xffD9D9D9)),
            ),
            child: expandedContent,
          ),
        ),
      );
}
