import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/core/widgets/custom_auth_views/app_custom_button.dart';
import 'package:event_app/models/vendor_models/products/create_product/global_options_data_response.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_product_general_settings_model.dart';
import 'package:event_app/vendor/components/dropdowns/generic_dropdown.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProductOptionsScreen extends StatefulWidget {
  const VendorProductOptionsScreen({
    super.key,
    required this.selectedOptions,
    required this.globalOptions,
  });

  final List<GlobalOptionsData> selectedOptions;
  final List<GlobalOptions> globalOptions;

  @override
  _VendorProductOptionsScreenState createState() => _VendorProductOptionsScreenState();
}

class _VendorProductOptionsScreenState extends State<VendorProductOptionsScreen> {
  List<GlobalOptionsData> productOptions = [];
  List<String> priceType = ['Fixed', 'Percent'];

  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future _fetchOptionsData(String optionId) async {
    try {
      print('Inside fetch options ');
      setProcessing(true);
      final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);
      final result = await provider.getGlobalOptions(optionId);
      if (result?.data != null) {
        setState(() {
          productOptions.add(result!.data!);
        });
      }

      setProcessing(false);
    } catch (e) {
      setProcessing(false);
      print('Error: $e');
    }
  }

  @override
  void initState() {
    productOptions = widget.selectedOptions;
    super.initState();
  }

  void deleteSection(int index) {
    setState(() {
      productOptions.removeAt(index);
    });
  }

  void addNewRow(int sectionIndex) {
    setState(() {
      productOptions[sectionIndex].values.add(GlobalOptionsValues.defaultData());
    });
  }

  void deleteRow(int sectionIndex, int rowIndex) {
    setState(() {
      productOptions[sectionIndex].values.removeAt(rowIndex);
    });
  }

  void _returnBack() {
    Navigator.pop(context, productOptions);
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
            title: Text('Product Options', style: vendorName(context)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _returnBack,
            ),
          ),
          body: productOptions.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                    child: Text(
                      'Please add product options on the tap of + button at bottom right corner.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : _buildUI(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.lightCoral,
            onPressed: () => showAddSectionPopup(),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _buildUI() => AppUtils.modelProgressHud(
        context: context,
        processing: _isProcessing,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80, top: 16),
          itemCount: productOptions.length,
          itemBuilder: (context, sectionIndex) {
            final section = productOptions[sectionIndex];
            final typeValue = GlobalOptions(
              id: section.id,
              value: section.name,
            );
            productOptions[sectionIndex].nameController.text = productOptions[sectionIndex].name;
            productOptions[sectionIndex].optionTypeController.text = productOptions[sectionIndex].getType();
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          activeColor: Theme.of(context).colorScheme.onPrimary,
                          checkColor: Theme.of(context).colorScheme.primary,
                          value: section.required == 1,
                          onChanged: (value) {
                            setState(() {
                              productOptions[sectionIndex].required = value == true ? 1 : 0;
                            });
                          },
                        ),
                        Text(VendorAppStrings.required.tr),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteSection(sectionIndex),
                        ),
                      ],
                    ),
                    CustomTextFormField(
                      labelText: '',
                      showTitle: false,
                      required: false,
                      hintText: VendorAppStrings.enterNameField.tr,
                      controller: productOptions[sectionIndex].nameController,
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      labelText: '',
                      readOnly: true,
                      showTitle: false,
                      required: false,
                      hintText: VendorAppStrings.enterNameField.tr,
                      controller: productOptions[sectionIndex].optionTypeController,
                    ),
                    const SizedBox(height: 10),
                    if (section.getType().toString().toLowerCase() != 'location')
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: GenericDropdown<String>(
                              textStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                              value: priceType.first,
                              menuItemsList: priceType,
                              displayItem: (String priceType) => priceType,
                              onChanged: (String? value) {
                                /// TODO: set the affect type here 0 for fixed and 1 for percentage
                                productOptions[sectionIndex].values[0].affectType =
                                    value?.toLowerCase() == 'percent' ? 1 : 0;
                                setState(() {});
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              children: List.generate(section.values.length, (rowIndex) {
                                productOptions[sectionIndex].values[rowIndex].priceController.text =
                                    productOptions[sectionIndex].values[rowIndex].affectPrice.toString();
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: VendorAppStrings.price.tr,
                                          showTitle: false,
                                          keyboardType: TextInputType.number,
                                          controller: productOptions[sectionIndex].values[rowIndex].priceController,
                                          onChanged: (value) {
                                            print(
                                              'value  ==> $sectionIndex || $rowIndex || $value',
                                            );
                                            if (value is String) {
                                              productOptions[sectionIndex].values[rowIndex].affectPrice =
                                                  value.isNotEmpty ? int.parse(value) : 0;
                                            }
                                            // setState(() {});
                                          },
                                          required: false,
                                          hintText: VendorAppStrings.price.tr,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    if (section.getType().toString().toLowerCase() == 'location')
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                            ),
                            child: Column(
                              children: List.generate(section.values.length, (rowIndex) {
                                productOptions[sectionIndex].values[rowIndex].optionValueController.text =
                                    productOptions[sectionIndex].values[rowIndex].optionValue ?? '';

                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: VendorAppStrings.enterLabel.tr,
                                          showTitle: false,
                                          controller: section.values[rowIndex].optionValueController,
                                          onChanged: (value) {
                                            setState(() {
                                              productOptions[sectionIndex].values[rowIndex].optionValue = value;
                                            });
                                          },
                                          required: false,
                                          hintText: VendorAppStrings.enterLabel.tr,
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.grey,
                                          size: 24,
                                        ),
                                        onPressed: () => deleteRow(sectionIndex, rowIndex),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.lightCoral,
                              ),
                              label: const Text(
                                'Add new row',
                                style: TextStyle(color: AppColors.lightCoral),
                              ),
                              onPressed: () => addNewRow(sectionIndex),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      );

  void showAddSectionPopup() {
    String newGlobalOptionID = '';
    bool hasError = false;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(kSmallCardRadius),
              topLeft: Radius.circular(kSmallCardRadius),
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kPadding),
          child: Material(
            child: Wrap(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Section Type',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: AppColors.lightCoral,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    kMediumSpace,
                    GenericDropdown<GlobalOptions>(
                      textStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                      menuItemsList: widget.globalOptions,
                      displayItem: (GlobalOptions option) => option.value ?? '',
                      onChanged: (GlobalOptions? selectedOption) {
                        setState(() {
                          newGlobalOptionID = selectedOption?.id?.toString() ?? '';
                          hasError = false;
                        });
                      },
                    ),
                    if (hasError)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Please select type',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const SizedBox(height: 10),
                    CustomAppButton(
                      buttonText: 'Add Global Options',
                      buttonColor: AppColors.lightCoral,
                      onTap: () async {
                        print('ID ==> $newGlobalOptionID  || $hasError');
                        if (newGlobalOptionID.isNotEmpty) {
                          _fetchOptionsData(newGlobalOptionID);
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            hasError = true;
                          });
                        }
                      },
                    ),
                    kMediumSpace,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
