import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/user_by_type_model/userbytype_packages_models.dart';
import '../../models/product_packages_models/product_models.dart';

class ProductProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<RecordProduct> _products = [];
  ProductModels? _ProductsModels;
  PaginationPagination? _productPagination;
  bool _isLoadingProducts = false;

  bool get isLoadingProducts => _isLoadingProducts;
  ProductFiltersModel? _productFilters;

  bool _isMoreLoading = false;

  ProductModels? get productsModels => _ProductsModels;

  bool get isMoreLoading => _isMoreLoading;

  List<RecordProduct> get products => _products;

  ProductFiltersModel? get productFilters => _productFilters;

  Future<void> fetchProducts(
    BuildContext context, {
    required int storeId,
    int perPage = 12,
    int page = 1,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
  }) async {
    if (page == 1) {
      // _isLoading = true;
      _products.clear();
      _isLoadingProducts = true;
    } else {
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

    final baseUrl = '${ApiEndpoints.userByTypeProducts}?per-page=$perPage&page=$page&sort-by=$sortBy&store_id=$storeId';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final Map<String, dynamic> jsonResponse = response.data;
        final ProductModels products = ProductModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = products.data?.records ?? [];
          _productPagination = products.data?.pagination;
          _productFilters = products.data?.filters;
        } else {
          _products.addAll(products.data?.records ?? []);
          _productFilters = products.data?.filters;
        }
      } else {
        throw Exception('');
      }
    } finally {
      _isLoadingProducts = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  ///  packges

  List<Records> _records = [];
  Pagination? _brandsPagination;
  TopBrandsProducts? _topBrandsProducts;
  bool _isLoadingPackages = false;
  final bool _isMoreLoadingProducts = false;

  List<Records> get records => _records;

  TopBrandsProducts? get topBrandsProducts => _topBrandsProducts;

  bool get isLoadingPackages => _isLoadingPackages;

  Future<void> fetchPackages(
    BuildContext context, {
    required int storeId,
    int perPage = 12,
    int page = 1,
    String sortBy = 'default_sorting',
  }) async {
    if (page == 1) {
      // _isLoading = true;
      _records.clear();
      _isLoadingPackages = true;
    }
    notifyListeners();

    final url = '${ApiEndpoints.userByTypePackages}?per-page=$perPage&page=$page&sort-by=$sortBy&store_id=$storeId';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final Map<String, dynamic> jsonResponse = response.data;
        final TopBrandsProducts apiResponse = TopBrandsProducts.fromJson(jsonResponse);

        if (page == 1) {
          _records = apiResponse.data?.records ?? [];
          _brandsPagination = apiResponse.data?.pagination;
        } else {
          _records.addAll(apiResponse.data?.records ?? []);
        }
      } else {
        throw Exception('');
      }
    } finally {
      _isLoadingPackages = false;
      notifyListeners();
    }
  }
}

//    https://newapistaging.theevents.ae/api/v1/vendor-data/102
