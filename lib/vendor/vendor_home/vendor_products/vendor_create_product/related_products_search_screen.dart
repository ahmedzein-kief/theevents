import 'package:event_app/models/vendor_models/products/create_product/vendor_search_product_data_response.dart';
import 'package:event_app/models/vendor_models/products/holder_models/search_dropdown_model.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/dropdowns/search_dropdown.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_create_product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RelatedProductsSearchScreen extends StatefulWidget {
  final String title;
  String? dataId = null;
  List<SearchProductRecord> selectedRelatedProducts = [];

  RelatedProductsSearchScreen({
    required this.title,
    required this.dataId,
    required this.selectedRelatedProducts,
  });

  @override
  _RelatedProductsSearchScreenState createState() => _RelatedProductsSearchScreenState();
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

  Future<VendorSearchProductDataResponse?> _fetchOptionsData(String query, String dataId) async {
    final provider = Provider.of<VendorCreateProductViewModel>(context, listen: false);
    if (query.isEmpty) {
      return null;
    }
    try {
      setProcessing(true);
      print(query);
      final result = await provider.productSearch(query, dataId);
      print(result);
      return result;
    } catch (e) {
      print("Error: $e");
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
  Widget build(BuildContext context) {
    return PopScope(
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
            icon: Icon(Icons.arrow_back),
            onPressed: _returnBack,
          ),
        ),
        backgroundColor: AppColors.bgColor,
        body: Utils.modelProgressHud(
          processing: _isProcessing,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchDropdown(
                  hint: "Search products",
                  searchDropdownModel: searchDropdownModel,
                  onSelected: (selectedProduct) {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      searchDropdownModel.searchText = "";
                      searchDropdownModel.showDropdown = false;
                      searchDropdownModel.records = [];
                      if (!listSearchProducts.any((product) => product.id == selectedProduct.id)) {
                        listSearchProducts.add(selectedProduct);
                      } else {
                        AlertServices.showErrorSnackBar(message: "Selected product already added in the list", context: context);
                      }
                    });
                  },
                  onSearchChanged: (searchModel) async {
                    final result = await _fetchOptionsData(searchModel.searchText, widget.dataId ?? '');
                    print(result);
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
  }

  Widget _buildUi(BuildContext context) {
    return Expanded(
      // Ensure it takes the available space
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
        child: listSearchProducts.isEmpty
            ? Center(
                child: Text(
                  "Please search and add products",
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
  }

  List<Widget> _buildRecords(List<SearchProductRecord>? records) {
    if (records == null || records.isEmpty) return [SizedBox.shrink()];
    return records.map((product) {
      return Column(
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
                    child: Icon(Icons.cancel_outlined, color: Colors.grey),
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
}
