import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../models/dashboard/fresh_picks_models/e_com_tags_models.dart';

class EComTagProvider with ChangeNotifier {
  ///  +++++++++++++++++++++++++++++++++++++++++   E-COM TOP BANNER  +++++++++++++++++++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  EcomTag? _ecomTag;
  bool _isLoading = false;

  EcomTag? get ecomTag => _ecomTag;

  bool get isLoading => _isLoading;

  Future<void> fetchEcomTagData(
    String slug,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.eComBanner}$slug';
    try {
      final response = await _apiResponseHandler.getRequest(url);
      if (response.statusCode == 200) {
        final jsonData = response.data;
        _ecomTag = EcomTag.fromJson(jsonData['data']);
      } else {}
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///   ++++++++++++++++++++++++++++   E-COM PRODUCTS PROVIDER +++++++++++++++++++++++++++++++++

  List<Records> _products = [];

  // Pagination? _pagination;
  bool _isMoreLoading = false;

  ProductFiltersModel? _productFilters;

  List<Records> get products => _products;

  bool get isMoreLoading => _isMoreLoading;

  ProductFiltersModel? get productFilters => _productFilters;

  Future<void> fetchEComProductsNew(
    BuildContext context, {
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required String slug,
  }) async {
    // _isLoading = false;

    if (page == 1) {
      _isMoreLoading = true;
    } else {}
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

    final baseUrl = '${ApiEndpoints.productsECom}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(url);
      if (response.statusCode == 200) {
        // final jsonData = response.data;
        // final jsonResponse = NewProductsModels.fromJson(jsonData).data?.records ?? [];

        final Map<String, dynamic> jsonResponse = response.data;
        final EComProductsModels apiResponse = EComProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = apiResponse.data?.records ?? [];
          // _pagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _products.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }
      } else {}
    } catch (error) {
      debugPrint(error.toString());
    }
    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }

  ///   ++++++++++++++++++++++++++++   E-COM PACKAGES PROVIDER +++++++++++++++++++++++++++++++++

  List<Records> _packages = [];

  // Pagination? _paginationPackage;

  bool _isPackagesLoading = false;

  List<Records> get packages => _packages;

  bool get isPackagesLoading => _isPackagesLoading;

  Future<void> fetchEComPackagesNew(
    BuildContext context, {
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    required String slug,
  }) async {
    _isPackagesLoading = true;
    notifyListeners();

    // final url = Uri.parse('https://apistaging.theevents.ae/api/v1/tag-packages/$slug?per-page=$perPage&page=$page&sort-by=$sortBy');
    final url = '${ApiEndpoints.packagesECom}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';

    try {
      final response = await _apiResponseHandler.getRequest(url);
      if (response.statusCode == 200) {
        // final jsonData = response.data;
        // final jsonResponse = NewProductsModels.fromJson(jsonData).data?.records ?? [];

        final Map<String, dynamic> jsonResponse = response.data;
        final EComProductsModels apiResponse = EComProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _packages = apiResponse.data?.records ?? [];
          // _paginationPackage = apiResponse.data?.pagination;
        } else {
          _packages.addAll(apiResponse.data?.records ?? []);
        }
      } else {}
    } catch (error) {
      debugPrint(error.toString());
    }
    _isPackagesLoading = false;
    notifyListeners();
  }
}
