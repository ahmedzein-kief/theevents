//    =======================================   BEST SELLER BANNER MODELS +++++++++++++++
// class CollectionModel {
//   final bool error;
//   final Data data;
//   final String? message;
//
//   CollectionModel({required this.error, required this.data, this.message});
//
//   factory CollectionModel.fromJson(Map<String, dynamic> json) {
//     return CollectionModel(
//       error: json['error'],
//       data: Data.fromJson(json['data']),
//       message: json['message'],
//     );
//   }
// }
//
// class Data {
//   final int id;
//   final String name;
//   final String? description;
//   final String slug;
//   final String image;
//   final String thumb;
//   final String coverImage;
//   final int items;
//   final String? website;
//   final int isFeatured;
//   final SeoMeta seoMeta;
//
//   Data({
//     required this.id,
//     required this.name,
//     this.description,
//     required this.slug,
//     required this.image,
//     required this.thumb,
//     required this.coverImage,
//     required this.items,
//     this.website,
//     required this.isFeatured,
//     required this.seoMeta,
//   });
//
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       id: json['id'],
//       name: json['name'],
//       description: json['description'],
//       slug: json['slug'],
//       image: json['image'],
//       thumb: json['thumb'],
//       coverImage: json['cover_image'],
//       items: json['items'],
//       website: json['website'],
//       isFeatured: json['is_featured'],
//       seoMeta: SeoMeta.fromJson(json['seo_meta']),
//     );
//   }
// }
//
// class SeoMeta {
//   final String title;
//   final String description;
//   final String image;
//   final String robots;
//
//   SeoMeta({
//     required this.title,
//     required this.description,
//     required this.image,
//     required this.robots,
//   });
//
//   factory SeoMeta.fromJson(Map<String, dynamic> json) {
//     return SeoMeta(
//       title: json['title'],
//       description: json['description'],
//       image: json['image'],
//       robots: json['robots'],
//     );
//   }
// }

import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class CollectionModel {
  CollectionModel({this.error, this.data, this.message});

  factory CollectionModel.fromJson(Map<String, dynamic> json) =>
      CollectionModel(
        error: json['error'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
        message: json['message'],
      );
  dynamic error;
  dynamic data;
  dynamic message;
}

class Data {
  Data({
    this.id,
    this.name,
    this.description,
    this.slug,
    this.image,
    this.thumb,
    this.coverImage,
    this.items,
    this.website,
    this.isFeatured,
    this.seoMeta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        slug: json['slug'],
        image: json['image'],
        thumb: json['thumb'],
        coverImage: json['cover_image'],
        items: json['items'],
        website: json['website'],
        isFeatured: json['is_featured'],
        seoMeta: json['seo_meta'] != null
            ? SeoMeta.fromJson(json['seo_meta'])
            : null,
      );
  dynamic id;
  dynamic name;
  dynamic description;
  dynamic slug;
  dynamic image;
  dynamic thumb;
  dynamic coverImage;
  dynamic items;
  dynamic website;
  dynamic isFeatured;
  dynamic seoMeta;
}

class SeoMeta {
  SeoMeta({
    this.title,
    this.description,
    this.image,
    this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  dynamic title;
  dynamic description;
  dynamic image;
  dynamic robots;
}

// +++++++++++     BEST SELLER PRODUCTS MODELS ++++++++++++++++++++++++++++=======

class NewProductsModels {
  NewProductsModels({this.error, this.data, this.message});

  NewProductsModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? BestSellerData.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  BestSellerData? data;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class BestSellerData {
  BestSellerData({this.parent, this.pagination, this.records, this.filters});

  BestSellerData.fromJson(Map<String, dynamic> json) {
    // Handle parent as either a list or a single object
    if (json['parent'] is List) {
      parent = json['parent']?.map((v) => v).toList();
    } else if (json['parent'] is Map) {
      parent = [json['parent']]; // Convert single object to a list
    } else {
      parent = [];
    }

    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    records = json['records'] != null
        ? List<Records>.from(json['records'].map((v) => Records.fromJson(v)))
        : null;
    filters = json['filters'] != null
        ? ProductFiltersModel.fromJson(json['filters'])
        : null;
  }
  List<dynamic>? parent;
  Pagination? pagination;
  List<Records>? records;
  ProductFiltersModel? filters;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parent != null) {
      data['parent'] = parent;
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (records != null) {
      data['records'] = records!.map((v) => v.toJson()).toList();
    }
    if (filters != null) {
      data['filters'] = filters!.toJson();
    }
    return data;
  }
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
    brand = json['brand'] != null ? Store.fromJson(json['brand']) : null;
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
  Store? brand;
  List<dynamic>? labels;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['is_featured'] = isFeatured;
    data['product_type'] = productType;
    data['slug_prefix'] = slugPrefix;
    data['image'] = image;
    data['out_of_stock'] = outOfStock;
    data['cart_enabled'] = cartEnabled;
    data['wish_enabled'] = wishEnabled;
    data['compare_enabled'] = compareEnabled;
    data['review_enabled'] = reviewEnabled;
    if (review != null) {
      data['review'] = review!.toJson();
    }
    if (prices != null) {
      data['prices'] = prices!.toJson();
    }
    if (store != null) {
      data['store'] = store!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    if (labels != null) {
      data['labels'] = labels;
    }
    return data;
  }
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
          json['categories'].map((v) => Categories.fromJson(v)),);
    }
    if (json['tags'] != null) {
      tags = List<Categories>.from(
          json['tags'].map((v) => Categories.fromJson(v)),);
    }
    if (json['brands'] != null) {
      brands = List<Categories>.from(
          json['brands'].map((v) => Categories.fromJson(v)),);
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

int? _toInt(value) {
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}

//   +++++++++++++++++++++++++++++++++++++++   BEST SELLER PACKAGES MODELS +++++++++++++++++++++++++++++++++
