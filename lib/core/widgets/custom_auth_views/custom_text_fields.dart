import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFields extends StatelessWidget {
  final TextEditingController? textEditingController;
  final FormFieldValidator<String>? formFieldValidator;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final TextInputType? inputType;
  final bool isObsecureText;
  final Widget? rightIcon;
  final Widget? leftIcon;
  final TextStyle? hintStyle;

  CustomTextFields(
      {this.hintText,
      this.rightIcon,
      this.leftIcon,
      this.textEditingController,
      this.textCapitalization = TextCapitalization.none,
      this.suffixIcon,
      this.isObsecureText = false,
      this.inputType,
      this.formFieldValidator,
      this.onChanged,
      this.hintStyle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: textEditingController,
              keyboardType: inputType,
              obscureText: isObsecureText,
              onChanged: onChanged,
              validator: formFieldValidator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                suffixIcon: suffixIcon,
                prefixIcon: leftIcon,
                prefixIconConstraints: BoxConstraints(
                  minWidth: 45,
                  maxWidth: 50,
                ),
                hintText: hintText,
                hintStyle: hintStyle,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 0.8),
                ),
                errorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 0.5),
                ),
                focusedErrorBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 0.8),
                ),
                errorStyle: GoogleFonts.inter(height: 0, color: Colors.red),
                errorMaxLines: 2,
              ),
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
