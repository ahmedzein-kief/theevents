import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/revenues/revenue_data_response.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import 'package:event_app/vendor/view_models/vendor_orders/vendor_get_orders_view_model.dart';
import 'package:event_app/vendor/view_models/vendor_revenues/vendor_revenues_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/generics/debouced_search.dart';

class VendorRevenuesView extends StatefulWidget {
  const VendorRevenuesView({super.key});

  @override
  State<VendorRevenuesView> createState() => _VendorRevenuesViewState();
}

class _VendorRevenuesViewState extends State<VendorRevenuesView> with MediaQueryMixin {
  /// To show modal progress hud
  bool _isProcessing = false;

  setProcessing(bool value) {
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
    }
  }

  void _loadMoreData() async {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: Utils.modelProgressHud(processing: _isProcessing, child: Utils.pageRefreshIndicator(onRefresh: _onRefresh, child: _buildUi(context))),
    );
  }

  Widget _buildUi(BuildContext context) {
    return Padding(
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
                  return Utils.pageLoadingIndicator(context: context);
                }
                if (apiStatus == ApiStatus.ERROR) {
                  return ListView(physics: AlwaysScrollableScrollPhysics(), children: [Utils.somethingWentWrong()]);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    VendorDataListBuilder(
                      scrollController: _scrollController,
                      listLength: provider.list.length,
                      loadingMoreData: provider.apiResponse.status == ApiStatus.LOADING,
                      contentBuilder: (context) =>_buildRecordsList(provider: provider),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsList({required VendorRevenuesViewModel provider}) {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final record = provider.list[index];
          return Column(
            children: [
              RecordListTile(
                onTap: () => _onRowTap(rowData: record, context: context),
                // imageAddress: record.image.toString(),
                status: record.type,
                statusTextStyle: TextStyle(color: AppColors.lightCoral),
                title: record.orderCode,
                leading: Text(
                  record.id.toString() ?? '',
                  style: dataRowTextStyle(),
                ),
                subtitle: "${record.amountFormat.toString() ?? '--'}",
              ),
              kSmallSpace,
            ],
          );
        });
  }

  /// Tool Bar
  Widget _toolBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kSmallSpace,
        VendorToolbarWidgets.vendorSearchWidget(
            onSearchTap: () async{
              if(_searchController.text.isNotEmpty){
                await _onRefresh();
              }
            },
            textEditingController: _searchController,
            onChanged: (value) => debouncedSearch<VendorRevenuesViewModel>(
                  context: context,
                  value: value,
                  providerGetter: (context)=>context.read<VendorRevenuesViewModel>(),
                  refreshFunction: _onRefresh,
                ),
        ),
      ],
    );
  }

  _onRowTap({required BuildContext context, required RevenueRecord rowData}) {
    /// showing through bottom sheet
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              // dragHandleColor: AppColors.lightCoral,
              onClosing: () {},
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(kCardRadius)),
                  child: SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(kSmallPadding),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildRow("ID", rowData.id.toString()),
                            buildRow("Order Code", rowData.orderCode.toString()),
                            buildRow("Amount", rowData.amountFormat.toString()),
                            buildRow("Sub Amount", rowData.subAmountFormat.toString()),
                            buildRow("Fee", rowData.feeFormat.toString()),
                            buildRow("Type", rowData.type.toString()),
                            buildRow("Created At", rowData.createdAt.toString() ?? ''),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              });
        });
  }
}
