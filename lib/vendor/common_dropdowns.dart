import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/styles/app_colors.dart';

Future<String?> showGenderDropdown(BuildContext context, String currentSelection) async {
  const genderOptions = ["Male", "Female", "Not to say"];
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Gender"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: genderOptions.length,
            itemBuilder: (context, index) {
              final gender = genderOptions[index];
              return ListTile(
                title: Text(
                  gender,
                  style: TextStyle(
                    color: gender == currentSelection ? AppColors.peachyPink : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, gender);
                },
              );
            },
          ),
        ),
      );
    },
  );
}

Future<String?> showRegionDropdown(BuildContext context, String currentSelection) async {
  const regionOptions = [
    "Abu Dhabi",
    "Dubai",
    "Sharjah",
    "Ajman",
    "Umm AI Quwain",
    "Ras AI Khaimah",
    "Fujairah",
  ];
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select Region"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: regionOptions.length,
            itemBuilder: (context, index) {
              final region = regionOptions[index];
              return ListTile(
                title: Text(
                  region,
                  style: TextStyle(
                    color: region == currentSelection ? AppColors.peachyPink : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, region);
                },
              );
            },
          ),
        ),
      );
    },
  );
}

Future<String?> showCompanyCategoryType(BuildContext context, String currentSelection) async {
  const regionOptions = [
    "Vendor",
    "Event Organizer",
    "Makeup Artist",
    "Celebrity",
  ];
  return showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Select CC Type"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: regionOptions.length,
            itemBuilder: (context, index) {
              final region = regionOptions[index];
              return ListTile(
                title: Text(
                  region,
                  style: TextStyle(
                    color: region == currentSelection ? AppColors.peachyPink : Colors.black,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context, region);
                },
              );
            },
          ),
        ),
      );
    },
  );
}

Future<String?> showDatePickerDialog(BuildContext context, String format) async {
  var now = DateTime.now();
  var firstDate = now.add(const Duration(days: 1));
  var initialDate = now.isBefore(firstDate) ? firstDate : now;

  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: initialDate,
    // Ensure initialDate is not before firstDate
    firstDate: firstDate,
    // Earliest selectable date is 2 days from now
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

  if (picked != null) {
    return DateFormat(format).format(picked);
  }

  return null;
}
