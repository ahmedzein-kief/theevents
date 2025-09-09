import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';

class VendorDataListBuilder extends StatelessWidget {
  VendorDataListBuilder({
    super.key,
    required this.listLength,
    required this.scrollController,
    this.onNoDataAvailable,
    this.loadingMoreData = false,
    this.onLoadingMoreData,
    required this.contentBuilder,
  });

  final int listLength;
  final ScrollController scrollController;
  Widget? onNoDataAvailable;
  final bool loadingMoreData;
  Widget? onLoadingMoreData;
  final WidgetBuilder contentBuilder;

  @override
  Widget build(BuildContext context) => Expanded(
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          controller: scrollController,
          children: listLength == 0
              ? [onNoDataAvailable ?? AppUtils.noDataAvailable()]
              : [
                  contentBuilder(context),
                  if (loadingMoreData) onLoadingMoreData ?? AppUtils.spinKitThreeBounce(),
                ],
        ),
      );
}
