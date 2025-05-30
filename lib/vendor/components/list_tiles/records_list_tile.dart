import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:flutter/material.dart';

class RecordListTile extends StatefulWidget {
  final void Function() onTap;
  final Color selectedTileColor;
  final bool selected;
  final String? imageAddress;
  final String title;
  final String subtitle;
  final Widget? subtitleAsWidget;
  final String? status;
  final Widget? actionCell;
  final Widget? leading;
  final Widget? endWidget;
  final TextStyle? statusTextStyle;
  final Color? tileColor;
  final TextStyle? titleTextStyle;

  RecordListTile(
      {super.key,
      required this.onTap,
      this.selectedTileColor = AppColors.lavenderHaze,
      this.selected = false,
      this.imageAddress,
      this.title = '',
      this.subtitle = '',
      this.status,
      this.actionCell,
      this.leading,
      this.endWidget = null,
      this.statusTextStyle,
      this.subtitleAsWidget,
      this.tileColor,
      this.titleTextStyle});

  @override
  State<RecordListTile> createState() => _RecordListTileState();
}

class _RecordListTileState extends State<RecordListTile> with MediaQueryMixin {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(kSmallCardRadius),
        child: ListTile(
          tileColor: widget.tileColor ?? Colors.white,
          selected: widget.selected,
          selectedTileColor: widget.selectedTileColor,
          selectedColor: Colors.black,
          titleAlignment: ListTileTitleAlignment.center,
          isThreeLine: false,
          dense: false,
          // minTileHeight: 60,
          contentPadding: EdgeInsets.symmetric(horizontal: kPadding, vertical: kSmallPadding),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kSmallCardRadius)),
          leading: widget.leading ??
              ClipRRect(
                  borderRadius: BorderRadius.circular(kSmallCardRadius),
                  child: Image.network(
                    widget.imageAddress ?? '',
                    width: screenWidth / 6.5,
                    errorBuilder: (error, object, _) {
                      return Icon(
                        Icons.error_outline,
                        color: AppColors.darkGrey,
                      );
                    },
                  )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: widget.titleTextStyle ?? dataRowTextStyle().copyWith(fontSize: 15),
              ),
              kExtraSmallSpace,
              widget.subtitleAsWidget ??
                  Text(
                    widget.subtitle, style: dataColumnTextStyle(),
                    // overflow: TextOverflow.ellipsis,
                  )
            ],
          ),
          // subtitle: Text("Test Product",style: dataColumnTextStyle(),),
          trailing: widget.endWidget != null
              ? widget.endWidget
              : Column(
                  /// Handling dynamically because if status is 0 then it not visible in center and looks dirty therefor if value is larger then 0 than show in end its fine.
                  crossAxisAlignment: widget.status == '0' ? CrossAxisAlignment.center : CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.status != null)
                      Text(
                        widget.status ?? '',
                        style: widget.statusTextStyle ?? dataRowTextStyle().copyWith(color: Colors.black),
                        textAlign: TextAlign.end,
                      ),
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
        ),
      ),
    );
  }
}
