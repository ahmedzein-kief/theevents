import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_endpoints/api_end_point.dart';
import '../../models/dashboard/feature_categories_model/feature_category_banner_model.dart';

class FeatureCategoryRepository {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  /// +++++++++++++++++++++   FEATURED CATEGORY BANNER  ----------------------------------
  Future<PageData> featureCategoryBanner(BuildContext context) async {
    try {
      final tokenLogin = await SecurePreferencesUtil.getToken();
      const url = ApiEndpoints.categoryViewAllBanner;
      final headers = {
        'Authorization': 'Bearer $tokenLogin',
      };

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        authService: true,
      );
      if (response['status']) {
        return PageData.fromJson(response['data']);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow; // Rethrow to handle it in the provider
    }
  }

  /// +++++++++++++++++++++   ORDER SCREENS BANNER  ----------------------------------

  Future<PageData> orderScreenBanner() async {
    try {
      final tokenLogin = await SecurePreferencesUtil.getToken();
      const url = ApiEndpoints.orderScreenBanner;
      final headers = {
        'Authorization': 'Bearer $tokenLogin',
      };
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        authService: true,
      );
      if (response['status']) {
        return PageData.fromJson(response['data']);
      } else {
        throw Exception(response['message']);
      }
    } catch (e) {
      rethrow; // Rethrow to handle it in the provider
    }
  }
}
