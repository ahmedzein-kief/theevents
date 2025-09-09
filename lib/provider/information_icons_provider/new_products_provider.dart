import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/dashboard/information_icons_models/new_products_models.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

class NewProductsProvider extends ChangeNotifier {
  ///     THIS IS FOR THE BANNER OF THE TOP PRODUCT
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  Product? _product;
  String? _errorMessage;

  Product? get product => _product;

  // bool _isLoading = false;
  // bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> fetchProducts(BuildContext context) async {
    // const newProductUrl = "https://apistaging.theevents.ae/api/v1/pages/products";
    const newProductUrl = ApiEndpoints.newProductsBanner;

    print('URL $newProductUrl');

    try {
      // _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        newProductUrl,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        _product = Product.fromJson(jsonResponse['data']);
      } else {
        _errorMessage = '';
      }
    } catch (error) {
      print(error.toString());
      _errorMessage = error.toString();
    } finally {
      // _isLoading = false;
      notifyListeners();
    }
  }

  ///      +++++++++++++++++++++++++++++  New Products Provider +++++++++++++++++++++++++++++

  List<Records> _products = [];
  Pagination? _pagination;
  NewProductsModels? _newProductsModels;
  bool _isMoreLoading = false;
  ProductFiltersModel? _productFilters;

  List<Records> get products => _products;

  bool get isMoreLoading => _isMoreLoading;

  NewProductsModels? get newProductsModels => _newProductsModels;

  ProductFiltersModel? get productFilters => _productFilters;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> fetchProductsNew({
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required BuildContext context,
  }) async {
    if (page == 1) {
      _isLoading = true;
    } else {
      _isMoreLoading = true;
    }
    _isLoading = true;
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

    final baseUrl = '${ApiEndpoints.newProducts}?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    print('URL $url');

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        // final newProducts = NewProductsModels.fromJson(jsonData).data?.records ?? [];
        final Map<String, dynamic> jsonResponse = response.data;
        print('json response $jsonResponse');
        final NewProductsModels apiResponse = NewProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = apiResponse.data?.records ?? [];
          _pagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _products.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }
      } else {}
    } catch (error) {
      print(error.toString());
    }

    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }
}
