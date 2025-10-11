import 'package:dio/dio.dart';

abstract class DioBaseApiServices {
  Future<dynamic> dioGetApiService({
    required String url,
    required Map<String, String>? headers,
    Map<String, String>? queryParams, // Optional query parameters
  });

  Future<dynamic> dioPostApiService({
    required String url,
    required Map<String, String> headers,
    required body,
  });

  Future<dynamic> dioPutApiService({
    required String url,
    required Map<String, String> headers,
    required body,
  });

  // known as update in http
  Future<dynamic> dioPatchApiService({
    required String url,
    required Map<String, String> headers,
    required body,
  });

  Future<dynamic> dioDeleteApiService({
    required String url,
    required Map<String, String> headers,
  });

  Future<dynamic> dioMultipartApiService({
    required String method,
    required String url,
    required FormData data,
    required Map<String, String> headers,
  });
}
