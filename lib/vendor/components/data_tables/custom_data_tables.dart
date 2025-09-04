import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/styles/custom_themes.dart';
import 'package:event_app/vendor/components/common_widgets/scrollable_widget.dart';
import 'package:flutter/material.dart';

/// This is scrollable data table created using DataTable
class CustomDataTable extends StatefulWidget {
  const CustomDataTable({
    super.key,
    required this.columns,
    required this.rows,
    this.onSelectAll,
    this.dividerThickness = 0.2,
  });

  final List<DataColumn> columns;
  final List<DataRow> rows;
  final Function(bool?)? onSelectAll;
  final double? dividerThickness;

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable>
    with MediaQueryMixin {
  @override
  Widget build(BuildContext context) => Center(
        child: CustomThemes.checkboxTheme(
          context: context,
          child: ScrollableWidget(
            child: DataTable(
              dividerThickness: widget.dividerThickness,
              onSelectAll: widget.onSelectAll,
              columns: widget.columns,
              headingRowColor: kDataColumnColor,
              dataRowColor: kDataRowColor,
              checkboxHorizontalMargin: 10,
              columnSpacing: 40,
              rows: widget.rows,
            ),
          ),
        ),
      );
}

/// Data Column text style
TextStyle dataColumnTextStyle() => const TextStyle(
    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.mistyGray,);

/// Data Row text style
TextStyle dataRowTextStyle() => const TextStyle(
    fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.slateGrayBlue,);

Widget buildHeaderCell(String value) => Expanded(
      child: Text(
        value,
        style: dataColumnTextStyle(),
        textAlign: TextAlign.center,
      ),
    );

// Data Cell Styling
Widget buildDataCell(Widget data) => Expanded(
      child: data,
    );

/// Data row with style
Widget buildDataRowWithStyle({required Widget child, onRowTap}) =>
    GestureDetector(
      onTap: onRowTap,
      child: Material(
        elevation: 2,
        child: Container(
          decoration: const BoxDecoration(
            border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey, width: 0.1),),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: child,
        ),
      ),
    );

// Helper method to avoid repetitive code for row items
Widget buildRow(String label, String? value,
        {bool isLastRow = false, TextStyle? style, Widget? valueWidget,}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: detailsTitleStyle),
            const SizedBox(width: 8),
            if (valueWidget == null)
              Expanded(
                  child: Text(value ?? '--',
                      style: style ?? detailsDescriptionStyle,),)
            else
              valueWidget,
          ],
        ),
        if (!isLastRow)
          const Divider(
            color: AppColors.stoneGray,
            thickness: 0.3,
          ),
      ],
    );

Widget buildWidgetRow(String label, Widget value) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(label, style: detailsTitleStyle),
            const SizedBox(width: 8),
            Expanded(child: value),
          ],
        ),
        const Divider(
          color: AppColors.stoneGray,
          thickness: 0.3,
        ),
      ],
    );

// Special Row for the status with a button
Widget buildStatusRow(
        {required String label,
        required String buttonText,
        Color? color,
        Color? textColor,}) =>
    Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(label, style: detailsTitleStyle),
        const SizedBox(
          width: 8,
        ),
        showStatusBox(
            statusText: buttonText, color: color, textColor: textColor,),
      ],
    );

/// show status
Widget showStatusBox({Color? textColor, color, required statusText}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        color: color,
      ),
      child: Text(statusText,
          style: detailsTitleStyle.copyWith(color: textColor ?? Colors.white),),
    );

TextStyle detailsTitleStyle = const TextStyle(
    fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black,);
TextStyle detailsDescriptionStyle = const TextStyle(
    fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey,);

Color getStatusButtonColor(String? status) {
  const statusColors = {
    'pending': AppColors.pumpkinOrange,
    'completed': AppColors.success,
    'delivered': AppColors.success,
  };

  return statusColors[status?.toLowerCase().trim()] ?? Colors.transparent;
}
