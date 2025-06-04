import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/data/vendor/data/response/apis_status.dart';
import 'package:event_app/vendor/components/common_widgets/vendor_data_list_builder.dart';
import 'package:event_app/vendor/components/list_tiles/records_list_tile.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/views/base_screens/profile_screens/reviews/customer_submit_review_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../provider/customer/account_view_models/reviews/customer_get_product_reviews_view_model.dart';

class CustomerWaitingForReviewsView extends StatefulWidget {
  const CustomerWaitingForReviewsView({super.key});

  @override
  State<CustomerWaitingForReviewsView> createState() =>
      _CustomerWaitingForReviewsViewState();
}

class _CustomerWaitingForReviewsViewState
    extends State<CustomerWaitingForReviewsView> with MediaQueryMixin {
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
      final provider = Provider.of<CustomerGetProductReviewsViewModel>(context,
          listen: false);

      /// clear list on refresh
      provider.clearList();
      setState(() {});
      await provider.customerGetProductReviews(search: _searchController.text);
      setState(() {});
    } catch (e) {}
  }

  Future<void> _loadMoreData() async {
    // Load more data here
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      final provider = Provider.of<CustomerGetProductReviewsViewModel>(context,
          listen: false);
      if (provider.apiResponse.status != ApiStatus.LOADING) {
        await provider.customerGetProductReviews(
            search: _searchController.text);
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
        backgroundColor: AppColors.bgColor,
        body: Utils.modelProgressHud(
            processing: _isProcessing,
            child: Utils.pageRefreshIndicator(
                onRefresh: _onRefresh, child: _buildUi(context))),
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
                        children: [Utils.somethingWentWrong()]);
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      VendorDataListBuilder(
                        onNoDataAvailable: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'You do not have any products to review yet. Just shopping!',
                            style: GoogleFonts.inter(
                                fontSize: 20,
                                color: AppColors.peachyPink,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        scrollController: _scrollController,
                        listLength: provider.list.length,
                        loadingMoreData:
                            provider.apiResponse.status == ApiStatus.LOADING,
                        contentBuilder: (context) =>
                            _buildRecordsList(provider: provider),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );

  double initialRating = 0;
  Widget _buildRecordsList(
          {required CustomerGetProductReviewsViewModel provider}) =>
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: provider.list.length,
        itemBuilder: (context, index) {
          final record = provider.list[index];
          return Column(
            children: [
              RecordListTile(
                onTap: () {},
                // imageAddress: record.image.toString(),
                title: record.cleanName.toString(),
                // leading: Text(record.id.toString(), style: dataRowTextStyle(),),
                imageAddress: record.image,
                subtitle: record.completedAt.toString(),
                endWidget: RatingBar.builder(
                  initialRating: initialRating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 20,
                  itemBuilder: (context, _) {
                    /// show static color here
                    return const Icon(
                      Icons.star,
                      color: Colors.grey,
                    );
                  },
                  onRatingUpdate: (rating) async {
                    /// navigate to submit review view
                    await Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => CustomerSubmitReviewView(
                              currentRating: rating,
                              productsAvailableForReview: record,
                            )));
                  },
                ),
              ),
              kSmallSpace,
            ],
          );
        },
      );
}
