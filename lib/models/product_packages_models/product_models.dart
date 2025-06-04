import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class ProductModels {
  ProductModels({this.error, this.data, this.message});

  ProductModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }
  bool? error;
  Data? data;
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

class Data {
  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    pagination = json['pagination'] != null
        ? PaginationPagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = <RecordProduct>[];
      json['records'].forEach((v) {
        records!.add(RecordProduct.fromJson(v));
      });
    }
    filters = json['filters'] != null
        ? ProductFiltersModel.fromJson(json['filters'])
        : null;
  }
  List<dynamic>? parent;
  PaginationPagination? pagination;
  List<RecordProduct>? records;
  ProductFiltersModel? filters;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parent'] = parent;
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

class PaginationPagination {
  PaginationPagination(
      {this.total, this.lastPage, this.currentPage, this.perPage});

  PaginationPagination.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['last_page'] = lastPage;
    data['current_page'] = currentPage;
    data['per_page'] = perPage;
    return data;
  }
}

class RecordProduct {
  RecordProduct({
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

  factory RecordProduct.fromJson(Map<String, dynamic> json) {
    String? productType;

    if (json['product_type'] is String) {
      // If product_type is a string, assign it directly
      productType = json['product_type'] as String?;
    } else if (json['product_type'] is Map) {
      // If product_type is a map, access the 'value' key
      productType = json['product_type']?['value'] as String?;
    }

    return RecordProduct(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      isFeatured: json['is_featured'],
      productType: productType,
      slugPrefix: json['slug_prefix'],
      image: json['image'],
      outOfStock: json['out_of_stock'],
      cartEnabled: json['cart_enabled'],
      wishEnabled: json['wish_enabled'],
      compareEnabled: json['compare_enabled'],
      reviewEnabled: json['review_enabled'],
      review: json['review'] != null ? Review.fromJson(json['review']) : null,
      prices: json['prices'] != null ? Prices.fromJson(json['prices']) : null,
      store: json['store'] != null ? Store.fromJson(json['store']) : null,
      brand: json['brand'] != null ? Store.fromJson(json['brand']) : null,
      labels: json['labels'],
    );
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
    data['labels'] = labels;
    return data;
  }
}

class Review {
  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    reviewsCount = json['reviews_count'];
  }
  dynamic rating;
  int? reviewsCount;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rating'] = rating;
    data['reviews_count'] = reviewsCount;
    return data;
  }
}

class Prices {
  Prices(
      {this.frontSalePrice,
      this.price,
      this.frontSalePriceWithTaxes,
      this.priceWithTaxes});

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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slug'] = slug;
    return data;
  }
}

class Filters {
  Filters(
      {this.categories,
      this.brands,
      this.tags,
      this.rand,
      this.categoryRequest,
      this.categoryId,
      this.maxPrice});

  Filters.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brands>[];
      json['brands'].forEach((v) {
        brands!.add(Brands.fromJson(v));
      });
    }
    if (json['tags'] != null) {
      tags = <Tags>[];
      json['tags'].forEach((v) {
        tags!.add(Tags.fromJson(v));
      });
    }
    rand = json['rand'];
    categoryRequest = json['category_request'];
    categoryId = json['category_id'];
    maxPrice = json['max_price'];
  }
  List<Categories>? categories;
  List<Brands>? brands;
  List<Tags>? tags;
  int? rand;
  List<dynamic>? categoryRequest;
  int? categoryId;
  int? maxPrice;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    if (brands != null) {
      data['brands'] = brands!.map((v) => v.toJson()).toList();
    }
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    data['rand'] = rand;
    data['category_request'] = categoryRequest;
    data['category_id'] = categoryId;
    data['max_price'] = maxPrice;
    return data;
  }
}

class Categories {
  Categories(
      {this.id, this.name, this.image, this.count, this.selected, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['count'] = count;
    data['selected'] = selected;
    data['slug'] = slug;
    return data;
  }
}

class Brands {
  Brands(
      {this.id, this.name, this.image, this.count, this.selected, this.slug});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['count'] = count;
    data['selected'] = selected;
    data['slug'] = slug;
    return data;
  }
}

class Tags {
  Tags({this.id, this.name, this.image, this.count, this.selected, this.slug});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['count'] = count;
    data['selected'] = selected;
    data['slug'] = slug;
    return data;
  }
}
