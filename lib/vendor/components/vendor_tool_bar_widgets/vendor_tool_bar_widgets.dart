import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../dropdowns/custom_dropdown.dart';
import '../text_fields/custom_text_form_field.dart';

class VendorToolbarWidgets {
  /// search bar
  /// A customizable search widget used in the vendor toolbar.
  ///
  /// The widget allows for dynamic functionality via the [onTap] parameter.
  static CustomTextFormField vendorSearchWidget({
    required onSearchTap,
    required TextEditingController textEditingController,
    required Function(String?) onChanged,
  }) =>
      CustomTextFormField(
        labelText: 'Search..',
        showTitle: false,
        required: false,
        hintText: 'Search..',
        hintStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
        borderColor: AppColors.stoneGray,
        borderRadius: 2,
        height: 35,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        suffix: GestureDetector(
          onTap: onSearchTap,
          child: const Icon(
            Icons.search,
            color: AppColors.charcoalPurple,
          ),
        ),
        filled: true,
        fillColor: AppColors.lavenderHaze,
        controller: textEditingController,
        onChanged: (value) {
          onChanged(value);
        },
      );

  /// Reload Button
  static dynamic vendorReloadButton({
    required Function() onTap,
    required isLoading,
  }) =>
      wrapUnderElevation(
        child: CustomAppButton(
          buttonText: 'Reload',
          borderColor: AppColors.stoneGray,
          buttonColor: Colors.white,
          prefixIcon: Icons.refresh_sharp,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          borderRadius: 2,
          height: 35,
          prefixIconColor: Colors.black,
          isLoading: isLoading,
          onTap: onTap,
        ),
      );

  /// vendor tool bar dropdown widget
  static dynamic vendorDropdownWidget({
    required String hintText,
    required List<DropdownMenuItem> menuItemsList,
    required Function(dynamic) onChanged,
  }) =>
      wrapUnderElevation(
        child: CustomDropdown(
          menuItemsList: menuItemsList,
          borderRadius: 0,
          hintText: hintText,
          textStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w400, fontSize: 12),
          borderColor: AppColors.stoneGray,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 7.2),
          onChanged: (value) {
            onChanged(value);

            /// Callback
          },
        ),
      );

  /// Create Button
  static dynamic vendorCreateButton({
    required Function() onTap,
    required bool isLoading,
  }) =>
      wrapUnderElevation(
        child: CustomAppButton(
          buttonText: 'Create',
          buttonColor: AppColors.lightCoral,
          prefixIcon: Icons.add,
          suffixIcon: Icons.keyboard_arrow_down_rounded,
          textStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          borderRadius: 2,
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          isLoading: isLoading,
          onTap: onTap,
        ),
      );

  /// Provide Elevation to widgets
  static Material wrapUnderElevation({required child}) => Material(
        elevation: 0.1,
        child: child,
      );
}
