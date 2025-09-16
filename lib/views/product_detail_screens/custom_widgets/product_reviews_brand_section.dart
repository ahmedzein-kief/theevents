import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/views/product_detail_screens/custom_widgets/product_brand_section.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/styles/custom_text_styles.dart';
import '../customer_reviews_view.dart';

// Separate widget for Reviews and Brand Section
class ProductReviewsAndBrandSection extends StatelessWidget {
  final dynamic provider;
  final dynamic record;

  const ProductReviewsAndBrandSection({
    super.key,
    required this.provider,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        right: 20,
        left: 20,
        bottom: 100,
      ),
      child: Column(
        children: [
          Text(
            AppStrings.customerReviews.tr,
            style: productValueItemsStyle(context),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              height: 0.5,
              color: Colors.grey,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                if (provider.isReviewLoading) ...{
                  Container(
                    color: Colors.transparent,
                    child: const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.peachyPink,
                        ),
                      ),
                    ),
                  ),
                } else ...{
                  if (record.review != null && provider.apiReviewsResponse != null) ...{
                    CustomerReviews(
                      review: record.review!,
                      customerReviews: provider.apiReviewsResponse?.data?.records ?? [],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 0.5,
                        color: Colors.grey,
                      ),
                    ),
                  },
                },
                if (record.brand != null) ProductBrandSection(brand: record.brand!),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
