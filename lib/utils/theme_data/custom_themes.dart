import 'package:flutter/material.dart';

import '../../vendor/components/checkboxes/custom_checkboxes.dart';

class CustomThemes {
  static checkboxTheme({required Widget child}) => CheckboxTheme(
      data: CheckboxThemeData(
        fillColor: checkboxColor(),
        checkColor: checkColor(),
        overlayColor: checkboxColor(),
        side: BorderSide(
          color: Colors.grey,
          width: 1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
          side: BorderSide(color: Colors.grey, width: 0.1),
        ),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: child);
}
