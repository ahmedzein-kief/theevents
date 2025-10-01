import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../constants/app_assets.dart';

extension AEDDoubleExtension on double {
  /// Converts a double amount into a Dirham text widget with symbol
  Widget toAEDAmount({
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double gap = 2,
    TextAlign textAlign = TextAlign.left,
    int fractionDigits = 2,
  }) {
    final amount = toStringAsFixed(fractionDigits);

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: style,
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SvgPicture.asset(
              currencySvg ?? AppAssets.dirham,
              width: currencySize ?? (style?.fontSize ?? 14) * 0.70,
              height: currencySize ?? (style?.fontSize ?? 14) * 0.70,
              colorFilter: currencyColor != null ? ColorFilter.mode(currencyColor, BlendMode.srcIn) : null,
            ),
          ),
          WidgetSpan(child: SizedBox(width: gap)),
          TextSpan(text: amount),
        ],
      ),
    );
  }
}
