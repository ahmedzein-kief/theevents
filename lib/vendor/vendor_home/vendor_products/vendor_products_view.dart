import 'dart:async';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/list_tiles/custom_records_list_tile.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import 'package:event_app/vendor/vendor_home/vendor_products/vendor_create_product/vendor_create_physical_product_view.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_delete_product_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_products/vendor_get_products_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/vendor_app_strings.dart';
import '../../components/generics/debouced_search.dart';
import 'widgets/rejection_history_dialog.dart'; // Add this import

class VendorProductsView extends StatefulWidget {
  const VendorProductsView({super.key});

  @override
  State<VendorProductsView> createState() => _VendorProductsViewState();
}

class _VendorProductsViewState extends State<VendorProductsView> with MediaQueryMixin {
  /// To show modal progress hud
  bool _isProcessing = false;

  void setProcessing(bool value) {
    setState(() {
      _isProcessing = value;
    });
  }

  /// Search controller
  final TextEditingController _searchController = TextEditingController();

  // scroll controller
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;

  Future _onRefresh() async {
    try {
      final provider = Provider.of<VendorGetProductsViewModel>(context, listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {}); // ✅ Force UI update immediately after clearing
      await provider.vendorGetProducts(search: _searchController.text);
      setState(() {});
    } catch (e) {}
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorGetProductsViewModel>(context, listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorGetProducts(search: _searchController.text);
      }
    }
  }

  @override
  void initState() {
    super.initState();

    /// To implement pagination adding listeners
    _scrollController.addListener(() {
      _loadMoreData();
    });

    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      await _onRefresh();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Utils.modelProgressHud(
          context: context,
          processing: _isProcessing,
          child: Utils.pageRefreshIndicator(
            onRefresh: _onRefresh,
            child: _buildUi(context),
            context: context,
          ),
        ),
      );

  Widget _buildUi(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: kSmallPadding),
        child: Column(
          children: [
            kFormFieldSpace,

            /// Toolbar
            _toolBar(),
            kSmallSpace,
            Expanded(
              child: Consumer<VendorGetProductsViewModel>(
                builder: (context, provider, _) {
                  /// current api status
                  final ApiStatus? apiStatus = provider.apiResponse.status;
                  if (apiStatus == ApiStatus.LOADING && provider.list.isEmpty) {
                    return Utils.pageLoadingIndicator(context: context);
                  }
                  if (apiStatus == ApiStatus.ERROR) {
                    return Utils.somethingWentWrong();
                  }
                  return Column(
                    children: [
                      VendorDataListBuilder(
                        scrollController: _scrollController,
                        listLength: provider.list.length,
                        loadingMoreData: provider.apiResponse.status == ApiStatus.LOADING,
                        contentBuilder: (context) => _buildRecordsList(provider: provider),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildRecordsList({required VendorGetProductsViewModel provider}) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final product = provider.list[index];
          return Column(
            children: [
              CustomRecordListTile(
                productId: product.id,
                onTap: () => _onRowTap(rowData: product, context: context),
                imageAddress: product.image.toString(),
                multiplePrice: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min, // Prevents Column from taking full height
                  children: [
                    if ((product.price ?? 0) > (product.salePrice ?? 0)) ...{
                      Text(
                        product.salePriceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.black),
                      ),
                      Text(
                        product.priceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.red).copyWith(
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                            ),
                      ),
                      kMinorSpace,
                    } else ...{
                      Text(
                        product.priceFormat?.toString() ?? '--',
                        style: dataRowTextStyle().copyWith(color: Colors.black),
                      ),
                      kMinorSpace,
                    },
                  ],
                ),
                status: product.status?.label,
                statusTextStyle: TextStyle(
                  color: AppColors.getProductPackageStatusColor(
                    product.status?.value.toString(),
                  ),
                ),
                title: product.id.toString(),
                subtitle: product.name.toString(),
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: product.isDeleting,
                  showEdit: true,
                  showDelete: true,
                  showView: false,
                  onEdit: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => VendorCreatePhysicalProductView(
                          productID: product.id.toString(),
                          productType: VendorProductType.none,
                        ),
                      ),
                    );
                  },
                  onDelete: () {
                    _onDeleteRecord(rowData: product);
                  },
                ),
                // Updated onRejectionHistoryTap to show the dialog
                onRejectionHistoryTap: (productId) => _showRejectionHistoryDialog(
                  productId: productId,
                  productName: product.name ?? 'Unknown Product',
                  provider: provider,
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );

  /// Method to show rejection history dialog
  Future<void> _showRejectionHistoryDialog({
    required String productId,
    required String productName,
    required VendorGetProductsViewModel provider,
  }) async {
    try {
      // Set processing to true to show loading indicator
      setProcessing(true);

      // Load rejection history
      await provider.loadRejectionHistory(productId);

      // Set processing to false to hide loading indicator
      setProcessing(false);

      // Check for errors
      if (provider.error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading rejection history: ${provider.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show rejection history dialog
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => RejectionHistoryDialog(
            productName: productName,
            rejectionHistory: provider.rejectionHistory,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      setProcessing(false);

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Tool Bar
  Widget _toolBar() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              // search button
              Expanded(
                child: VendorToolbarWidgets.vendorSearchWidget(
                  onSearchTap: () async {
                    if (_searchController.text.isNotEmpty) {
                      await _onRefresh();
                    }
                  },
                  textEditingController: _searchController,
                  onChanged: (value) => debouncedSearch<VendorGetProductsViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorGetProductsViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
              kExtraSmallSpace,

              /// create button
              VendorToolbarWidgets.vendorCreateButton(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(kSmallCardRadius),
                          topLeft: Radius.circular(kSmallCardRadius),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: kPadding,
                        vertical: kPadding,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Select Product Type',
                            style: TextStyle(
                              fontSize: 17.0,
                              color: AppColors.lightCoral,
                              decoration: TextDecoration.none,
                            ),
                          ),
                          kMediumSpace,
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VendorCreatePhysicalProductView(
                                        productType: VendorProductType.physical,
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.cube_box,
                                      color: AppColors.lightCoral,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Physical product',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: AppColors.darkGrey,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ), // Space before the divider
                              const Divider(color: Colors.grey, thickness: 1),
                              const SizedBox(
                                height: 10,
                              ), // Space after the divider
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => VendorCreatePhysicalProductView(
                                        productType: VendorProductType.digital,
                                      ),
                                    ),
                                  );
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.floppy_disk,
                                      color: AppColors.lightCoral,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      'Digital product',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: AppColors.darkGrey,
                                        decoration: TextDecoration.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          kMediumSpace,
                        ],
                      ),
                    ),
                  );
                },
                isLoading: false,
              ),
            ],
          ),
        ],
      );

  void _onRowTap({
    required BuildContext context,
    required GetProductRecords rowData,
  }) {
    /// showing through bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        onClosing: () {},
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kCardRadius),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(kSmallPadding),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(rowData.image.toString()),
                        ),
                      ),
                    ),
                    buildRow(VendorAppStrings.id.tr, rowData.id?.toString()),
                    buildRow(
                      VendorAppStrings.name.tr,
                      rowData.name?.toString(),
                    ),
                    Wrap(
                      spacing: 8.0, // Horizontal space between children
                      runSpacing: 4.0, // Vertical space between lines
                      children: [
                        if ((rowData.price ?? 0) > (rowData.salePrice ?? 0)) ...{
                          buildRow(
                            VendorAppStrings.price.tr,
                            rowData.salePriceFormat?.toString(),
                            valueWidget: Expanded(
                              child: Wrap(
                                children: [
                                  Text(
                                    rowData.salePriceFormat?.toString() ?? '',
                                    style: detailsDescriptionStyle,
                                  ),
                                  kMinorSpace,
                                  Text(
                                    rowData.priceFormat?.toString() ?? '',
                                    style: detailsDescriptionStyle.copyWith(color: Colors.red).copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        } else ...{
                          buildRow(
                            VendorAppStrings.price.tr,
                            rowData.priceFormat?.toString(),
                          ),
                        },
                      ],
                    ),
                    buildRow(
                      VendorAppStrings.quantity.tr,
                      rowData.quantity?.toString(),
                    ),
                    buildRow(VendorAppStrings.sku.tr, rowData.sku?.toString()),
                    buildRow(
                      VendorAppStrings.order.tr,
                      rowData.order?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.createdAt.tr,
                      rowData.createdAt?.toString(),
                    ),
                    buildStatusRow(
                      label: 'Status',
                      buttonText: rowData.status?.label?.toString() ?? '',
                      color: AppColors.getProductPackageStatusColor(
                        rowData.status?.value?.toString().toLowerCase().trim(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDeleteRecord({required GetProductRecords rowData}) async {
    deleteItemAlertDialog(
      context: context,
      onDelete: () async {
        _setDeletionProcessing(rowData: rowData, processing: true);
        Navigator.pop(context);
        final VendorGetProductsViewModel provider = Provider.of<VendorGetProductsViewModel>(context, listen: false);
        final result = await context
            .read<VendorDeleteProductViewModel>()
            .vendorDeleteProduct(productID: rowData.id, context: context);

        /// Fetch the viewmodel for deleting the record
        if (result) {
          provider.removeElementFromList(id: rowData.id);
          _setDeletionProcessing(rowData: rowData, processing: false);
          setState(() {});
        }
        _setDeletionProcessing(rowData: rowData, processing: false);
      },
    );
  }

  /// maintain the deletion indicator visibility by calling setState.
  void _setDeletionProcessing({
    required GetProductRecords rowData,
    required bool processing,
  }) {
    setState(() {
      rowData.isDeleting = processing;
      // setProcessing(processing); /// To show model progress hud. toggle this if don't want to show progress hud.
    });
  }
}
