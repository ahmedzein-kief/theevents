import 'dart:io';

import 'package:dio/dio.dart';

import '../services/shared_preferences_helper.dart';
import 'api_endpoints/api_contsants.dart'; // adjust path as needed

class ApiInterceptor implements Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) => handler.next(response);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final langCode = SecurePreferencesUtil.getLanguage();

    if (langCode != null && langCode != 'en') {
      options.queryParameters['language'] = langCode;
    }

    // Add Authorization header if endpoint requires authentication
    if (options.extra.containsKey(ApiConstants.requireAuthKey)) {
      final accessToken = await SecurePreferencesUtil.getToken();
      options.headers[HttpHeaders.authorizationHeader] = accessToken;
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async =>
      handler.next(error);
}
