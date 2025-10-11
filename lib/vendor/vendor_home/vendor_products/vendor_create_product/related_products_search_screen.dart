import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/search_dropdown_model.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/dropdowns/search_dropdown.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/vendor_app_strings.dart';

class RelatedProductsSearchScreen extends StatefulWidget {
  const RelatedProductsSearchScreen({
    super.key,
    required this.title,
    required this.dataId,
    this.selectedRelatedProducts = const [],
  });

  final String title;
  final String? dataId;
  final List<SearchProductRecord> selectedRelatedProducts;

  @override
  State<RelatedProductsSearchScreen> createState() => _RelatedProductsSearchScreenState();
}

class _RelatedProductsSearchScreenState extends State<RelatedProductsSearchScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isProcessing = false;
  SearchDropdownModel searchDropdownModel = SearchDropdownModel();
  List<SearchProductRecord> listSearchProducts = [];

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
    String query,
    String dataId,
  ) async {
    final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);
    if (query.isEmpty) {
      return null;
    }
    try {
      setProcessing(true);
      log(query);
      final result = await provider.productSearch(query, dataId);

      return result;
    } catch (e) {
      log('Error: $e');
      return null;
    } finally {
      setProcessing(false);
    }
  }

  void _returnBack() {
    Navigator.pop(context, listSearchProducts);
  }

  @override
  void initState() {
    listSearchProducts = widget.selectedRelatedProducts;
    super.initState();
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
          ),
          //
          body: AppUtils.modelProgressHud(
            context: context,
            processing: _isProcessing,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SearchDropdown(
                    hint: VendorAppStrings.searchProducts.tr,
                    searchDropdownModel: searchDropdownModel,
                    onSelected: (selectedProduct) {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        searchDropdownModel.searchText = '';
                        searchDropdownModel.showDropdown = false;
                        searchDropdownModel.records = [];
                        if (!listSearchProducts.any(
                          (product) => product.id == selectedProduct.id,
                        )) {
                          listSearchProducts.add(selectedProduct);
                        } else {
                          AppUtils.showToast(VendorAppStrings.selectedProductAlreadyAdded.tr);
                        }
                      });
                    },
                    onSearchChanged: (searchModel) async {
                      final result = await _fetchOptionsData(
                        searchModel.searchText,
                        widget.dataId ?? '',
                      );
                      if (result != null) {
                        setState(() {
                          searchDropdownModel.showDropdown = searchDropdownModel.searchText.isNotEmpty == true;
                          searchDropdownModel.records = result.data?.records ?? [];
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
              ? Center(
                  child: Text(
                    VendorAppStrings.pleaseSearchAndAddProducts.tr,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
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
    return records
        .map(
          (product) => Column(
            children: [
              RecordListTile(
                imageAddress: product.image.toString(),
                title: product.id.toString(),
                subtitle: product.name.toString(),
                onTap: () {},
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: false,
                  showEdit: false,
                  showDelete: false,
                  showView: false,
                  onEdit: () {},
                  onDelete: () {},
                  showViewWidget: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      kExtraSmallSpace,
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            listSearchProducts.remove(product);
                          });
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              kSmallSpace,
            ],
          ),
        )
        .toList();
  }
}
