class AddToCartResponse {
  AddToCartResponse(
      {required this.error, required this.data, required this.message,});

  factory AddToCartResponse.fromJson(Map<String, dynamic> json) =>
      AddToCartResponse(
        error: json['error'] as bool,
        data: json['data'] != null
            ? CartDataItem.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String,
      );
  final bool error;
  final CartDataItem? data;
  final String message;
}

class CartDataItem {
  CartDataItem({
    required this.count,
    required this.totalPrice,
    required this.content,
    required this.status,
    required this.trackedStartCheckout,
  });

  factory CartDataItem.fromJson(Map<String, dynamic> json) {
    // If content is a List, use List<CartItems>
    List<CartItems> contentList = [];
    if (json['content'] is List) {
      contentList = (json['content'] as List)
          .map((item) => CartItems.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return CartDataItem(
      count: json['count'] as int,
      totalPrice: json['total_price'],
      content: contentList,
      status: json['status'] as bool,
      trackedStartCheckout: json['tracked_start_checkout'],
    );
  }
  final int count;
  final dynamic totalPrice;
  final List<CartItems> content; // Change to List if content is an array
  final bool status;
  final dynamic trackedStartCheckout;
}

class CartItems {
  CartItems({
    required this.rowId,
    required this.id,
    required this.name,
    required this.qty,
    required this.price,
    required this.options,
    required this.tax,
    required this.subtotal,
    required this.updatedAt,
  });

  factory CartItems.fromJson(Map<String, dynamic> json) => CartItems(
        rowId: json['rowId'],
        id: json['id'] as int,
        name: json['name'] as String,
        qty: json['qty'] as int,
        price: json['price'],
        options: CartOptions.fromJson(json['options'] as Map<String, dynamic>),
        tax: json['tax'],
        subtotal: json['subtotal'],
        updatedAt: json['updated_at'],
      );
  final dynamic rowId;
  final int id;
  final String name;
  final int qty;
  final dynamic price;
  final CartOptions options;
  final dynamic tax;
  final dynamic subtotal;
  final dynamic updatedAt;
}

class CartOptions {
  CartOptions({
    required this.image,
    required this.attributes,
    required this.taxRate,
    required this.taxClasses,
    required this.options,
    required this.extras,
    required this.sku,
    required this.weight,
  });

  factory CartOptions.fromJson(Map<String, dynamic> json) => CartOptions(
        image: json['image'] as String,
        attributes: json['attributes'],
        taxRate: json['taxRate'],
        taxClasses: Map<String, dynamic>.from(json['taxClasses'] as Map),
        options: List<dynamic>.from(json['options'] as List),
        extras: List<dynamic>.from(json['extras'] as List),
        sku: json['sku'] as String,
        weight: json['weight'],
      );
  final String image;
  final dynamic attributes;
  final dynamic taxRate;
  final Map<String, dynamic> taxClasses;
  final List<dynamic> options;
  final List<dynamic> extras;
  final String sku;
  final dynamic weight;
}

// _______________________________________  MODELS FOR SHOWING THE ITEMS INT THE CART __________________________________
