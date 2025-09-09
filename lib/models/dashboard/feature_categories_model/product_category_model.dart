//    ----------------------------------------------------------------  MODELS CLASS OF THE FEATURED CATEGORY BANNER ----------------------------------------------------------------
class ProductCategoryBanner {
  ProductCategoryBanner({
    required this.error,
    required this.data,
    this.message,
  });

  factory ProductCategoryBanner.fromJson(Map<String, dynamic> json) => ProductCategoryBanner(
        error: json['error'] ?? false, // Default to false if not present
        data: ProductCategoryData.fromJson(
          json['data'] ?? {},
        ), // Provide empty map if 'data' is null
        message: json['message'],
      );
  final bool error;
  final ProductCategoryData data;
  final String? message;
}

class ProductCategoryData {
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

  factory ProductCategoryData.fromJson(Map<String, dynamic> json) => ProductCategoryData(
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
        seoMeta: SeoMeta.fromJson(
          json['seo_meta'] ?? {},
        ), // Provide empty map if 'seo_meta' is null
      );
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
}

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        image: json['image'] ?? '',
        robots: json['robots'] ?? '',
      );
  final String title;
  final String description;
  final String image;
  final String robots;
}

//    ----------------------------------------------------------------   MODELS OF THE PRODUCTS FEATURED CATEGORY ----------------------------------------------------------------
class ProductCategoryModel {
  ProductCategoryModel({this.error, this.data, this.message});

  ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  bool? error;
  Data? data;
  String? message;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['error'] = error;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = (json['parent'] is Map<String, dynamic>) ? Parent.fromJson(json['parent']) : null;
    pagination = json['pagination'] != null ? Paginations.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = (json['records'] as List).map((v) => Records.fromJson(v)).toList();
    }
    filters = json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Parent? parent;
  Paginations? pagination;
  List<Records>? records;
  Filters? filters;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (parent != null) {
      data['parent'] = parent!.toJson();
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

class Parent {
  Parent({
    this.id,
    this.name,
    this.image,
    this.thumb,
    this.coverImage,
    this.description,
    this.slug,
  });

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    thumb = json['thumb'];
    coverImage = json['cover_image'];
    description = json['description'];
    slug = json['slug'];
  }

  int? id;
  String? name;
  String? image;
  String? thumb;
  String? coverImage;
  String? description;
  String? slug;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['thumb'] = thumb;
    data['cover_image'] = coverImage;
    data['description'] = description;
    data['slug'] = slug;
    return data;
  }
}

class Paginations {
  Paginations({this.total, this.lastPage, this.currentPage, this.perPage});

  Paginations.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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

    review = (json['review'] is Map<String, dynamic>) ? Review.fromJson(json['review']) : null;

    prices = (json['prices'] is Map<String, dynamic>) ? Prices.fromJson(json['prices']) : null;

    store = (json['store'] is Map<String, dynamic>) ? Store.fromJson(json['store']) : null;

    brand = (json['brand'] is Map<String, dynamic>) ? Store.fromJson(json['brand']) : null;

    if (json['labels'] is List) {
      labels = (json['labels'] as List).map((v) => Labels.fromJson(v)).toList();
    } else {
      labels = [];
    }
  }

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
      data['labels'] = labels!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Review {
  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating']?.toDouble();
    reviewsCount = json['reviews_count'];
  }

  double? rating;
  int? reviewsCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['rating'] = rating;
    data['reviews_count'] = reviewsCount;
    return data;
  }
}

class Prices {
  Prices({
    this.frontSalePrice,
    this.price,
    this.frontSalePriceWithTaxes,
    this.priceWithTaxes,
  });

  Prices.fromJson(Map<String, dynamic> json) {
    frontSalePrice = json['front_sale_price'];
    price = json['price'];
    frontSalePriceWithTaxes = json['front_sale_price_with_taxes'];
    priceWithTaxes = json['price_with_taxes'];
  }

  int? frontSalePrice;
  int? price;
  String? frontSalePriceWithTaxes;
  String? priceWithTaxes;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['front_sale_price'] = frontSalePrice;
    data['price'] = price;
    data['front_sale_price_with_taxes'] = frontSalePriceWithTaxes;
    data['price_with_taxes'] = priceWithTaxes;
    return data;
  }
}

class Store {
  Store({this.name, this.slug});

  Store.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
  }

  String? name;
  String? slug;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Labels {
  Labels({this.color, this.name});

  Labels.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    name = json['name'];
  }

  String? color;
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['color'] = color;
    data['name'] = name;
    return data;
  }
}

class Filters {
  Filters({this.filterData, this.options});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['data'] is List) {
      filterData = (json['data'] as List).map((v) => FilterData.fromJson(v)).toList();
    } else {
      filterData = [];
    }

    if (json['options'] is List) {
      options = (json['options'] as List).map((v) => Options.fromJson(v)).toList();
    } else {
      options = [];
    }
  }

  List<FilterData>? filterData;
  List<Options>? options;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (filterData != null) {
      data['data'] = filterData!.map((v) => v.toJson()).toList();
    }
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FilterData {
  FilterData({this.id, this.name});

  FilterData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Options {
  Options({this.id, this.name});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  int? id;
  String? name;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
