import 'package:dio/dio.dart';

import '../services/shared_preferences_helper.dart'; // adjust path as needed

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

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async =>
      handler.next(error);
}
