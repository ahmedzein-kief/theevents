import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/home_screens_shortcode/shorcode_featured_brands/featured_brands_items_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/custom_text_styles.dart';

class ProductBrandSection extends StatelessWidget {
  final dynamic brand;

  const ProductBrandSection({
    super.key,
    required this.brand,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          Text(
            'ProductCode - 202t86876',
            style: productsReviewDescription(context),
          ),
          Text(
            '${AppStrings.sellingBy.tr} ${brand.name}',
            style: productsReviewDescription(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FeaturedBrandsItemsScreen(
                      slug: brand.slug ?? '',
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Text(
                    '${AppStrings.view.tr} ${brand.name}->',
                    style: viewShopText(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
