import 'package:flutter/material.dart';

class InputBordersHub {
  /// outlined input border
  static InputBorder getOutlinedInputBorder(
          {Color? borderColor, double? borderRadius, double? borderWidth,}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        borderSide: BorderSide(
          color: borderColor ?? Colors.grey,
          width: borderWidth ?? 0.5,
        ),
      );

  /// Underlined input border
  static InputBorder getUnderlinedInputBorder(
          {Color? borderColor, double? borderRadius, double? borderWidth,}) =>
      UnderlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadius ?? 8.0),
        borderSide: BorderSide(
          color: borderColor ?? Colors.grey,
          width: borderWidth ?? 0.5,
        ),
      );
}
