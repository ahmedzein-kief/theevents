import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/apiStatus/api_status.dart';

class AddressModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String country;
  final String city;
  final String state;
  final String zipCode;
  final bool isDefault;

  AddressModel({
    this.id = "",
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.country,
    required this.city,
    this.state = '',
    this.zipCode = '',
    this.isDefault = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'country': country,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'is_default': isDefault ? 1 : 0,
    };
  }

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
      'zip_code': zipCode,
      'is_default': isDefault ? "1" : "0",
    };
  }

  Map<String, dynamic> vendorOrderDetailsUpdateShippingAddressToJson() {
    return {
      'order_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'country': country,
      'city': city,
      'state': state,
      'zip_code': zipCode,
    };
  }
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

  Future<int?> saveAddress(AddressModel address) async {
    setStatus(ApiStatus.loading);
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    final urlCreateAddress = ApiEndpoints.createCustomerAddress;
    final url = urlCreateAddress;
    final headers = {
      // 'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      // Encode the address object to JSON string format
      final response = await _apiResponseHandler.postRequest(url, headers: headers, body: address.toJsonString());

      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        var responseData = json.decode(response.body);
        var createData = CreateAddressResponse.fromJson(responseData);
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
  final bool error;
  final dynamic data;
  final String message;

  CreateAddressResponse({
    required this.error,
    this.data,
    required this.message,
  });

  // Factory constructor to create a CartUpdateResponse from JSON
  factory CreateAddressResponse.fromJson(Map<String, dynamic> json) {
    return CreateAddressResponse(
      error: json['error'] as bool,
      data: json['data'], // Handle null or any type of data here
      message: json['message'] as String,
    );
  }

  // Method to convert CartUpdateResponse to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'data': data,
      'message': message,
    };
  }
}
