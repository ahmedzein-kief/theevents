import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/product_packages_models/product_options_model.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class DropdownWidget extends StatelessWidget {
  // Optional error message

  const DropdownWidget({
    super.key,
    required this.option,
    required this.selectedValue,
    required this.onChanged,
    this.errorMessage, // Add optional errorMessage parameter
  });

  final ProductOptionsModel option;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final dropdownValues = option.values.map((e) => e.optionValue).toList();

    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: errorMessage != null
                    ? Colors.red
                    : Colors.grey, // Red border on error
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButton<String>(
              value:
                  dropdownValues.contains(selectedValue) ? selectedValue : null,
              hint: Text(AppStrings.selectLocation.tr),
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: option.values
                  .map(
                    (value) => DropdownMenuItem<String>(
                      value: value.optionValue,
                      child: Text(value.optionValue),
                    ),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
          if (errorMessage != null) // Display error message if it exists
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12.0),
              ),
            ),
        ],
      ),
    );
  }
}
