import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/provider/customer/account_view_models/reviews/customer_delete_review_view_model.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../models/account_models/reviews/customer_get_product_reviews_model.dart';
import '../../../../provider/customer/account_view_models/reviews/customer_get_product_reviews_view_model.dart';
import '../../../../vendor/Components/data_tables/custom_data_tables.dart';
import '../../../../vendor/components/dialogs/delete_item_alert_dialog.dart';

class CustomerReviewedView extends StatefulWidget {
  const CustomerReviewedView({super.key});

  @override
  State<CustomerReviewedView> createState() => _CustomerReviewedViewState();
}

class _CustomerReviewedViewState extends State<CustomerReviewedView> with MediaQueryMixin {
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
      final provider = Provider.of<CustomerGetProductReviewsViewModel>(
        context,
        listen: false,
      );

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.customerGetProductReviews(search: _searchController.text);
      setState(() {});
    } catch (e) {}
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<CustomerGetProductReviewsViewModel>(
        context,
        listen: false,
      );
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.customerGetProductReviews(
          search: _searchController.text,
        );
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

    // WidgetsBinding.instance.addPostFrameCallback((callback) async {
    //   await _onRefresh();
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        // backgroundColor: AppColors.bgColor,
        body: Utils.modelProgressHud(
          context: context,
          processing: _isProcessing,
          child: Utils.pageRefreshIndicator(
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
            Expanded(
              child: Consumer<CustomerGetProductReviewsViewModel>(
                builder: (context, provider, _) {
                  /// current api status
                  final ApiStatus? apiStatus = provider.apiResponse.status;
                  if (apiStatus == ApiStatus.LOADING && provider.list.isEmpty) {
                    return Utils.pageLoadingIndicator(context: context);
                  }
                  if (apiStatus == ApiStatus.ERROR) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [Utils.somethingWentWrong()],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      VendorDataListBuilder(
                        onNoDataAvailable: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            AppStrings.noReviews.tr,
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              color: AppColors.peachyPink,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        scrollController: _scrollController,
                        listLength: provider.reviewedProductList.length,
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

  Widget _buildRecordsList({
    required CustomerGetProductReviewsViewModel provider,
  }) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.reviewedProductList.length,
        itemBuilder: (context, index) {
          print(provider.reviewedProductList.length);
          final record = provider.reviewedProductList[index];
          return Column(
            children: [
              RecordListTile(
                onTap: () => _onRowTap(context: context, rowData: record),
                title: record.cleanName.toString(),
                imageAddress: record.image,
                subtitleAsWidget: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.createdAt.toString(),
                      style: dataColumnTextStyle(),
                    ),
                    Text(
                      record.sortComment != null
                          ? (record.sortComment!.length > 20
                              ? '${record.sortComment!.substring(0, 20)}...'
                              : record.sortComment!)
                          : '', // Default text if null
                      style: dataColumnTextStyle(),
                    ),
                  ],
                ),
                endWidget: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    RatingBar.builder(
                      initialRating: record.star?.toDouble() ?? 0.0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemSize: 20,
                      itemBuilder: (context, _) {
                        /// show static color here
                        return const Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                      onRatingUpdate: (rating) async {
                        /// navigate to submit review view
                      },
                      ignoreGestures: true,
                    ),
                    kSmallSpace,
                    GestureDetector(
                      onTap: record.isDeleting ? null : () => _onDeleteRecord(rowData: record),
                      child: record.isDeleting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: Utils.pageLoadingIndicator(context: context),
                            )
                          : SvgPicture.asset(
                              'assets/vendor_assets/settings/delete_record.svg',
                            ),
                    ),
                  ],
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );

  void _onRowTap({
    required BuildContext context,
    required ReviewedRecords rowData,
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
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(rowData.image.toString()),
                        ),
                      ),
                    ),
                    kSmallSpace,
                    // buildRow("ID", rowData.id?.toString()),
                    buildRow('Name', rowData.name?.toString()),
                    if ((rowData.sku?.length ?? 0) > 0) buildRow('SKU', rowData.sku?.toString()),
                    buildWidgetRow(
                      'Star',
                      RatingBar.builder(
                        initialRating: rowData.star?.toDouble() ?? 0.0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        itemSize: 20,
                        itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                        ignoreGestures: true,
                        onRatingUpdate: (rating) {},
                      ),
                    ),
                    buildRow('Comment', rowData.comment?.toString()),
                    if ((rowData.storeName?.length ?? 0) > 0) buildRow('Store Name', rowData.storeName?.toString()),
                    buildRow('Created At', rowData.createdAt?.toString()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onDeleteRecord({required ReviewedRecords rowData}) async {
    deleteItemAlertDialog(
      context: context,
      onDelete: () async {
        _setDeletionProcessing(rowData: rowData, processing: true);
        Navigator.pop(context);
        final CustomerGetProductReviewsViewModel provider = Provider.of<CustomerGetProductReviewsViewModel>(
          context,
          listen: false,
        );
        final result = await context
            .read<CustomerDeleteReviewViewModel>()
            .customerDeleteReview(reviewID: rowData.id, context: context);

        await Future.delayed(const Duration(seconds: 5));

        /// Fetch the viewmodel for deleting the record
        if (result) {
          provider.removeElementFromList(id: rowData.id);
          _setDeletionProcessing(rowData: rowData, processing: false);
          setState(() {});
          _onRefresh();
        }
        _setDeletionProcessing(rowData: rowData, processing: false);
      },
    );
  }

  /// maintain the deletion indicator visibility by calling setState.
  void _setDeletionProcessing({
    required ReviewedRecords rowData,
    required bool processing,
  }) {
    setState(() {
      rowData.isDeleting = processing;
    });
  }
}
