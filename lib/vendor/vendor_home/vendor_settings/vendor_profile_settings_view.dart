import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/vendor/components/app_bars/vendor_common_app_bar.dart';
import 'package:event_app/vendor/components/utils/utils.dart';
import 'package:event_app/vendor/vendor_home/vendor_settings/tab_bar_views/payout_info_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_settings/tab_bar_views/store_view.dart';
import 'package:event_app/vendor/vendor_home/vendor_settings/tab_bar_views/tax_info_view.dart';
import 'package:event_app/vendor/view_models/vendor_settings/vendor_get_settings_view_model.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VendorProfileSettingsView extends StatefulWidget {
  VendorProfileSettingsView({super.key, this.initialIndex});
  int? initialIndex;

  @override
  State<VendorProfileSettingsView> createState() =>
      _VendorProfileSettingsViewState();
}

class _VendorProfileSettingsViewState extends State<VendorProfileSettingsView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        initialIndex: widget.initialIndex ?? 0, length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bgColor,
        appBar: widget.initialIndex != null
            ? const VendorCommonAppBar(title: 'Settings')
            : null,
        body: Utils.pageRefreshIndicator(
            onRefresh: () async {}, child: _buildUI(context)),
      );

  Widget _buildUI(context) {
    const double tabHeight = 30;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: kExtraSmallPadding, horizontal: kPadding),
      child: Column(
        children: [
          /// TAB BAR
          Container(
            decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(9)),
            child: TabBar(
              // automaticIndicatorColorAdjustment: false,
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorColor: Colors.black,
              // labelColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              // indicatorPadding: const EdgeInsets.symmetric(horizontal: 0),
              labelStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
              unselectedLabelStyle:
                  const TextStyle(color: Colors.black, fontSize: 13),
              unselectedLabelColor: Colors.black,
              dragStartBehavior: DragStartBehavior.down,
              indicator: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(6)),
              tabs: const [
                Tab(
                  key: Key('1'),
                  height: tabHeight,
                  child: Text('Store'),
                ),
                Tab(
                  key: Key('2'),
                  height: tabHeight,
                  child: Text('Tax Info'),
                ),
                Tab(
                  key: Key('3'),
                  height: tabHeight,
                  child: Text('Payout Info'),
                ),
              ],
            ),
          ),
          kFormFieldSpace,

          /// TAB BAR VIEW
          Expanded(
            child: Consumer<VendorGetSettingsViewModel>(
              builder: (context, provider, _) => TabBarView(
                controller: _tabController,
                children: const [
                  StoreView(),
                  TaxInfoView(),
                  PayoutInfoView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
