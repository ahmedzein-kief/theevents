//    ----------------------------------------------------------------  MODELS CLASS OF THE FEATURED CATEGORY BANNER ----------------------------------------------------------------
class ProductCategoryBanner {
  final bool error;
  final ProductCategoryData data;
  final String? message;

  ProductCategoryBanner({required this.error, required this.data, this.message});

  factory ProductCategoryBanner.fromJson(Map<String, dynamic> json) {
    return ProductCategoryBanner(
      error: json['error'] ?? false, // Default to false if not present
      data: ProductCategoryData.fromJson(json['data'] ?? {}), // Provide empty map if 'data' is null
      message: json['message'],
    );
  }
}

class ProductCategoryData {
  final int id;
  final String name;
  final String? title;
  final String? description;
  final String slug;
  final String image;
  final String thumb;
  final String coverImage;
  final int items;
  final SeoMeta seoMeta;

  ProductCategoryData({
    required this.id,
    required this.name,
    this.title,
    this.description,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.items,
    required this.seoMeta,
  });

  factory ProductCategoryData.fromJson(Map<String, dynamic> json) {
    return ProductCategoryData(
      id: json['id'] ?? 0,
      // Provide default values if needed
      name: json['name'] ?? '',
      title: json['title'],
      description: json['description'],
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
      thumb: json['thumb'] ?? '',
      coverImage: json['cover_image'] ?? '',
      items: json['items'] ?? 0,
      seoMeta: SeoMeta.fromJson(json['seo_meta'] ?? {}), // Provide empty map if 'seo_meta' is null
    );
  }
}

class SeoMeta {
  final String title;
  final String description;
  final String image;
  final String robots;

  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      robots: json['robots'] ?? '',
    );
  }
}

//    ----------------------------------------------------------------   MODELS OF THE PRODUCTS FEATURED CATEGORY ----------------------------------------------------------------
class ProductCategoryModel {
  bool? error;
  Data? data;
  String? message;

  ProductCategoryModel({this.error, this.data, this.message});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = this.error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class Data {
  Parent? parent;
  Paginations? pagination;
  List<Records>? records;
  Filters? filters;

  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
    pagination = json['pagination'] != null ? Paginations.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = (json['records'] as List).map((v) => Records.fromJson(v)).toList();
    }
    filters = json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.parent != null) {
      data['parent'] = this.parent!.toJson();
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

class Parent {
  int? id;
  String? name;
  String? image;
  String? thumb;
  String? coverImage;
  String? description;
  String? slug;

  Parent({this.id, this.name, this.image, this.thumb, this.coverImage, this.description, this.slug});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    thumb = json['thumb'];
    coverImage = json['cover_image'];
    description = json['description'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['thumb'] = this.thumb;
    data['cover_image'] = this.coverImage;
    data['description'] = this.description;
    data['slug'] = this.slug;
    return data;
  }
}

class Paginations {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Paginations({this.total, this.lastPage, this.currentPage, this.perPage});

  Paginations.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class Records {
  int? id;
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
  List<Labels>? labels;

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
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    isFeatured = json['is_featured'];
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
    if (json['labels'] != null) {
      labels = (json['labels'] as List).map((v) => Labels.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
      data['labels'] = this.labels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  double? rating;
  int? reviewsCount;

  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating']?.toDouble();
    reviewsCount = json['reviews_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rating'] = this.rating;
    data['reviews_count'] = this.reviewsCount;
    return data;
  }
}

class Prices {
  int? frontSalePrice;
  int? price;
  String? frontSalePriceWithTaxes;
  String? priceWithTaxes;

  Prices({this.frontSalePrice, this.price, this.frontSalePriceWithTaxes, this.priceWithTaxes});

  Prices.fromJson(Map<String, dynamic> json) {
    frontSalePrice = json['front_sale_price'];
    price = json['price'];
    frontSalePriceWithTaxes = json['front_sale_price_with_taxes'];
    priceWithTaxes = json['price_with_taxes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['front_sale_price'] = this.frontSalePrice;
    data['price'] = this.price;
    data['front_sale_price_with_taxes'] = this.frontSalePriceWithTaxes;
    data['price_with_taxes'] = this.priceWithTaxes;
    return data;
  }
}

class Store {
  String? name;
  String? slug;

  Store({this.name, this.slug});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Labels {
  String? color;
  String? name;

  Labels({this.color, this.name});

  Labels.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['color'] = this.color;
    data['name'] = this.name;
    return data;
  }
}

class Filters {
  List<FilterData>? filterData;
  List<Options>? options;

  Filters({this.filterData, this.options});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      filterData = (json['data'] as List).map((v) => FilterData.fromJson(v)).toList();
    }
    if (json['options'] != null) {
      options = (json['options'] as List).map((v) => Options.fromJson(v)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.filterData != null) {
      data['data'] = this.filterData!.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterData {
  int? id;
  String? name;

  FilterData({this.id, this.name});

  FilterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Options {
  int? id;
  String? name;

  Options({this.id, this.name});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}
