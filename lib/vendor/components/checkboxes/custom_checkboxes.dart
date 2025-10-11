import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../Components/vendor_text_style.dart';

WidgetStateProperty<Color?> checkboxColor(BuildContext context) =>
    WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Theme.of(context).colorScheme.primary;
      }
      if (states.contains(WidgetState.hovered)) {
        return Theme.of(context).colorScheme.secondary;
      }
      if (states.contains(WidgetState.disabled)) {
        return Theme.of(context).colorScheme.outline;
      }
      return null;
    });

WidgetStateProperty<Color?> checkColor(BuildContext context) =>
    WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Theme.of(context).colorScheme.onPrimary;
      }
      if (states.contains(WidgetState.hovered)) {
        return Theme.of(context).colorScheme.secondary;
      }
      if (states.contains(WidgetState.disabled)) {
        return Theme.of(context).colorScheme.outline;
      }
      return null;
    });

/// checkbox list tile
class CustomCheckBoxTile extends StatelessWidget {
  const CustomCheckBoxTile({
    super.key,
    required this.isChecked,
    required this.title,
    required this.onChanged,
    this.controlAffinity,
    this.subTitle,
    this.subTitleStyle,
  });

  final bool isChecked;
  final String title;
  final String? subTitle;
  final TextStyle? subTitleStyle;

  final ListTileControlAffinity? controlAffinity;
  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        controlAffinity: controlAffinity ?? ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        fillColor: checkboxColor(context),
        splashRadius: 5,
        tileColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        title: Text(
          title.toString(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        subtitle: subTitle != null ? Text(subTitle ?? '') : null,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        checkColor: Colors.white,
        value: isChecked,
        onChanged: onChanged,
      );
}

/// Simple Check box
class CustomCheckBox extends StatelessWidget {
  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.controlAffinity,
  });

  final bool value;
  final ListTileControlAffinity? controlAffinity;
  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) => Checkbox(
        activeColor: Theme.of(context).colorScheme.onPrimary,
        checkColor: Theme.of(context).colorScheme.primary,
        visualDensity: VisualDensity.compact,
        // fillColor: checkboxColor(context),
        splashRadius: 5,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: const BorderSide(color: Colors.grey, width: 0.1),
        ),
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        value: value,
        onChanged: onChanged,
      );
}

/// square check box
class CustomGFCheckbox extends StatefulWidget {
  const CustomGFCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
    this.textStyle,
    this.type,
    this.focusNode,
  });

  final FocusNode? focusNode;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  final TextStyle? textStyle;
  final GFCheckboxType? type;

  @override
  State<CustomGFCheckbox> createState() => _CustomGFCheckboxState();
}

class _CustomGFCheckboxState extends State<CustomGFCheckbox> {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          // Toggle checkbox when text is tapped
          widget.onChanged(!widget.value);
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GFCheckbox(
              focusNode: widget.focusNode,
              size: 20,
              type: widget.type ?? GFCheckboxType.custom,
              // activeBgColor: AppColors.WHITE,
              // inactiveBorderColor: AppColors.checkBoxBorderColor,
              // activeBorderColor: AppColors.checkBoxBorderColor,
              // activeIcon: Padding(
              //   padding: const EdgeInsets.all(2.0),
              //   child: Container(decoration: BoxDecoration(color: AppColors.SUCCESS,borderRadius: BorderRadius.circular(180)),),
              // ),
              onChanged: widget.onChanged,
              value: widget.value,
              inactiveIcon: null,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.text,
                style: widget.textStyle,
              ),
            ),
          ],
        ),
      );
}

/// Using simple checkbox and title together
class CustomCheckboxWithTitle extends StatelessWidget {
  const CustomCheckboxWithTitle({
    super.key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
    this.titleStyle,
    this.subTitle,
    this.subTitleStyle,
    this.isTitleExpanded = true,
  });

  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String title;
  final TextStyle? titleStyle;
  final String? subTitle;
  final TextStyle? subTitleStyle;
  final bool isTitleExpanded;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged(!isChecked);
      },
      child: Column(
        children: [
          // title with checkbox
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomCheckBox(
                value: isChecked,
                onChanged: onChanged,
              ),
              if (isTitleExpanded)
                Expanded(
                  child: Text(
                    title,
                    style: titleStyle ??
                        const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          // color: Colors.black,
                        ),
                  ),
                )
              else
                Text(
                  title,
                  style: titleStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        // color: Colors.black,
                      ),
                ),
            ],
          ),
          // Subtitle
          if (subTitle != null)
            Row(
              children: [
                if (subTitle != null)
                  const SizedBox(
                    width: 32,
                  ),
                Expanded(
                  child: Text(
                    subTitle ?? '',
                    style: subTitleStyle ?? subtitleTextStyle(context).copyWith(height: 0),
                    textAlign: TextAlign.justify,
                  ),
                ),
                if (subTitle != null)
                  const SizedBox(
                    width: 32,
                  ),
              ],
            ),
        ],
      ),
    );

    // GestureDetector(
    //   onTap: () {
    //     onChanged(!isChecked);
    //   },
    //   child: Row(
    //     children: [
    //       Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         mainAxisSize: MainAxisSize.max,
    //         children: [
    //           CustomCheckBox(
    //             value: isChecked,
    //             onChanged: onChanged,
    //           ),
    //           const SizedBox(),
    //         ],
    //       ),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           mainAxisAlignment: MainAxisAlignment.end,
    //           children: [
    //             // if(subTitle != null) kMediumSpace,
    //             Text(
    //               title,
    //               style: titleStyle ??
    //                   const TextStyle(
    //                     fontSize: 16,
    //                     fontWeight: FontWeight.w400,
    //                     color: Colors.black,
    //                   ),
    //             ),
    //             if (subTitle != null)
    //               Row(
    //                 children: [
    //                   Expanded(
    //                     child: Text(
    //                       subTitle ?? '',
    //                       style: subTitleStyle ?? subtitleTextStyle(titleStyle).copyWith(height: 0),
    //                       textAlign: TextAlign.justify,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
