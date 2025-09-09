import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/constants/vendor_app_strings.dart';
import '../core/styles/app_colors.dart';

Future<String?> showGenderDropdown(
  BuildContext context,
  String currentSelection,
) async {
  const genderOptions = ['Male', 'Female', 'Not to say'];
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(VendorAppStrings.selectGender.tr),
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
    ),
  );
}

Future<String?> showRegionDropdown(
  BuildContext context,
  String currentSelection,
) async {
  const regionOptions = [
    'Abu Dhabi',
    'Dubai',
    'Sharjah',
    'Ajman',
    'Umm AI Quwain',
    'Ras AI Khaimah',
    'Fujairah',
  ];
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(VendorAppStrings.selectRegion.tr),
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
    ),
  );
}

Future<String?> showCompanyCategoryType(
  BuildContext context,
  String currentSelection,
  List<Map<String, dynamic>>? vendorTypes,
) async {
  final regionOptions = vendorTypes ?? [];

  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(VendorAppStrings.selectCcType.tr),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: regionOptions.length,
          itemBuilder: (context, index) {
            final region = regionOptions[index]['name'] as String;
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
    ),
  );
}

Future<String?> showDatePickerDialog(
  BuildContext context,
  String format,
) async {
  final now = DateTime.now();
  final firstDate = now.add(const Duration(days: 1));
  final initialDate = now.isBefore(firstDate) ? firstDate : now;

  final results = await showCalendarDatePicker2Dialog(
    context: context,
    config: CalendarDatePicker2WithActionButtonsConfig(
      firstDate: firstDate,
      lastDate: DateTime(2101),
      currentDate: initialDate,
      selectedDayHighlightColor: Colors.blue,
      cancelButtonTextStyle: const TextStyle(color: Colors.pink),
    ),
    dialogSize: const Size(325, 400),
    value: [initialDate],
  );

  if (results != null && results.isNotEmpty && results[0] != null) {
    return DateFormat(format).format(results[0]!);
  }

  return null;
}
