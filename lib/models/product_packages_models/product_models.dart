import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class ProductModels {
  bool? error;
  Data? data;
  String? message;

  ProductModels({this.error, this.data, this.message});

  ProductModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
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

class Data {
  List<dynamic>? parent;
  PaginationPagination? pagination;
  List<RecordProduct>? records;
  ProductFiltersModel? filters;

  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    pagination = json['pagination'] != null ? PaginationPagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <RecordProduct>[];
      json['records'].forEach((v) {
        records!.add(RecordProduct.fromJson(v));
      });
    }
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['parent'] = this.parent;
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

class PaginationPagination {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  PaginationPagination({this.total, this.lastPage, this.currentPage, this.perPage});

  PaginationPagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    lastPage = json['last_page'];
    currentPage = json['current_page'];
    perPage = json['per_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = this.total;
    data['last_page'] = this.lastPage;
    data['current_page'] = this.currentPage;
    data['per_page'] = this.perPage;
    return data;
  }
}

class RecordProduct {
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

  RecordProduct(
      {this.id,
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
      this.labels});

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
    data['labels'] = this.labels;
    return data;
  }
}

class Review {
  dynamic rating;
  int? reviewsCount;

  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    reviewsCount = json['reviews_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Filters {
  List<Categories>? categories;
  List<Brands>? brands;
  List<Tags>? tags;
  int? rand;
  List<dynamic>? categoryRequest;
  int? categoryId;
  int? maxPrice;

  Filters({this.categories, this.brands, this.tags, this.rand, this.categoryRequest, this.categoryId, this.maxPrice});

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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands!.map((v) => v.toJson()).toList();
    }
    if (this.tags != null) {
      data['tags'] = this.tags!.map((v) => v.toJson()).toList();
    }
    data['rand'] = this.rand;
    data['category_request'] = this.categoryRequest;
    data['category_id'] = this.categoryId;
    data['max_price'] = this.maxPrice;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Categories({this.id, this.name, this.image, this.count, this.selected, this.slug});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['count'] = this.count;
    data['selected'] = this.selected;
    data['slug'] = this.slug;
    return data;
  }
}

class Brands {
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Brands({this.id, this.name, this.image, this.count, this.selected, this.slug});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['count'] = this.count;
    data['selected'] = this.selected;
    data['slug'] = this.slug;
    return data;
  }
}

class Tags {
  int? id;
  String? name;
  String? image;
  int? count;
  bool? selected;
  String? slug;

  Tags({this.id, this.name, this.image, this.count, this.selected, this.slug});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    count = json['count'];
    selected = json['selected'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['count'] = this.count;
    data['selected'] = this.selected;
    data['slug'] = this.slug;
    return data;
  }
}
