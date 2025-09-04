import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
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
  State<VendorProfileSettingsView> createState() => _VendorProfileSettingsViewState();
}

class _VendorProfileSettingsViewState extends State<VendorProfileSettingsView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      initialIndex: widget.initialIndex ?? 0,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: widget.initialIndex != null ? VendorCommonAppBar(title: VendorAppStrings.settingsTitle.tr) : null,
        body: Utils.pageRefreshIndicator(
          context: context,
          onRefresh: () async {},
          child: _buildUI(context),
        ),
      );

  Widget _buildUI(context) {
    const double tabHeight = 30;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: kExtraSmallPadding,
        horizontal: kPadding,
      ),
      child: Column(
        children: [
          /// THEME TOGGLE SWITCH
          // const ThemeToggleSwitch(),
          kFormFieldSpace,

          /// TAB BAR
          Container(
            decoration: BoxDecoration(
              // color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(9),
            ),
            child: TabBar(
              controller: _tabController,
              dividerColor: Colors.transparent,
              indicatorColor: theme.colorScheme.onPrimary,
              labelStyle: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: TextStyle(color: theme.colorScheme.onPrimary, fontSize: 13),
              unselectedLabelColor: theme.colorScheme.onPrimary,
              dragStartBehavior: DragStartBehavior.down,
              tabs: [
                Tab(
                  key: const Key('1'),
                  height: tabHeight,
                  child: Text(VendorAppStrings.store.tr),
                ),
                Tab(
                  key: const Key('2'),
                  height: tabHeight,
                  child: Text(VendorAppStrings.taxInfo.tr),
                ),
                Tab(
                  key: const Key('3'),
                  height: tabHeight,
                  child: Text(VendorAppStrings.payoutInfo.tr),
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
