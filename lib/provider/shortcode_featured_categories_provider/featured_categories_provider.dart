import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../data/repository/featured_category_repository.dart';
import '../../models/dashboard/feature_categories_model/feature_category_banner_model.dart';
import '../../models/dashboard/feature_categories_model/feature_category_view_all_models.dart';
import '../../models/dashboard/feature_categories_model/featured_categories_models.dart';

class FeaturedCategoriesProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  // =================================================================    Featured Categories   Home Page =================================================================
  FeaturedCategoriesModels? _gifts;
  bool _loading = false;
  String? _errorMessage;

  FeaturedCategoriesModels? get gifts => _gifts;

  bool get loading => _loading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchGiftsByOccasion(
    BuildContext context, {
    required data,
  }) async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    final String shortcode = data['shortcode'].replaceAll('shortcode-', '');

    final String url = '${ApiEndpoints.baseUrl}$shortcode';

    try {
      final response = await _apiResponseHandler.getRequest(url);

      if (response.statusCode == 200) {
        _gifts = FeaturedCategoriesModels.fromJson(response.data);
      } else {
        _errorMessage = AppStrings.failedToLoadData.tr;
      }
    } catch (error) {
      _errorMessage = 'Please Turn on Device Internet';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  ///   =====================================================   Featured categories Banner See All Categories     =====================================================

  PageData? _pageData;

  PageData? get pageData => _pageData;

  final _authRepository = FeatureCategoryRepository();

  Future<void> fetchPageData(BuildContext context) async {
    if (pageData != null) return;
    _loading = true;
    notifyListeners();
    try {
      final pageData = await _authRepository.featureCategoryBanner(context);
      _pageData = pageData;
    } catch (e) {
      _pageData = null;
    }
    _loading = false;
    notifyListeners();
  }

//      +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  Featured Category View All inner models

  List<Category> categories = [];
  bool isLoading = false;

  // Pagination? _paginationCategory;
  bool _isMoreLoading = false;

  bool get isMoreLoading => _isMoreLoading;

  List<Category> get products => categories;

  Future<void> fetchCategories(
    BuildContext context, {
    String sortBy = 'default_sorting',
    int page = 1,
    int perPage = 12,
  }) async {
    if (page == 1) {
      isLoading = true;
      notifyListeners();
    } else {
      _isMoreLoading = true;
      notifyListeners();
    }

    final url = '${ApiEndpoints.categoryViewAllItems}?per_page=$perPage&page=$page&sort-by=$sortBy';

    final response = await _apiResponseHandler.getRequest(url);

    if (response.statusCode == 200) {
      final jsonResponse = response.data;
      final CategoryResponse categoryResponse = CategoryResponse.fromJson(jsonResponse);

      if (page == 1) {
        categories = categoryResponse.data.records;
        // _paginationCategory = categoryResponse.data.pagination;
      } else {
        categories.addAll(categoryResponse.data.records);
        // _paginationCategory = categoryResponse.data.pagination;
      }
    } else {
      throw Exception('Failed to load categories');
    }

    isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }
}
