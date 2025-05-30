import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../views/auth_screens/auth_page_view.dart';

class ApiResponseHandler {
  Future<dynamic> getRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, String> queryParams = const {},
    bool authService = false,
    required BuildContext context,
  }) async {
    try {
      Uri uri = queryParams.isNotEmpty ? Uri.parse(url).replace(queryParameters: queryParams) : Uri.parse(url);

      Map<String, String>? headersOrNull = headers.isNotEmpty ? headers : null;

      final response = await http.get(uri, headers: headersOrNull);

      if (response.statusCode != 401) {
        return authService ? _handleResponse(response) : response;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
        throw HttpException('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw authService ? _handleException(e) : Exception('Error during API request: $e');
    }
  }

  Future<dynamic> deleteRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, String> queryParams = const {},
  }) async {
    try {
      Uri uri = queryParams.isNotEmpty ? Uri.parse(url).replace(queryParameters: queryParams) : Uri.parse(url);

      Map<String, String>? headersOrNull = headers.isNotEmpty ? headers : null;

      final response = await http.delete(uri, headers: headersOrNull);

      if (response.statusCode != 401) {
        return response;
      } else {
        throw HttpException('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }

  Future<dynamic> postRequest(
    String url, {
    Map<String, String> headers = const {},
    Map<String, dynamic> body = const {},
    String bodyString = "",
    Map<String, dynamic> queryParams = const {},
    bool authService = false,
  }) async {
    try {
      Uri uri = queryParams.isNotEmpty ? Uri.parse(url).replace(queryParameters: queryParams) : Uri.parse(url);

      Map<String, String>? headersOrNull = headers.isNotEmpty ? headers : null;
      dynamic bodyOrNull = body.isNotEmpty
          ? body
          : bodyString.isNotEmpty
              ? bodyString
              : null;

      final response = await http.post(uri, headers: headersOrNull, body: bodyOrNull);


      if (response.statusCode != 401) {
        return authService ? _handleResponse(response) : response;
      } else {
        throw HttpException('Failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      throw authService ? _handleException(e) : Exception('Error during API request: $e');
    }
  }

  Future<Response<dynamic>> postDioMultipartRequest(
    String url,
    Map<String, String> headers,
    FormData formData,
  ) {
    // Make Dio request
    final dio = Dio();
    try {
      return dio.post(
        url,
        data: formData,
        options: Options(
          method: "POST",
          headers: headers,
          contentType: 'multipart/form-data',
        ),
      );
    } catch (e) {
      if (e is DioException) {
        final errorDetails = e.response?.data;

      } else {

      }
      // Re-throw the exception or return a dummy response if needed
      throw Exception('Dio request failed: $e');
    }
  }

  Future<Response<dynamic>> getDioRequest(
    String url, {
    Map<String, String> headers = const {},
    ResponseType? responseType = null,
  }) {
    // Make Dio request
    final dio = Dio();

    try {
      return dio.get(
        url,
        options: Options(
          method: "GET",
          headers: headers,
          responseType: responseType,
        ),
      );
    } catch (e) {
      if (e is DioException) {
        final errorDetails = e.response?.data;

      } else {

      }
      // Re-throw the exception or return a dummy response if needed
      throw Exception('Dio request failed: $e');
    }
  }

  Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
    final responseBody = json.decode(utf8.decode(response.bodyBytes));

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

  Map<String, dynamic> _handleException(Object e) {
    if (e is SocketException) {
      return {
        'status': false,
        'message': 'No internet connection. Please check your network settings.',
      };
    } else if (e is TimeoutException) {
      return {
        'status': false,
        'message': 'Request timed out. Please try again.',
      };
    } else {
      return {
        'status': false,
        'message': 'An error occurred: ${e.toString()}',
      };
    }
  }
}
