import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:event_app/core/helper/mixins/media_query_mixin.dart';
import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final Widget? prefix;
  final Widget? suffix;
  final List<DropdownMenuItem<T>> menuItemsList;
  final ValueChanged<T?>? onChanged;
  final FocusNode? currentFocusNode;
  final FocusNode? nextFocusNode;
  final bool filled;
  final Color? textColor;
  final String? errorText;
  final bool readOnly;
  final T? value;
  final double? borderRadius;
  final String? hintText;
  final bool isOutlinedBorder;
  final double? borderWidth;
  final Color? borderColor;
  final String? Function(T?)? validator;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropdown({
    super.key,
    this.prefix,
    this.suffix,
    required this.menuItemsList,
    required this.onChanged,
    this.currentFocusNode,
    this.value,
    this.nextFocusNode,
    this.filled = true,
    this.textColor,
    this.hintText,
    this.errorText,
    this.isOutlinedBorder = true,
    this.borderRadius,
    this.readOnly = false,
    this.borderWidth,
    this.borderColor,
    this.validator,
    this.textStyle,
    this.contentPadding,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> with MediaQueryMixin<CustomDropdown<T>> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final border = widget.isOutlinedBorder
        ? InputBordersHub.getOutlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
          )
        : InputBordersHub.getUnderlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
          );

    return IgnorePointer(
      ignoring: widget.readOnly,
      child: DropdownButtonFormField2<T>(
        alignment: Alignment.centerLeft,
        isExpanded: true,
        enableFeedback: true,
        isDense: true,
        items: widget.menuItemsList,
        value: widget.value,
        onChanged: (value) {
          widget.onChanged?.call(value);
          if (widget.nextFocusNode != null) {
            FocusScope.of(context).requestFocus(widget.nextFocusNode);
          }
        },
        focusNode: widget.currentFocusNode,
        decoration: InputDecoration(
          fillColor: widget.readOnly ? Colors.grey.shade200 : _getAdaptiveFillColor(context),
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
          hintStyle: const TextStyle(
            color: AppColors.softBlueGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          focusedErrorBorder: border,
          filled: widget.filled,
        ),
        style: widget.textStyle ??
            TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              overflow: TextOverflow.ellipsis,
            ),
        hint: Text(
          widget.hintText ?? 'Select',
          style: widget.textStyle ??
              TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
          overflow: TextOverflow.ellipsis,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.keyboard_arrow_down_sharp,
          ),
          openMenuIcon: Icon(
            Icons.keyboard_arrow_up_sharp,
            color: AppColors.darkGrey,
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          useSafeArea: true,
          width: 0.7 * screenWidth,
          maxHeight: screenHeight / 1.5,
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            // color: _getAdaptiveFillColor(context),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        validator: widget.validator,
      ),
    );
  }

  Color _getAdaptiveFillColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? const Color(0xFF3A3A3A) : const Color(0xFFF5F5F5);
  }
}
