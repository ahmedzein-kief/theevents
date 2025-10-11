import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/constants/vendor_app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_auth_views/app_custom_button.dart';
import '../dropdowns/custom_dropdown.dart';
import '../text_fields/custom_text_form_field.dart';

class VendorToolbarWidgets {
  /// search bar
  /// A customizable search widget used in the vendor toolbar.
  ///
  /// The widget allows for dynamic functionality via the [`onTap`] parameter.
  static CustomTextFormField vendorSearchWidget({
    required VoidCallback onSearchTap, // Updated to use VoidCallback for clarity
    required TextEditingController textEditingController,
    required ValueChanged<String?> onChanged, // Explicitly typed for clarity
  }) =>
      CustomTextFormField(
        labelText: VendorAppStrings.search.tr,
        showTitle: false,
        required: false,
        hintText: VendorAppStrings.search.tr,
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
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
        onChanged: onChanged,
      );

  /// Reload Button
  static Widget vendorReloadButton({
    required VoidCallback onTap, // Updated to use VoidCallback
    required bool isLoading,
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
  static Widget vendorDropdownWidget<T>({
    required String hintText,
    required List<DropdownMenuItem<T>> menuItemsList, // Updated to use generic type T
    required ValueChanged<T?>? onChanged, // Updated to use T? instead of dynamic
  }) =>
      wrapUnderElevation(
        child: CustomDropdown<T>(
          // Explicitly specify generic type T
          menuItemsList: menuItemsList,
          borderRadius: 0,
          hintText: hintText,
          textStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
          borderColor: AppColors.stoneGray,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7.2),
          onChanged: onChanged,
        ),
      );

  /// Create Button
  static Widget vendorCreateButton({
    required VoidCallback onTap, // Updated to use VoidCallback
    required bool isLoading,
  }) =>
      wrapUnderElevation(
        child: CustomAppButton(
          buttonText: AppStrings.create.tr,
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
  static Widget wrapUnderElevation({required Widget child}) => Material(
        elevation: 0.1,
        child: child,
      );
}
