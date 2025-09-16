import 'package:event_app/views/product_detail_screens/extra_product_options.dart';
import 'package:event_app/views/product_detail_screens/product_attributes_screen.dart';
import 'package:flutter/material.dart';

// Separate widget for Product Content (Attributes and Options)
class ProductContentSection extends StatelessWidget {
  final dynamic record;
  final double screenWidth;
  final List<Map<String, dynamic>?> selectedAttributes;
  final List<int> unavailableAttributes;
  final Map<String, dynamic> selectedExtraOptions;
  final List<Map<String, dynamic>> extraOptionErrorData;
  final Function(List<Map<String, dynamic>?>) onAttributesChanged;
  final Function(Map<String, dynamic>) onExtraOptionsChanged;

  const ProductContentSection({
    super.key,
    required this.record,
    required this.screenWidth,
    required this.selectedAttributes,
    required this.unavailableAttributes,
    required this.selectedExtraOptions,
    required this.extraOptionErrorData,
    required this.onAttributesChanged,
    required this.onExtraOptionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (record.attributes?.isNotEmpty == true)
          ProductAttributesScreen(
            screenWidth: screenWidth,
            attributes: record.attributes!,
            selectedAttributes: selectedAttributes,
            unavailableAttributes: unavailableAttributes,
            onSelectedAttributes: onAttributesChanged,
          ),
        if (record.options.isNotEmpty == true)
          ExtraProductOptions(
            options: record.options,
            screenWidth: screenWidth,
            selectedOptions: selectedExtraOptions,
            extraOptionsError: extraOptionErrorData,
            onSelectedOptions: onExtraOptionsChanged,
          ),
      ],
    );
  }
}
