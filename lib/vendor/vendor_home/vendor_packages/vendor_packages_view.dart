import 'dart:async';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/products/vendor_get_products_model.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import 'package:event_app/vendor/vendor_home/vendor_packages/vendor_create_package_view.dart';
import 'package:event_app/vendor/view_models/vendor_packages/vendor_delete_package_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/vendor_app_strings.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../components/data_tables/custom_data_tables.dart';
import '../../components/generics/debouced_search.dart';
import '../../view_models/vendor_packages/vendor_get_packages_view_model.dart';

class VendorPackagesView extends StatefulWidget {
  const VendorPackagesView({super.key});

  @override
  State<VendorPackagesView> createState() => _VendorPackagesViewState();
}

class _VendorPackagesViewState extends State<VendorPackagesView> with MediaQueryMixin {
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
      final provider = Provider.of<VendorGetPackagesViewModel>(context, listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {}); // ✅ Force UI update immediately after clearing
      await provider.vendorGetPackages(search: _searchController.text);
      setState(() {});
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorGetPackagesViewModel>(context, listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorGetPackages(search: _searchController.text);
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
            /// Toolbar
            _toolBar(),
            kSmallSpace,
            Expanded(
              child: Consumer<VendorGetPackagesViewModel>(
                builder: (context, provider, _) {
                  /// current api status
                  final ApiStatus? apiStatus = provider.apiResponse.status;
                  if (apiStatus == ApiStatus.LOADING && provider.list.isEmpty) {
                    return AppUtils.pageLoadingIndicator(context: context);
                  }
                  if (apiStatus == ApiStatus.ERROR) {
                    return AppUtils.somethingWentWrong();
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

  Widget _buildRecordsList({required VendorGetPackagesViewModel provider}) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final product = provider.list[index];
          return Column(
            children: [
              RecordListTile(
                onTap: () => _onRowTap(rowData: product, context: context),
                imageAddress: product.image.toString(),
                status: '${product.status?.label.toString()}',
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
                  showDelete: true,
                  showEdit: true,
                  showView: false,
                  onEdit: () => _onEditRecord(rowData: product),
                  onDelete: () => _onDeleteRecord(rowData: product),
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );

  /// Tool Bar
  Widget _toolBar() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          kFormFieldSpace,
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: VendorToolbarWidgets.vendorSearchWidget(
                  onSearchTap: () async {
                    if (_searchController.text.isNotEmpty) {
                      await _onRefresh();
                    }
                  },
                  textEditingController: _searchController,
                  onChanged: (value) => debouncedSearch<VendorGetPackagesViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorGetPackagesViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
              kExtraSmallSpace,
              VendorToolbarWidgets.vendorCreateButton(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const VendorCreatePackageView(),
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
              padding: EdgeInsets.symmetric(
                vertical: kPadding,
                horizontal: kSmallPadding,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(kCardRadius),
                        image: DecorationImage(
                          // fit: BoxFit.fill,
                          image: NetworkImage(
                            rowData.image.toString(),
                          ),
                        ),
                      ),
                    ),
                    kMediumSpace,
                    buildRow(
                      VendorAppStrings.id.tr,
                      rowData.id.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.name.tr,
                      rowData.name.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.price.tr,
                      rowData.priceFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.quantity.tr,
                      rowData.quantity.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.sku.tr,
                      rowData.sku.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.order.tr,
                      rowData.order.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.createdAt.tr,
                      rowData.createdAt.toString(),
                    ),
                    buildStatusRow(
                      label: VendorAppStrings.status.tr,
                      buttonText: rowData.status?.label.toString() ?? '',
                      color: AppColors.getProductPackageStatusColor(
                        rowData.status?.value.toString(),
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
        final VendorGetPackagesViewModel provider = Provider.of<VendorGetPackagesViewModel>(context, listen: false);

        final result = await context
            .read<VendorDeletePackageViewModel>()
            .vendorDeletePackage(packageID: rowData.id, context: context);

        /// Fetch the viewmodel for deleting the record
        if (result) {
          provider.removeElementFromList(id: rowData.id);
          setState(() {});
        }
        _setDeletionProcessing(rowData: rowData, processing: false);
      },
    );
  }

  Future<void> _onEditRecord({required GetProductRecords rowData}) async {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => VendorCreatePackageView(
          packageID: rowData.id.toString(),
        ),
      ),
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
