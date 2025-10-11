import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/network/api_status/api_status.dart';
import '../../core/utils/app_utils.dart';

class ProfileUpdateProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  void setStatus(ApiStatus newStatus) {
    _status = newStatus;
    notifyListeners(); // Notify the UI about the status change
  }

  Future<void> editProfileDetails(
    ProfileUpdateResponse request,
    BuildContext context,
  ) async {
    const urlChangePassword = ApiEndpoints.editAccount;
    const url = urlChangePassword;

    setStatus(ApiStatus.loading); // Set status to loading before the API call

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: {
          'Accept': 'application/json',
        },
        extra: {ApiConstants.requireAuthKey: true},
        body: request.toJson(),
      );

      final responseData = response.data;
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed); // Set status to comp
        AppUtils.showToast(responseData['message'], isSuccess: true);
      } else {
        setStatus(ApiStatus.error); // Set status to error if the API cal
        AppUtils.showToast(responseData['message']);
      }
    } catch (error) {
      setStatus(ApiStatus.error);
    }
  }

  Future<bool> deleteAccount(BuildContext context) async {
    const urlChangePassword = ApiEndpoints.customerDelete;
    const url = urlChangePassword;
    final headers = {
      'Accept': 'application/json',
    };

    setStatus(ApiStatus.loading); // Set status to loading before the API call

    try {
      final response = await _apiResponseHandler.deleteRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
        headers: headers,
      );

      final responseData = response.data;
      if (response.statusCode == 200) {
        setStatus(ApiStatus.completed);
        AppUtils.showToast(responseData['message'], isSuccess: true);
        return true;
      } else {
        setStatus(ApiStatus.error);
        AppUtils.showToast(responseData['message']);
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
