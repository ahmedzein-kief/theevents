//     ----------------------------------------------------------------   MODEL CLASSES OF WISHLIST
class WishlistModel {
  final bool? error;
  final WishlistData? data;
  final String? message;

  WishlistModel({
    this.error,
    this.data,
    this.message,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) {
    return WishlistModel(
      error: json['error'],
      data: WishlistData.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class WishlistData {
  final List<Product> products;
  final dynamic total;
  final dynamic count;
  final List<int>? ids;

  WishlistData({
    required this.products,
    this.total,
    this.count,
    this.ids,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) {
    return WishlistData(
      products: List<Product>.from(json['products'].map((x) => Product.fromJson(x))),
      total: json['total'],
      count: json['count'],
      ids: List<int>.from(json['ids']),
    );
  }
}

class Product {
  final dynamic id;
  final dynamic image;
  final dynamic name;
  final dynamic slug;
  final dynamic slugPrefix;
  final Store store;
  final dynamic frontSalePrice;
  final dynamic price;
  final dynamic frontSalePriceWithTaxes;
  final dynamic priceWithTaxes;

  Product({
    required this.id,
    required this.image,
    required this.name,
    required this.slug,
    required this.slugPrefix,
    required this.store,
    required this.frontSalePrice,
    required this.price,
    required this.frontSalePriceWithTaxes,
    required this.priceWithTaxes,
  });

  // Converts JSON to Product
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      image: json['image'],
      name: json['name'],
      slug: json['slug'],
      slugPrefix: json['slug_prefix'],
      store: (json['store'] != null && json['store'] is Map<String, dynamic>) ? Store.fromJson(json['store']) : Store(name: "", slug: ""),
      frontSalePrice: (json['front_sale_price']),
      price: (json['price']),
      frontSalePriceWithTaxes: json['front_sale_price_with_taxes'],
      priceWithTaxes: json['price_with_taxes'],
    );
  }

  // Converts Product to JSON (this is needed for storing in Hive)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'slug': slug,
      'slug_prefix': slugPrefix,
      'store': store.toJson(),
      'front_sale_price': frontSalePrice,
      'price': price,
      'front_sale_price_with_taxes': frontSalePriceWithTaxes,
      'price_with_taxes': priceWithTaxes,
    };
  }
}

class Store {
  final String name;
  final String slug;

  Store({
    required this.name,
    required this.slug,
  });

  // Converts JSON to Store
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      slug: json['slug'],
    );
  }

  // Converts Store to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'slug': slug,
    };
  }
}
