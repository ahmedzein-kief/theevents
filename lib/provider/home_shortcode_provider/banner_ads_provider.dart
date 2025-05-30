import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/home_bottom_banner_models.dart';

class BannerAdsProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  bool _isLoading = false;
  bool _hasError = false;
  HomeBottomBannerModels? _homeBannerModels;

  bool get isLoading => _isLoading;

  bool get hasError => _hasError;

  HomeBottomBannerModels? get homeBannerModels => _homeBannerModels;

  Future<void> fetchHomeBanner(BuildContext context, {required dynamic data}) async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.homeBrands}${data['attributes']['key']}';

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        _homeBannerModels = HomeBottomBannerModels.fromJson(json.decode(response.body));
      } else {
        _hasError = true;
      }
    } catch (error) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
