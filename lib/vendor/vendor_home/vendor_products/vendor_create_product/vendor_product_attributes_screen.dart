import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/vendor/components/dropdowns/custom_dropdown.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductAttributeScreen extends StatefulWidget {
  VendorProductAttributeScreen(
      {super.key,
      this.initialAttributes,
      this.listAttributesSets,
      this.productId,});

  String? productId;
  List<Map<String, dynamic>>? initialAttributes = [];
  List<AttributeSetsData>? listAttributesSets;

  @override
  _VendorProductAttributeScreenState createState() =>
      _VendorProductAttributeScreenState();
}

class _VendorProductAttributeScreenState
    extends State<VendorProductAttributeScreen> {
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
      final provider =
          Provider.of<VendorCreateProductViewModel>(context, listen: false);

      final result = await provider.addAttributeToExistingProduct(
        context: context,
        productID: widget.productId ?? '',
        attributes: attributes,
      );

      if (result != null) {
        Navigator.pop(context, null);
      }

      setProcessing(false);
      setState(() {});
    } catch (e) {
      setProcessing(false);
      print('Error in fetching products: $e');
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

    remainingNames = attributeMainNames
        .where((name) => !attributeMap.contains(name))
        .toList();
  }

  void addAttribute() {
    if (remainingNames.isNotEmpty) {
      setState(() {
        attributes.add({
          'name': remainingNames.isNotEmpty ? remainingNames[0] : '',
          'id': getAttributeId(
              remainingNames.isNotEmpty ? remainingNames[0] : '',),
          'value': getChildAttributeFirstValue(
              remainingNames.isNotEmpty ? remainingNames[0] : '',),
          'value_id': getChildAttributeFirstValueId(
              remainingNames.isNotEmpty ? remainingNames[0] : '',),
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
    print(attributes);

    if (widget.productId != null) {
      attributes = [];
    }
    Navigator.pop(context, attributes);
  }

  int getAttributeId(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) =>
                element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .id ??
      -1;

  String getChildAttributeFirstValue(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) =>
                element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .attributes[0]
          .title ??
      '';

  int getChildAttributeFirstValueId(String selectedAttribute) =>
      widget.listAttributesSets
          ?.firstWhere(
            (element) =>
                element.title.toLowerCase() == selectedAttribute.toLowerCase(),
            orElse: () => AttributeSetsData(title: '', attributes: [], id: -1),
          )
          .attributes[0]
          .id ??
      -1;

  @override
  void initState() {
    super.initState();

    remainingNames = attributeMainNames =
        widget.listAttributesSets?.map((e) => e.title.toString()).toList() ??
            [];

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
            title: Text('Attributes', style: vendorName(context)),
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
                          'Update',
                          style: vendorButtonText(context),
                        ),
                      ),
                    ),
                  ],
          ),
          body: Utils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: Utils.pageRefreshIndicator(
              context: context,
              onRefresh: addAttributesToProduct,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Adding new attributes helps the product to have many options, such as size or color.',
                      style: vendorDescription(),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: attributes.length,
                        itemBuilder: (context, index) {
                          final String selectedAttribute =
                              attributes[index]['name'] ?? '';

                          // Find the matching attribute set based on the selected attribute name
                          final selectedSet = widget.listAttributesSets
                                  ?.firstWhere(
                                (element) => element.title == selectedAttribute,
                                orElse: () => AttributeSetsData(
                                    title: '', attributes: [], id: -1,),
                              ) ??
                              AttributeSetsData(
                                  title: '', attributes: [], id: -1,);

                          // Get available values based on the selected attribute set
                          final List<String> availableValues = selectedSet
                              .attributes
                              .map((attr) => attr.title.toString())
                              .toList();
                          remainingNames.remove(selectedAttribute);
                          final dropDownList =
                              [selectedAttribute] + remainingNames;

                          print('dropDownList ${dropDownList.length}');

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomDropdown(
                                          value: selectedAttribute,
                                          hintText: 'Select Attribute Name',
                                          textStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 15,),
                                          menuItemsList: dropDownList
                                              .map(
                                                (element) => DropdownMenuItem(
                                                  value: element,
                                                  child: Text(element),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              attributes[index]['name'] = value;
                                              attributes[index]['id'] =
                                                  getChildAttributeFirstValueId(
                                                      value,);
                                              attributes[index]['value'] =
                                                  getChildAttributeFirstValue(
                                                      value,);
                                              attributes[index]['value_id'] =
                                                  getChildAttributeFirstValueId(
                                                      value,);
                                              updateNameList();
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 8),
                                        CustomDropdown(
                                          hintText: 'Select Attribute Value',
                                          value:
                                              attributes[index]['value'] ?? '',
                                          textStyle: const TextStyle(
                                              color: Colors.grey, fontSize: 15,),
                                          menuItemsList: availableValues
                                              .map(
                                                (val) => DropdownMenuItem(
                                                  value: val,
                                                  child: Text(val),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              attributes[index]['value'] =
                                                  value;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red,),
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
                        'Add More Attribute',
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
