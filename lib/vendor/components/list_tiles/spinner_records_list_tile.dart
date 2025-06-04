import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:flutter/material.dart';

class SpinnerRecordListTile extends StatefulWidget {
  const SpinnerRecordListTile({
    super.key,
    required this.onTap,
    this.selectedTileColor = AppColors.lavenderHaze,
    this.selected = false,
    this.imageAddress,
    this.title = '',
    this.subtitle = '',
    this.status,
    this.leading,
    this.endWidget,
    this.bottomWidget,
    this.statusTextStyle,
    this.subtitleAsWidget,
    this.tileColor,
    this.titleTextStyle,
  });
  final void Function() onTap;
  final Color selectedTileColor;
  final bool selected;
  final String? imageAddress;
  final String title;
  final String subtitle;
  final Widget? subtitleAsWidget;
  final String? status;
  final Widget? leading;
  final Widget? endWidget;
  final Widget? bottomWidget;
  final TextStyle? statusTextStyle;
  final Color? tileColor;
  final TextStyle? titleTextStyle;

  @override
  State<SpinnerRecordListTile> createState() => _SpinnerRecordListTileState();
}

class _SpinnerRecordListTileState extends State<SpinnerRecordListTile>
    with MediaQueryMixin {
  @override
  Widget build(BuildContext context) => Card(
        elevation: 1,
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(kSmallCardRadius),
          child: Column(
            children: [
              ListTile(
                tileColor: widget.tileColor ?? Colors.white,
                selected: widget.selected,
                selectedTileColor: widget.selectedTileColor,
                selectedColor: Colors.black,
                titleAlignment: ListTileTitleAlignment.center,
                isThreeLine: false,
                dense: false,
                // minTileHeight: 60,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: kPadding, vertical: kSmallPadding),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kSmallCardRadius)),
                leading: widget.leading ??
                    ClipRRect(
                      borderRadius: BorderRadius.circular(kSmallCardRadius),
                      child: Image.network(
                        widget.imageAddress ?? '',
                        width: screenWidth / 6.5,
                        errorBuilder: (error, object, _) => const Icon(
                          Icons.error_outline,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: widget.titleTextStyle ??
                          dataRowTextStyle().copyWith(fontSize: 15),
                    ),
                    kExtraSmallSpace,
                    widget.subtitleAsWidget ??
                        Text(
                          widget.subtitle, style: dataColumnTextStyle(),
                          // overflow: TextOverflow.ellipsis,
                        ),
                  ],
                ),
                // subtitle: Text("Test Product",style: dataColumnTextStyle(),),
                trailing: widget.endWidget,
              ),
              if (widget.bottomWidget != null) widget.bottomWidget!,
            ],
          ),
        ),
      );
}
