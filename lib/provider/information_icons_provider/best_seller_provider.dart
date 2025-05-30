import 'dart:convert';

import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/information_icons_models/best_seller_models.dart';

class BestSellerProvider with ChangeNotifier {
  //    ++++++++++++++   BEST SELLER TOP BANNER +++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  CollectionModel? _collection;
  bool _isLoading = false;
  String? _errorMessage;

  CollectionModel? get collection => _collection;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchBannerBestSeller(BuildContext context) async {
    // const url = 'https://api.staging.theevents.ae/api/v1/collections/best-sellers';
    const url = ApiEndpoints.bestSellerBanner;

    try {
      _isLoading = true;
      _errorMessage = null; // Clear any previous errors
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _collection = CollectionModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to load collection data');
      }
    } catch (error) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//   ++++++++++++++++++++++++++++++   BEST SELLER PRODUCTS PROVIDER ++++++++++++++++++++++++++++++

  List<Records> _products = [];
  Pagination? _pagination;
  bool _isMoreLoading = false;
  ProductFiltersModel? _productFilters;

  List<Records> get products => _products;

  bool get isMoreLoading => _isMoreLoading;

  ProductFiltersModel? get productFilters => _productFilters;

  bool _isLoadingProducts = false;

  bool get isLoadingProducts => _isLoadingProducts;

  Future<void> fetchProductsNew({
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required BuildContext context,
  }) async {
    _isLoading = false;

    if (page == 1) {
      _products.clear();
      _isLoadingProducts = true;
    } else {}
    notifyListeners();

    // Convert selectedFilters to query parameters
    String filtersQuery = filters.entries
        .where((entry) => entry.value.isNotEmpty) // Exclude empty lists
        .map((entry) {
      if (entry.key == 'Prices') {
        // Handle Price range specifically
        int minPrice = entry.value[0];
        int maxPrice = entry.value[1];
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

    final baseUrl = '${ApiEndpoints.bestSellerProducts}?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // final jsonResponse = NewProductsModels.fromJson(jsonData).data?.records ?? [];

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final NewProductsModels apiResponse = NewProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = apiResponse.data?.records ?? [];
          _pagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _products.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }
      } else {
      }
    } catch (error) {
    }
    _isLoadingProducts = false;
    // _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }

//   ++++++++++++++++++++++++++++++   BEST SELLER PACKAGES PROVIDER ++++++++++++++++++++++++++++++

  List<Records> _packages = [];
  Pagination? _paginationPackages;

  List<Records> get packages => _packages;

  Future<void> fetchPackagesNew(BuildContext context, {int page = 1, int perPage = 12, String sortBy = 'default_sorting'}) async {
    // _isLoading = false;

    if (page == 1) {
    } else {}
    notifyListeners();

    final url = '${ApiEndpoints.bestSellerPackages}?per-page=$perPage&page=$page&sort-by=$sortBy';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        // final jsonResponse = NewProductsModels.fromJson(jsonData).data?.records ?? [];

        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final NewProductsModels apiResponse = NewProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _packages = apiResponse.data?.records ?? [];
          _paginationPackages = apiResponse.data?.pagination;
        } else {
          _packages.addAll(apiResponse.data?.records ?? []);
        }
      } else {
      }
    } catch (error) {
    }
    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }
}
