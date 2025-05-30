import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

class ForgotPasswordProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;
  String? _message;
  Map<String, dynamic>? _errors;

  bool get isLoading => _isLoading;

  String? get message => _message;

  Map<String, dynamic>? get errors => _errors;

  Future<void> forgotPassword(String email) async {
    _isLoading = true;
    _message = null;
    _errors = null;
    notifyListeners();

    try {
      final url = ApiEndpoints.forgotPassword;
      final headers = {'Content-Type': 'application/json'};

      final response = await _apiResponseHandler.postRequest(url, headers: headers, body: {'email': email});

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        ForgotPasswordResponse forgotPasswordResponse = ForgotPasswordResponse.fromJson(responseData);
        _message = forgotPasswordResponse.message;
      } else {
        ForgotPasswordResponse forgotPasswordResponse = ForgotPasswordResponse.fromJson(responseData);
        _message = forgotPasswordResponse.message;
        _errors = forgotPasswordResponse.errors;
      }
    } catch (error) {
      _message = 'An error occurred. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

//  __________________________________________  FORGOT PASSWORD MODELS ________________________________________

class ForgotPasswordResponse {
  final String? message;
  final Map<String, dynamic>? errors;

  ForgotPasswordResponse({this.message, this.errors});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ForgotPasswordResponse(
      message: json['message'],
      errors: json['errors'],
    );
  }
}
