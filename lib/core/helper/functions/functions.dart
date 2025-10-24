import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../../../provider/payment_address/customer_address_provider.dart';
import '../../../views/auth_screens/auth_page_view.dart';
import '../../../views/base_screens/profile_screens/create_address_screen.dart';
import '../../constants/app_strings.dart';
import '../../services/shared_preferences_helper.dart';
import '../../utils/app_utils.dart';
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
  // computeLuminance returns 0.0 (dark) to 1.0 (light)
  final double luminance = backgroundColor.computeLuminance();

  // If background is light, return dark color; otherwise light color
  return luminance > 0.5 ? Colors.black87 : Colors.white;
}

/// Check if user is logged in
Future<bool> isLoggedIn() async {
  final token = await SecurePreferencesUtil.getToken();
  return token != null && token.isNotEmpty;
}

/// Navigate to login screen with appropriate message
void navigateToLogin(BuildContext context, String messageKey) {
  PersistentNavBarNavigator.pushNewScreen(
    context,
    screen: const AuthScreen(),
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

bool checkUserHasAddress(BuildContext context) {
  final provider = Provider.of<CustomerAddressProvider>(context, listen: false);
  if (provider.addresses.isEmpty) {
    AppUtils.showToast(AppStrings.youMustAddAddressFirstToContinue.tr);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateAddressScreen(),
      ),
    );
    return false;
  }

  return true;
}
