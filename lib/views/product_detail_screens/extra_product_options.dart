import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/models/product_packages_models/product_options_model.dart';
import 'package:event_app/views/product_detail_screens/custom_widgets/widget_date_picker.dart';
import 'package:flutter/material.dart';

import 'custom_widgets/widget_drop_down.dart';
import 'custom_widgets/widget_text_area.dart';

class ExtraProductOptions extends StatefulWidget {
  const ExtraProductOptions({
    super.key,
    required this.options,
    required this.screenWidth,
    required this.onSelectedOptions,
    required this.extraOptionsError,
    required this.selectedOptions,
  });

  final void Function(Map<String, dynamic> selectedOptions) onSelectedOptions;
  final List<ProductOptionsModel> options;
  final List<Map<String, dynamic>> extraOptionsError;
  final Map<String, dynamic> selectedOptions;
  final double screenWidth;

  @override
  State<ExtraProductOptions> createState() => _ExtraProductOptionsState();
}

class _ExtraProductOptionsState extends State<ExtraProductOptions> {
  String? selectedLocation = '';
  String? messageOnCake = '';
  DateTime? selectedDate;

  void updateOptions() {
    final Map<String, dynamic> options = {};

    final String datePickerOptionId = getOptionId('datepicker');
    if (datePickerOptionId.isNotEmpty) {
      options[datePickerOptionId] = {
        'option_type': 'datepicker',
        'values': selectedDate.toString().split(' ')[0],
      };
    }

    final String locationOptionId = getOptionId('location');
    if (locationOptionId.isNotEmpty) {
      options[locationOptionId] = {
        'option_type': 'location',
        'values': selectedLocation,
      };
    }

    final String textAreaOptionId = getOptionId('textarea');
    if (textAreaOptionId.isNotEmpty) {
      options[textAreaOptionId] = {
        'option_type': 'textarea',
        'values': messageOnCake,
      };
    }
    widget.onSelectedOptions(options); // Ensure this is called correctly
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    for (final option in widget.options) {
      final hasMatch = widget.extraOptionsError.any(
        (errorData) => errorData['option_id'] == option.id,
      );

      if (hasMatch) {
        final errorData = widget.extraOptionsError.firstWhere(
          (errorData) => errorData['option_id'] == option.id,
        );
        final errorValue = errorData['error'];

        option.isError = errorValue;
      }
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: widget.screenWidth * 0.06,
          vertical: widget.screenWidth * 0.06,
        ),
        child: Column(
          children: widget.options.map((option) {
            switch (option.optionType) {
              case 'location':
                return DropdownWidget(
                  option: option,
                  selectedValue: selectedLocation,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedLocation = newValue;
                      updateOptions();
                    });
                  },
                  errorMessage:
                      (selectedLocation?.isEmpty == true) && option.isError ? AppStrings.pleaseSelectLocation.tr : null,
                );
              case 'datepicker':
                return DatePickerWidget(
                  option: option,
                  selectedDate: selectedDate,
                  onDateSelected: (DateTime date) {
                    setState(() {
                      selectedDate = date;
                      updateOptions();
                    });
                  },
                  errorMessage: selectedDate == null && option.isError ? AppStrings.pleaseSelectValidDate.tr : null,
                );
              case 'textarea':
                return TextAreaWidget(
                  option: option,
                  message: messageOnCake,
                  onChanged: (String text) {
                    setState(() {
                      messageOnCake = text;
                      updateOptions();
                    });
                  },
                  errorMessage: option.isError ? AppStrings.messageCanNotBeEmpty.tr : null,
                );
              default:
                return const SizedBox.shrink();
            }
          }).toList(),
        ),
      ),
    );
  }

  String getOptionId(String option) {
    for (final data in widget.options) {
      if (data.optionType.toLowerCase() == option.toLowerCase()) {
        return data.id.toString();
      }
    }
    return ''; // Return an empty string if no match found
  }
}
