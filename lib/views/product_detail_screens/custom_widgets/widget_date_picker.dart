import 'package:event_app/models/product_packages_models/product_options_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatelessWidget {
  final ProductOptionsModel option;
  final DateTime? selectedDate; // Make it nullable
  final Function(DateTime) onDateSelected;
  final String? errorMessage; // Optional error message for validation

  const DatePickerWidget({
    Key? key,
    required this.option,
    required this.selectedDate,
    required this.onDateSelected,
    this.errorMessage, // Add an optional errorMessage parameter
  }) : super(key: key);

  Future<void> _selectDate(BuildContext context) async {
    var date = DateTime.now().add(const Duration(days: 2));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? date,
      // Use current date if no date is selected
      firstDate: DateTime.now().add(const Duration(days: 2)),
      // Ensure the earliest date is 2 days from now
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.pink, // "Cancel" button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      onDateSelected(picked); // Call the callback with the picked date
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0), // Adding margin to the date picker
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // Padding around the label text
            child: Text(
              option.name,
              style: const TextStyle(
                fontSize: 12.0, // Increase font size
                fontWeight: FontWeight.bold, // Make text bold
              ),
            ),
          ),
          SizedBox(
            width: double.infinity, // Ensure this sized box takes full width
            child: InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 12.0,
                ), // Adding padding inside the date picker
                decoration: BoxDecoration(
                  border: Border.all(
                    color: errorMessage != null ? Colors.red : Colors.grey, // Show red border on error
                    width: 1.0, // Outline thickness
                  ),
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                child: Text(
                  selectedDate == null
                      ? "Select Date" // Placeholder text if no date is selected
                      : "Selected Date: ${DateFormat('dd-MM-yyyy').format(selectedDate!)}",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          if (errorMessage != null) // Show error message if it's not null
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12.0), // Red text for error
              ),
            ),
        ],
      ),
    );
  }
}
