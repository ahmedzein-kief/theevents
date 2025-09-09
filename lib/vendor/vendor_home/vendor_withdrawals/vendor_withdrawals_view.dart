import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/models/vendor_models/vendor_withdrawals_model/vendor_get_withdrawals_model.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/status_constants/withdrawal_status_constants.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/vendor/vendor_home/vendor_withdrawals/vendor_create_update_withdrawal_view.dart';
import 'package:event_app/vendor/view_models/vendor_withdrawal/vendor_withdrawal_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/vendor_app_strings.dart';
import '../../components/generics/debouced_search.dart';
import '../../components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';

class VendorWithdrawalsView extends StatefulWidget {
  const VendorWithdrawalsView({super.key});

  @override
  State<VendorWithdrawalsView> createState() => _VendorWithdrawalsViewState();
}

class _VendorWithdrawalsViewState extends State<VendorWithdrawalsView> with MediaQueryMixin {
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
      final provider = Provider.of<VendorWithdrawalsViewModel>(context, listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.vendorWithdrawals(search: _searchController.text);
      setState(() {});
    } catch (e) {}
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorWithdrawalsViewModel>(context, listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorWithdrawals(search: _searchController.text);
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
            kMediumSpace,
            Expanded(
              child: Consumer<VendorWithdrawalsViewModel>(
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

  Widget _buildRecordsList({required VendorWithdrawalsViewModel provider}) => ListView.builder(
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
                title: record.amountFormat?.toString() ?? '--',
                leading: Text(
                  record.id?.toString() ?? '--',
                  style: dataRowTextStyle(),
                ),
                subtitleAsWidget: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Fee: ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: record.amountFormat?.toString() ?? '--',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: AppColors.pumpkinOrange,
                        ),
                      ),
                    ],
                  ),
                ),
                status: record.status?.label?.toString() ?? '--',
                statusTextStyle: TextStyle(
                  color: AppColors.getWithdrawalStatusColor(
                    record.status?.value?.toString(),
                  ),
                ),
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: false,
                  showEdit: record.status?.value == WithdrawalStatusConstants.PENDING,
                  showView: record.status?.value != WithdrawalStatusConstants.PENDING,
                  onEdit: () => _onEditRecord(rowData: record),
                  onView: () => _onEditRecord(rowData: record),
                  showDelete: false,
                  onDelete: () {},
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
          kSmallSpace,
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
                  onChanged: (value) => debouncedSearch<VendorWithdrawalsViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorWithdrawalsViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
              kExtraSmallSpace,
              VendorToolbarWidgets.vendorCreateButton(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => VendorCreateUpdateWithdrawalView(),
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
    required VendorWithdrawalRecords rowData,
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
                      VendorAppStrings.amount.tr,
                      rowData.amountFormat?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.fee.tr,
                      rowData.feeFormat?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.createdAt.tr,
                      rowData.createdAt?.toString(),
                    ),
                    buildStatusRow(
                      label: 'Status',
                      buttonText: (rowData.status?.value == null) ? '--' : rowData.status!.label!,
                      color: AppColors.getWithdrawalStatusColor(
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

  void _onEditRecord({required VendorWithdrawalRecords rowData}) {
    /// Move to Edit Order View
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => VendorCreateUpdateWithdrawalView(
          withdrawalID: rowData.id.toString(),
        ),
      ),
    );
  }
}
