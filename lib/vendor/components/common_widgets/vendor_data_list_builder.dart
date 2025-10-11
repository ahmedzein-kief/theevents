import 'package:flutter/material.dart';

import '../../../core/utils/app_utils.dart';

class VendorDataListBuilder extends StatelessWidget {
  const VendorDataListBuilder({
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
  final Widget? onNoDataAvailable;
  final bool loadingMoreData;
  final Widget? onLoadingMoreData;
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
