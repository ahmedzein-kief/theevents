import 'package:event_app/models/product_packages_models/product_filters_model.dart';

/// +++++++++++++++++++++   E-COM TAGS MODELS BANNER +++++++++++++++++++++

class SeoMeta {
  final dynamic title;
  final dynamic description;
  final dynamic image;
  final dynamic robots;

  SeoMeta({required this.title, required this.description, required this.image, required this.robots});

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      robots: json['robots'] ?? '',
    );
  }
}

class EcomTag {
  final dynamic id;
  final dynamic name;
  final dynamic title;
  final dynamic description;
  final dynamic slug;
  final dynamic items;
  final dynamic image;
  final dynamic thumb;
  final dynamic coverImage;
  final SeoMeta seoMeta;

  EcomTag({
    required this.id,
    required this.name,
    required this.title,
    required this.description,
    required this.slug,
    required this.items,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.seoMeta,
  });

  factory EcomTag.fromJson(Map<String, dynamic> json) {
    return EcomTag(
      id: json['id'],
      name: json['name'],
      title: json['title'],
      description: json['description'] ?? '',
      slug: json['slug'],
      items: json['items'],
      image: json['image'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      seoMeta: SeoMeta.fromJson(json['seo_meta']),
    );
  }
}

//
// ///   +++++++++++++++++++++++   E-COM BRAND ITEMS DATA   ++++++++++++++++++++
//
// // models/record.dart
// class BrandRecord {
//   final int id;
//   final String name;
//   final String? title;
//   final String? description;
//   final String? website;
//   final String slug;
//   final String image;
//   final String thumb;
//   final String coverImage;
//   final int isFeatured;
//   final int items;
//
//   BrandRecord({
//     required this.id,
//     required this.name,
//     this.title,
//     this.description,
//     this.website,
//     required this.slug,
//     required this.image,
//     required this.thumb,
//     required this.coverImage,
//     required this.isFeatured,
//     required this.items,
//   });
//
//   factory BrandRecord.fromJson(Map<String, dynamic> json) {
//     return BrandRecord(
//       id: json['id'],
//       name: json['name'],
//       title: json['title'],
//       description: json['description'],
//       website: json['website'],
//       slug: json['slug'],
//       image: json['image'],
//       thumb: json['thumb'],
//       coverImage: json['cover_image'],
//       isFeatured: json['is_featured'],
//       items: json['items'],
//     );
//   }
// }
//
// // models/brands_response.dart
// class BrandsResponse {
//   final bool error;
//   final Data data;
//   final String? message;
//
//   BrandsResponse({
//     required this.error,
//     required this.data,
//     this.message,
//   });
//
//   factory BrandsResponse.fromJson(Map<String, dynamic> json) {
//     return BrandsResponse(
//       error: json['error'],
//       data: Data.fromJson(json['data']),
//       message: json['message'],
//     );
//   }
// }
//
// class Data {
//   final BrandPagination pagination;
//   final List<BrandRecord> records;
//
//   Data({
//     required this.pagination,
//     required this.records,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       pagination: BrandPagination.fromJson(json['pagination']),
//       records: (json['records'] as List).map((item) => BrandRecord.fromJson(item)).toList(),
//     );
//   }
// }
//
// class BrandPagination {
//   final int total;
//   final int lastPage;
//   final int currentPage;
//   final int perPage;
//
//   BrandPagination({
//     required this.total,
//     required this.lastPage,
//     required this.currentPage,
//     required this.perPage,
//   });
//
//   factory BrandPagination.fromJson(Map<String, dynamic> json) {
//     return BrandPagination(
//       total: json['total'],
//       lastPage: json['last_page'],
//       currentPage: json['current_page'],
//       perPage: json['per_page'],
//     );
//   }
// }

///   +++++++++++++++++++++++++++   E-COM TAGS PRODUCTS MODEL +++++++++++++++++++++++++++++++++++++++++++++++++

class EComProductsModels {
  bool? error;
  HalfDiscountData? data;
  String? message;

  EComProductsModels({this.error, this.data, this.message});

  EComProductsModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? HalfDiscountData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class HalfDiscountData {
  List<dynamic>? parent;
  Pagination? pagination;
  List<Records>? records;
  ProductFiltersModel? filters;

  HalfDiscountData({this.parent, this.pagination, this.records, this.filters});

  HalfDiscountData.fromJson(Map<String, dynamic> json) {
    // Handle parent as either a list or a single object
    if (json['parent'] is List) {
      parent = json['parent']?.map((v) => v).toList();
    } else if (json['parent'] is Map) {
      parent = [json['parent']]; // Convert single object to a list
    } else {
      parent = [];
    }

    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    records = json['records'] != null ? List<Records>.from(json['records'].map((v) => Records.fromJson(v))) : null;
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.parent != null) {
      data['parent'] = this.parent;
    }
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.records != null) {
      data['records'] = this.records!.map((v) => v.toJson()).toList();
    }
    if (this.filters != null) {
      data['filters'] = this.filters!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Pagination({this.total, this.lastPage, this.currentPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      total = json['total'] as int?;
      lastPage = json['last_page'] as int?;
      currentPage = json['current_page'] as int?;
      perPage = json['per_page'] as int?;
    }
  }

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
  Store? brand;
  List<dynamic>? labels;

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
    brand = json['brand'] != null ? Store.fromJson(json['brand']) : null;
    labels = json['labels']?.map((v) => v).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['is_featured'] = this.isFeatured;
    data['product_type'] = this.productType;
    data['slug_prefix'] = this.slugPrefix;
    data['image'] = this.image;
    data['out_of_stock'] = this.outOfStock;
    data['cart_enabled'] = this.cartEnabled;
    data['wish_enabled'] = this.wishEnabled;
    data['compare_enabled'] = this.compareEnabled;
    data['review_enabled'] = this.reviewEnabled;
    if (this.review != null) {
      data['review'] = this.review!.toJson();
    }
    if (this.prices != null) {
      data['prices'] = this.prices!.toJson();
    }
    if (this.store != null) {
      data['store'] = this.store!.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.labels != null) {
      data['labels'] = this.labels;
    }
    return data;
  }
}

class Review {
  dynamic average;
  dynamic reviewsCount;

  Review({this.average, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    average = json['average'];
    reviewsCount = _toInt(json['reviews_count']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = this.average;
    data['reviews_count'] = this.reviewsCount;
    return data;
  }
}

class Prices {
  int? price;
  dynamic priceWithTaxes;
  int? frontSalePrice;
  String? frontSalePriceWithTaxes;
  int? discountAmount;
  int? discountPercentage;
  bool? hasDiscount;

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
    frontSalePriceWithTaxes = (json['front_sale_price_with_taxes']);
    discountAmount = _toInt(json['discount_amount']);
    discountPercentage = _toInt(json['discount_percentage']);
    hasDiscount = json['has_discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = this.price;
    data['price_with_taxes'] = this.priceWithTaxes;
    data['front_sale_price'] = this.frontSalePrice;
    data['front_sale_price_with_taxes'] = this.frontSalePriceWithTaxes;
    data['discount_amount'] = this.discountAmount;
    data['discount_percentage'] = this.discountPercentage;
    data['has_discount'] = this.hasDiscount;
    return data;
  }
}

class Store {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? coverImage;
  String? logo;
  dynamic averageRating;
  int? reviewsCount;
  bool? enabled;

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['cover_image'] = this.coverImage;
    data['logo'] = this.logo;
    data['average_rating'] = this.averageRating;
    data['reviews_count'] = this.reviewsCount;
    data['enabled'] = this.enabled;
    return data;
  }
}

class Filters {
  List<Categories>? categories;
  List<Categories>? tags;
  List<Categories>? brands;

  Filters({this.categories, this.tags, this.brands});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = List<Categories>.from(json['categories'].map((v) => Categories.fromJson(v)));
    }
    if (json['tags'] != null) {
      tags = List<Categories>.from(json['tags'].map((v) => Categories.fromJson(v)));
    }
    if (json['brands'] != null) {
      brands = List<Categories>.from(json['brands'].map((v) => Categories.fromJson(v)));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;
  String? image;
  String? banner;

  Categories({this.id, this.name, this.slug, this.image, this.banner});

  Categories.fromJson(Map<String, dynamic> json) {
    id = _toInt(json['id']);
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
    banner = json['banner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    data['banner'] = this.banner;
    return data;
  }
}

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}
