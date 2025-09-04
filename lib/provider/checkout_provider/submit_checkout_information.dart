import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_status/api_status.dart';

class SubMitCheckoutInformationProvider extends ChangeNotifier {
  ///  +++++++++++++++++++++++++++++++++  POST THE INFORMATION CHECKOUT API +++++++++++++++++++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  ApiStatus get status => _status;

  void setStatus(ApiStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<dynamic> submitCheckoutInformation({
    required BuildContext context,
    required String trackedStartCheckout,
    required String addressId,
    required String name,
    required String email,
    required String city,
    required String state,
    required String address,
    required int phone,
    required String country,
    required int vendorId,
    required String shippingMethod,
    required String shippingOption,
    required String token, // Token parameter
    String? billingAddressSameAsShippingAddress,
  }) async {
    _isLoading = true;
    notifyListeners();
    setStatus(ApiStatus.loading);
    final url = 'https://apistaging.theevents.ae/api/v1/checkout/$trackedStartCheckout/information';
    final headers = {
      'Authorization': token,
    };

    final Map<String, dynamic> postDataMap = {
      'tracked_start_checkout': trackedStartCheckout,
      'address': {
        'address_id': addressId,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.toString().trim(),
        'country': country,
        'city': city,
        'state': state,
        'address': address,
      },
    };

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        body: postDataMap,
      );
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        final responseData = response.data;
        final cartUpdateResponse = InformationUpdate.fromJson(responseData);
        notifyListeners();
        _isLoading = false;
        notifyListeners();
        return response;
      } else {}
    } catch (error) {
      setStatus(ApiStatus.error);
    }
    _isLoading = false;
    notifyListeners();
    return null;
  }
}

class InformationUpdate {
  InformationUpdate({
    required this.error,
    this.data,
    required this.message,
  });

  // Factory constructor to create a CartUpdateResponse from JSON
  factory InformationUpdate.fromJson(Map<String, dynamic> json) => InformationUpdate(
        error: json['error'] as bool,
        data: json['data'], // Handle null or any type of data here
        message: json['message'] as String,
      );
  final bool error;
  final dynamic data;
  final String message;

  // Method to convert CartUpdateResponse to JSON (optional)
  Map<String, dynamic> toJson() => {
        'error': error,
        'data': data,
        'message': message,
      };
}
