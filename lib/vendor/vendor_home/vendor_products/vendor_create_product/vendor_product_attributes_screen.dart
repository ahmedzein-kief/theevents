import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/vendor_app_strings.dart';

class VendorProductAttributesScreen extends StatefulWidget {
  const VendorProductAttributesScreen({
    super.key,
    this.initialAttributes = const [],
    this.listAttributesSets,
    this.productId,
  });

  final String? productId;
  final List<Map<String, dynamic>>? initialAttributes;
  final List<AttributeSetsData>? listAttributesSets;

  @override
  State<VendorProductAttributesScreen> createState() => _VendorProductAttributeScreenState();
}

class _VendorProductAttributeScreenState extends State<VendorProductAttributesScreen> {
  List<Map<String, dynamic>> attributes = [];

  List<String> attributeMainNames = [];
  List<String> remainingNames = [];

  /// To show modal progress hud
  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future addAttributesToProduct() async {
    try {
      setProcessing(true);

      if (!mounted) return;
      final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);

      final result = await provider.addAttributeToExistingProduct(
        context: context,
        productID: widget.productId ?? '',
        attributes: attributes,
      );

      if (result != null) {
        if (!mounted) return;
        Navigator.pop(context, null);
      }

      setProcessing(false);
      setState(() {});
    } catch (e) {
      setProcessing(false);
    }
  }

  void updateList(List<Map<String, bool>> data, List<String> namesToCheck) {
    for (final map in data) {
      final String key = map.keys.first; // Assuming each map has only one key
      if (namesToCheck.contains(key)) {
        map[key] = true;
      }
    }
  }

  void updateNameList() {
    final List<String> attributeMap = attributes
        .where((attr) => attr['name'] is String) // Ensure "name" is a String
        .map((attr) => attr['name'] as String) // Directly extract the String
        .toList();

    remainingNames = attributeMainNames.where((name) => !attributeMap.contains(name)).toList();
  }

  void addAttribute() {
    if (remainingNames.isNotEmpty) {
      setState(() {
        attributes.add({
          'name': remainingNames.isNotEmpty ? remainingNames[0] : '',
          'id': getAttributeId(
            remainingNames.isNotEmpty ? remainingNames[0] : '',
          ),
          'value': getChildAttributeFirstValue(
            remainingNames.isNotEmpty ? remainingNames[0] : '',
          ),
          'value_id': getChildAttributeFirstValueId(
            remainingNames.isNotEmpty ? remainingNames[0] : '',
          ),
        });
        updateNameList();
      });
    }
  }

  void removeAttribute(int index) {
    setState(() {
      attributes.removeAt(index);
      updateNameList();
    });
  }

  void _returnBack() {
    if (widget.productId != null) {
      attributes = [];
    }
    Navigator.pop(context, attributes);
  }

  int getAttributeId(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) => element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .id ??
      -1;

  String getChildAttributeFirstValue(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) => element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .attributes[0]
          .title ??
      '';

  int getChildAttributeFirstValueId(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) => element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .attributes[0]
          .id ??
      -1;

  @override
  void initState() {
    super.initState();

    remainingNames = attributeMainNames = widget.listAttributesSets?.map((e) => e.title.toString()).toList() ?? [];

    if (widget.initialAttributes != null) {
      attributes.addAll(widget.initialAttributes!);
      updateNameList();
    } else {
      addAttribute();
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (!didPop) {
            _returnBack();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(VendorAppStrings.attributes.tr, style: vendorName(context)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _returnBack,
            ),
            actions: widget.productId == null
                ? []
                : [
                    GestureDetector(
                      onTap: () {
                        addAttributesToProduct();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          AppStrings.update.tr,
                          style: vendorButtonText(context),
                        ),
                      ),
                    ),
                  ],
          ),
          body: AppUtils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: AppUtils.pageRefreshIndicator(
              context: context,
              onRefresh: addAttributesToProduct,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      VendorAppStrings.addingNewAttributesInfo.tr,
                      style: vendorDescription(),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attributes.length,
                        itemBuilder: (context, index) {
                          final String selectedAttribute = attributes[index]['name'] ?? '';

                          // Find the matching attribute set based on the selected attribute name
                          final selectedSet = widget.listAttributesSets?.firstWhere(
                                (element) => element.title == selectedAttribute,
                                orElse: () => AttributeSetsData(
                                  title: '',
                                  attributes: [],
                                  id: -1,
                                ),
                              ) ??
                              AttributeSetsData(
                                title: '',
                                attributes: [],
                                id: -1,
                              );

                          // Get available values based on the selected attribute set
                          final List<String> availableValues =
                              selectedSet.attributes.map((attr) => attr.title.toString()).toList();
                          remainingNames.remove(selectedAttribute);
                          final dropDownList = [selectedAttribute] + remainingNames;

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdown<String>(
                                          // ← Add type parameter
                                          value: selectedAttribute,
                                          hintText: VendorAppStrings.selectAttributeName.tr,
                                          textStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                                          menuItemsList: dropDownList
                                              .map(
                                                (element) => DropdownMenuItem<String>(
                                                  // ← Add type parameter
                                                  value: element,
                                                  child: Text(element),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              attributes[index]['name'] = value ?? ''; // ← Handle nullable
                                              attributes[index]['id'] =
                                                  getChildAttributeFirstValueId(value ?? ''); // ← Handle nullable
                                              attributes[index]['value'] =
                                                  getChildAttributeFirstValue(value ?? ''); // ← Handle nullable
                                              attributes[index]['value_id'] =
                                                  getChildAttributeFirstValueId(value ?? '');
                                              updateNameList();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        CustomDropdown<String>(
                                          // ← Add type parameter
                                          hintText: VendorAppStrings.selectAttributeValue.tr,
                                          value: attributes[index]['value'] ?? '',
                                          textStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                                          menuItemsList: availableValues
                                              .map(
                                                (val) => DropdownMenuItem<String>(
                                                  // ← Add type parameter
                                                  value: val,
                                                  child: Text(val),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              attributes[index]['value'] = value ?? ''; // ← Handle nullable
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => removeAttribute(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    ElevatedButton(
                      onPressed: addAttribute,
                      child: Text(
                        VendorAppStrings.addMoreAttribute.tr,
                        style: vendorButtonText(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
