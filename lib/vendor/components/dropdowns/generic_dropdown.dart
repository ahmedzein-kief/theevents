import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/media_query_mixin.dart';
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:flutter/material.dart';

class GenericDropdown<T> extends StatefulWidget {
  final Widget? prefix;
  final Widget? suffix;
  final List<T> menuItemsList;
  final void Function(T? value) onChanged;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  bool? filled;
  Color? textColor;
  String? errorText;
  bool? readOnly;
  dynamic value;
  double? borderRadius;
  String? hintText;
  bool isOutlinedBorder;
  double? borderWidth;
  Color? borderColor;
  String? Function(dynamic)? validator;
  TextStyle? textStyle;
  EdgeInsetsGeometry? contentPadding;
  final String Function(T item) displayItem;

  GenericDropdown({
    super.key,
    this.prefix,
    this.suffix,
    // required this.textDirection,
    required this.menuItemsList, // required this.menuList,
    required this.onChanged,
    this.currentFocusNode,
    this.value,
    this.nextFocusNode,
    this.filled,
    this.textColor,
    this.hintText,
    this.errorText,
    this.isOutlinedBorder = true,
    this.borderRadius,
    this.readOnly,
    this.borderWidth,
    this.borderColor,
    this.validator,
    this.textStyle,
    this.contentPadding,
    required this.displayItem,
  });

  @override
  State<GenericDropdown<T>> createState() => _GenericDropdownState<T>();
}

class _GenericDropdownState<T> extends State<GenericDropdown<T>> with MediaQueryMixin<GenericDropdown<T>> {
  String? selectedValue;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.isOutlinedBorder
        ? InputBordersHub.getOutlinedInputBorder(borderColor: widget.borderColor, borderWidth: widget.borderWidth, borderRadius: widget.borderRadius)
        : InputBordersHub.getUnderlinedInputBorder(borderColor: widget.borderColor, borderWidth: widget.borderWidth, borderRadius: widget.borderRadius);

    return IgnorePointer(
      ignoring: widget.readOnly ?? false,
      child: DropdownButtonFormField2<T>(
        alignment: Alignment.centerLeft,
        isExpanded: true,
        enableFeedback: true,
        isDense: true,
        items: widget.menuItemsList.map((option) {
          return DropdownMenuItem<T>(
            value: option,
            child: Text(widget.displayItem(option)), // Customize display
          );
        }).toList(),
        value: widget.value,
        onChanged: (T? value) {
          setState(() {
            widget.onChanged(value);
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          });
        },
        focusNode: widget.currentFocusNode,
        decoration: InputDecoration(
          errorText: widget.errorText,
          errorMaxLines: 5,
          isDense: true,
          contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          prefixIcon: widget.prefix,
          prefixIconConstraints: const BoxConstraints(
            minWidth: 30,
            minHeight: 0,
          ),
          hintText: widget.hintText,
          hintFadeDuration: const Duration(milliseconds: 500),
          hintStyle: const TextStyle(color: AppColors.softBlueGrey, fontSize: 14, fontWeight: FontWeight.w500),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          focusedErrorBorder: border,
          filled: widget.filled,
          fillColor: Colors.grey.shade200,
        ),

        // cursorColor: AppColors.darkGrey,
        style: widget.textStyle ?? TextStyle(color: widget.textColor ?? AppColors.softBlueGrey, overflow: TextOverflow.ellipsis),
        // padding: EdgeInsets.zero,
        hint: Text(
          widget.hintText ?? 'Select',
          style: widget.textStyle ?? TextStyle(color: widget.textColor ?? AppColors.softBlueGrey, fontSize: 14, fontWeight: FontWeight.w500, overflow: TextOverflow.ellipsis),
          overflow: TextOverflow.ellipsis,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
            color: AppColors.darkGrey,
          ),
          openMenuIcon: Icon(
            Icons.keyboard_arrow_up_sharp,
            color: AppColors.darkGrey,
            // weight: 10000,
          ),
          // iconSize: 20
        ),
        menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 0)),
        dropdownStyleData: DropdownStyleData(
          useSafeArea: true,
          width: null,
          maxHeight: screenHeight / 1.5,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }
}
