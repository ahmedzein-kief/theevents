import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_endpoints/api_end_point.dart';
import '../../models/checkout_models/checkout_data_models.dart';

class CheckoutScreenRepository {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  /// +++++++++++++++++++++   Checkout Payment Screen----------------------------------

  Future<CheckoutResponse> checkout(BuildContext context, String token) async {
    try {
      final tokenLogin = await SecurePreferencesUtil.getToken();
      const url = ApiEndpoints.checkout;
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
