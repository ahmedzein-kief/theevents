import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/feature_categories_model/featured_category_products_models.dart';
import '../../models/dashboard/feature_categories_model/product_category_model.dart';

class FeaturedCategoriesDetailProvider with ChangeNotifier {
  ///  ++++++++++++++++++++++++++++++++++++  FEATURED CATEGORIES BANNER +++++++++++++++++++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  ProductCategoryBanner? _productCategoryBanner;
  bool _isLoading = false;

  ProductCategoryBanner? get productCategoryBanner => _productCategoryBanner;

  bool get isLoading => _isLoading;

  Future<void> fetchFeaturedCategoryBanner(BuildContext context,
      {required String slug,}) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.categoryBanner}$slug';
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        _productCategoryBanner = ProductCategoryBanner.fromJson(data);
      } else {
        throw Exception('Failed to load data');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///      ++++++++++++++++++++++++++++++++++++++++++++++++   FeaturedCategoryInnerProductProvider +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  List<Record> _recordsProducts = [];
  Pagination? _paginations;
  bool _isMoreLoading = false;
  bool _isLoadingProducts = false;
  ProductFiltersModel? _productFilters;

  List<Record> get recordsProducts => _recordsProducts;

  bool get isLoadingProducts => _isLoadingProducts;

  ProductFiltersModel? get productFilters => _productFilters;

  Future<void> fetchCategoryProducts(
    BuildContext context, {
    required String slug,
    int perPage = 12,
    int page = 1,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
  }) async {
    if (page == 1) {
      _recordsProducts.clear();
      _productFilters = null;
      _isLoadingProducts = true;
    } else {
      _productFilters = null;
      _isMoreLoading = true;
    }

    notifyListeners();

    // Convert selectedFilters to query parameters
    final String filtersQuery = filters.entries
        .where((entry) => entry.value.isNotEmpty) // Exclude empty lists
        .map((entry) {
      if (entry.key == 'Prices') {
        // Handle Price range specifically
        final int minPrice = entry.value[0];
        final int maxPrice = entry.value[1];
        return 'min_price=$minPrice&max_price=$maxPrice';
      } else {
        // Handle all other filters
        return entry.value.map((id) {
          if (entry.key.toLowerCase() == 'Colors'.toLowerCase()) {
            return 'attributes[${entry.key.toLowerCase()}][]=$id';
          } else {
            return '${entry.key.toLowerCase()}[]=$id';
          }
        }).join('&');
      }
    }).join('&');

    final baseUrl =
        '${ApiEndpoints.categoryProducts}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty
        ? '$baseUrl&$filtersQuery&allcategories=1'
        : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final FeaturedCategoryProductsModels apiResponse =
            FeaturedCategoryProductsModels.fromJson(jsonResponse);
        if (page == 1) {
          _recordsProducts = apiResponse.data.records;
          _paginations = apiResponse.data.pagination;
          _productFilters = apiResponse.data.filters;
        } else {
          _recordsProducts.addAll(apiResponse.data.records);
          _productFilters = apiResponse.data.filters;
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingProducts = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  ///      ++++++++++++++++++++++++++++   FeaturedCategoryInnerPackagesProvider +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  List<Record> _recordsPackages = [];

  bool _isLoadingPackages = false;

  List<Record> get recordsPackages => _recordsPackages;

  bool get isLoadingPackages => _isLoadingPackages;

  Future<void> fetchCategoryPackages(
    BuildContext context, {
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    required String slug,
  }) async {
    notifyListeners();

    if (page == 1) {
      _recordsPackages.clear();
      _isLoadingPackages = true;
    } else {}
    notifyListeners();

    final url =
        '${ApiEndpoints.categoryPackages}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';

    print(url);

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      print(response.statusCode);

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final FeaturedCategoryProductsModels apiResponse =
            FeaturedCategoryProductsModels.fromJson(jsonResponse);
        print(apiResponse.data.records);
        notifyListeners();

        if (page == 1) {
          _recordsPackages = apiResponse.data.records;
          _paginations = apiResponse.data.pagination;
          notifyListeners();
        } else {
          _recordsPackages.addAll(apiResponse.data.records);
          notifyListeners();
        }

        // _records = apiResponse.data.records;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      print(error.toString());
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }
}
