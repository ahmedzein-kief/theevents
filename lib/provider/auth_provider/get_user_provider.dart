import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/network/api_endpoints/vendor_api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/utils/app_utils.dart';
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

  Future<void> fetchUserData() async {
    setUser(null);
    _isLoading = true;
    notifyListeners();

    const url = ApiEndpoints.getCustomer;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
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

  /// Call become vendor API
  Future<bool> becomeVendor(int userId) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.becomeVendor}/$userId';

    try {
      final response = await _apiResponseHandler.getDioRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        // Optionally update user data after successful vendor conversion
        await fetchUserData();
        _isLoading = false;
        notifyListeners();
        AppUtils.showToast(response.data['message'], isSuccess: true);
        return true;
      } else {
        _isLoading = false;
        notifyListeners();

        final errorMessage = response.data['message'] ?? 'Failed to become vendor';
        AppUtils.showToast(errorMessage);

        return false;
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();

      AppUtils.showToast('Become vendor exception: $error');
      return false;
    }
  }

  Future<void> downloadAgreement(BuildContext context, int vendorId) async {
    _isLoading = true;
    notifyListeners();

    const url = VendorApiEndpoints.getAgreementUrl;
    final token = await SecurePreferencesUtil.getToken();
    final headers = {'Authorization': token ?? ''};
    try {
      final response = await _apiResponseHandler.getDioRequest(
        '$url/$vendorId',
        headers: headers,
      );
      final data = response.data;
      if (response.statusCode != 200) {
        AppUtils.showToast(data['message']);
        return;
      }

      await openPdfFromUrl(data['data']['url']);
    } catch (e) {
      AppUtils.showToast('Could not open PDF ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> openPdfFromUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not launch PDF URL: $url');
    }
  }

// String _errorMessage(response) {
//   var errors;
//   var error;
//   var message;
//
//   if (response is Response) {
//     if (response.data != null) {
//       final errorData = response.data;
//       errors = errorData['errors'] ?? errorData['data'];
//       error = errorData['error'];
//       message = errorData['message'];
//     }
//   } else {
//     final jsonData = response.data;
//     if (response != null) {
//       errors = jsonData['errors'];
//       error = jsonData['error'];
//       message = jsonData['message'];
//     }
//   }
//
//   try {
//     // Initialize a variable to store error messages
//     String allErrors = '';
//
//     // Check if `errors` is present and process it
//     if (errors != null && errors is Map) {
//       final errorBuffer = StringBuffer();
//
//       errors.forEach((key, value) {
//         if (value is List) {
//           for (final msg in value) {
//             errorBuffer.writeln('$key: $msg'); // Append each error message
//           }
//         }
//       });
//
//       allErrors = errorBuffer.toString();
//     }
//
//     // Check if `error` is present and append it
//     if (error != null && error is String) {
//       allErrors += 'Error: $error\n';
//     }
//
//     // Check if `message` is present and append it
//     // if (message != null && message is String) {
//     //   allErrors += 'Message: $message\n';
//     // }
//
//     // Return the collected error messages
//     if (allErrors.isNotEmpty) {
//       return allErrors.trim(); // Remove trailing newline
//     }
//
//     return 'An unknown error occurred.'; // Fallback message if no errors are found
//   } catch (e) {
//     return 'Unknown error occurred with status code: ${response.statusCode}';
//   }
// }
}
