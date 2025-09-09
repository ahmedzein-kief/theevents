import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../views/auth_screens/auth_page_view.dart';
import '../../constants/app_strings.dart';
import '../../widgets/custom_items_views/custom_toast.dart';
import '../enums/enums.dart';

String getFilterText(String filter) {
  final mapping = {
    'Categories': ProductFilter.categories,
    'Brands': ProductFilter.brands,
    'Tags': ProductFilter.tags,
    'Prices': ProductFilter.prices,
    'Colors': ProductFilter.colors,
  };

  final productFilter = mapping[filter];
  if (productFilter == null) {
    throw Exception('Unknown filter: $filter');
  }

  return AppStrings.productSearchFiltersStrings[productFilter]!.tr;
}

// Helper method to get opposite color for better visibility
Color getOppositeColor(Color backgroundColor) {
  // Calculate luminance to determine if background is light or dark
  final double luminance =
      (0.299 * backgroundColor.red + 0.587 * backgroundColor.green + 0.114 * backgroundColor.blue) / 255;

  // If background is light, return dark color; if dark, return light color
  return luminance > 0.5 ? Colors.black87 : Colors.white;
}

/// Navigate to login screen with appropriate message
void navigateToLogin(BuildContext context, String messageKey) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: AuthScreen(),
    withNavBar: false,
    pageTransitionAnimation: PageTransitionAnimation.fade,
  );

  final CustomToast customToast = CustomToast(context);
  customToast.showToast(
    context: context,
    textHint: messageKey,
    onDismiss: () {
      customToast.removeToast();
    },
  );
}
