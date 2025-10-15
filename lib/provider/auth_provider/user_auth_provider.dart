import 'dart:convert';

import 'package:event_app/core/services/image_picker.dart';
import 'package:event_app/core/widgets/bottom_navigation_bar.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../core/network/api_endpoints/api_end_point.dart';
import '../../core/network/api_status/api_status.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/app_utils.dart';
import '../../core/utils/custom_toast.dart';
import '../../models/auth_models/login_models.dart';
import '../../models/auth_models/logout_models.dart';
import '../../models/auth_models/sign_up_models.dart';
import 'get_user_provider.dart';

class AuthProvider with ChangeNotifier {
  ///    +++++++++++++++++  LOGIN -------------------------------------------

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  bool _isLoading = false;
  String _message = '';
  ApiStatus _status = ApiStatus.completed;

  ApiStatus get status => _status;

  bool get isLoading => _isLoading;

  String get message => _message;

  Future<UserLoginModel?> login(
    BuildContext context,
    String email,
    String password,
    bool rememberMe, {
    required String tokenName,
  }) async {
    _isLoading = true;
    _status = ApiStatus.loading;
    notifyListeners();

    const url = ApiEndpoints.login;
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    final body = jsonEncode(
      {'email': email, 'password': password, 'token_name': tokenName},
    );

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        bodyString: body,
        authService: false,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final UserLoginModel userLoginModel = UserLoginModel.fromJson(jsonData);

        /// store image url to preferences
        ImagePickerHelper().saveImageToPreferences(userLoginModel.data?.avatar ?? '');
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          AppUtils.showToast(
            isSuccess: true,
            userLoginModel.message ?? 'Login successfully.',
          );
        }
        return userLoginModel;
      } else {
        final jsonData = response.data;
        final UserLoginModel userLoginModel = UserLoginModel.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
        if (context.mounted) {
          AppUtils.showToast(userLoginModel.message ?? '');
        }
        return userLoginModel;
      }
    } catch (exception) {
      _isLoading = false;
      notifyListeners();
      if (context.mounted) {
        AppUtils.showToast(exception.toString());
      }
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///    +++++++++++++++++  SignUp -------------------------------------------

  Future<SignUpResponse?> signUp(
    String name,
    String email,
    String password,
    String passwordConfirmation,
    context,
  ) async {
    _isLoading = true;
    _status = ApiStatus.loading;
    notifyListeners();

    try {
      const url = ApiEndpoints.signUp;

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final body = jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        bodyString: body,
        authService: false,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final signUpResponse = SignUpResponse.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
        CustomSnackbar.showSuccess(
          context,
          signUpResponse.message ?? 'Registered successfully.',
        );
        return signUpResponse;
      } else {
        final jsonData = response.data;
        final SignUpResponse dataModel = SignUpResponse.fromJson(jsonData);
        _isLoading = false;
        AppUtils.showToast(dataModel.formattedErrors);
        notifyListeners();
        return null;
      }
    } catch (exception) {
      _isLoading = false;
      AppUtils.showToast(exception.toString());
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ++++++++++++++++++   LOGOUT FUNCTION      ------------------------------

  Future<void> logout(context, token) async {
    setLoading(true);
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    if (token == null || token.isEmpty) {
      setLoading(false);
      _isLoading = false;
      notifyListeners();
      return;
    }

    final dynamic headers = {'Authorization': token};
    final provider = Provider.of<UserProvider>(context, listen: false);
    final user = provider.user;
    final url = '${ApiEndpoints.logout}?${user?.name}';

    final response = await _apiResponseHandler.getRequest(
      url,
      headers: headers,
    );

    setLoading(false);
    if (response.statusCode == 200) {
      final responseBody = response.data;
      final UserLogoutModel userLogoutModel = UserLogoutModel.fromJson(responseBody);
      if (userLogoutModel.error == false) {
        // await SecurePreferencesUtil.clearSharedPreferences();

        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          CupertinoPageRoute(builder: (context) => const BaseHomeScreen()),
        );
        CustomSnackbar.showSuccess(
          context,
          userLogoutModel.message ?? 'Logged out successfully',
        );
        _isLoading = false;
        notifyListeners();
      } else {
        // Show error message from the model
        CustomSnackbar.showError(
          context,
          userLogoutModel.message ?? 'Logged out successfully',
        );
        _isLoading = false;
        notifyListeners();
      }
    } else {
      // Handle other status codes and show an appropriate message
      CustomSnackbar.showError(
        context,
        'An error occurred. Please try again later.',
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  ///  ++++++++++++++++++  FORGOT PASSWORD ------------------------------

  String? _messages;
  Map<String, dynamic>? _errors;

  String? get messages => _messages;

  Map<String, dynamic>? get errors => _errors;

  Future<void> forgotPassword(String email, BuildContext context) async {
    _isLoading = true;
    _errors = null;
    notifyListeners();

    try {
      // Use the postRequest method from AuthRepository

      const url = '${ApiEndpoints.baseUrl}${ApiEndpoints.forgotPassword}';

      final headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };

      final body = jsonEncode({'email': email});

      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        bodyString: body,
        authService: true,
      ) as Map<String, dynamic>;

      if (response['status']) {
        // Success case
        _message = response['data']['message'];
        AppUtils.showToast(_message, isSuccess: true);
      } else {
        // Error response
        _message = response['message'];
        _errors = response['errors'];
        AppUtils.showToast(_message);
      }
    } catch (error) {
      AppUtils.showToast(_message);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// +++++++++++++++++++  FUNCTIONS  =================================

  Future<bool> checkLoginState() async => SecurePreferencesUtil.getBool(SecurePreferencesUtil.isLoggedInKey) ?? false;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
