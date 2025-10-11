import 'package:event_app/vendor/components/vendor_text_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VendorCustomTextFields extends StatefulWidget {
  const VendorCustomTextFields({
    super.key,
    this.prefixIconColor,
    this.borderSideColor,
    this.suffixIconColor,
    required this.labelText,
    required this.textStar,
    required this.hintText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.suffixWidget,
    this.suffixIcon,
    this.onIconPressed,
    this.borderColor = Colors.grey,
    this.focusNode,
    this.nextFocusNode,
    this.prefixIcon,
    this.prefixText,
    this.prefixContainerColor,
    this.isPrefixFilled = false,
    this.validator,
    this.isEditable = true,
    this.onValueChanged,
  });

  final String labelText;
  final String textStar;
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? suffixWidget;
  final IconData? suffixIcon;
  final VoidCallback? onIconPressed;
  final Color borderColor;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final IconData? prefixIcon;
  final String? prefixText;
  final Color? prefixContainerColor;
  final bool isPrefixFilled;
  final bool isEditable;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final BorderSide? borderSideColor;
  final String? Function(String?)? validator;
  final Function(String?)? onValueChanged;

  @override
  State<VendorCustomTextFields> createState() => _VendorCustomTextFieldsState();
}

class _VendorCustomTextFieldsState extends State<VendorCustomTextFields> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          left: MediaQuery.sizeOf(context).width * 0.02,
          right: MediaQuery.sizeOf(context).width * 0.02,
          top: MediaQuery.sizeOf(context).height * 0.02,
          bottom: MediaQuery.sizeOf(context).height * 0.010,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.sizeOf(context).height * 0.010,
              ),
              child: Row(
                children: [
                  Text(
                    widget.labelText,
                    style: headingFields(),
                  ),
                  Text(
                    widget.textStar,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              readOnly: !widget.isEditable,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              obscureText: widget.obscureText,
              focusNode: widget.focusNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onFieldSubmitted: (_) {
                if (widget.nextFocusNode != null) {
                  FocusScope.of(context).requestFocus(widget.nextFocusNode);
                }
              },
              onChanged: widget.onValueChanged,
              validator: widget.validator,
              // Apply validator
              decoration: InputDecoration(
                errorMaxLines: 2,
                hintText: widget.hintText,
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: (widget.prefixIcon != null || widget.prefixText != null)
                    ? Container(
                        padding: const EdgeInsets.only(left: 10),
                        margin: const EdgeInsets.only(
                          left: 1,
                          top: 1,
                          bottom: 1,
                          right: 8,
                        ),
                        decoration: BoxDecoration(
                          color: widget.isPrefixFilled && widget.prefixContainerColor != null
                              ? widget.prefixContainerColor
                              : Colors.transparent,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(7),
                            topLeft: Radius.circular(7),
                          ),
                          border: Border(
                            right: widget.borderSideColor ?? BorderSide.none,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (widget.prefixText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  widget.prefixText!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            if (widget.prefixIcon != null)
                              Padding(
                                padding: const EdgeInsets.only(right: 4, left: 5),
                                child: IconButton(
                                  icon: Icon(
                                    widget.prefixIcon,
                                    color: widget.prefixIconColor ?? Colors.grey,
                                  ),
                                  onPressed: widget.onIconPressed,
                                ),
                              ),
                            if (widget.prefixIcon != null && widget.prefixText != null)
                              Container(
                                color: Colors.grey,
                                width: 0.5,
                                height: 45,
                              ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: widget.borderColor,
                    width: 0.5,
                  ),
                ),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.5),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 0.8),
                ),
                errorStyle: GoogleFonts.inter(height: 0, color: Colors.red),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                suffixIcon: widget.suffixWidget ??
                    (widget.suffixIcon != null
                        ? IconButton(
                            icon: Icon(
                              widget.suffixIcon,
                              color: widget.suffixIconColor ?? Colors.grey,
                              size: 18,
                            ),
                            onPressed: widget.onIconPressed,
                          )
                        : null),
              ),
            ),
          ],
        ),
      );
}
