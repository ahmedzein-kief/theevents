import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration getDecoration() {
    return InputDecoration(
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      errorStyle: TextStyle(color: Colors.red),
      filled: true,
      isDense: true,
    );
  }
}
