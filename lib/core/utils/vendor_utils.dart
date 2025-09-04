import 'package:flutter/services.dart';

class DecimalInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue,) {
    final String text = newValue.text;

    // Ensure only one decimal point is allowed
    if (text.contains('.') && text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue; // Reject input if multiple dots are found
    }

    // Prevent entering "." at the 10th position
    if (text.endsWith('.') && text.length == 10) {
      return oldValue; // Reject the input
    }

    return newValue;
  }
}

String formatDecimal(String value) {
  if (value.isEmpty) {
    return '0';
  }
  if (value.endsWith('.')) {
    return value.substring(0, value.length - 1); // Remove dot
  }
  return value;
}
