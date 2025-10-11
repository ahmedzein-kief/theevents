import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomMultiselectDropdown extends StatelessWidget {
  const CustomMultiselectDropdown({
    super.key,
    required this.dropdownItems,
    required this.dropdownController,
    required this.hintText,
    this.onSelectionChanged,
    this.isSearchEnabled = false,
  });

  final dynamic dropdownItems;
  final dynamic dropdownController;
  final String hintText;
  final void Function(List selectedItems)? onSelectionChanged;
  final bool isSearchEnabled;

  @override
  Widget build(BuildContext context) => MultiDropdown(
        controller: dropdownController,
        dropdownDecoration: DropdownDecoration(
          backgroundColor: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(kCardRadius),
        ),
        fieldDecoration: FieldDecoration(
          // backgroundColor: Theme.of(context).colorScheme.onPrimary,
          border: InputBordersHub.getOutlinedInputBorder(),
          hintText: hintText,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_outlined),
        ),
        dropdownItemDecoration: const DropdownItemDecoration(
          // selectedBackgroundColor: AppColors.lightCoral,
          selectedIcon: Icon(
            CupertinoIcons.checkmark_alt,
            // color: Colors.white,
          ),
          // selectedTextColor: Colors.white,
        ),
        chipDecoration: ChipDecoration(
          // backgroundColor: AppColors.lightCoral,
          borderRadius: BorderRadius.circular(3),
          // labelStyle: const TextStyle(color: Colors.white, fontSize: 15),
        ),
        searchDecoration: SearchFieldDecoration(
          border: InputBordersHub.getOutlinedInputBorder(
            borderColor: AppColors.success,
          ),
          focusedBorder: InputBordersHub.getOutlinedInputBorder(),
        ),
        items: dropdownItems,
        searchEnabled: isSearchEnabled,
        onSelectionChange: onSelectionChanged,
      );
}
