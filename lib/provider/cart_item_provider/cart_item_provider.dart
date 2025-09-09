import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper/functions/functions.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/custom_toast.dart';
import '../../models/cartItems_models/cart_item_models.dart';
import '../../models/cart_items_models/cart_delete_models.dart';
import '../../models/cart_items_models/cart_items_models.dart';
import '../../models/cart_items_models/cart_update_models.dart';
import '../auth_provider/get_user_provider.dart';

class CartProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  dynamic _checkoutResponse;

  AddToCartResponse? _addToCartResponse;

  AddToCartResponse? get addToCartResponse => _addToCartResponse;

  dynamic get checkoutResponse => _checkoutResponse;

  /// Check if user is logged in
  Future<bool> _isLoggedIn() async {
    final token = await SecurePreferencesUtil.getToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> addToCart(
    int productID,
    BuildContext context,
    int quantity, {
    Map<String, dynamic> selectedExtraOptions = const {}, // Default to an empty map
    List<Map<String, dynamic>?> selectedAttributes = const [], // Default to an empty list
  }) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      navigateToLogin(context, 'Please log in to add items to cart');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      const url = ApiEndpoints.addToCart;

      if (token == null || token.isEmpty) {
        navigateToLogin(context, 'Please log in to add items to cart');
        return;
      }

      final headers = {
        'Authorization': token,
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
        bodyString: jsonEncode(postDataMap),
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        _addToCartResponse = AddToCartResponse.fromJson(jsonData);

        /// fetch cart after add to cart
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.fetchCartData(token ?? '', context);

        // Check if there's no error in the response
        if (_addToCartResponse != null && !_addToCartResponse!.error) {
          CustomSnackbar.showSuccess(
            context,
            _addToCartResponse?.message?.replaceAll('&amp;', '&') ?? 'Item added to cart successfully',
          );
        } else {
          CustomSnackbar.showError(
            context,
            _addToCartResponse?.message ?? 'Failed to add item to cart',
          );
        }
      } else if (response.statusCode == 401) {
        // Token expired or invalid
        CustomSnackbar.showError(context, 'Session expired. Please log in again.');
        navigateToLogin(context, 'Session expired. Please log in again.');
      } else {
        CustomSnackbar.showError(
          context,
          response.data?['message'] ?? 'Failed to add item to cart',
        );
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'An error occurred. Please try again.');
      _addToCartResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///   -----------------------------------------------------------  CART ITEMS DELETE FUNCTION  --------------------------------------------------------

  bool _deletingCartItem = false;

  bool get deletingCartItem => _deletingCartItem;

  Future<void> deleteCartListItem(
    String rowId,
    BuildContext context,
    String token,
  ) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      navigateToLogin(context, 'Please log in to manage your cart');
      return;
    }

    _deletingCartItem = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.cartRemove}$rowId';
      final headers = {'Authorization': token};

      final response = await _apiResponseHandler.postRequest(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = response.data;
        final cartResponse = CartDeleteResponse.fromJson(responseData);

        await fetchCartData(token, context);
        CustomSnackbar.showSuccess(context, cartResponse.message);
      } else if (response.statusCode == 401) {
        CustomSnackbar.showError(context, 'Session expired. Please log in again.');
        navigateToLogin(context, 'Session expired. Please log in again.');
      } else {
        CustomSnackbar.showError(context, 'Something went wrong.');
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'An error occurred. Please try again.');
    } finally {
      _deletingCartItem = false;
      notifyListeners();
    }
  }

  ///    ________________________________________________________________   FETCH CART ITEMS IN CART SCREEN ________________________________________________________________

  CartModel? _cartResponse;
  bool _cartLoading = false;

  CartModel? get cartResponse => _cartResponse;

  bool get cartLoading => _cartLoading;

  Future<void> fetchCartData(String token, BuildContext context) async {
    _cartLoading = true;
    notifyListeners();

    try {
      const url = ApiEndpoints.cartItems;
      final headers = {'Authorization': token};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        _cartResponse = CartModel.fromJson(response.data);

        final token = await SecurePreferencesUtil.getToken();
        final provider = Provider.of<UserProvider>(context, listen: false);
        provider.fetchUserData(token ?? '', context);
      } else if (response.statusCode == 401) {
        CustomSnackbar.showError(context, 'Session expired. Please log in again.');
        navigateToLogin(context, 'Session expired. Please log in again.');
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'Failed to load cart data.');
    } finally {
      _cartLoading = false;
      notifyListeners();
    }
  }

  /// Optimistically clear cart locally (e.g., after successful checkout)
  void clearCartLocally() {
    _cartResponse = null;
    notifyListeners();
  }

  bool _checkoutLoading = false;

  bool get checkoutLoading => _checkoutLoading;

  Future<dynamic> fetchCheckoutData(
    String token,
    BuildContext context,
    String checkoutToken,
  ) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      navigateToLogin(context, 'Please log in to proceed with checkout');
      return null;
    }

    _checkoutLoading = true;
    notifyListeners();

    try {
      final url = '${ApiEndpoints.checkout}$checkoutToken';
      final headers = {'Authorization': token};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        return response;
      } else if (response.statusCode == 401) {
        CustomSnackbar.showError(context, 'Session expired. Please log in again.');
        navigateToLogin(context, 'Session expired. Please log in again.');
      } else {
        CustomSnackbar.showError(context, 'Failed to load checkout data.');
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'An error occurred during checkout.');
    } finally {
      _checkoutLoading = false;
      notifyListeners();
    }

    return null;
  }

  ///  ----------------------------------------------------------------  UPDATE CART ITEMS ----------------------------------------------------------------

  Future<void> updateCart(
    String token,
    BuildContext context,
    Map<String, dynamic> items,
  ) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      navigateToLogin(context, 'Please log in to update your cart');
      return;
    }

    try {
      const url = ApiEndpoints.updateCart;
      final headers = {'Authorization': token};

      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        body: items,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final updateCart = UpdateCartResponse.fromJson(responseData);

        await fetchCartData(token, context); // Fetch updated cart data
        CustomSnackbar.showSuccess(context, updateCart.message);
      } else if (response.statusCode == 401) {
        CustomSnackbar.showError(context, 'Session expired. Please log in again.');
        navigateToLogin(context, 'Session expired. Please log in again.');
      } else {
        final errorResponse = UpdateCartResponse.fromJson(response.data);
        CustomSnackbar.showError(context, errorResponse.message);
      }
    } catch (e) {
      CustomSnackbar.showError(context, 'An error occurred while updating cart.');
      throw Exception('Something went wrong');
    }

    notifyListeners();
  }
}
