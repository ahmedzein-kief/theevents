import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:flutter/material.dart';

class CustomRecordListTile extends StatefulWidget {
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

  CustomRecordListTile(
      {super.key,
      required this.onTap,
      this.selectedTileColor = AppColors.lavenderHaze,
      this.selected = false,
      this.imageAddress,
      this.title = '',
      this.subtitle = '',
      this.multiplePrice,
      this.centerWidget = null,
      this.status,
      this.actionCell,
      this.leading,
      this.endWidget = null,
      this.statusTextStyle,
      this.subtitleAsWidget,
      this.tileColor,
      this.titleTextStyle});

  @override
  State<CustomRecordListTile> createState() => _RecordListTileState();
}

class _RecordListTileState extends State<CustomRecordListTile> with MediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(kSmallCardRadius),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kSmallPadding),
          decoration: BoxDecoration(
            color: widget.tileColor ?? Colors.white,
            borderRadius: BorderRadius.circular(kSmallCardRadius),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading Widget (Image or custom widget)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: widget.leading ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kSmallCardRadius),
                      child: Image.network(
                        widget.imageAddress ?? '',
                        width: screenWidth / 4.5, // Maintain width
                        height: 70, // Set a fixed height to match previous code
                        fit: BoxFit.cover,
                        errorBuilder: (error, object, _) {
                          return Icon(
                            Icons.error_outline,
                            color: AppColors.darkGrey,
                          );
                        },
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
                      Text(
                        widget.status ?? '',
                        style: widget.statusTextStyle ?? dataRowTextStyle().copyWith(color: Colors.black),
                        textAlign: TextAlign.end,
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
                    )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
