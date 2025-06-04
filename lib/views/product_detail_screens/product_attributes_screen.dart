import 'package:event_app/models/product_packages_models/product_attributes_model.dart';
import 'package:flutter/cupertino.dart';

import '../../core/styles/custom_text_styles.dart';
import 'custom_size_container.dart';

class ProductAttributesScreen extends StatefulWidget {
  const ProductAttributesScreen({
    super.key,
    required this.screenWidth,
    required this.attributes,
    required this.onSelectedAttributes,
    required this.selectedAttributes,
    required this.unavailableAttributes,
  });
  final void Function(List<Map<String, dynamic>?> selectedMethod)
      onSelectedAttributes;
  final double screenWidth;
  final List<ProductAttributesModel> attributes;
  final List<Map<String, dynamic>?> selectedAttributes;
  final List<int> unavailableAttributes;

  @override
  State<ProductAttributesScreen> createState() =>
      _ProductAttributesScreenState();
}

class _ProductAttributesScreenState extends State<ProductAttributesScreen> {
  List<Map<String, dynamic>?> attributesMap = [];

  @override
  Widget build(BuildContext context) {
    attributesMap = widget.selectedAttributes;

    return Padding(
      padding: EdgeInsets.only(
        top: widget.screenWidth * 0.06,
        left: widget.screenWidth * 0.06,
        right: widget.screenWidth * 0.06,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: widget.attributes.isEmpty
            ? const Center(child: Text('No attributes available'))
            : ListView.builder(
                shrinkWrap: true, // Allow outer ListView to shrink
                physics:
                    const NeverScrollableScrollPhysics(), // Disable scrolling for the outer ListView
                itemCount: widget.attributes.length,
                itemBuilder: (context, attributeIndex) {
                  final mainCategoryAttributes =
                      widget.attributes[attributeIndex];

                  if (mainCategoryAttributes.children.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    mainAxisSize: MainAxisSize
                        .min, // Allow height to be determined by content
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0), // Add margin around the text
                        child: Text(
                          mainCategoryAttributes.title,
                          style: productValueItemsStyle(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: widget.screenWidth * 0.02,
                          top: widget.screenWidth * 0.03,
                        ),
                        child: Container(
                          width: double.infinity, // Full width of the parent
                          constraints: const BoxConstraints(
                            minHeight: 30, // Set a minimum height
                          ),
                          child: SingleChildScrollView(
                            // Use SingleChildScrollView for horizontal scrolling
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              // Use Row instead of ListView
                              children: List.generate(
                                  mainCategoryAttributes.children.length,
                                  (index) {
                                final isAvailable = !widget
                                    .unavailableAttributes
                                    .contains(mainCategoryAttributes
                                        .children[index].id);

                                return CustomSizeContainer(
                                  title: mainCategoryAttributes
                                      .children[index].title,
                                  onTap: () {
                                    setState(
                                      () {
                                        // Deselect all sizes in the list
                                        for (final value
                                            in mainCategoryAttributes
                                                .children) {
                                          value.selected = false;
                                        }

                                        // Select the current size
                                        mainCategoryAttributes
                                            .children[index].selected = true;

                                        final childAttributeData =
                                            mainCategoryAttributes
                                                .children[index];
                                        if (childAttributeData.selected) {
                                          final attribute =
                                              attributesMap.firstWhere(
                                            (data) =>
                                                data?['attribute_category_slug']
                                                    .toString()
                                                    .toLowerCase() ==
                                                mainCategoryAttributes.slug
                                                    .toLowerCase(),
                                            orElse: () => null,
                                          );

                                          if (attribute != null) {
                                            attribute['attribute_key_name'] =
                                                mainCategoryAttributes.keyName;
                                            attribute[
                                                    'attribute_category_slug'] =
                                                mainCategoryAttributes.slug;
                                            attribute['attribute_name'] =
                                                childAttributeData.title;
                                            attribute['attribute_slug'] =
                                                childAttributeData.slug;
                                            attribute['attribute_id'] =
                                                childAttributeData.id;
                                            attribute['attribute_set_id'] =
                                                childAttributeData
                                                    .attributeSetId;
                                          } else {
                                            final newAttribute = {
                                              'attribute_key_name':
                                                  mainCategoryAttributes
                                                      .keyName,
                                              'attribute_category_slug':
                                                  mainCategoryAttributes.slug,
                                              'attribute_name':
                                                  childAttributeData.title,
                                              'attribute_slug':
                                                  childAttributeData.slug,
                                              'attribute_id':
                                                  childAttributeData.id,
                                              'attribute_set_id':
                                                  childAttributeData
                                                      .attributeSetId,
                                            };
                                            attributesMap.add(newAttribute);
                                          }
                                        }

                                        widget.onSelectedAttributes(
                                            attributesMap);
                                      },
                                    );
                                  },
                                  selected: mainCategoryAttributes
                                      .children[index].selected,
                                  isAvailable: isAvailable,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
