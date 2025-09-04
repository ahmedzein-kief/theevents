import 'package:event_app/core/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFieldProfileScreen extends StatefulWidget {
  const CustomFieldProfileScreen({
    super.key,
    required this.hintText,
    required this.controller,
    this.suffixIcon,
    required this.focusNode,
    this.labelText,
    this.nextFocusNode,
    this.displayName,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxWords,
    this.isEditable = true,
    this.isObscureText = false,
    this.onTap,
    this.formFieldValidator,
    this.textInputFormatters,
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
  final String? labelText;
  final bool isEditable;
  final bool isObscureText;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? formFieldValidator;
  final List<TextInputFormatter>? textInputFormatters;

  @override
  State<CustomFieldProfileScreen> createState() =>
      _CustomFieldProfileScreenState();
}

class _CustomFieldProfileScreenState extends State<CustomFieldProfileScreen> {
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.labelText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Text(
                widget.labelText!,
                style: GoogleFonts.inter(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            keyboardType: widget.keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
            ),
            readOnly: !widget.isEditable,
            obscureText: widget.isObscureText,
            inputFormatters: widget.textInputFormatters,
            validator: widget.formFieldValidator,
            textInputAction: widget.nextFocusNode != null
                ? TextInputAction.next
                : TextInputAction.done,
            onFieldSubmitted: (_) {
              if (widget.nextFocusNode != null) {
                FocusScope.of(context).requestFocus(widget.nextFocusNode);
              }
            },
            onChanged: (text) {
              if (widget.maxWords != null) {
                final words = text.trim().split(RegExp(r'\s+'));
                if (words.length > widget.maxWords!) {
                  widget.controller.text =
                      words.take(widget.maxWords!).join(' ');
                  widget.controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: widget.controller.text.length),
                  );
                }
              }
              if (widget.formFieldValidator != null) {
                final error = widget.formFieldValidator!(text);
                setState(() {
                  errorText = error;
                });
              }
              widget.onChanged?.call(text);
            },
            onTap: widget.onTap,
            decoration: InputDecoration(
              hintText: widget.controller.text.isEmpty ? widget.hintText : null,
              hintStyle: TextStyle(
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
              suffixIcon: widget.suffixIcon,
              filled: true,
              fillColor: isDark ? Colors.grey[900] : Colors.white,
              isDense: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.peachyPink),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.red),
              ),
              errorText: null,
              errorStyle: GoogleFonts.inter(
                color: Colors.red,
              ),
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
