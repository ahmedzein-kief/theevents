import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TagChip extends StatelessWidget {
  const TagChip({
    super.key,
    required this.keyword,
    required this.onRemove,
    this.backgroundColor = const Color(0xFFFFC1C1), // Default peachy pink
    this.textStyle =
        const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
    this.borderRadius = 2,
    this.iconSize = 13.0,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
    this.tooltipMessage,
  });
  final String keyword;
  final VoidCallback onRemove;
  final Color backgroundColor;
  final TextStyle textStyle;
  final double borderRadius;
  final double iconSize;
  final EdgeInsets padding;
  final String? tooltipMessage;

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(keyword, style: textStyle),
            const SizedBox(width: 5),
            Tooltip(
              message: tooltipMessage ?? 'Remove',
              child: Material(
                color: Colors.transparent,
                child: InkResponse(
                  onTap: onRemove,
                  containedInkWell: false,
                  splashColor: Colors.black12,
                  child: Icon(CupertinoIcons.clear_thick, size: iconSize),
                ),
              ),
            ),
          ],
        ),
      );
}
