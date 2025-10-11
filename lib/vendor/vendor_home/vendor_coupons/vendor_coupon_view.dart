import 'dart:developer';

import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_action_cell.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/dialogs/delete_item_alert_dialog.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/vendor_home/vendor_coupons/coupon_view_utils.dart';
import 'package:event_app/vendor/view_models/vendor_coupons/vendor_delete_coupon_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/vendor_app_strings.dart';
import '../../../core/router/app_routes.dart';
import '../../../core/styles/app_colors.dart';
import '../../../core/utils/app_utils.dart';
import '../../../models/vendor_models/vendor_coupons_models/vendor_get_coupons_model.dart';
import '../../components/data_tables/custom_data_tables.dart';
import '../../components/generics/debouced_search.dart';
import '../../components/vendor_tool_bar_widgets/vendor_tool_bar_widgets.dart';
import '../../view_models/vendor_coupons/vendor_get_coupons_view_model.dart';

class VendorCouponView extends StatefulWidget {
  const VendorCouponView({super.key});

  @override
  State<VendorCouponView> createState() => _VendorCouponViewState();
}

class _VendorCouponViewState extends State<VendorCouponView> with MediaQueryMixin {
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
      final provider = Provider.of<VendorGetCouponsViewModel>(context, listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.vendorGetCoupons(search: _searchController.text);
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<VendorGetCouponsViewModel>(context, listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.vendorGetCoupons(search: _searchController.text);
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
              child: Consumer<VendorGetCouponsViewModel>(
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
                      /// Card style products list data
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

  Widget _buildRecordsList({required VendorGetCouponsViewModel provider}) => ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final coupon = provider.list[index];
          final totalQuantity = coupon.quantity != null ? "/${coupon.quantity?.toString() ?? ''}" : '';
          return Column(
            children: [
              RecordListTile(
                onTap: () => _onRowTap(rowData: coupon, context: context),
                leading: Text(
                  coupon.id.toString(),
                  style: dataRowTextStyle(),
                ),
                status: '${coupon.totalUsed?.toString()}$totalQuantity',
                tileColor: coupon.isExpired ?? false ? AppColors.lavenderHaze : Colors.white,
                statusTextStyle: const TextStyle(fontSize: 13),
                title: coupon.code.toString(),
                titleTextStyle: dataRowTextStyle().copyWith(fontSize: 15, color: AppColors.lightCoral),
                subtitle: CouponViewUtils.generateCouponHelperText(
                  typeOption: coupon.typeOption.toString(),
                  value: double.tryParse(coupon.value.toString()),
                ),
                actionCell: VendorActionCell(
                  mainAxisSize: MainAxisSize.min,
                  isDeleting: coupon.isDeleting,
                  showEdit: false,
                  onEdit: () {},
                  onDelete: () => _onDeleteRecord(rowData: coupon),
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
                  onChanged: (value) => debouncedSearch<VendorGetCouponsViewModel>(
                    context: context,
                    value: value,
                    providerGetter: (context) => context.read<VendorGetCouponsViewModel>(),
                    refreshFunction: _onRefresh,
                  ),
                ),
              ),
              kExtraSmallSpace,
              VendorToolbarWidgets.vendorCreateButton(
                onTap: () {
                  Navigator.of(context).pushNamed(AppRoutes.vendorCreateCouponView);
                },
                isLoading: false,
              ),
            ],
          ),
          // Wrap(
          //   alignment: WrapAlignment.start,
          //   spacing: kSmallPadding,
          //   runSpacing: kSmallPadding,
          //   children: [
          //     // VendorToolbarWidgets.vendorDropdownWidget(
          //     //   hintText: "Bulk Action",
          //     //   menuItemsList: [],
          //     //   /// TODO: ADD DROPDOWN MENU ITEMS LIST HERE
          //     //   onChanged: (value) {},
          //     // )
          //     // VendorToolbarWidgets.vendorReloadButton(
          //     //   onTap: () async{
          //     //     await _onRefresh();
          //     //   },
          //     //   isLoading: false,
          //     // ),
          //   ],
          // ),
        ],
      );

  /// on row tap show full description
  void _onRowTap({
    required BuildContext context,
    required CouponRecords rowData,
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
                    buildRow(VendorAppStrings.id.tr, rowData.id?.toString()),
                    buildRow(
                      VendorAppStrings.couponCode.tr,
                      rowData.code?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.couponName.tr,
                      rowData.title?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.discount.tr,
                      rowData.value?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.startDate.tr,
                      rowData.startDate?.toString(),
                    ),
                    buildRow(
                      VendorAppStrings.endDate.tr,
                      rowData.endDate?.toString(),
                    ),
                    buildStatusRow(
                      label: 'Status',
                      buttonText: rowData.isExpired ?? false ? 'Expired' : 'Valid',
                      color: rowData.isExpired ?? false ? AppColors.pumpkinOrange : AppColors.success,
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

  /// Handles the deletion of a record (coupon).
  Future<void> _onDeleteRecord({required CouponRecords rowData}) async {
    deleteItemAlertDialog(
      context: context,
      onDelete: () async {
        try {
          final vendorCouponsProvider = context.read<VendorGetCouponsViewModel>();
          final deleteCouponProvider = context.read<VendorDeleteCouponViewModel>();

          // Indicate that deletion is in progress
          _setDeletionProcessing(rowData: rowData, processing: true);
          Navigator.of(context).pop();

          // Attempt to delete the coupon record
          final bool isDeleted = await deleteCouponProvider.vendorDeleteCoupon(
            context: context,
            couponId: rowData.id.toString(),
          );

          if (isDeleted && deleteCouponProvider.apiResponse.status == ApiStatus.COMPLETED) {
            // Remove the deleted item from the provider list
            vendorCouponsProvider.removeElementFromList(id: rowData.id);
          }

          // Stop the deletion indicator
          _setDeletionProcessing(rowData: rowData, processing: false);
        } catch (e) {
          // Ensure the deletion indicator is stopped in case of an error
          _setDeletionProcessing(rowData: rowData, processing: false);
        }
      },
    );
  }

  /// Updates the deletion indicator visibility for the given record.
  void _setDeletionProcessing({
    required CouponRecords rowData,
    required bool processing,
  }) {
    setState(() {
      rowData.setIsDeleting(processing);
      // Optionally show a global progress HUD if needed
      // setProcessing(processing);
    });
  }
}
