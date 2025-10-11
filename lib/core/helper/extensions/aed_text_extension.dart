// text_extension.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants/app_assets.dart';
import '../../widgets/price_row.dart';

extension AEDTextExtension on String {
  /// Replaces all occurrences of AED with dirham symbol
  Widget toAEDText({
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double? gap = 2,
    TextAlign textAlign = TextAlign.left,
  }) {
    if (!contains('AED')) {
      return Text(
        this,
        style: style,
        textAlign: textAlign,
      );
    }

    final parts = split('AED');

    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        style: style,
        children: [
          for (int i = 0; i < parts.length; i++) ...[
            TextSpan(text: parts[i]),
            if (i < parts.length - 1)
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _buildCurrencySymbol(
                  size: currencySize,
                  color: currencyColor,
                  svgAsset: currencySvg,
                  gap: gap,
                  style: style,
                ),
              ),
          ],
        ],
      ),
    );
  }

  /// Replaces AED with dirham symbol and extracts amount if present (symbol before amount)
  Widget toAEDTextWithAmount({
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double? gap = 2,
    TextAlign textAlign = TextAlign.left,
  }) {
    // Try to extract pattern like "100.00 AED" or "1,000.00 AED"
    final regex = RegExp(r'(\d[\d,.]*)\s*AED');
    final matches = regex.allMatches(this);

    if (matches.isEmpty) {
      return toAEDText(
        style: style,
        currencySize: currencySize,
        currencyColor: currencyColor,
        currencySvg: currencySvg,
        gap: gap,
        textAlign: textAlign,
      );
    }

    // Build text spans with extracted amounts
    int currentIndex = 0;
    final children = <InlineSpan>[]; // Use InlineSpan instead of TextSpan

    for (final match in matches) {
      // Add text before the match
      if (match.start > currentIndex) {
        children.add(TextSpan(text: substring(currentIndex, match.start)));
      }

      // Add currency symbol BEFORE amount
      final amount = match.group(1);
      children.addAll([
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _buildCurrencySymbol(
            size: currencySize,
            color: currencyColor,
            svgAsset: currencySvg,
            gap: gap,
            style: style,
          ),
        ),
        const WidgetSpan(child: SizedBox(width: 2)),
        TextSpan(text: amount ?? ''),
      ]);

      currentIndex = match.end;
    }

    // Add remaining text after last match
    if (currentIndex < length) {
      children.add(TextSpan(text: substring(currentIndex)));
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(style: style, children: children),
    );
  }

  /// Replaces AED with dirham symbol using PriceRow widget (symbol before amount)
  Widget toAEDPriceRow({
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double? gap = 2,
    TextAlign textAlign = TextAlign.left,
  }) {
    // Try to extract pattern like "100.00 AED" or "1,000.00 AED"
    final regex = RegExp(r'(\d[\d,.]*)\s*AED');
    final matches = regex.allMatches(this);

    if (matches.isEmpty) {
      return toAEDText(
        style: style,
        currencySize: currencySize ?? (style?.fontSize ?? 14) * 0.70,
        currencyColor: currencyColor,
        currencySvg: currencySvg,
        gap: gap,
        textAlign: textAlign,
      );
    }

    // Build text spans with PriceRow widget
    int currentIndex = 0;
    final children = <InlineSpan>[]; // Use InlineSpan instead of TextSpan

    for (final match in matches) {
      // Add text before the match
      if (match.start > currentIndex) {
        children.add(TextSpan(text: substring(currentIndex, match.start)));
      }

      // Add PriceRow widget (symbol before amount by default)
      final amount = match.group(1);
      children.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: PriceRow(
            price: amount,
            style: style,
            currencySize: currencySize ?? (style?.fontSize ?? 14) * 0.70,
            currencyColor: currencyColor,
            currencySvg: currencySvg ?? AppAssets.dirham,
            gap: gap,
          ),
        ),
      );

      currentIndex = match.end;
    }

    // Add remaining text after last match
    if (currentIndex < length) {
      children.add(TextSpan(text: substring(currentIndex)));
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(style: style, children: children),
    );
  }

  /// Simple method that just replaces "AED" with symbol without extracting amount
  Widget toAEDSimple({
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double? gap = 2,
    TextAlign textAlign = TextAlign.left,
  }) {
    if (!contains('AED')) {
      return Text(
        this,
        style: style,
        textAlign: textAlign,
      );
    }

    // Simple replacement: "100.00 AED" becomes "100.00 ﷼"
    final replacedText = replaceAll('AED', '﷼');

    return Text(
      replacedText,
      style: style,
      textAlign: textAlign,
    );
  }

  /// Helper method to build currency symbol widget
  Widget _buildCurrencySymbol({
    double? size,
    Color? color,
    String? svgAsset,
    double? gap,
    TextStyle? style,
  }) {
    return SvgPicture.asset(
      svgAsset ?? AppAssets.dirham,
      width: size ?? (style?.fontSize ?? 14) * 0.70,
      height: size ?? (style?.fontSize ?? 14) * 0.70,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}

// Enhanced PriceRow widget with extension method
extension PriceRowExtension on PriceRow {
  /// Creates a PriceRow from text containing amount and AED (symbol before amount)
  static Widget fromText(
    String text, {
    TextStyle? style,
    double? currencySize,
    Color? currencyColor,
    String? currencySvg,
    double? gap = 2,
  }) {
    final regex = RegExp(r'(\d[\d,.]*)\s*AED');
    final match = regex.firstMatch(text);

    if (match != null) {
      final amount = match.group(1);
      return PriceRow(
        price: amount,
        style: style,
        currencySize: currencySize,
        currencyColor: currencyColor,
        currencySvg: currencySvg,
        gap: gap,
      );
    }

    return const SizedBox.shrink();
  }
}
