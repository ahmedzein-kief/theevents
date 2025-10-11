import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_utils.dart';
import 'create_address_provider.dart';
import 'customer_address.dart';

class CustomerAddress extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  Future<bool> updateAddress(
    AddressModel address,
    String token,
    int addressId,
    BuildContext context,
  ) async {
    final url = '${ApiEndpoints.customerAddressEdit}$addressId';
    final headers = {
      'Authorization': token,
      // 'Content-Type': 'application/json',
    };

    final response = await _apiResponseHandler.postRequest(
      url,
      headers: headers,
      body: address.toJsonString(),
    );

    if (response.statusCode == 200) {
      AppUtils.showToast(AppStrings.addressUpdateSuccess.tr, isSuccess: true);

      /// --------------------------- RE-FETCH THE DATA OF THE CUSTOMER ------------------------------
      if (context.mounted) {
        // Check if context is still valid
        final reFetchUserData = Provider.of<CustomerAddressProvider>(context, listen: false);
        await reFetchUserData.fetchCustomerAddresses(context);
        notifyListeners();
      }
      return true;
    } else {
      AppUtils.showToast(AppStrings.invalidAddressData.tr);
      return false;
    }
  }
}
