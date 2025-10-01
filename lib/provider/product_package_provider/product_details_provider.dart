import 'dart:developer';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/models/product_packages_models/customer_reviews_data_response.dart';
import 'package:event_app/models/product_variation_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../models/product_packages_models/product_details_models.dart';

class ProductItemsProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  ProductDetailsModels? _apiResponse;
  CustomerReviewsDataResponse? _apiReviewsResponse;
  Images? _images;
  ItemRecord? _itemRecord;
  bool _isReviewLoading = false;
  bool _FetchLoading = false;
  bool _OtherLoading = false;
  String _errorMessage = '';

  ProductDetailsModels? get apiResponse => _apiResponse;

  CustomerReviewsDataResponse? get apiReviewsResponse => _apiReviewsResponse;

  ItemRecord? get itemRecord => _itemRecord;

  Images? get images => _images;

  bool get isLoading => _FetchLoading;

  bool get isReviewLoading => _isReviewLoading;

  bool get isOtherLoading => _OtherLoading;

  String get errorMessage => _errorMessage;

  void resetDetailData() {
    _apiResponse = null;
  }

  void updateWishListData(bool isWishList) {
    _apiResponse?.data?.record?.inWishList = isWishList;
    notifyListeners();
  }

  Future<ProductDetailsModels?> fetchProductData(
    String slug,
    BuildContext context,
  ) async {
    _FetchLoading = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.products}$slug';
      final token = await SecurePreferencesUtil.getToken();
      final headers = {'Authorization': '$token'};

      print(url);
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
        headers: headers,
      );

      if (response.statusCode == 200) {
        _apiResponse = ProductDetailsModels.fromJson(response.data);
        _itemRecord = _apiResponse?.data?.record;
        _images = Images.fromJson(response.data);
        _errorMessage = '';
        _FetchLoading = false;
        notifyListeners();

        return _apiResponse;
      } else {
        _errorMessage = 'Failed to load product data';
        _FetchLoading = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      log('Error: $error', name: 'fetchProductData');
      _errorMessage = error.toString();
    }

    _FetchLoading = false;
    notifyListeners();
    return null;
  }

  Future<CustomerReviewsDataResponse?> fetchCustomerReviews(
    String productId,
    BuildContext context,
  ) async {
    _isReviewLoading = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.customerReviews}$productId?per-page=10&page=1';
      final token = await SecurePreferencesUtil.getToken();
      final headers = {'Authorization': '$token'};

      log(url);
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
        headers: headers,
      );

      if (response.statusCode == 200) {
        _apiReviewsResponse = CustomerReviewsDataResponse.fromJson(response.data);
        _errorMessage = '';
        _isReviewLoading = false;
        notifyListeners();
        return _apiReviewsResponse;
      } else {
        _apiReviewsResponse = null;
        _isReviewLoading = false;
        notifyListeners();
        return null;
      }
    } catch (error) {
      _apiReviewsResponse = null;
      _isReviewLoading = false;
      _errorMessage = error.toString();
    }

    _FetchLoading = false;
    notifyListeners();
    return null;
  }

  Future<ProductVariationModel?> updateProductAttributes(
    String productID,
    BuildContext context,
    List<Map<String, dynamic>?> selectedAttributes,
  ) async {
    _OtherLoading = true;
    notifyListeners();

    try {
      // Extract attribute IDs
      final List<int> attributeIds = selectedAttributes.map((e) => e?['attribute_id'] as int).toList();

      // Build the query string manually
      final String queryString = attributeIds.map((id) => 'attributes[]=$id').join('&');

      final url = '${ApiEndpoints.productVariations}$productID?$queryString';
      final token = await SecurePreferencesUtil.getToken();
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final ProductVariationModel responseData = ProductVariationModel.fromJson(response.data);

        _OtherLoading = false;
        notifyListeners();
        return responseData;
      } else {
        _errorMessage = 'Failed to load product data';
      }
    } catch (error) {}

    _OtherLoading = false;
    notifyListeners();
    return null;
  }

  void resetData() {
    _apiReviewsResponse = null;
  }
}
