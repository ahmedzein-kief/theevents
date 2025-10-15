import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../constants/vendor_app_strings.dart';
import '../widgets/custom_auth_views/app_custom_button.dart';
import 'app_colors.dart';

double get kTinyPadding => 2.5;

double get kExtraSmallPadding => 5;

double get kSmallPadding => 10;

double get kMediumPadding => 15;

double get kPadding => 20;

double get kLargePadding => 30;

Widget get kFormFieldSpace => const SizedBox.square(dimension: 15);

Widget get kMinorSpace => const SizedBox.square(dimension: 2.5);

Widget get kExtraSmallSpace => const SizedBox.square(dimension: 5);

Widget get kSmallSpace => const SizedBox.square(dimension: 10);

Widget get kMediumSpace => const SizedBox.square(dimension: 20);

Widget get kLargeSpace => const SizedBox.square(dimension: 30);

Widget get kExtraLargeSpace => const SizedBox.square(dimension: 50);

Widget get kShowVoid => const SizedBox.shrink();

double get kExtraSmallCardRadius => 2;

double get kTinyCardRadius => 4;

double get kSmallCardRadius => 10;

double get kCardRadius => 15;

double get kLargeCardRadius => 15;

double get kExtraSmallButtonRadius => 2;

double get kSmallButtonRadius => 4;

double get kButtonRadius => 8;

double get kLargeButtonRadius => 16;

double get kFileCardRadius => 2;

Widget get kFormTitleFieldSpace => const SizedBox.square(dimension: 8);

WidgetStateProperty<Color?> get kDataColumnColor => WidgetStateProperty.resolveWith((state) => Colors.white);

WidgetStateProperty<Color?> get kDataRowColor => WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lavenderHaze;
      }
      return Colors.white; // Default color when no specific state matches
    });

SizedBox kCancelButton({
  required screenWidth,
  double? borderRadius,
  required BuildContext context,
}) =>
    SizedBox(
      width: screenWidth * 0.25,
      child: CustomAppButton(
        buttonText: VendorAppStrings.cancelButton.tr,
        buttonColor: Colors.transparent,
        borderColor: Theme.of(context).colorScheme.onPrimary,
        borderRadius: borderRadius,
        textStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
