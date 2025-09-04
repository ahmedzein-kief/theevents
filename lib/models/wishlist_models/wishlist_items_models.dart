//     ----------------------------------------------------------------   MODEL CLASSES OF WISHLIST
class WishlistModel {
  WishlistModel({
    this.error,
    this.data,
    this.message,
  });

  factory WishlistModel.fromJson(Map<String, dynamic> json) => WishlistModel(
        error: json['error'],
        data: WishlistData.fromJson(json['data']),
        message: json['message'],
      );
  final bool? error;
  final WishlistData? data;
  final String? message;
}

class WishlistData {
  WishlistData({
    required this.products,
    this.total,
    this.count,
    this.ids,
  });

  factory WishlistData.fromJson(Map<String, dynamic> json) => WishlistData(
        products: List<Product>.from(
            json['products'].map((x) => Product.fromJson(x)),),
        total: json['total'],
        count: json['count'],
        ids: List<int>.from(json['ids']),
      );
  final List<Product> products;
  final dynamic total;
  final dynamic count;
  final List<int>? ids;
}

class Product {
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
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        image: json['image'],
        name: json['name'],
        slug: json['slug'],
        slugPrefix: json['slug_prefix'],
        store: (json['store'] != null && json['store'] is Map<String, dynamic>)
            ? Store.fromJson(json['store'])
            : Store(name: '', slug: ''),
        frontSalePrice: json['front_sale_price'],
        price: json['price'],
        frontSalePriceWithTaxes: json['front_sale_price_with_taxes'],
        priceWithTaxes: json['price_with_taxes'],
      );
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

  // Converts Product to JSON (this is needed for storing in Hive)
  Map<String, dynamic> toJson() => {
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

class Store {
  Store({
    required this.name,
    required this.slug,
  });

  // Converts JSON to Store
  factory Store.fromJson(Map<String, dynamic> json) => Store(
        name: json['name'],
        slug: json['slug'],
      );
  final String name;
  final String slug;

  // Converts Store to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'slug': slug,
      };
}
