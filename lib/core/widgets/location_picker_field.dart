import 'package:flutter/material.dart';

import '../../../core/styles/app_colors.dart';
import '../../../core/widgets/custom_profile_views/custom_text_field_view.dart';

class LocationPickerField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback onTap;
  final String? Function(String?)? formFieldValidator;
  final bool isLoading;

  const LocationPickerField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.nextFocusNode,
    required this.onTap,
    this.formFieldValidator,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFieldProfileScreen(
      hintText: hintText,
      controller: controller,
      focusNode: focusNode,
      nextFocusNode: nextFocusNode,
      isEditable: false,
      formFieldValidator: formFieldValidator,
      suffixIcon: isLoading
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  backgroundColor: AppColors.peachyPink,
                ),
              ),
            )
          : const Icon(Icons.arrow_drop_down_outlined),
      onTap: onTap,
    );
  }
}
