import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/helper/functions/functions.dart';
import '../../core/network/api_status/api_status.dart';

class AddressModel {
  AddressModel({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    required this.city,
    required this.state,
    required this.countryId,
    required this.stateId,
    required this.cityId,
    this.isDefault = true,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String country;
  final String city;
  final String state;
  final String countryId;
  final String stateId;
  final String cityId;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'country': country,
        'city': city,
        'state': state,
        'country_id': countryId,
        'state_id': stateId,
        'city_id': cityId,
        'is_default': isDefault ? 1 : 0,
      };

  Map<String, dynamic> toJsonString() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'country': country,
      'city': city,
      'state': state,
      'country_id': countryId,
      'state_id': stateId,
      'city_id': cityId,
      'is_default': isDefault ? '1' : '0',
    };
  }

  Map<String, dynamic> vendorOrderDetailsUpdateShippingAddressToJson() => {
        'order_id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'country': country,
        'city': city,
        'state': state,
        'country_id': countryId,
        'state_id': stateId,
        'city_id': cityId,
      };
}

class AddressProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setStatus(ApiStatus status) {
    _status = status;
    notifyListeners();
  }

  Future<int?> saveAddress(BuildContext context, AddressModel address) async {
    setStatus(ApiStatus.loading);
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    const urlCreateAddress = ApiEndpoints.createCustomerAddress;
    const url = urlCreateAddress;

    if (token == null || token.isEmpty) {
      navigateToLogin(context, 'Please log in to create an address');
      return null;
    }
    final headers = {
      // 'Content-Type': 'application/json',
      'Authorization': token,
    };

    try {
      // Encode the address object to JSON string format
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        body: address.toJsonString(),
      );

      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        final responseData = response.data;
        final createData = CreateAddressResponse.fromJson(responseData);
        _isLoading = false;
        notifyListeners();
        return (createData.data as Map<String, dynamic>)['id'];
      } else {
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      setStatus(ApiStatus.error);
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}

class CreateAddressResponse {
  CreateAddressResponse({
    required this.error,
    this.data,
    required this.message,
  });

  // Factory constructor to create a CartUpdateResponse from JSON
  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) => CreateAddressResponse(
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
