import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
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
      const url = ApiEndpoints.forgotPassword;
      final headers = {'Content-Type': 'application/json'};

      final response = await _apiResponseHandler
          .postRequest(url, headers: headers, body: {'email': email});

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        final ForgotPasswordResponse forgotPasswordResponse =
            ForgotPasswordResponse.fromJson(responseData);
        _message = forgotPasswordResponse.message;
      } else {
        final ForgotPasswordResponse forgotPasswordResponse =
            ForgotPasswordResponse.fromJson(responseData);
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
  ForgotPasswordResponse({this.message, this.errors});

  factory ForgotPasswordResponse.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordResponse(
        message: json['message'],
        errors: json['errors'],
      );
  final String? message;
  final Map<String, dynamic>? errors;
}
