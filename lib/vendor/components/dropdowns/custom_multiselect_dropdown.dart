import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/utils/mixins_and_constants/constants.dart';
import 'package:event_app/vendor/components/input_borders_hub/input_border_hub.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class CustomMultiselectDropdown extends StatelessWidget {
  final dynamic dropdownItems;
  final dynamic dropdownController;
  final String hintText;
  final Function(dynamic)? onSelectionChanged;
  final bool isSearchEnabled;

  const CustomMultiselectDropdown({
    super.key,
    required this.dropdownItems,
    required this.dropdownController,
    required this.hintText,
    this.onSelectionChanged,
    this.isSearchEnabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiDropdown(
      controller: dropdownController,
      dropdownDecoration: DropdownDecoration(
        backgroundColor: Colors.white,
        borderRadius: BorderRadius.circular(kCardRadius),
      ),
      fieldDecoration: FieldDecoration(
          backgroundColor: Colors.transparent,
          border: InputBordersHub.getOutlinedInputBorder(),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          suffixIcon: Icon(Icons.keyboard_arrow_down_outlined)),
      dropdownItemDecoration: DropdownItemDecoration(
        selectedBackgroundColor: AppColors.lightCoral,
        selectedIcon: Icon(
          CupertinoIcons.checkmark_alt,
          color: Colors.white,
        ),
        selectedTextColor: Colors.white,
      ),
      chipDecoration: ChipDecoration(backgroundColor: AppColors.lightCoral, borderRadius: BorderRadius.circular(3), labelStyle: TextStyle(color: Colors.white, fontSize: 15)),
      searchDecoration: SearchFieldDecoration(
        border: InputBordersHub.getOutlinedInputBorder(borderColor: AppColors.success),
        focusedBorder: InputBordersHub.getOutlinedInputBorder(),
      ),
      items: dropdownItems,
      searchEnabled: isSearchEnabled,
      onSelectionChange: onSelectionChanged,
    );
  }
}
