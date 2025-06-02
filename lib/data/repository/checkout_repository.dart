import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

import '../../models/checkout_models/checkout_data_models.dart';
import '../../utils/apiendpoints/api_end_point.dart';

class CheckoutScreenRepository {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  /// +++++++++++++++++++++   Checkout Payment Screen----------------------------------

  Future<CheckoutResponse> checkout(BuildContext context, String token) async {
    try {
      final tokenLogin = await SecurePreferencesUtil.getToken();
      final url = ApiEndpoints.checkout;
      final headers = {
        'Authorization': 'Bearer $tokenLogin',
      };
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response['status']) {
        return CheckoutResponse.fromJson(response['data']);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow; // Rethrow to handle it in the provider
    }
  }
}
