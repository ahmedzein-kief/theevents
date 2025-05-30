import 'package:flutter/material.dart';

import '../../Components/utils/utils.dart';

class VendorDataListBuilder extends StatelessWidget {
  final int listLength;
  final ScrollController scrollController;
  Widget? onNoDataAvailable;
  final bool loadingMoreData;
  Widget? onLoadingMoreData;
  final WidgetBuilder contentBuilder;

  VendorDataListBuilder({
    Key? key,
    required this.listLength,
    required this.scrollController,
    this.onNoDataAvailable,
    this.loadingMoreData = false,
    this.onLoadingMoreData,
    required this.contentBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: scrollController,
        children: listLength == 0
            ? [onNoDataAvailable ?? Utils.noDataAvailable()]
            : [
                contentBuilder(context),
                if (loadingMoreData) onLoadingMoreData ?? Utils.spinKitThreeBounce(),
              ],
      ),
    );
  }
}
