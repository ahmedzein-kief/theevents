// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import '../../core/helper/di/locator.dart';
// import '../../core/network/api_endpoints/api_end_point.dart';
// import '../../core/services/shared_preferences_helper.dart';
// import '../../core/utils/custom_toast.dart';
// import '../../models/dashboard/home_top_brands_models.dart';
//
// class ApiService {
//   ApiService({Dio? dio}) : _dio = dio ?? locator.get<Dio>();
//   final Dio _dio;
//
//   Future<Map<String, dynamic>> _handleResponse(Response response) async {
//     final responseBody = response.data is String ? json.decode(response.data) : response.data;
//     switch (response.statusCode) {
//       case HttpStatus.ok:
//         return {
//           'status': true,
//           'data': responseBody,
//         };
//       case HttpStatus.badRequest:
//         return {
//           'status': false,
//           'message': 'Bad request. Please check your input.',
//         };
//       case HttpStatus.unauthorized:
//         return {
//           'status': false,
//           'message': 'Unauthorized. Please check your credentials.',
//         };
//       case HttpStatus.forbidden:
//         return {
//           'status': false,
//           'message': 'Forbidden. You do not have permission to access this resource.',
//         };
//       case HttpStatus.internalServerError:
//         return {
//           'status': false,
//           'message': 'Internal server error. Please try again later.',
//         };
//       default:
//         final errorMessages = responseBody['message'] ?? 'Unknown error occurred';
//         return {'status': false, 'message': errorMessages};
//     }
//   }
//
//   Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, dynamic> body) async {
//     try {
//       final response = await _dio.post(
//         endpoint,
//         data: jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } on DioException catch (e) {
//       return _handleException(e);
//     } catch (e) {
//       return _handleException(e);
//     }
//   }
//
//   Future<dynamic> getRequest(String endpoint, BuildContext context) async {
//     try {
//       final tokenLogin = await SecurePreferencesUtil.getToken();
//       final response = await _dio.get(
//         endpoint,
//         options: Options(
//           headers: {
//             'Authorization': 'Bearer $tokenLogin',
//           },
//         ),
//       );
//       if (response.statusCode == 200) {
//         final result = await _handleResponse(response);
//         if (!result['status']) {
//           CustomSnackbar.showError(context, result['message']);
//         }
//         return result;
//       } else {
//         CustomSnackbar.showError(context, 'Error fetching data: ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       final exceptionResult = _handleException(e);
//       CustomSnackbar.showError(context, exceptionResult['message']);
//     } catch (e) {
//       final exceptionResult = _handleException(e);
//       CustomSnackbar.showError(context, exceptionResult['message']);
//     }
//     return null;
//   }
//
//   Map<String, dynamic> _handleException(Object e) {
//     if (e is DioException) {
//       if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
//         return {
//           'status': false,
//           'message': 'Request timed out. Please try again.',
//         };
//       } else if (e.type == DioExceptionType.connectionError) {
//         return {
//           'status': false,
//           'message': 'No internet connection. Please check your network settings.',
//         };
//       } else {
//         return {
//           'status': false,
//           'message': 'An error occurred: ${e.message}',
//         };
//       }
//     } else {
//       return {
//         'status': false,
//         'message': 'An error occurred: ${e.toString()}',
//       };
//     }
//   }
//
//   Future<HomeTopBrandsModels> fetchTopBrands() async {
//     final response = await _dio.get(ApiEndpoints.featuredBrandsSlide);
//     if (response.statusCode == 200) {
//       return HomeTopBrandsModels.fromJson(response.data);
//     } else {
//       throw Exception('Failed to fetch top brands');
//     }
//   }
// }
