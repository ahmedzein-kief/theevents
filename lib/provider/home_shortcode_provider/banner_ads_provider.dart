import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
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

  Future<void> fetchHomeBanner(BuildContext context, {required data}) async {
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
        _homeBannerModels = HomeBottomBannerModels.fromJson(response.data);
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
