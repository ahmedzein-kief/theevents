import 'dart:async';
import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/generics/debouced_search.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/vendor_home/vendor_orders/vendor_edit_order_view.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_delete_order_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/constants/vendor_app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/vendor_models/vendor_order_models/vendor_get_orders_model.dart';
import '../../components/data_tables/custom_data_tables.dart';
import '../../components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import '../../view_models/vendor_orders/vendor_get_orders_view_model.dart';

class VendorOrdersView extends StatefulWidget {
  const VendorOrdersView({super.key});

  @override
  State<VendorOrdersView> createState() => _VendorOrdersViewState();
}

class _VendorOrdersViewState extends State<VendorOrdersView> with MediaQueryMixin {
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

  Future _onRefresh() async {
    try {
      final provider = Provider.of<VendorGetOrdersViewModel>(context, listen: false);

      /// Clear list before fetching new data
      provider.clearList();
      setState(() {}); // ✅ Force UI update immediately after clearing
      await provider.vendorGetOrders(search: _searchController.text);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorGetOrdersViewModel>(context, listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorGetOrders(search: _searchController.text);
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
        body: AppUtils.modelProgressHud(
          context: context,
          processing: _isProcessing,
          child: AppUtils.pageRefreshIndicator(
            context: context,
            onRefresh: _onRefresh,
            child: _buildUi(context),
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
              child: Consumer<VendorGetOrdersViewModel>(
                builder: (context, provider, _) {
                  /// current api status
                  final ApiStatus? apiStatus = provider.apiResponse.status;
                  if (apiStatus == ApiStatus.LOADING && provider.list.isEmpty) {
                    return AppUtils.pageLoadingIndicator(context: context);
                  }
                  if (apiStatus == ApiStatus.ERROR) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [AppUtils.somethingWentWrong()],
                    );
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

  Widget _buildRecordsList({required VendorGetOrdersViewModel provider}) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final record = provider.list[index];
          return Column(
            children: [
              RecordListTile(
                onTap: () => _onRowTap(rowData: record, context: context),
                // imageAddress: record.image.toString(),
                status: record.status?.label?.toString() ?? '--',
                statusTextStyle: TextStyle(
                  color: AppColors.getOrderStatusColor(
                    record.status?.value?.toString(),
                  ),
                ),
                title: record.customerName?.toString() ?? '--',
                leading: Text(
                  record.id?.toString() ?? '--',
                  style: dataRowTextStyle(),
                ),
                subtitle: record.amountFormat?.toString() ?? '--',
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: record.isDeleting,
                  showEdit: true,
                  onEdit: () => _onEditRecord(rowData: record),
                  showDelete: true,
                  onDelete: () => _onDeleteRecord(rowData: record),
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );

  /// Tool Bar
  Widget _toolBar() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: VendorToolbarWidgets.vendorSearchWidget(
                  onSearchTap: () async {
                    if (_searchController.text.isNotEmpty) {
                      await _onRefresh();
                    }
                  },
                  textEditingController: _searchController,
                  onChanged: (value) => debouncedSearch<VendorGetOrdersViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorGetOrdersViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
            ],
          ),
        ],
      );

  void _onRowTap({
    required BuildContext context,
    required OrderRecords rowData,
  }) {
    /// showing through bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (context) => BottomSheet(
        // dragHandleColor: AppColors.lightCoral,
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
                    buildRow(VendorAppStrings.id.tr, rowData.id?.toString()),
                    buildRow(
                      VendorAppStrings.customer.tr,
                      rowData.customerName?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.amount.tr,
                      rowData.amountFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.taxAmount.tr,
                      rowData.taxAmountFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.shippingAmount.tr,
                      rowData.shippingAmountFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.payment.tr,
                      (rowData.paymentMethod?.value == null) ? '--' : rowData.paymentMethod?.label?.toString(),
                    ),
                    buildStatusRow(
                      label: AppStrings.paymentType.tr,
                      buttonText: (rowData.paymentStatus?.value == null) ? '--' : rowData.paymentStatus!.label!,
                      color: AppColors.getPaymentStatusColor(
                        rowData.paymentStatus?.value,
                      ),
                      textColor: (rowData.paymentStatus?.value == null) ? AppColors.stoneGray : Colors.white,
                    ),
                    const Divider(
                      thickness: 0.1,
                    ),
                    buildRow(
                      VendorAppStrings.createdAt.tr,
                      rowData.createdAt.toString(),
                    ),
                    buildStatusRow(
                      label: VendorAppStrings.status.tr,
                      buttonText: rowData.status?.label?.toString() ?? '',
                      color: AppColors.getOrderStatusColor(
                        rowData.status?.value,
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

  Future<void> _onDeleteRecord({required OrderRecords rowData}) async {
    deleteItemAlertDialog(
      context: context,
      onDelete: () async {
        _setDeletionProcessing(rowData: rowData, processing: true);
        Navigator.of(context).pop();
        final VendorGetOrdersViewModel provider = context.read<VendorGetOrdersViewModel>();
        final VendorDeleteOrderViewModel deleteOrderProvider = context.read<VendorDeleteOrderViewModel>();

        final bool result = await deleteOrderProvider.vendorDeleteOrder(
          orderID: rowData.id.toString(),
          context: context,
        );

        /// Fetch the viewmodel for deleting the record
        if (result) {
          provider.removeElementFromList(id: rowData.id);
          setState(() {});
        }
        _setDeletionProcessing(rowData: rowData, processing: false);
      },
    );
  }

  Future<void> _onEditRecord({required OrderRecords rowData}) async {
    /// Move to Edit Order View
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => VendorEditOrderView(orderID: rowData.id.toString()),
      ),
    );
  }

  /// maintain the deletion indicator visibility by calling setState.
  void _setDeletionProcessing({
    required OrderRecords rowData,
    required bool processing,
  }) {
    setState(() {
      rowData.isDeleting = processing;
      // setProcessing(processing); /// To show model progress hud. toggle this if don't want to show progress hud.
    });
  }
}
