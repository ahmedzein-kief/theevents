// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
//
// import 'package:event_app/utils/apiendpoints/api_end_point.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../../models/dashboard/home_top_brands_models.dart';
// import '../../core/utils/custom_toast.dart';
// import '../../utils/storage/shared_preferences_helper.dart';
//
// class ApiService {
//   /// +++++++++++++++++++++++++++++++++ Common request handler   +++++++++++++++++++++++++++++++++
//   Future<Map<String, dynamic>> _handleResponse(http.Response response) async {
//     final responseBody = json.decode(utf8.decode(response.bodyBytes));
//
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
//   /// ++++++++++++++++++++++++++++++++ POST Request function  ++++++++++++++++++++++++++++++++
//   Future<Map<String, dynamic>> postRequest(String endpoint, Map<String, String> body) async {
//     try {
//       final response = await http
//           .post(
//             Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
//             headers: <String, String>{
//               'Content-Type': 'application/json; charset=UTF-8',
//             },
//             body: jsonEncode(body),
//           )
//           .timeout(const Duration(seconds: 15)); // Timeout
//
//       return _handleResponse(response); // Call common handler
//     } catch (e) {
//       return _handleException(e);
//     }
//   }
//
//   Future<dynamic> getRequest(String endpoint, BuildContext context) async {
//     try {
//       final tokenLogin = await SharedPreferencesUtil.getToken();
//       final response = await http.get(
//         Uri.parse('${ApiEndpoints.baseUrl}$endpoint'),
//         headers: <String, String>{
//           'Authorization': 'Bearer $tokenLogin',
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final result = await _handleResponse(response);
//         if (!result['status']) {
//           CustomSnackbar.showError(context, result['message']);
//         }
//         return result;
//       } else {
//         CustomSnackbar.showError(context, 'Error fetching data: ${response.statusCode}');
//       }
//     } catch (e) {
//       final exceptionResult = _handleException(e);
//       CustomSnackbar.showError(context, exceptionResult['message']);
//     }
//     return null; // Return null if there was an error
//   }
//
//   /// ++++++++++++++++++++++++++++++++++++ Combined Exception Handler     +++++++++++++++++++++++++++++++++++++++++++++++++
//   Map<String, dynamic> _handleException(Object e) {
//     if (e is SocketException) {
//       return {
//         'status': false,
//         'message': 'No internet connection. Please check your network settings.',
//       };
//     } else if (e is TimeoutException) {
//       return {
//         'status': false,
//         'message': 'Request timed out. Please try again.',
//       };
//     } else {
//       return {
//         'status': false,
//         'message': 'An error occurred: ${e.toString()}',
//       };
//     }
//   }
//
//   ///    +++++++++++++++++++++++++++++++++++++++++    top ten brands +++++++++++++++++++++++++++++++++++++++++++++++++
//   Future<HomeTopBrandsModels> fetchTopBrands() async {
//     final response = await http.get(Uri.parse(ApiEndpoints.featuredBrandsSlide));
//
//     if (response.statusCode == 200) {
//       return HomeTopBrandsModels.fromJson(json.decode(response.body));
//     } else {
//       throw Exception('');
//     }
//   }
// }
