import 'package:event_app/core/styles/app_colors.dart';
import 'package:event_app/core/styles/app_sizes.dart';
import 'package:event_app/vendor/components/buttons/custom_icon_button_with_text.dart';
import 'package:event_app/vendor/components/data_tables/custom_data_tables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future deleteItemAlertDialog({
  required BuildContext context,
  String? descriptionText,
  String? buttonText,
  Widget? buttonIcon,
  Color? buttonColor,
  required VoidCallback onDelete,
  Widget? customDescription,
}) async {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kCardRadius),),
      title: Text(
        'Confirmation!',
        style: detailsTitleStyle.copyWith(fontSize: 16),
      ),
      content: customDescription ??
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(descriptionText ??
                  'Are you sure you want to delete this item?',),
              Text(
                'This operation cannot be undone.',
                style: dataRowTextStyle().copyWith(color: AppColors.lightCoral),
              ),
            ],
          ),
      actions: [
        CustomIconButtonWithText(
          text: buttonText ?? 'Delete',
          color: buttonColor ?? Colors.red,
          borderColor: buttonColor ?? Colors.white,
          textColor: Colors.white,
          icon: buttonIcon ??
              const Icon(
                CupertinoIcons.delete,
                size: 16,
                color: Colors.white,
              ),
          onPressed: onDelete,
        ),
        CustomIconButtonWithText(
          text: 'Cancel',
          color: Colors.white,
          borderColor: AppColors.stoneGray,
          textColor: Colors.black,
          icon: const Icon(
            Icons.cancel_outlined,
            size: 16,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );
}
