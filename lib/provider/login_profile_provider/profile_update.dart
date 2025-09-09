import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_status/api_status.dart';

class ProfileUpdateProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  void setStatus(ApiStatus newStatus) {
    _status = newStatus;
    notifyListeners(); // Notify the UI about the status change
  }

  Future<void> editProfileDetails(
    String token,
    ProfileUpdateResponse request,
    BuildContext context,
  ) async {
    const urlChangePassword = ApiEndpoints.editAccount;
    const url = urlChangePassword;
    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
    };

    setStatus(ApiStatus.loading); // Set status to loading before the API call

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        body: request.toJson(),
      );

      final responseData = response.data;
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed); // Set status to comp
        CustomSnackbar.showSuccess(context, responseData['message']);
      } else {
        setStatus(ApiStatus.error); // Set status to error if the API cal
        CustomSnackbar.showError(context, responseData['message']);
      }
    } catch (error) {
      setStatus(ApiStatus.error);
    }
  }

  Future<bool> deleteAccount(String token, BuildContext context) async {
    const urlChangePassword = ApiEndpoints.customerDelete;
    const url = urlChangePassword;
    final headers = {
      'Authorization': token,
      'Accept': 'application/json',
    };

    setStatus(ApiStatus.loading); // Set status to loading before the API call

    try {
      final response = await _apiResponseHandler.deleteRequest(
        url,
        headers: headers,
      );

      final responseData = response.data;
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        CustomSnackbar.showSuccess(context, responseData['message']);
        return true;
      } else {
        setStatus(ApiStatus.error);
        CustomSnackbar.showError(context, responseData['message']);
        return false;
      }
    } catch (error) {
      setStatus(ApiStatus.error);
      return false;
    }
  }
}

class ProfileUpdateResponse {
  ProfileUpdateResponse({
    required this.fullName,
    required this.fullEmail,
    required this.phoneNumber,
  });

  String fullName;
  String fullEmail;
  String phoneNumber;

  Map<String, String> toJson() => {
        'name': fullName,
        'email': fullEmail,
        'phone': phoneNumber,
      };
}
