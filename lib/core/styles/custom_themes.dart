import 'package:flutter/material.dart';

import '../../vendor/components/checkboxes/custom_checkboxes.dart';

class CustomThemes {
  static CheckboxTheme checkboxTheme(
          {required BuildContext context, required Widget child,}) =>
      CheckboxTheme(
        data: CheckboxThemeData(
          fillColor: checkboxColor(context),
          checkColor: checkColor(context),
          overlayColor: checkboxColor(context),
          side: const BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
            side: const BorderSide(color: Colors.grey, width: 0.1),
          ),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: child,
      );
}
