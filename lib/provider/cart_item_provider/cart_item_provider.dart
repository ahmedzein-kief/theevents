import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/helper/functions/functions.dart';
import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/utils/app_utils.dart';
import '../../models/cartItems_models/cart_item_models.dart';
import '../../models/cart_items_models/cart_delete_models.dart';
import '../../models/cart_items_models/cart_items_models.dart';
import '../../models/cart_items_models/cart_update_models.dart';

class CartProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  dynamic _checkoutResponse;

  dynamic get checkoutResponse => _checkoutResponse;

  AddToCartResponse? _addToCartResponse;

  AddToCartResponse? get addToCartResponse => _addToCartResponse;

  CartModel? _cartResponse;

  CartModel? get cartResponse => _cartResponse;

  bool _cartLoading = false;

  bool get cartLoading => _cartLoading;

  bool _deletingCartItem = false;

  bool get deletingCartItem => _deletingCartItem;

  bool _checkoutLoading = false;

  bool get checkoutLoading => _checkoutLoading;

  /// Add to cart - returns success status and message
  Future<AddToCartResult> addToCart(
    int productID,
    int quantity, {
    Map<String, dynamic> selectedExtraOptions = const {},
    List<Map<String, dynamic>?> selectedAttributes = const [],
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      const url = ApiEndpoints.addToCart;

      final headers = {
        'Content-Type': 'application/json',
      };

      final Map<String, dynamic> postDataMap = {
        'id': productID,
        'qty': quantity,
      };

      if (selectedExtraOptions.isNotEmpty) {
        postDataMap['options'] = selectedExtraOptions;
      }

      if (selectedAttributes.isNotEmpty) {
        for (final attributesValue in selectedAttributes) {
          if (attributesValue != null) {
            postDataMap[attributesValue['attribute_key_name']] = attributesValue['attribute_id'];
          }
        }
      }

      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        extra: {ApiConstants.requireAuthKey: true},
        bodyString: jsonEncode(postDataMap),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        _addToCartResponse = AddToCartResponse.fromJson(jsonData);

        // Automatically refresh cart data
        await fetchCartData();

        // Return result for UI to handle
        if (_addToCartResponse != null && !_addToCartResponse!.error) {
          return AddToCartResult(
            success: true,
            message: _addToCartResponse!.message.replaceAll('&amp;', '&'),
          );
        } else {
          return AddToCartResult(
            success: false,
            message: _addToCartResponse?.message ?? 'Failed to add item to cart',
          );
        }
      } else if (response.statusCode == 401) {
        return AddToCartResult(success: false, message: 'Authentication failed');
      } else {
        return AddToCartResult(
          success: false,
          message: response.data?['message'] ?? 'Failed to add item to cart',
        );
      }
    } catch (e) {
      if (e is AuthException) {
        return AddToCartResult(success: false, message: 'Authentication required');
      }

      if (e is DioException && e.type == DioExceptionType.cancel) {
        return AddToCartResult(success: false, message: 'Request cancelled');
      }

      log('addToCart error ${e.toString()}');
      _addToCartResponse = null;
      return AddToCartResult(success: false, message: 'An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete cart item - returns success status and message
  Future<CartOperationResult> deleteCartItem(String rowId) async {
    _deletingCartItem = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.cartRemove}$rowId';

      final response = await _apiResponseHandler.postRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final cartResponse = CartDeleteResponse.fromJson(responseData);

        await fetchCartData();

        return CartOperationResult(
          success: true,
          message: cartResponse.message,
        );
      } else if (response.statusCode == 401) {
        return CartOperationResult(success: false, message: 'Authentication failed');
      } else {
        return CartOperationResult(success: false, message: 'Something went wrong.');
      }
    } catch (e) {
      if (e is AuthException) {
        return CartOperationResult(success: false, message: 'Authentication required');
      }

      if (e is DioException && e.type == DioExceptionType.cancel) {
        return CartOperationResult(success: false, message: 'Request cancelled');
      }

      log('deleteCartListItem error ${e.toString()}');
      return CartOperationResult(success: false, message: 'An error occurred. Please try again.');
    } finally {
      _deletingCartItem = false;
      notifyListeners();
    }
  }

  /// Fetch cart data - no BuildContext needed
  Future<void> fetchCartData() async {
    final user = await isLoggedIn();
    if (!user) {
      return;
    }

    _cartLoading = true;
    notifyListeners();

    try {
      const url = ApiEndpoints.cartItems;

      final response = await _apiResponseHandler.getRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        _cartResponse = CartModel.fromJson(response.data);
      }
    } catch (e) {
      if (e is AuthException) {
        return;
      }

      if (e is DioException) {
        if (e.type == DioExceptionType.cancel) {
          return;
        }

        if (e.response?.statusCode == 401) {
          return;
        }
      }

      log('Error in fetchCartData: ${e.toString()}');
      AppUtils.showToast(AppStrings.failedToLoadCartData.tr);
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Clear cart locally (e.g., after successful checkout)
  void clearCartLocally() {
    _cartResponse = null;
    notifyListeners();
  }

  /// Fetch checkout data
  Future<dynamic> fetchCheckoutData(String checkoutToken) async {
    _checkoutLoading = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.checkout}$checkoutToken';

      final response = await _apiResponseHandler.getRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        return null;
      } else {
        AppUtils.showToast(AppStrings.failedToLoadCheckoutData.tr);
      }
    } catch (e) {
      if (e is AuthException) {
        return null;
      }

      if (e is DioException && e.type == DioExceptionType.cancel) {
        return null;
      }

      log('fetchCheckoutData error ${e.toString()}');
      AppUtils.showToast(AppStrings.anErrorOccurredDuringCheckout.tr);
    } finally {
      _checkoutLoading = false;
      notifyListeners();
    }

    return null;
  }

  /// Update cart - returns success status and message
  Future<CartOperationResult> updateCart(Map<String, dynamic> items) async {
    try {
      const url = ApiEndpoints.updateCart;

      final response = await _apiResponseHandler.postRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
        body: items,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final updateCart = UpdateCartResponse.fromJson(responseData);

        await fetchCartData();

        return CartOperationResult(
          success: true,
          message: updateCart.message,
        );
      } else if (response.statusCode == 401) {
        return CartOperationResult(success: false, message: AppStrings.authenticationFailed.tr);
      } else {
        final errorResponse = UpdateCartResponse.fromJson(response.data);
        return CartOperationResult(success: false, message: errorResponse.message);
      }
    } catch (e) {
      if (e is AuthException) {
        return CartOperationResult(success: false, message: AppStrings.authenticationRequired.tr);
      }

      if (e is DioException && e.type == DioExceptionType.cancel) {
        return CartOperationResult(success: false, message: AppStrings.requestCancelled.tr);
      }

      log('updateCart error ${e.toString()}');
      return CartOperationResult(success: false, message: AppStrings.anErrorOccurredWhileUpdatingCart.tr);
    } finally {
      notifyListeners();
    }
  }
}

/// Result models for better error handling in UI
class AddToCartResult {
  final bool success;
  final String message;

  AddToCartResult({required this.success, required this.message});
}

class CartOperationResult {
  final bool success;
  final String message;

  CartOperationResult({required this.success, required this.message});
}
