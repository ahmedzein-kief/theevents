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
    this.labelText, // Initialize labelText
    this.nextFocusNode,
    this.displayName,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.maxWords,
    this.isEditable = true,
    this.isObscureText = false, // Default to false
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
  final String? labelText; // New labelText field
  final bool isEditable;
  final bool isObscureText; // New isObscureText property
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.labelText != null) // Conditionally show labelText
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  widget.labelText!,
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            TextFormField(
              controller: widget.controller,
              focusNode: widget.focusNode,
              keyboardType: widget.keyboardType,
              style: const TextStyle(color: Colors.black),
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
                // If the form field passes the validation, reset the errorText
                if (widget.formFieldValidator != null) {
                  final error = widget.formFieldValidator!(text);
                  setState(() {
                    errorText =
                        error; // Set error text from validator if any, otherwise null
                  });
                }
                widget.onChanged?.call(text);
              },
              onTap: widget.onTap,
              decoration: InputDecoration(
                hintText:
                    widget.controller.text.isEmpty ? widget.hintText : null,
                hintStyle: const TextStyle(color: Colors.grey),
                suffixIcon: widget.suffixIcon,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey),
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
                filled: true,
                isDense: true,
                errorText: null,
                // Dynamically display error text
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
