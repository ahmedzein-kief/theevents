import 'dart:convert';

import 'package:event_app/models/dashboard/featured_top_brands_models/feature_brands_items.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/featured_top_brands_models/feature_top_brand_banner.dart';
import '../../models/dashboard/featured_top_brands_models/featured_brand_products_models.dart';
import '../../models/dashboard/featured_top_brands_models/featured_brands_items_models.dart';
import '../../models/dashboard/home_top_brands_models.dart';

class FeaturedBrandsProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  HomeTopBrandsModels? _topBrands;
  bool _isLoading = false;
  String? _errorMessage;

  HomeTopBrandsModels? get topBrands => _topBrands;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchTopBrands(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    try {
      final url = ApiEndpoints.featuredBrandsSlide;

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        _topBrands = HomeTopBrandsModels.fromJson(json.decode(response.body));
        _errorMessage = null;
      } else {
        throw Exception('');
      }
    } catch (e) {
      _errorMessage = e.toString();
      _topBrands = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///      -------------------------------------------------------   FEATURE BRAND TOP VIEW ALL BANNER ----------------------------------------------------

  BrandsResponse? _featuredBrandsBanner;
  bool _hasError = false;

  BrandsResponse? get featuredBrandsBanner => _featuredBrandsBanner;

  bool get hasError => _hasError;

  Future<void> fetchFeaturedBrands(BuildContext context) async {
    try {
      const url = ApiEndpoints.featureBrandsBanner;
      _isLoading = true;
      notifyListeners();

      _hasError = false;
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _featuredBrandsBanner = BrandsResponse.fromJson(jsonResponse);
        _isLoading = false;
        notifyListeners();
      } else {
        _hasError = true;
      }
    } catch (error) {
      _hasError = true;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///      -------------------------------------------------------   FEATURE BRANDS VIEW ALL ITEMS      ----------------------------------------------------

  List<Brand> _brands = [];
  String? _error;
  bool _isMoreLoading = false;
  PaginationBrands? _pagination;

  bool branLoader = false;

  List<Brand> get brands => _brands;

  String? get error => _error;

  bool get isMoreLoading => _isMoreLoading;

  Future<void> fetchBrandsItems(BuildContext context, {String sortBy = 'default_sorting', int perPage = 12, int page = 1}) async {
    if (page == 1) {
      branLoader = true;
      notifyListeners();
    } else {
      _isMoreLoading = true;
      notifyListeners();
    }

    final url = '${ApiEndpoints.featureBrandsAll}?per-page=$perPage&page=$page&sort-by=$sortBy';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = ApiResponse.fromJson(json.decode(response.body));

        if (page == 1) {
          _brands = data.data.records;
          _pagination = data.data.pagination;
        } else {
          _brands.addAll(data.data.records);
        }
      } else {
        _error = 'Failed to load data';
      }
    } catch (e) {
      _error = 'Failed to load data: $e';
    } finally {
      branLoader = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  ///      -------------------------------------------------------   FEATURED TOP BRANDS BANNER PROVIDER      ----------------------------------------------------

  FeaturedBrand? _brandModel;

  FeaturedBrand? get brandModel => _brandModel;

  Future<void> fetchBrandData(String slug, BuildContext context) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    final url = '${ApiEndpoints.featuredBrands}$slug';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _brandModel = FeaturedBrand.fromJson(data['data'] ?? {});
      } else {
        _error = 'Failed to load data: ${response.statusCode}';
        _brandModel = null;
      }
    } catch (e) {
      _error = 'Error: $e';
      _brandModel = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  FEATURED TOP BRANDS PRODUCTS PROVIDER +++++++++++++++++++++++++++++++++++++++++++++++++

  List<ProductRecords> _records = [];
  BrandsPagination? _brandsPagination;
  TopBrandsProducts? _topBrandsProducts;
  bool _isLoadingProducts = false;
  bool _isMoreLoadingProducts = false;
  ProductFiltersModel? _productFilters;

  List<ProductRecords> get records => _records;

  TopBrandsProducts? get topBrandsProducts => _topBrandsProducts;

  bool get isLoadingProducts => _isLoadingProducts;

  ProductFiltersModel? get productFilters => _productFilters;

  Future<void> fetchBrandsProducts({
    required String slug,
    int perPage = 12,
    page = 1,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required BuildContext context,
  }) async {
    if (page == 1) {
      _records.clear();
      _isLoadingProducts = true;
    }

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

    final baseUrl = '${ApiEndpoints.featuredBrandProducts}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;


    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final TopBrandsProducts apiResponse = TopBrandsProducts.fromJson(jsonResponse);


        if (page == 1) {
          _records = apiResponse.data?.records ?? [];
          _brandsPagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _records.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }

        // _records = apiResponse.data!.records!;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingProducts = false;
      _isMoreLoadingProducts = false;
      notifyListeners();
    }
  }

  ///   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  FEATURED TOP BRANDS PACKAGES PROVIDER +++++++++++++++++++++++++++++++++++++++++++++++++

  List<ProductRecords> _recordsPackages = [];

  List<ProductRecords> get recordsPackages => _recordsPackages;

  bool _isLoadingPackages = false;
  bool _isMoreLoadingPackages = false;

  bool get isLoadingPackages => _isLoadingPackages;

  Future<void> fetchBrandsPackages(BuildContext context, {required String slug, int perPage = 12, page = 1, String sortBy = 'default_sorting'}) async {
    if (page == 1) {
      _isMoreLoading = true;
      _isLoadingPackages = true;
    } else {
      _isMoreLoadingPackages = true;
    }
    notifyListeners();

    final url = '${ApiEndpoints.featuredBrandPackages}$slug?per-page=$perPage&page=$page&sort-by=$sortBy';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final TopBrandsProducts apiResponse = TopBrandsProducts.fromJson(jsonResponse);

        if (page == 1) {
          _recordsPackages = apiResponse.data?.records ?? [];
          _brandsPagination = apiResponse.data?.pagination;
        } else {
          _recordsPackages.addAll(apiResponse.data?.records ?? []);
        }
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingPackages = false;
      _isMoreLoadingPackages = false;
      notifyListeners();
    }
  }
}
