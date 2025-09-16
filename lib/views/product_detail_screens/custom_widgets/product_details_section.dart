import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';

// Separate widget for Product Details
class ProductDetailsSection extends StatelessWidget {
  final String content;

  const ProductDetailsSection({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    if (content.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(
        top: 10,
        right: 20,
        left: 20,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.productDetails.tr,
            style: productValueItemsStyle(context),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4,
              right: 4,
              left: 4,
            ),
            child: Html(
              data: content,
              style: {
                'div': Style(
                  margin: Margins.only(bottom: 4.0),
                  lineHeight: LineHeight.number(1.4),
                  whiteSpace: WhiteSpace.normal,
                  padding: HtmlPaddings.zero,
                ),
                'p': Style(
                  margin: Margins.only(bottom: 4.0),
                  lineHeight: LineHeight.number(1.4),
                  padding: HtmlPaddings.zero,
                  whiteSpace: WhiteSpace.normal,
                ),
                'li': Style(
                  margin: Margins.only(bottom: 4.0),
                  lineHeight: LineHeight.number(1.2),
                  padding: HtmlPaddings.zero,
                  listStyleType: ListStyleType.disc,
                ),
                'strong': Style(
                  fontWeight: FontWeight.w600,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}
