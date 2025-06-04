import 'package:flutter/material.dart';

import '../constants/app_strings.dart';

class BackIcon extends StatelessWidget {
  const BackIcon({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the current screen
        },
        child: Container(
          width: double.infinity, // Makes the button take the full width
          padding: const EdgeInsets.all(8), // Padding around the icon and text
          child: const Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Centers the content in the row
            children: [
              Icon(Icons.arrow_back_ios_sharp, size: 16), // Back icon
              SizedBox(width: 5),
              Text(AppStrings.back), // Back text
            ],
          ),
        ),
      );
}
