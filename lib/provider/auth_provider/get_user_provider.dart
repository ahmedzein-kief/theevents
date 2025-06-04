// user_provider.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/auth_models/get_user_models.dart';

class UserProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  UserModel? _user;

  UserModel? get user => _user;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setUser(UserModel? userModel) {
    _user = userModel;
    notifyListeners();
  }

  Future<void> fetchUserData(String token, BuildContext context) async {
    setUser(null);
    _isLoading = true;
    notifyListeners();
    if (token.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }
    const url = ApiEndpoints.getCustomer;
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        _user = UserModel.fromJson(responseData['data']);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load user data');
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<Uint8List?> downloadAgreement(
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.downloadAgreement;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {
      'Authorization': token ?? '',
    };

    try {
      final response = await _apiResponseHandler.getDioRequest(
        url,
        headers: headers,
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return response.data;
      } else {
        final jsonData = json.decode(response.data);
        CustomSnackbar.showError(context, _errorMessage(response));
        _isLoading = false;
        notifyListeners();
        return null;
      }
    } catch (e) {
      if (e is DioException) {
        CustomSnackbar.showError(context, _errorMessage(e.response));
      } else {}
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _errorMessage(response) {
    var errors;
    var error;
    var message;

    if (response is Response) {
      if (response.data != null) {
        final errorData = response.data;
        errors = errorData['errors'] ?? errorData['data'];
        error = errorData['error'];
        message = errorData['message'];
      }
    } else {
      final jsonData = json.decode(response.body);
      if (response != null) {
        errors = jsonData['errors'];
        error = jsonData['error'];
        message = jsonData['message'];
      }
    }

    try {
      // Initialize a variable to store error messages
      String allErrors = '';

      // Check if `errors` is present and process it
      if (errors != null && errors is Map) {
        errors.forEach((key, value) {
          if (value is List) {
            for (final msg in value) {
              allErrors += '$key: $msg\n'; // Append each error message
            }
          }
        });
      }

      // Check if `error` is present and append it
      if (error != null && error is String) {
        allErrors += 'Error: $error\n';
      }

      // Check if `message` is present and append it
      // if (message != null && message is String) {
      //   allErrors += 'Message: $message\n';
      // }

      // Return the collected error messages
      if (allErrors.isNotEmpty) {
        return allErrors.trim(); // Remove trailing newline
      }

      return 'An unknown error occurred.'; // Fallback message if no errors are found

    } catch (e) {
      return 'Unknown error occurred with status code: ${response.statusCode}';
    }
  }
}
