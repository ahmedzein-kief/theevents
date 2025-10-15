import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:flutter/material.dart';

class CustomRecordListTile extends StatefulWidget {
  const CustomRecordListTile({
    super.key,
    required this.onTap,
    this.selectedTileColor = AppColors.lavenderHaze,
    this.selected = false,
    this.imageAddress,
    this.title = '',
    this.subtitle = '',
    this.multiplePrice,
    this.centerWidget,
    this.status,
    this.actionCell,
    this.leading,
    this.endWidget,
    this.statusTextStyle,
    this.subtitleAsWidget,
    this.tileColor,
    this.titleTextStyle,
    this.productId, // Add productId for API call
    this.onRejectionHistoryTap, // Callback for handling rejection history
  });

  final void Function() onTap;
  final Color selectedTileColor;
  final bool selected;
  final String? imageAddress;
  final String title;
  final String subtitle;
  final Widget? subtitleAsWidget;
  final String? status;
  final Widget? multiplePrice;
  final Widget? centerWidget;
  final Widget? actionCell;
  final Widget? leading;
  final Widget? endWidget;
  final TextStyle? statusTextStyle;
  final Color? tileColor;
  final TextStyle? titleTextStyle;
  final int? productId; // Product ID for API call
  final void Function(String productId)? onRejectionHistoryTap; // Callback

  @override
  State<CustomRecordListTile> createState() => _CustomRecordListTileState();
}

class _CustomRecordListTileState extends State<CustomRecordListTile> with MediaQueryMixin {
  bool get isRejected => widget.status?.toLowerCase() == 'rejected';

  void _handleRejectionTap() {
    if (widget.productId != null && widget.onRejectionHistoryTap != null) {
      widget.onRejectionHistoryTap!(widget.productId.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(kSmallCardRadius),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: kPadding,
              vertical: kSmallPadding,
            ),
            decoration: BoxDecoration(
              color: widget.tileColor ?? Colors.white,
              borderRadius: BorderRadius.circular(kSmallCardRadius),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Leading Widget (Image or custom widget)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: widget.leading ??
                      ClipRRect(
                        borderRadius: BorderRadius.circular(kSmallCardRadius),
                        child: Image.network(
                          widget.imageAddress ?? '',
                          width: screenWidth / 4.5, // Maintain width
                          height: 70, // Set a fixed height to match previous code
                          fit: BoxFit.cover,
                          errorBuilder: (error, object, _) => const Icon(
                            Icons.error_outline,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ),
                ),

                // Title and Subtitle Section
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: widget.titleTextStyle ?? dataRowTextStyle().copyWith(fontSize: 15),
                      ),
                      kExtraSmallSpace,
                      widget.subtitleAsWidget ??
                          Text(
                            widget.subtitle,
                            style: dataColumnTextStyle(),
                          ),
                      kExtraSmallSpace,
                      if (widget.status != null)
                        Row(
                          children: [
                            if (isRejected)
                              const Icon(
                                Icons.warning,
                                color: AppColors.vividRed,
                                size: 16,
                              ),
                            if (isRejected) const SizedBox(width: 4),
                            GestureDetector(
                              onTap: isRejected ? _handleRejectionTap : null,
                              child: Text(
                                widget.status ?? '',
                                style: widget.statusTextStyle ??
                                    dataRowTextStyle().copyWith(
                                      color: isRejected ? AppColors.vividRed : Colors.black,
                                      decoration: isRejected ? TextDecoration.underline : null,
                                    ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                if (widget.centerWidget != null)
                  Expanded(
                    child: widget.centerWidget!,
                  ),

                // Content in the End (multiplePrice, status, actionCell)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (widget.endWidget != null)
                        widget.endWidget!
                      else
                        Column(
                          crossAxisAlignment: widget.status == '0' ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                          children: [
                            if (widget.multiplePrice != null) widget.multiplePrice!,
                            if (widget.actionCell != null)
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  kExtraSmallSpace,
                                  widget.actionCell ?? kShowVoid,
                                ],
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
