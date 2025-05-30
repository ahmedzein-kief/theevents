import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

import '../../../core/styles/app_colors.dart';
import '../../Components/vendor_text_style.dart';

WidgetStateProperty<Color?> checkboxColor() {
  return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return AppColors.lightCoral; // Color when the checkbox is selected
    }
    if (states.contains(WidgetState.hovered)) {
      return Colors.blue; // Color when the checkbox is hovered
    }
    if (states.contains(WidgetState.disabled)) {
      return Colors.grey; // Color when the checkbox is disabled
    }
    return null; // Default color
  });
}

WidgetStateProperty<Color?> checkColor() {
  return WidgetStateProperty.resolveWith((Set<WidgetState> states) {
    if (states.contains(WidgetState.selected)) {
      return Colors.white; // Color when the checkbox is selected
    }
    if (states.contains(WidgetState.hovered)) {
      return Colors.blue; // Color when the checkbox is hovered
    }
    if (states.contains(WidgetState.disabled)) {
      return Colors.grey; // Color when the checkbox is disabled
    }
    return null; // Default color
  });
}

/// checkbox list tile
class CustomCheckBoxTile extends StatelessWidget {
  bool isChecked;
  String title;
  String? subTitle;
  TextStyle? subTitleStyle;

  ListTileControlAffinity? controlAffinity;
  void Function(bool? value) onChanged;

  CustomCheckBoxTile({
    super.key,
    required this.isChecked,
    required this.title,
    required this.onChanged,
    this.controlAffinity,
    this.subTitle,
    this.subTitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        controlAffinity: controlAffinity ?? ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.zero,
        dense: true,
        visualDensity: VisualDensity.compact,
        fillColor: checkboxColor(),
        splashRadius: 5,
        tileColor: Colors.white,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        title: Text(
          title.toString(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        subtitle: subTitle != null ? Text(subTitle ?? '') : null,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey, width: 1),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey, width: 1),
        ),
        checkColor: Colors.white,
        value: isChecked,
        onChanged: onChanged);
  }
}

/// Simple Check box
class CustomCheckBox extends StatelessWidget {
  bool value;
  ListTileControlAffinity? controlAffinity;
  void Function(bool? value) onChanged;

  CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.controlAffinity,
  });

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        visualDensity: VisualDensity.compact,
        fillColor: checkboxColor(),
        splashRadius: 5,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        checkColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey, width: 0.1),
        ),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        value: value,
        onChanged: onChanged);
  }
}

/// square check box
class CustomGFCheckbox extends StatefulWidget {
  FocusNode? focusNode;
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;
  TextStyle? textStyle;
  GFCheckboxType? type;

  CustomGFCheckbox({required this.value, required this.onChanged, required this.text, this.textStyle, this.type, this.focusNode});

  @override
  _CustomGFCheckboxState createState() => _CustomGFCheckboxState();
}

class _CustomGFCheckboxState extends State<CustomGFCheckbox> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
}

/// Using simple checkbox and title together
class CustomCheckboxWithTitle extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;
  final String title;
  final TextStyle? titleStyle;
  String? subTitle;
  TextStyle? subTitleStyle;
  bool isTitleExpanded;

  CustomCheckboxWithTitle({
    Key? key,
    required this.isChecked,
    required this.onChanged,
    required this.title,
    this.titleStyle,
    this.subTitle,
    this.subTitleStyle,
    this.isTitleExpanded = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          onChanged(!(isChecked));
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
                isTitleExpanded
                    ? Expanded(
                        child: Text(title,
                            style: titleStyle ??
                                const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                )))
                    : Text(title,
                        style: titleStyle ??
                            const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ))
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
                      style: subTitleStyle ?? subtitleTextStyle(titleStyle).copyWith(height: 0),
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
        ));

    GestureDetector(
      onTap: () {
        onChanged(!(isChecked));
      },
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              CustomCheckBox(
                value: isChecked,
                onChanged: onChanged,
              ),
              const SizedBox(),
            ],
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if(subTitle != null) kMediumSpace,
                Text(
                  title,
                  style: titleStyle ??
                      const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                ),
                if (subTitle != null)
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          subTitle ?? '',
                          style: subTitleStyle ?? subtitleTextStyle(titleStyle).copyWith(height: 0),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
