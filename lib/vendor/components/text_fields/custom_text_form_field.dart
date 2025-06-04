import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/core/utils/vendor_utils.dart'
    show DecimalInputFormatter;
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField({
    super.key,
    this.prefixIconColor,
    this.borderSideColor,
    this.suffixIconColor,
    required this.labelText,
    required this.required,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixIcon,
    this.onIconPressed,
    this.borderColor = Colors.grey,
    this.focusNode,
    this.nextFocusNode,
    this.prefixIcon,
    this.prefixText,
    this.prefixContainerColor,
    this.isPrefixFilled = false, // Default to not filled
    this.validator,
    this.onChanged,
    this.maxLength,
    this.maxLines,
    this.suffix,
    this.hintStyle,
    this.contentPadding,
    this.showTitle = true,
    this.labelTextStyle,
    this.borderWidth,
    this.borderRadius,
    this.prefix,
    this.isOutlinedBorder = true,
    this.filled,
    this.fillColor,
    this.height,
    this.width,
    this.readOnly = false,
    this.onTap,
    this.isExpanded = false,
    this.textStyle,
    this.errorText,
  });
  final String labelText;
  final bool required;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onIconPressed;
  final Color borderColor;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final IconData? prefixIcon;
  final String? prefixText;
  final Color? prefixContainerColor;
  final bool isPrefixFilled;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final BorderSide? borderSideColor;
  dynamic validator;
  dynamic onChanged;
  int? maxLength;
  int? maxLines;
  Widget? suffix;
  bool showTitle;
  TextStyle? hintStyle;
  TextStyle? labelTextStyle;
  EdgeInsetsGeometry? contentPadding;
  double? borderRadius;
  double? borderWidth;
  Widget? prefix;
  bool isOutlinedBorder;
  bool? filled;
  Color? fillColor;
  double? height;
  double? width;
  final bool? readOnly;
  final dynamic onTap;
  final bool isExpanded;
  final TextStyle? textStyle;
  String? errorText;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    // creating border for text field
    final border = widget.isOutlinedBorder
        ? InputBordersHub.getOutlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius)
        : InputBordersHub.getUnderlinedInputBorder(
            borderColor: widget.borderColor,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showTitle)
          Padding(
            padding: EdgeInsets.only(
              bottom: kTinyPadding,
            ),
            child:
                fieldTitle(text: widget.labelText, required: widget.required),
          )
        else
          kShowVoid,
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: widget.controller,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,
            focusNode: widget.focusNode,
            maxLines: widget.isExpanded ? null : widget.maxLines,
            expands: widget.isExpanded,
            readOnly: widget.readOnly ?? false,
            onTap: widget.onTap,
            style: widget.textStyle,

            /// If field is required then only validate the field
            validator: (value) {
              if (widget.required ||
                  (value != null && value.isNotEmpty == true)) {
                return widget.validator?.call(value);
              }
              return null;
            },
            maxLength: widget.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: widget.onChanged,
            onFieldSubmitted: (_) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
            },
            inputFormatters: widget.keyboardType ==
                    const TextInputType.numberWithOptions(decimal: true)
                ? [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d+\.?\d{0,2}'),
                    ),
                    DecimalInputFormatter(),
                  ]
                : null,
            decoration: InputDecoration(
              errorText: widget.errorText,
              errorMaxLines: 100,
              hintText: widget.hintText,
              suffixIcon: widget.suffix,
              hintStyle: widget.hintStyle ??
                  const TextStyle(color: Colors.grey, fontSize: 12),
              prefixIcon: widget.prefix,
              border: border,
              focusedBorder: border,
              enabledBorder: border,
              contentPadding: widget.contentPadding ??
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              isCollapsed: false,
              isDense: false,
              filled: widget.filled ?? true,
              fillColor: widget.fillColor ??
                  (widget.readOnly ?? false
                      ? Colors.grey.shade200
                      : Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

/// field label
Widget fieldTitle(
        {required String text, TextStyle? textStyle, bool? required}) =>
    Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(text,
            style: textStyle ??
                headingFields()
                    .copyWith(fontSize: 13, fontWeight: FontWeight.w400)),
        Text(
          required ?? false ? '*' : '',
          style: headingFields().copyWith(
              fontSize: 13, fontWeight: FontWeight.w400, color: Colors.red),
        ),
      ],
    );
