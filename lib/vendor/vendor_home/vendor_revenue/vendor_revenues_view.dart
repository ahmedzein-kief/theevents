import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/revenues/revenue_data_response.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import 'package:event_app/vendor/view_models/vendor_revenues/vendor_revenues_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/vendor_app_strings.dart';
import '../../components/generics/debouced_search.dart';

class VendorRevenuesView extends StatefulWidget {
  const VendorRevenuesView({super.key});

  @override
  State<VendorRevenuesView> createState() => _VendorRevenuesViewState();
}

class _VendorRevenuesViewState extends State<VendorRevenuesView> with MediaQueryMixin {
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
      final provider = Provider.of<VendorRevenuesViewModel>(context, listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.vendorRevenues(search: _searchController.text);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = context.read<VendorRevenuesViewModel>();
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorRevenues(search: _searchController.text);
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
            /// Toolbar
            _toolBar(),
            kMediumSpace,
            Expanded(
              child: Consumer<VendorRevenuesViewModel>(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
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

  Widget _buildRecordsList({required VendorRevenuesViewModel provider}) => ListView.builder(
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
                status: record.type,
                statusTextStyle: const TextStyle(color: AppColors.lightCoral),
                title: record.orderCode,
                leading: Text(
                  record.id.toString(),
                  style: dataRowTextStyle(),
                ),
                subtitle: record.amountFormat.toString(),
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
          kSmallSpace,
          VendorToolbarWidgets.vendorSearchWidget(
            onSearchTap: () async {
              if (_searchController.text.isNotEmpty) {
                await _onRefresh();
              }
            },
            textEditingController: _searchController,
            onChanged: (value) => debouncedSearch<VendorRevenuesViewModel>(
              context: context,
              value: value,
              providerGetter: (context) => context.read<VendorRevenuesViewModel>(),
              refreshFunction: _onRefresh,
            ),
          ),
        ],
      );

  void _onRowTap({
    required BuildContext context,
    required RevenueRecord rowData,
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
                    buildRow(VendorAppStrings.id.tr, rowData.id.toString()),
                    buildRow(
                      VendorAppStrings.orderCode.tr,
                      rowData.orderCode.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.amount.tr,
                      rowData.amountFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.subAmount.tr,
                      rowData.subAmountFormat.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.fee.tr,
                      rowData.feeFormat.toString(),
                    ),
                    buildRow(VendorAppStrings.type.tr, rowData.type.toString()),
                    buildRow(
                      VendorAppStrings.createdAt.tr,
                      rowData.createdAt.toString(),
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
}
