import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/search_dropdown_model.dart';
import 'package:event_app/vendor/components/dropdowns/generic_dropdown.dart';
import 'package:event_app/vendor/components/dropdowns/search_dropdown.dart';
import 'package:event_app/vendor/components/list_tiles/spinner_records_list_tile.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:event_app/vendor/components/text_fields/custom_text_form_field.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrossSellingProductsSearchScreen extends StatefulWidget {
  CrossSellingProductsSearchScreen({
    super.key,
    required this.title,
    required this.dataId,
    required this.selectedCrossSellingProducts,
  });
  final String title;
  String? dataId;
  List<SearchProductRecord> selectedCrossSellingProducts = [];

  @override
  _CrossSellingProductsSearchScreenState createState() =>
      _CrossSellingProductsSearchScreenState();
}

class _CrossSellingProductsSearchScreenState
    extends State<CrossSellingProductsSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;
  SearchDropdownModel searchDropdownModel = SearchDropdownModel();
  List<SearchProductRecord> listSearchProducts = [];
  List<String> priceType = ['Fixed', 'Percent'];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  Future<VendorSearchProductDataResponse?> _fetchOptionsData(
      String query, String dataId) async {
    final provider =
        Provider.of<VendorCreateProductViewModel>(context, listen: false);
    if (query.isEmpty) {
      return null;
    }
    try {
      setProcessing(true);
      return await provider.productSearch(query, dataId);
    } catch (e) {
      print('Error: $e');
      return null;
    } finally {
      setProcessing(false);
    }
  }

  @override
  void initState() {
    listSearchProducts = widget.selectedCrossSellingProducts;
    super.initState();
  }

  void _returnBack() {
    Navigator.pop(context, listSearchProducts);
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Padding(
          padding: const EdgeInsets.all(4.0),
          child: SingleChildScrollView(
            // Ensures content is scrollable if needed
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min, // Wraps content height
              children: [
                _buildFormattedText(
                  title: 'Price field',
                  description:
                      'Enter the amount you want to reduce from the original price. Example: If the original price is \$100, enter 20 to reduce the price to \$80.',
                ),
                const SizedBox(height: 8),
                _buildFormattedText(
                  title: 'Type field',
                  description:
                      'Choose the discount type: Fixed (reduce a specific amount) or Percent (reduce by a percentage).',
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            title: Text(widget.title, style: vendorName(context)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _returnBack,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.info_outline,
                  color: AppColors.lightCoral,
                ), // Change this icon as needed
                onPressed: () {
                  _showInfoDialog(context);
                },
              ),
            ],
          ),
          backgroundColor: AppColors.bgColor,
          body: Utils.modelProgressHud(
            processing: _isProcessing,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, left: 8.0, right: 8.0, top: 4.0),
                  child: SearchDropdown(
                    hint: 'Search products',
                    searchDropdownModel: searchDropdownModel,
                    onSelected: (selectedProduct) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        searchDropdownModel.searchText = '';
                        searchDropdownModel.showDropdown = false;
                        searchDropdownModel.records = [];
                        selectedProduct.price = null;
                        if (!listSearchProducts.any(
                            (product) => product.id == selectedProduct.id)) {
                          listSearchProducts.add(selectedProduct);
                        } else {
                          AlertServices.showErrorSnackBar(
                              message:
                                  'Selected product already added in the list',
                              context: context);
                        }
                      });
                    },
                    onSearchChanged: (searchModel) async {
                      final result = await _fetchOptionsData(
                          searchModel.searchText, widget.dataId ?? '');
                      if (result != null) {
                        setState(() {
                          searchDropdownModel.showDropdown =
                              searchDropdownModel.searchText.isNotEmpty == true;
                          searchDropdownModel.records =
                              result.data?.records ?? [];
                        });
                      }
                    },
                  ),
                ),
                if (listSearchProducts.isNotEmpty) _buildUi(context),
              ],
            ),
          ),
        ),
      );

  Widget _buildUi(BuildContext context) => Expanded(
        // Ensure it takes the available space
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
          child: listSearchProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Please search and add products',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [..._buildRecords(listSearchProducts)],
                  ),
                ),
        ),
      );

  List<Widget> _buildRecords(List<SearchProductRecord>? records) {
    if (records == null || records.isEmpty) return [const SizedBox.shrink()];
    return records.map((product) {
      if (product.price != null) {
        product.controller.text = product.price.toString();
      }
      String? productPriceType;
      if (product.priceType != null) {
        productPriceType =
            SearchProductRecord.capitalize(product.priceType ?? '');
      } else {
        productPriceType = priceType.first;
      }

      return Column(
        children: [
          SpinnerRecordListTile(
            imageAddress: product.image.toString(),
            title: product.id.toString(),
            subtitle: product.name.toString(),
            onTap: () {},
            endWidget: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                kExtraSmallSpace,
                GestureDetector(
                  onTap: () {
                    setState(() {
                      product.controller.dispose();
                      listSearchProducts.remove(product);
                    });
                  },
                  child: const Icon(Icons.cancel_outlined, color: Colors.grey),
                ),
              ],
            ),
            bottomWidget: Padding(
              padding: const EdgeInsets.only(
                  left: 8, right: 8, bottom: 12), // Adds padding on both sides
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomTextFormField(
                      labelText: 'Price',
                      showTitle: false,
                      controller: product.controller,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          print(
                              'User Input 1 : $value'); // Debugging user input
                          final int index = listSearchProducts
                              .indexWhere((option) => option.id == product.id);
                          if (index != -1) {
                            print(
                                'User Input 2 : $value'); // Debugging user input

                            if (value is String)
                              listSearchProducts[index].price =
                                  value.isNotEmpty ? int.parse(value) : 0;
                          }
                        });
                      },
                      required: false,
                      hintText: 'Price',
                    ),
                  ),
                  const SizedBox(
                      width:
                          8), // Adds spacing between input field and dropdown
                  Expanded(
                    flex: 1, // Ensure dropdown has a defined width
                    child: GenericDropdown<String>(
                      textStyle:
                          const TextStyle(color: Colors.grey, fontSize: 15),
                      value: productPriceType,
                      menuItemsList: priceType,
                      displayItem: (String priceType) => priceType,
                      onChanged: (String? value) {
                        setState(() {
                          final int index = listSearchProducts
                              .indexWhere((option) => option.id == product.id);
                          if (index != -1) {
                            listSearchProducts[index].priceType =
                                value?.toString().toLowerCase() ?? '';
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          kSmallSpace,
        ],
      );
    }).toList();
  }

  Widget _buildFormattedText(
          {required String title, required String description}) =>
      RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 14, color: Colors.black87),
          children: [
            TextSpan(
              text: '$title:\n',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: description),
          ],
        ),
      );
}
