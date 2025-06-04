import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_status/api_status.dart';

class ChangePasswordProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  void setStatus(ApiStatus newStatus) {
    _status = newStatus;
    notifyListeners(); // Notify the UI about the status change
  }

  Future<void> changePassword(
      String token, ChangePasswordRequest request, BuildContext context) async {
    const urlChangePassword = ApiEndpoints.changePassword;
    const url = urlChangePassword;
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    setStatus(ApiStatus.loading); // Set status to loading before the API call

    try {
      final response = await _apiResponseHandler.postRequest(url,
          headers: headers, body: request.toJson());

      final responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed); // Set status to compl
        CustomSnackbar.showSuccess(context, 'Password updated successfully.');
      } else {
        setStatus(ApiStatus.error); // Set status to error if the API call
        CustomSnackbar.showError(context, responseData['message']);
      }
    } catch (error) {
      setStatus(ApiStatus.error); // Set statu
    }
  }
}

class ChangePasswordRequest {
  ChangePasswordRequest(
      {required this.oldPassword,
      required this.password,
      required this.password_confirmation});
  String oldPassword;
  String password;
  String password_confirmation;

  Map<String, String> toJson() => {
        'old_password': oldPassword,
        'password': password,
        'password_confirmation': password_confirmation,
      };
}
