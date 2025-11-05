import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../../provider/api_response_handler.dart';
import '../../views/auth_screens/auth_page_view.dart';
import '../constants/app_strings.dart';
import '../services/shared_preferences_helper.dart';
import '../utils/app_utils.dart';
import 'api_endpoints/api_contsants.dart';

class ApiInterceptor implements Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) => handler.next(response);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Check if this is the vendor/meta endpoint
    // final isVendorMetaEndpoint = options.path.contains('vendor/meta') || options.uri.path.contains('vendor/meta');

    // Only add language parameter if NOT vendor/meta endpoint
    // if (!isVendorMetaEndpoint) {
    final langCode = SecurePreferencesUtil.getLanguage();

    if (langCode != null && langCode.isNotEmpty && langCode != 'en') {
      options.queryParameters['language'] = langCode;
    }
    // }

    // Add Authorization header if endpoint requires authentication
    if (options.extra.containsKey(ApiConstants.requireAuthKey)) {
      final accessToken = await SecurePreferencesUtil.getToken();

      if (accessToken == null || accessToken.isEmpty) {
        // No token available, navigate to auth screen
        _navigateToAuthScreen(options);
        return handler.reject(
          DioException(
            requestOptions: options,
            error: AuthException(ApiConstants.noTokenError), // Use AuthException
            type: DioExceptionType.cancel,
          ),
        );
      }

      options.headers[HttpHeaders.authorizationHeader] = accessToken;
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized responses
    if (error.response?.statusCode == 401) {
      // Token is invalid or expired
      await SecurePreferencesUtil.removeToken(); // Optional: clear invalid token
      _navigateToAuthScreen(error.requestOptions);

      return handler.reject(
        DioException(
          requestOptions: error.requestOptions,
          error: AuthException(AppStrings.authenticationFailed.tr), // Use AuthException
          type: DioExceptionType.badResponse,
          response: error.response,
        ),
      );
    }

    return handler.next(error);
  }

  void _navigateToAuthScreen(RequestOptions options) {
    final context = navigatorKey.currentContext;
    if (context != null) {
      AppUtils.showToast(AppStrings.pleaseLogInToContinue.tr);

      // Use pushAndRemoveUntil to clear navigation stack
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }
}
