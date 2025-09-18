import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_assets.dart';
import '../../core/styles/custom_text_styles.dart';
import '../utils/app_utils.dart';

class PriceRow extends StatelessWidget {
  final String? price;
  final TextStyle? style;
  final double? currencySize;
  final Color? currencyColor;
  final String? currencySvg; // optional SVG for currency icon
  final String? currencyText; // optional fallback text (like $, USD, €)
  final double? gap;
  final MainAxisAlignment? alignment;

  const PriceRow({
    super.key,
    this.price,
    this.style,
    this.currencySize,
    this.currencyColor,
    this.currencySvg,
    this.currencyText,
    this.gap,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    if (price == null || price!.isEmpty) return const SizedBox.shrink();

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment ?? MainAxisAlignment.start,
      children: [
        if (currencySvg != null) // 👈 custom icon provided
          SvgPicture.asset(
            currencySvg!,
            width: currencySize ?? 9,
            height: currencySize ?? 9,
            colorFilter: ColorFilter.mode(
              currencyColor ?? Colors.black,
              BlendMode.srcIn,
            ),
          )
        else if (currencyText != null) // 👈 fallback text provided
          Text(
            currencyText!,
            style: style?.copyWith(
              fontSize: currencySize ?? style?.fontSize,
              color: currencyColor ?? style?.color,
            ),
          )
        else // 👈 default = dirham asset
          SvgPicture.asset(
            AppAssets.dirham,
            width: currencySize ?? 9,
            height: currencySize ?? 9,
            colorFilter: ColorFilter.mode(
              currencyColor ?? Colors.black,
              BlendMode.srcIn,
            ),
          ),
        SizedBox(width: gap ?? 2),
        Text(
          AppUtils.cleanPrice(price!),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: style ?? priceStyle(context),
        ),
      ],
    );
  }
}
