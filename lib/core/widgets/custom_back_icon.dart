import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the current screen
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // Centers the content in the row
          children: [
            Icon(
              Icons.arrow_back_ios_sharp,
              size: 16,
              color: color ?? Theme.of(context).colorScheme.onPrimary,
            ), // Back icon
            const SizedBox(width: 5),
            Text(
              AppStrings.back.tr,
              style: TextStyle(
                color: color ?? Theme.of(context).colorScheme.onPrimary,
              ),
            ), // Back text
          ],
        ),
      );
}
