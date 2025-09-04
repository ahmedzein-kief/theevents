import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/product_packages_models/product_options_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class TextAreaWidget extends StatelessWidget {
  // New parameter for error handling

  const TextAreaWidget({
    super.key,
    required this.option,
    required this.message,
    required this.onChanged,
    this.errorMessage, // Initialize it
  });

  final ProductOptionsModel option;
  final String? message;
  final Function(String) onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                option.name,
                style: const TextStyle(
                  fontSize: 12.0, // Increase font size
                  fontWeight: FontWeight.bold, // Make text bold
                ),
              ),
            ),
            TextField(
              onChanged: onChanged,
              maxLines: 4, // Set maximum lines to make it multiline
              decoration: InputDecoration(
                hintText: AppStrings.enterYourMessage.tr,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0,),
                // Adjust vertical padding for height
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                  borderSide: const BorderSide(
                    color: Colors.grey, // Outline color
                    width: 1.0, // Outline thickness
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Colors.black, // Outline color when focused
                    width: 2.0, // Outline thickness when focused
                  ),
                ),
                errorText: errorMessage,
                // Display the error message if not null
                errorStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,), // Customize error message style
              ),
            ),
          ],
        ),
      );
}
