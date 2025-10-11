import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

import '../core/helper/di/locator.dart';

class ApiResponseHandler {
  ApiResponseHandler({Dio? dio}) : dio = dio ?? locator.get<Dio>();
  final Dio dio;

  Future<dynamic> getRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic>? extra,
    Map<String, String> queryParams = const {},
    bool authService = false,
    ResponseType? responseType,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          responseType: responseType,
          extra: extra,
        ),
      );

      return authService ? _handleDioResponse(response) : response;
    } catch (e) {
      // Preserve AuthException so it can be handled by the caller
      if (e is DioException && e.error is AuthException) {
        throw e.error as AuthException;
      }
      throw authService ? _handleException(e) : Exception('Error during API request: $e');
    }
  }

  Future<dynamic> putRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    String bodyString = '',
    Map<String, dynamic>? extra,
  }) async {
    try {
      final dynamic data = body.isNotEmpty
          ? body
          : bodyString.isNotEmpty
              ? bodyString
              : null;

      final response = await dio.put(
        url,
        data: data,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          extra: extra,
          validateStatus: (status) {
            return status! < 500; // Only reject server errors (5xx)
          },
        ),
      );

      return response;
    } catch (e) {
      // Preserve AuthException
      if (e is DioException && e.error is AuthException) {
        throw e.error as AuthException;
      }
      throw Exception('Error during API request: $e');
    }
  }

  Future<dynamic> deleteRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic>? extra,
    Map<String, String> queryParams = const {},
  }) async {
    try {
      final response = await dio.delete(
        url,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(headers: headers.isNotEmpty ? headers : null, extra: extra),
      );

      return response;
    } catch (e) {
      // Preserve AuthException
      if (e is DioException && e.error is AuthException) {
        throw e.error as AuthException;
      }
      throw Exception('Error during API request: $e');
    }
  }

  Future<dynamic> postRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    Map<String, dynamic>? extra,
    String bodyString = '',
    Map<String, dynamic> queryParams = const {},
    bool authService = false,
  }) async {
    try {
      final dynamic data = body.isNotEmpty
          ? body
          : bodyString.isNotEmpty
              ? bodyString
              : null;

      final response = await dio.post(
        url,
        data: data,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
        options: Options(
          headers: headers.isNotEmpty ? headers : null,
          extra: extra,
          validateStatus: (status) {
            return status! < 500; // Only reject server errors (5xx)
          },
        ),
      );

      return authService ? _handleDioResponse(response) : response;
    } catch (e) {
      // Preserve AuthException so it can be handled by the caller
      if (e is DioException && e.error is AuthException) {
        throw e.error as AuthException;
      }
      throw authService ? _handleException(e) : Exception('Error during API request: $e');
    }
  }

  Exception _handleException(Object e) {
    if (e is SocketException) {
      return Exception(
        'No internet connection. Please check your network settings.',
      );
    } else if (e is TimeoutException) {
      return Exception('Request timed out. Please try again.');
    } else if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
            'Connection timeout. Please check your internet connection.',
          );
        case DioExceptionType.connectionError:
          return Exception(
            'No internet connection. Please check your network.',
          );
        case DioExceptionType.badResponse:
          final message = e.response?.data?['message'] ?? 'Request failed';
          return Exception('Server error: $message');
        default:
          return Exception('Network error: ${e.message}');
      }
    } else {
      return Exception('An error occurred: ${e.toString()}');
    }
  }

  Future<Response<dynamic>> postDioMultipartRequest(
    String url, {
    required FormData formData,
    Map<String, String>? headers,
    Map<String, dynamic>? extra,
  }) {
    try {
      return dio.post(
        url,
        data: formData,
        options: Options(
          method: 'POST',
          headers: headers,
          contentType: 'multipart/form-data',
          extra: extra,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        final errorDetails = e.response?.data;
        log(errorDetails.toString());
      }
      throw Exception('Dio request failed: $e');
    }
  }

  Future<Response<dynamic>> getDioRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic>? extra,
    ResponseType? responseType,
  }) {
    try {
      return dio.get(
        url,
        options: Options(
          method: 'GET',
          headers: headers,
          responseType: responseType,
          extra: extra,
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _handleDioResponse(Response response) async {
    final responseBody = response.data is String ? json.decode(response.data) : response.data;
    switch (response.statusCode) {
      case HttpStatus.ok:
        return {
          'status': true,
          'data': responseBody,
        };
      case HttpStatus.badRequest:
        return {
          'status': false,
          'message': 'Bad request. Please check your input.',
        };
      case HttpStatus.unauthorized:
        return {
          'status': false,
          'message': 'Unauthorized. Please check your credentials.',
        };
      case HttpStatus.forbidden:
        return {
          'status': false,
          'message': 'Forbidden. You do not have permission to access this resource.',
        };
      case HttpStatus.internalServerError:
        return {
          'status': false,
          'message': 'Internal server error. Please try again later.',
        };
      default:
        final errorMessages = responseBody['message'] ?? 'Unknown error occurred';
        return {'status': false, 'message': errorMessages};
    }
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() => message;
}
