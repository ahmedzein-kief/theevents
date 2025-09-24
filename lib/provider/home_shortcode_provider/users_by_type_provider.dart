import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/dashboard/user_by_type_model/user_type_inner_page_banner_models.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../models/dashboard/user_by_type_model/home_celebraties_models.dart';

class UsersByTypeProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  String errorMessage = '';
  Map<int, List<Records>> recordsByTypeId = {};
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  Future<void> fetchCelebrities(BuildContext context, {required data}) async {
    final typeId = int.tryParse(data['attributes']['type_id'].toString()) ?? 0;
    final limit = data['attributes']['limit'].toString();
    // final url = Uri.parse('https://newapistaging.theevents.ae/api/v1/customers-by-type/$typeId');
    final url = '${ApiEndpoints.customerByType}/$typeId';

    // final params = {'limit': limit};
    final params = {'limit': '6'};

    notifyListeners();

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: params,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final HomeCelebratiesModels homeCelebratiesModels = HomeCelebratiesModels.fromJson(responseData);
        final List<Records> fetchedRecords = homeCelebratiesModels.data?.records ?? [];

        // Save data based on type_id
        recordsByTypeId[typeId] = fetchedRecords;

        errorMessage = '';
      } else {
        errorMessage = 'Failed to load data: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  List<Records> getRecordsByTypeId(int typeId) => recordsByTypeId[typeId] ?? [];

//     ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ PROVIDER FOR THE USER TYPES BANNER PAGE +++++++++++++++++++++++++

  UserData? _userData;

  UserData? get userData => _userData;

  Future<void> fetchUserData(BuildContext context, int id) async {
    _isLoading = true;
    notifyListeners();
    final url = '${ApiEndpoints.homeVendorData}$id';
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final json = response.data;
        _userData = UserModel.fromJson(json).data;
      } else {
        // Handle error
        throw Exception('Failed to load user data');
      }
    } catch (e) {
      // Handle error
      throw Exception('Failed to load user data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
