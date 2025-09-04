import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../styles/app_colors.dart';

class CustomFieldSaveAddress extends StatefulWidget {
  const CustomFieldSaveAddress({
    super.key,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    this.labelText,
    required this.focusNode,
    this.nextFocusNode,
    this.displayName,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxWords,
    this.isEditable = true,
    this.onTap,
    this.formFieldValidator,
  });

  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final Widget? suffixIcon;
  final String? displayName;
  final ValueChanged<String>? onChanged;
  final TextInputType keyboardType;
  final int? maxWords;
  final bool isEditable;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? formFieldValidator;
  final String? labelText;

  @override
  _CustomFieldSaveAddressState createState() => _CustomFieldSaveAddressState();
}

class _CustomFieldSaveAddressState extends State<CustomFieldSaveAddress> {
  @override
  void initState() {
    super.initState();
    if (widget.displayName != null && widget.controller.text.isEmpty) {
      widget.controller.text = widget.displayName!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            readOnly: !widget.isEditable,
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (_) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode!);
              }
            },
            onChanged: (text) {
              final words = text.trim().split(RegExp(r'\s+'));
              if (widget.maxWords != null && words.length > widget.maxWords!) {
                widget.controller.text = words.take(widget.maxWords!).join(' ');
                widget.controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: widget.controller.text.length),
                );
              }
              widget.onChanged?.call(widget.controller.text);
            },
            onTap: widget.onTap,
            validator: widget.formFieldValidator,
            decoration: InputDecoration(
              hintText: widget.controller.text.isEmpty ? widget.hintText : null,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: isDark ? Colors.grey[900] : Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey,
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.peachyPink),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
              errorStyle: GoogleFonts.inter(
                height: 0,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
