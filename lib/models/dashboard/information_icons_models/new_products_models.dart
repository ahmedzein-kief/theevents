// models/product.dart
//    ++++++++++++++++++++++++++++++++++++++++++ NEW PRODUCT BANNER MODELS
import 'package:event_app/models/cart_items_models/cart_items_models.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'] as String,
        description: json['description'] as String,
        image: json['image'] as String,
        robots: json['robots'] as String,
      );
  final String title;
  final String description;
  final String image;
  final String robots;
}

class Product {
  Product({
    required this.name,
    required this.slug,
    required this.image,
    required this.coverImage,
    required this.seoMeta,
    required this.content,
    this.coverImageForMobile,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json['name'] as String,
        slug: json['slug'] as String,
        image: json['image'] as String,
        coverImage: json['cover_image'] as String,
        coverImageForMobile: json['cover_image_for_mobile'],
        seoMeta: SeoMeta.fromJson(json['seo_meta']),
        content: json['content'] as String,
      );
  final String name;
  final String slug;
  final String image;
  final String coverImage;
  final SeoMeta seoMeta;
  final String content;
  final String? coverImageForMobile;
}

//  ++++++++++++++++++++++++++++++++  NEW PRODUCTS ITEMS MODELS +++++++++++++++++++++++++

class NewProductsModels {
  NewProductsModels({this.error, this.data, this.message});

  NewProductsModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  bool? error;
  Data? data;
  String? message;
}

class Data {
  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent']?.map((v) => v).toList();
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    records = json['records'] != null ? List<Records>.from(json['records'].map((v) => Records.fromJson(v))) : null;
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
  }

  List<dynamic>? parent;
  Pagination? pagination;
  List<Records>? records;
  ProductFiltersModel? filters;
}

class Pagination {
  Pagination({this.total, this.lastPage, this.currentPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      total = json['total'] as int?;
      lastPage = json['last_page'] as int?;
      currentPage = json['current_page'] as int?;
      perPage = json['per_page'] as int?;
    }
  }

  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['last_page'] = lastPage;
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    return data;
  }
}

class Records {
  Records({
    this.id,
    this.name,
    this.slug,
    this.isFeatured,
    this.productType,
    this.slugPrefix,
    this.image,
    this.outOfStock,
    this.cartEnabled,
    this.wishEnabled,
    this.compareEnabled,
    this.reviewEnabled,
    this.review,
    this.prices,
    this.store,
    this.brand,
    this.labels,
  });

  Records.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    slug = json['slug'];
    isFeatured = _toInt(json['is_featured']);
    productType = json['product_type'];
    slugPrefix = json['slug_prefix'];
    image = json['image'];
    outOfStock = json['out_of_stock'];
    cartEnabled = json['cart_enabled'];
    wishEnabled = json['wish_enabled'];
    compareEnabled = json['compare_enabled'];
    reviewEnabled = json['review_enabled'];
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    brand = json['brand'] is Map<String, dynamic> ? Brand.fromJson(json['brand']) : null;
    labels = json['labels']?.map((v) => v).toList();
  }

  dynamic id;
  String? name;
  String? slug;
  int? isFeatured;
  String? productType;
  String? slugPrefix;
  String? image;
  bool? outOfStock;
  bool? cartEnabled;
  bool? wishEnabled;
  bool? compareEnabled;
  bool? reviewEnabled;
  Review? review;
  Prices? prices;
  Store? store;
  Brand? brand;
  List<dynamic>? labels;
}

class Review {
  Review({this.average, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    reviewsCount = _toInt(json['reviews_count']);
  }

  dynamic average;
  dynamic reviewsCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = average;
    data['reviews_count'] = reviewsCount;
    return data;
  }
}

class Prices {
  Prices({
    this.price,
    this.priceWithTaxes,
    this.frontSalePrice,
    this.frontSalePriceWithTaxes,
    this.discountAmount,
    this.discountPercentage,
    this.hasDiscount,
  });

  Prices.fromJson(Map<String, dynamic> json) {
    price = _toInt(json['price']);
    priceWithTaxes = _toInt(json['price_with_taxes']);
    frontSalePrice = _toInt(json['front_sale_price']);
    frontSalePriceWithTaxes = json['front_sale_price_with_taxes'];
    discountAmount = _toInt(json['discount_amount']);
    discountPercentage = _toInt(json['discount_percentage']);
    hasDiscount = json['has_discount'];
  }

  int? price;
  dynamic priceWithTaxes;
  int? frontSalePrice;
  String? frontSalePriceWithTaxes;
  int? discountAmount;
  int? discountPercentage;
  bool? hasDiscount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['price_with_taxes'] = priceWithTaxes;
    data['front_sale_price'] = frontSalePrice;
    data['front_sale_price_with_taxes'] = frontSalePriceWithTaxes;
    data['discount_amount'] = discountAmount;
    data['discount_percentage'] = discountPercentage;
    data['has_discount'] = hasDiscount;
    return data;
  }
}

class Store {
  Store({
    this.id,
    this.name,
    this.slug,
    this.image,
    this.coverImage,
    this.logo,
    this.averageRating,
    this.reviewsCount,
    this.enabled,
  });

  Store.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    coverImage = json['cover_image'];
    logo = json['logo'];
    averageRating = json['average_rating'];
    reviewsCount = _toInt(json['reviews_count']);
    enabled = json['enabled'];
  }

  int? id;
  String? name;
  String? slug;
  String? image;
  String? coverImage;
  String? logo;
  dynamic averageRating;
  int? reviewsCount;
  bool? enabled;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['cover_image'] = coverImage;
    data['logo'] = logo;
    data['average_rating'] = averageRating;
    data['reviews_count'] = reviewsCount;
    data['enabled'] = enabled;
    return data;
  }
}

class Filters {
  Filters({this.categories, this.tags, this.brands});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = List<Categories>.from(
        json['categories'].map((v) => Categories.fromJson(v)),
      );
    }
    if (json['tags'] != null) {
      tags = List<Categories>.from(
        json['tags'].map((v) => Categories.fromJson(v)),
      );
    }
    if (json['brands'] != null) {
      brands = List<Categories>.from(
        json['brands'].map((v) => Categories.fromJson(v)),
      );
    }
  }

  List<Categories>? categories;
  List<Categories>? tags;
  List<Categories>? brands;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    if (brands != null) {
      data['brands'] = brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  Categories({this.id, this.name, this.slug, this.image, this.banner});

  Categories.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    banner = json['banner'];
  }

  int? id;
  String? name;
  String? slug;
  String? image;
  String? banner;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['image'] = image;
    data['banner'] = banner;
    return data;
  }
}

dynamic _toInt(value) {
  if (value == null) return null;
  if (value is int || value is double || value is String || value is bool) {
    return value;
  }
  return value.toString(); // Fallback to string if type is unknown
}
