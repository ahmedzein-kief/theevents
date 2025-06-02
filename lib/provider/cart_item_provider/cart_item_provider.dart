import 'dart:convert';
import 'dart:developer';

import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/provider/customer/Repository/customer_repository.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../models/cartItems_models/cart_item_models.dart';
import '../../models/cart_items_models/cart_items_models.dart';
import '../../core/utils/custom_toast.dart';
import '../../utils/storage/shared_preferences_helper.dart';
import '../auth_provider/get_user_provider.dart';

class CartProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  http.Response? _checkoutResponse = null;

  AddToCartResponse? _addToCartResponse;

  AddToCartResponse? get addToCartResponse => _addToCartResponse;

  http.Response? get checkoutResponse => _checkoutResponse;

  Future<void> addToCart(
    int productID,
    BuildContext context,
    int quantity, {
    Map<String, dynamic> selectedExtraOptions =
        const {}, // Default to an empty map
    List<Map<String, dynamic>?> selectedAttributes =
        const [], // Default to an empty list
  }) async
  {
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.addToCart}';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    Map<String, dynamic> postDataMap = {
      "id": productID,
      "qty": 1,
    };
    if (selectedExtraOptions.isNotEmpty) {
      postDataMap["options"] = selectedExtraOptions;
    }

    if (selectedAttributes.isNotEmpty) {
      selectedAttributes.forEach(
        (attributesValue) {
          postDataMap[attributesValue?['attribute_key_name']] =
              attributesValue?['attribute_id'];
        },
      );
    }

    try {
      final response = await _apiResponseHandler.postRequest(url,
          headers: headers, bodyString: jsonEncode(postDataMap));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _addToCartResponse = AddToCartResponse.fromJson(jsonData);

        /// fetch cart after add to cart
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        await cartProvider.fetchCartData(token ?? '', context);

        // Check if there's no error in the response
        if (!_addToCartResponse!.error) {
          CustomSnackbar.showSuccess(context, _addToCartResponse?.message.replaceAll('&amp;', '&') ?? "Item added to cart successfully");
        } else {
          CustomSnackbar.showError(context, _addToCartResponse?.message ?? 'Failed to add item to cart');
        }
        _isLoading = false;
        notifyListeners();
      } else {
        CustomSnackbar.showError(
            context, json.decode(response.body)['message']);
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _addToCartResponse = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///   -----------------------------------------------------------  CART ITEMS DELETE FUNCTION  --------------------------------------------------------

  bool _deletingCartItem = false;
  bool get deletingCartItem => _deletingCartItem;
  Future<void> deleteCartListItem(
      String rowId, BuildContext context, String token) async
  {
    _deletingCartItem = true;
    notifyListeners();

    final url = '${ApiEndpoints.cartRemove}$rowId';
    final headers = {'Authorization': 'Bearer $token'};

    final response = await _apiResponseHandler.postRequest(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final cartResponse = CartDeleteResponse.fromJson(responseData);

      await fetchCartData(token, context);
      CustomSnackbar.showSuccess(context, cartResponse.message);
      _deletingCartItem = false;
      notifyListeners();
    } else {
      _deletingCartItem = false;
      CustomSnackbar.showError(context, 'Something Went Wrong.');
    }
    _deletingCartItem = false;
    notifyListeners();
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
      final url = ApiEndpoints.cartItems;
      final headers = {'Authorization': '$token'};


      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        _cartResponse = CartModel.fromJson(json.decode(response.body));
        final token = await SecurePreferencesUtil.getToken();
        final provider = Provider.of<UserProvider>(context, listen: false);
        provider.fetchUserData(token ?? '', context);
        notifyListeners();
        _cartLoading = false;
      } else {
        _cartLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _cartLoading = false;
      notifyListeners();
    }
  }


  bool _checkoutLoading  = false;
  bool get checkoutLoading => _checkoutLoading;

  Future<http.Response?> fetchCheckoutData(
      String token, BuildContext context, String checkoutToken) async {
    _checkoutLoading = true;
    notifyListeners();
    try {
      final url = "${ApiEndpoints.checkout}$checkoutToken";
      final headers = {'Authorization': 'Bearer $token'};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );

      if (response.statusCode == 200) {
        notifyListeners();
        _checkoutLoading = false;
        return response;
      } else {
        _checkoutLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _checkoutLoading = false;
      notifyListeners();
    }
    return null;
  }

  ///  ----------------------------------------------------------------  UPDATE CART ITEMS ----------------------------------------------------------------

  Future<void> updateCart(
      String token, BuildContext context, Map<String, String> items) async {
    try {
      final url = '${ApiEndpoints.updateCart}';
      final headers = {'Authorization': 'Bearer $token'};

      final response = await _apiResponseHandler.postRequest(url,
          headers: headers, body: items);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final updateCart = UpdateCartResponse.fromJson(responseData);

        await fetchCartData(token, context); // Fetch updated cart data
        CustomSnackbar.showSuccess(context, updateCart.message);
        notifyListeners();

        /// Notify listeners here if you want to update any other dependent state
      } else {
        CustomSnackbar.showError(
            context,
            UpdateCartResponse.fromJson(jsonDecode(response.body))
                .message
                .toString());
      }
    } catch (e) {
      notifyListeners();
      throw Exception('Something Went Wrong');
    }
  }
}

///  CART UPDATE MODEL CLASS

class UpdateCartResponse {
  final bool error;
  final dynamic data; // You can specify the type if you have more detailed data
  final String message;

  UpdateCartResponse(
      {required this.error, required this.data, required this.message});

  factory UpdateCartResponse.fromJson(Map<String, dynamic> json) {
    return UpdateCartResponse(
      error: json['error'],
      data: json['data'],
      message: json['message'],
    );
  }
}

/// To parse this JSON data, do  CART DELETE MODEL CLASS
/// ---------   CART DELETE RESPONSE --------------------------------

class CartDeleteResponse {
  final dynamic error; // Dynamic type
  final dynamic data; // Dynamic type
  final dynamic message; // Dynamic type

  CartDeleteResponse({
    this.error,
    this.data,
    this.message,
  });

  // Safely check for nulls in the json
  factory CartDeleteResponse.fromJson(Map<String, dynamic> json) {
    CartData? data =
        (json['data'] != null && json['data'] is Map<String, dynamic>)
            ? CartData.fromJson(json['data'])
            : null;

    return CartDeleteResponse(
      error: json['error'],
      data: data,
      message: json['message'],
    );
  }
}

class CartData {
  final int? count; // Nullable
  final String? totalPrice; // Nullable
  final List<Product>? content; // Nullable

  CartData({this.count, this.totalPrice, this.content});

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      count: json['count'],
      totalPrice: json['total_price'],
      content: [],
    );
  }
}
