import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class FeaturedCategoryProductsModels {
  final dynamic error;
  final Data data;

  FeaturedCategoryProductsModels({required this.error, required this.data});

  factory FeaturedCategoryProductsModels.fromJson(Map<String, dynamic> json) {
    return FeaturedCategoryProductsModels(
      error: json['error'],
      data: Data.fromJson(json['data']),
    );
  }
}

// Data class
class Data {
  final Parent parent;
  final Pagination pagination;
  final List<Record> records;
  final ProductFiltersModel? filters;

  Data({required this.parent, required this.pagination, required this.records, required this.filters});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      parent: Parent.fromJson(json['parent']),
      pagination: Pagination.fromJson(json['pagination']),
      records: (json['records'] as List).map((item) => Record.fromJson(item)).toList(),
      filters: json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null,
    );
  }
}

// Parent class
class Parent {
  final dynamic id;
  final dynamic name;
  final dynamic image;
  final dynamic thumb;
  final dynamic coverImage;
  final dynamic description;
  final dynamic slug;

  Parent({
    required this.id,
    required this.name,
    required this.image,
    required this.thumb,
    required this.coverImage,
    this.description,
    required this.slug,
  });

  factory Parent.fromJson(Map<String, dynamic> json) {
    return Parent(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      description: json['description'],
      slug: json['slug'],
    );
  }
}

// Pagination class
class Pagination {
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;

  Pagination({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      total: json['total'],
      lastPage: json['last_page'],
      currentPage: json['current_page'],
      perPage: json['per_page'],
    );
  }
}

// Record class
class Record {
  final dynamic id;
  final dynamic name;
  final dynamic slug;
  final dynamic isFeatured;
  final dynamic productType;
  final dynamic slugPrefix;
  final dynamic image;
  final dynamic outOfStock;
  final dynamic cartEnabled;
  final dynamic wishEnabled;
  final dynamic compareEnabled;
  final dynamic reviewEnabled;
  final Review review;
  final Prices prices;
  final Store? store;
  final Brand? brand;
  final List<dynamic> labels;

  Record({
    required this.id,
    required this.name,
    required this.slug,
    required this.isFeatured,
    required this.productType,
    required this.slugPrefix,
    required this.image,
    required this.outOfStock,
    required this.cartEnabled,
    required this.wishEnabled,
    required this.compareEnabled,
    required this.reviewEnabled,
    required this.review,
    required this.prices,
    required this.store,
    required this.brand,
    required this.labels,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      isFeatured: json['is_featured'],
      productType: json['product_type'],
      slugPrefix: json['slug_prefix'],
      image: json['image'],
      outOfStock: json['out_of_stock'],
      cartEnabled: json['cart_enabled'],
      wishEnabled: json['wish_enabled'],
      compareEnabled: json['compare_enabled'],
      reviewEnabled: json['review_enabled'],
      review: Review.fromJson(json['review']),
      prices: Prices.fromJson(json['prices']),
      store: json['store'] is Map<String, dynamic>
          ? Store.fromJson(json['store'])
          : null,
      brand: json['brand'] is Map<String,dynamic> ? Brand.fromJson(json['brand']) : null,
      labels: json['labels'] ?? [],
    );
  }
}

// Review class
class Review {
  final dynamic rating;
  final dynamic reviewsCount;

  Review({this.rating, required this.reviewsCount});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      rating: json['rating'],
      reviewsCount: json['reviews_count'],
    );
  }
}

// Prices class
class Prices {
  final dynamic frontSalePrice;
  final dynamic price;
  final dynamic frontSalePriceWithTaxes;
  final dynamic priceWithTaxes;

  Prices({
    required this.frontSalePrice,
    required this.price,
    required this.frontSalePriceWithTaxes,
    required this.priceWithTaxes,
  });

  factory Prices.fromJson(Map<String, dynamic> json) {
    return Prices(
      frontSalePrice: json['front_sale_price'],
      price: json['price'],
      frontSalePriceWithTaxes: json['front_sale_price_with_taxes'],
      priceWithTaxes: json['price_with_taxes'],
    );
  }
}

// Store class
class Store {
  final String? name;
  final String? slug;

  Store({this.name, this.slug});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );
  }
}

// Brand class
class Brand {
  final String? name;
  final String? slug;

  Brand({this.name, this.slug});

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      name: json['name'] as String?,
      slug: json['slug'] as String?,
    );
  }
}

