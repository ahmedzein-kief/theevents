/// ---------   CART DELETE RESPONSE --------------------------------
library;

import '../../models/cart_items_models/cart_items_models.dart';

class CartDeleteResponse {
  // Dynamic type

  CartDeleteResponse({
    this.error,
    this.data,
    this.message,
  });

  // Safely check for nulls in the json
  factory CartDeleteResponse.fromJson(Map<String, dynamic> json) {
    final CartData? data =
        (json['data'] != null && json['data'] is Map<String, dynamic>)
            ? CartData.fromJson(json['data'])
            : null;

    return CartDeleteResponse(
      error: json['error'],
      data: data,
      message: json['message'],
    );
  }
  final dynamic error; // Dynamic type
  final dynamic data; // Dynamic type
  final dynamic message;
}

class CartData {
  // Nullable

  CartData({this.count, this.totalPrice, this.content});

  factory CartData.fromJson(Map<String, dynamic> json) => CartData(
        count: json['count'],
        totalPrice: json['total_price'],
        content: [],
      );
  final int? count; // Nullable
  final String? totalPrice; // Nullable
  final List<Product>? content;
}
