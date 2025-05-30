import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/custom_toast.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import 'create_address_provider.dart';
import 'customer_address.dart';

class CustomerAddress extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  Future<bool> updateAddress(AddressModel address, String token, int addressId, BuildContext context) async {
    final url = '${ApiEndpoints.customerAddressEdit}$addressId';
    final headers = {
      'Authorization': 'Bearer $token',
      // 'Content-Type': 'application/json',
    };

    final response = await _apiResponseHandler.postRequest(url, headers: headers, body: address.toJsonString());

    if (response.statusCode == 200) {
      CustomSnackbar.showSuccess(context, "Address Update successfully!");

      /// --------------------------- RE-FETCH THE DATA OF THE CUSTOMER ------------------------------
      final token = await SharedPreferencesUtil.getToken();
      final reFetchUserData = Provider.of<CustomerAddressProvider>(context, listen: false);
      await reFetchUserData.fetchCustomerAddresses(token ?? '', context);
      notifyListeners();
      return true;
    } else {
      CustomSnackbar.showError(context, "Please Enter Valid Data");

      // Handle error
      return false;
    }
  }
}
