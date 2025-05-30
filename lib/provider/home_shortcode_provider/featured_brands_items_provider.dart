import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../models/dashboard/home_brands_types_items_models.dart';

class FeaturedBrandsItemsProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  HomeBrandsTypesModels? homeBrandsTypes;
  bool isLoading = false;
  bool hasError = false;

  Future<HomeBrandsTypesModels?> fetchHomeBrands(List<int> ids, BuildContext context) async {
    const String url = 'https://api.staging.theevents.ae/api/v1/ecom-tags';
    final queryParameters = {
      'ids': ids.map((id) => id.toString()).join(','), // Join IDs with a comma
      // Add any other parameters needed, for example:
      // 'shortcode': 'shortcode-two-tags-blocks-with-ad',
    };

    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: queryParameters,
        context: context,
      );

      if (response.statusCode == 200) {
        homeBrandsTypes = HomeBrandsTypesModels.fromJson(json.decode(response.body));
        isLoading = false;
        hasError = false;
        notifyListeners();
        return homeBrandsTypes;
      } else {
        isLoading = false;
        hasError = true;
        notifyListeners();
        throw Exception('Failed to load data with status code: ${response.statusCode}');
      }
    } catch (e) {
      isLoading = false;
      hasError = true;
      notifyListeners();// Log the error for debugging
      throw Exception('Failed to load data');
    }
  }
}
