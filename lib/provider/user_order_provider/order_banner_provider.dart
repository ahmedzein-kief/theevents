import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiStatus/api_status.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repository/featured_category_repository.dart';
import '../../models/dashboard/feature_categories_model/feature_category_banner_model.dart';

class UserOrderProvider extends ChangeNotifier {
  ///   =====================================================   ORDERS SCREEN BANNER  =====================================================

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  PageData? _pageData;

  PageData? get pageData => _pageData;

  final _authRepository = FeatureCategoryRepository();
  ApiStatus _apiStatus = ApiStatus.loading;

  ApiStatus get apiStatus => _apiStatus;

  Future<void> fetchOrderBanner(BuildContext context) async {
    if (pageData != null) return;
    _apiStatus = ApiStatus.loading;
    notifyListeners();
    try {
      final pageData = await _authRepository.orderScreenBanner(context);
      _pageData = pageData;
      _apiStatus = ApiStatus.completed;
    } catch (e) {
      _pageData = null;
      _apiStatus = ApiStatus.error;
    }
    notifyListeners();
  }
}
