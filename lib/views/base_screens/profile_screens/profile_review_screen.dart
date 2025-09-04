import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/provider/customer/account_view_models/reviews/customer_get_product_reviews_view_model.dart';
import 'package:event_app/views/base_screens/profile_screens/reviews/customer_reviewed_view.dart';
import 'package:event_app/views/base_screens/profile_screens/reviews/customer_waiting_for_review_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_profile_views/custom_back_appbar_view.dart';

class ProfileReviewScreen extends StatefulWidget {
  const ProfileReviewScreen({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  State<ProfileReviewScreen> createState() => _ProfileReviewScreenState();
}

class _ProfileReviewScreenState extends State<ProfileReviewScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      initialIndex: widget.initialTabIndex,
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((callback) async {
      context.read<CustomerGetProductReviewsViewModel>().clearList();
      context.read<CustomerGetProductReviewsViewModel>().customerGetProductReviews();
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BackAppBarStyle(
              icon: Icons.arrow_back_ios,
              text: AppStrings.myAccount.tr,
            ),
            Padding(
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.04,
                right: screenWidth * 0.04,
              ),
              child: ClipRRect(
                // borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: 45,
                  // margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(9)),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Color(0xff787880).withAlpha(((1 - 0.12) * 255).toInt()) // opposite alpha
                        : Color(0xff787880).withAlpha((0.12 * 255).toInt()), // normal alpha
                  ),
                  child: Consumer<CustomerGetProductReviewsViewModel>(
                    builder: (context, provider, _) => TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent,
                      indicatorColor: theme.colorScheme.onSurface,
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: TextStyle(color: theme.colorScheme.onSurface, fontSize: 13),
                      unselectedLabelColor: theme.colorScheme.onSurface,
                      tabs: [
                        WaitingForReviewTab(
                          key: const Key('1'),
                          count: provider.apiResponse.data?.data?.products?.length.toString() ?? '0',
                        ),
                        ReviewedTab(
                          key: const Key('2'),
                          count: provider.apiResponse.data?.data?.reviews?.pagination?.total.toString() ?? '0',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CustomerWaitingForReviewsView(),
                  CustomerReviewedView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingForReviewTab extends StatelessWidget {
  WaitingForReviewTab({super.key, this.count});

  String? count;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '${AppStrings.waitingForReview.tr} ${count != null ? "($count)" : ''}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
}

class ReviewedTab extends StatelessWidget {
  ReviewedTab({super.key, this.count});

  String? count;

  @override
  Widget build(BuildContext context) => Tab(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${AppStrings.reviewed.tr} ${count != null ? "($count)" : ''}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
