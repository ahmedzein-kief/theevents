import 'dart:io';

import 'package:dio/dio.dart';

import '../../../../../core/helper/di/locator.dart';
import '../../app_exceptions.dart';
import 'DioBaseApiServices.dart';

class DioNetworkApiServices extends DioBaseApiServices {
  // DioNetworkApiServices() {
  //   // Initialize Logger
  //   _dio.interceptors.add(
  //     InterceptorsWrapper(
  //       onRequest: (options, handler) {
  //         logger.i('Request: ${options.method} ${options.uri}');
  //         logger.i('Request Headers: ${options.headers}');
  //         logger.d('Request Data: ${options.data}');
  //         return handler.next(options);
  //       },
  //       onResponse: (response, handler) {
  //         logger.d('Response Status: ${response.statusCode}');
  //         logger.d('Response Data: ${response.data}');
  //         return handler.next(response);
  //       },
  //       onError: (DioException e, handler) {
  //         logger.e('Error: ${e.message}');
  //         if (e.response != null) {
  //           logger.e('Error Response Status: ${e.response?.statusCode}');
  //           logger.e('Error Response Data: ${e.response?.data}');
  //         }
  //         return handler.next(e);
  //       },
  //     ),
  //   );
  // }

  // final Dio _dio = Dio();

  // final logger = Logger();

  DioNetworkApiServices({Dio? dio}) : _dio = dio ?? locator.get<Dio>();
  final Dio _dio;

  @override
  Future<dynamic> dioGetApiService({
    required String url,
    required Map<String, dynamic>? headers,
    Map<String, String?>? queryParams,
  }) async {
    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
          extra: {
            'cache': true, // Enable cache for this request
          },
        ),
        queryParameters: queryParams,
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<dynamic> dioPostApiService({
    required String url,
    required Map<String, dynamic> headers,
    required body,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<dynamic> dioPutApiService({
    required String url,
    required Map<String, dynamic> headers,
    required body,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<dynamic> dioPatchApiService({
    required String url,
    required Map<String, dynamic> headers,
    required body,
  }) async {
    try {
      final response = await _dio.patch(
        url,
        data: body,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<dynamic> dioDeleteApiService({
    required String url,
    required Map<String, dynamic> headers,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        options: Options(
          headers: headers,
          responseType: ResponseType.json,
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<dynamic> dioMultipartApiService({
    required String method,
    required String url,
    required FormData data,
    required Map<String, String> headers,
  }) async {
    try {
      final response = await _dio.request(
        url,
        data: data,
        options: Options(
          headers: headers,
          method: method,
          responseType: ResponseType.json,
        ),
      );
      return _handleResponse(response);
    } catch (e) {
      throw _handleError(e);
    }
  }

  dynamic _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
        return response.data;
      case 400:
        throw BadRequestException(_errorMessage(response));
      case 401:
        throw UnAuthorizedException(_errorMessage(response));
      case 404:
        throw UserNotFoundException(_errorMessage(response));
      case 422:
        // Handle 422 Unprocessable Entity
        throw BadRequestException(_errorMessage(response));
      case 429:
        throw TooManyRequestsException(_errorMessage(response));
      case 500:
        throw InternalServerErrorException(_errorMessage(response));
      default:
        throw FetchDataException(
            'Error occurred while communicating with server with status code ${response.statusCode}',);
    }
  }

  AppExceptions _handleError(error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return FetchDataException('Connection timeout');
        case DioExceptionType.sendTimeout:
          return FetchDataException('Send timeout');
        case DioExceptionType.receiveTimeout:
          return FetchDataException('Receive timeout');
        case DioExceptionType.badResponse:
          // Check for status code 422 specifically
          //   if (error.response?.statusCode == 422) {
          if (error.response?.statusCode != null) {
            return ValidationException(_errorMessage(error.response!));
          }
          return FetchDataException(
              'Received invalid status code: ${error.response?.statusCode}',);
        case DioExceptionType.cancel:
          return FetchDataException('Request cancelled');
        case DioExceptionType.badCertificate:
          return FetchDataException('Certification Error');
        case DioExceptionType.connectionError:
          return FetchDataException('Connection Error occurred');
        case DioExceptionType.unknown:
          // return FetchDataException('Unexpected error: ${error.message}');
          return FetchDataException(' ${error.message}');
      }
    } else if (error is SocketException) {
      return FetchDataException(error.message);
    } else if (error is FormatException) {
      return FetchDataException('Response format error: $error');
    } else {
      // return AppExceptions('Unexpected Error', error.toString());
      return AppExceptions('', error.toString());
    }
  }

  String _errorMessage(Response response) {
    try {
      // If errors field exists, extract detailed error messages
      if (response.data != null) {
        final errorData = response.data;
        final errors = errorData['errors'];
        final error = errorData['error'];
        final message = errorData['message'];

        // Initialize a variable to store error messages
        String allErrors = '';

        // Check if `errors` is present and process it
        if (errors != null && errors is Map) {
          errors.forEach((key, value) {
            if (value is List) {
              for (final msg in value) {
                allErrors += '$key: $msg\n'; // Append each error message
              }
            }
          });
        }

        // Check if `error` is present and append it
        if (error != null && error is String) {
          allErrors += 'Error: $error\n';
        }

        // Check if `message` is present and append it
        if (message != null && message is String && errors == null) {
          allErrors += 'Message: $message\n';
        }

        // Return the collected error messages
        if (allErrors.isNotEmpty) {
          return allErrors.trim(); // Remove trailing newline
        }

        return 'An unknown error occurred.'; // Fallback message if no errors are found
      }

      return 'Unknown error occurred';
    } catch (e) {
      return 'Unknown error occurred with status code: ${response.statusCode}';
    }
  }
}
