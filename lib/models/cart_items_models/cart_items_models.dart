import 'dart:developer';

class CartModel {
  CartModel({required this.error, required this.data});

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        error: json['error'] ?? false,
        data: Data.fromJson(json['data']),
      );
  final bool error;
  final Data data;
}

class Data {
  Data({
    required this.count,
    required this.totalPrice,
    required this.content,
    required this.products,
    required this.rawTotal,
    required this.finalTotal,
    required this.rawSubTotal,
    required this.rawTax,
    required this.formattedRawSubTotal,
    required this.formattedRawTax,
    required this.formattedFinalTotal,
    required this.isTaxEnabled,
    required this.trackedStartCheckout,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    // var contentMap = json['content'] as Map<String, dynamic>;
    // Map<String, CartItem> content = contentMap.map((key, value) => MapEntry(key, CartItem.fromJson(value)));

    // var productsList = json['products'] as List<dynamic>;
    // List<Product> products = productsList.map((i) => Product.fromJson(i)).toList();

    Map<String, CartItem> content = {};
    // Check if 'content' is a Map
    try {
      if (json['content'] is Map<String, dynamic>) {
        final contentMap = json['content'] as Map<String, dynamic>;
        content = contentMap.map((key, value) => MapEntry(key, CartItem.fromJson(value)));
      } else {}
    } catch (e) {
      log(e.toString());
    }

    List<Product> products = [];
    // Ensure products is a List
    try {
      if (json['products'] is List<dynamic>) {
        final productsList = json['products'] as List<dynamic>;
        products = productsList.map((i) => Product.fromJson(i)).toList();
      } else {}
    } catch (e) {
      log(e.toString());
    }

    return Data(
      count: json['count'] is String ? int.parse(json['count']) : json['count'],
      totalPrice: json['total_price']?.toString() ?? '0',
      content: content,
      products: products,
      rawTotal: (json['rawTotal'] as num).toDouble(),
      finalTotal: (json['finalTotal'] as num).toDouble(),
      rawSubTotal: (json['rawSubTotal'] as num).toDouble(),
      rawTax: (json['rawTax'] as num).toDouble(),
      formattedRawSubTotal: json['formatedRawSubTotal']?.toString() ?? 'AED0.00',
      formattedRawTax: json['formatedRawTax']?.toString() ?? 'AED0.00',
      formattedFinalTotal: json['formatedFinalTotal']?.toString() ?? 'AED0.00',
      isTaxEnabled: json['isTaxEnabled'] ?? false,
      trackedStartCheckout: json['tracked_start_checkout']?.toString() ?? '',
    );
  }

  final int count;
  final String totalPrice;
  final Map<String, CartItem> content;
  final List<Product> products;
  final double rawTotal;
  final double finalTotal;
  final double rawSubTotal;
  final double rawTax;
  final String formattedRawSubTotal;
  final String formattedRawTax;
  final String formattedFinalTotal;
  final bool isTaxEnabled;
  final String trackedStartCheckout;
}

class CartItem {
  CartItem({
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

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        rowId: json['rowId'] ?? '',
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        qty: json['qty'] is String ? int.parse(json['qty']) : json['qty'],
        price: (json['price'] is String
            ? double.tryParse(json['price']) ?? 0.0
            : (json['price'] is num ? json['price'].toDouble() : 0.0)),
        options: Options.fromJson(json['options'] ?? {}),
        tax: (json['tax'] is String
            ? double.tryParse(json['tax']) ?? 0.0
            : (json['tax'] is num ? json['tax'].toDouble() : 0.0)),
        subtotal: (json['subtotal'] is String
            ? double.tryParse(json['subtotal']) ?? 0.0
            : (json['subtotal'] is num ? json['subtotal'].toDouble() : 0.0)),
        updatedAt: json['updated_at'] ?? '',
      );
  final String rowId;
  final int id;
  final String name;
  final int qty;
  final double price;
  final Options options;
  final double tax;
  final double subtotal;
  final String updatedAt;
}

class Options {
  Options({
    required this.image,
    required this.attributes,
    required this.taxRate,
    required this.taxClasses,
    required this.options,
    required this.extras,
    required this.sku,
    required this.weight,
  });

  factory Options.fromJson(Map<String, dynamic> json) {
    final taxClassesMap = json['taxClasses'] as Map<String, dynamic>? ?? {};

    final Map<String, double> taxClasses = {};

    taxClassesMap.forEach((key, value) {
      taxClasses[key] = value is num ? value.toDouble() : value;
    });

    return Options(
      image: json['image'] ?? '',
      attributes: json['attributes'] ?? '',
      taxRate: (json['taxRate'] is String ? double.tryParse(json['taxRate']) : json['taxRate']?.toDouble()) ?? 0.0,
      taxClasses: taxClasses,
      options: json['options'] != null ? CartExtraOptionData.fromJson(json['options']) : null,
      extras: json['extras'] ?? [],
      sku: json['sku'] ?? '',
      weight: (json['weight'] is String ? double.tryParse(json['weight']) : json['weight']?.toDouble()) ?? 0.0,
    );
  }

  final String image;
  final String attributes;
  final double taxRate;
  final Map<String, double> taxClasses;
  final CartExtraOptionData? options;
  final List<dynamic> extras;
  final String sku;
  final double weight;
}

class CartExtraOptionData {
  CartExtraOptionData({this.optionCartValue, this.optionInfo});

  factory CartExtraOptionData.fromJson(Map<String, dynamic> json) => CartExtraOptionData(
        optionCartValue: json['optionCartValue'] != null
            ? (json['optionCartValue'] as Map<String, dynamic>).map(
                (key, value) => MapEntry(
                  key,
                  (value as List<dynamic>).map((item) => OptionCartValue.fromJson(item)).toList(),
                ),
              )
            : null,
        optionInfo: json['optionInfo'] != null ? Map<String, String>.from(json['optionInfo']) : null,
      );
  final Map<String, List<OptionCartValue>>? optionCartValue;
  final Map<String, String>? optionInfo;
}

class OptionCartValue {
  OptionCartValue({
    this.optionValue,
    this.affectPrice,
    this.affectType,
    this.optionType,
  });

  factory OptionCartValue.fromJson(Map<String, dynamic> json) => OptionCartValue(
        optionValue: json['option_value'],
        affectPrice: json['affect_price'],
        affectType: json['affect_type'],
        optionType: json['option_type'],
      );
  final String? optionValue;
  final int? affectPrice;
  final int? affectType;
  final String? optionType;
}

class Product {
  Product({
    required this.product,
    required this.cartItem,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        product: ProductDetails.fromJson(json['product'] ?? {}),
        cartItem: CartItem.fromJson(json['cart_item'] ?? {}),
      );
  final ProductDetails product;
  final CartItem cartItem;
}

class ProductDetails {
  ProductDetails({
    required this.id,
    required this.name,
    required this.slug,
    required this.isFeatured,
    required this.productType,
    required this.slugPrefix,
    required this.image,
    required this.thumb,
    required this.outOfStock,
    required this.cartEnabled,
    required this.wishEnabled,
    required this.compareEnabled,
    required this.reviewEnabled,
    required this.review,
    required this.prices,
    required this.store,
    required this.brand,
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) => ProductDetails(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
        isFeatured: json['is_featured'] ?? 0,
        productType: json['product_type'] ?? '',
        slugPrefix: json['slug_prefix'] ?? '',
        image: json['image'] ?? '',
        thumb: json['thumb'] ?? '',
        outOfStock: json['out_of_stock'] ?? false,
        cartEnabled: json['cart_enabled'] ?? false,
        wishEnabled: json['wish_enabled'] ?? false,
        compareEnabled: json['compare_enabled'] ?? false,
        reviewEnabled: json['review_enabled'] ?? false,
        review: Review.fromJson(json['review'] ?? {}),
        prices: Prices.fromJson(json['prices'] ?? {}),
        store: (json['store'] != null && json['store'] is Map<String, dynamic>) ? Store.fromJson(json['store']) : null,
        // Updated line
        brand: (json['brand'] != null && json['brand'] is Map<String, dynamic>)
            ? Brand.fromJson(json['brand'])
            : null, // Updated line
      );
  final int id;
  final String name;
  final String slug;
  final int isFeatured;
  final String productType;
  final String slugPrefix;
  final String image;
  final String thumb;
  final bool outOfStock;
  final bool cartEnabled;
  final bool wishEnabled;
  final bool compareEnabled;
  final bool reviewEnabled;
  final Review review;
  final Prices prices;
  final Store? store;
  final Brand? brand;
}

class Review {
  Review({required this.rating, required this.reviewsCount});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json['rating'],
        reviewsCount: json['reviews_count'],
      );
  final dynamic rating;
  final dynamic reviewsCount;
}

class Prices {
  Prices({
    required this.frontSalePrice,
    required this.price,
    required this.frontSalePriceWithTaxes,
    required this.priceWithTaxes,
  });

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        frontSalePrice: (json['front_sale_price'] is String
            ? double.tryParse(json['front_sale_price']) ?? 0.0
            : (json['front_sale_price'] is num ? json['front_sale_price'].toDouble() : 0.0)),
        price: (json['price'] is String
            ? double.tryParse(json['price']) ?? 0.0
            : (json['price'] is num ? json['price'].toDouble() : 0.0)),
        frontSalePriceWithTaxes: json['front_sale_price_with_taxes'] ?? '',
        priceWithTaxes: json['price_with_taxes'] ?? '',
      );
  final double frontSalePrice;
  final double price;
  final dynamic frontSalePriceWithTaxes;
  final dynamic priceWithTaxes;
}

class Store {
  Store({required this.name, required this.slug});

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
      );
  final String name;
  final String slug;
}

class Brand {
  Brand({required this.name, required this.slug});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        name: json['name'] ?? '',
        slug: json['slug'] ?? '',
      );
  final String name;
  final String slug;
}
