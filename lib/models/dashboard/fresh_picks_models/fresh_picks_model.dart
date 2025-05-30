import 'package:event_app/models/product_packages_models/product_filters_model.dart';

class HomeFreshPicksModels {
  bool? error;
  Data? data;
  String? message;

  HomeFreshPicksModels({this.error, this.data, this.message});

  HomeFreshPicksModels.fromJson(Map<String, dynamic> json) {
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
  List<Parent>? parent;
  Pagination? pagination;
  List<Records>? records;
  ProductFiltersModel? filters;

  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['parent'] != null) {
      parent = [];
      json['parent'].forEach((v) {
        parent!.add(Parent.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = [];
      json['records'].forEach((v) {
        records!.add(Records.fromJson(v));
      });
    }
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.parent != null) {
      data['parent'] = this.parent!.map((v) => v.toJson()).toList();
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

  Pagination.fromJson(Map<String, dynamic> json) {
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
    wishEnabled = json['wish_enabled'] ?? false;
    compareEnabled = json['compare_enabled'];
    reviewEnabled = json['review_enabled'];
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    store = json['store'] != null ? Store.fromJson(json['store']) : null;
    brand = json['brand'] != null ? Store.fromJson(json['brand']) : null;
    if (json['labels'] != null) {
      labels = [];
      json['labels'].forEach((v) {
        labels!.add(Labels.fromJson(v));
      });
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
  dynamic rating;
  int? reviewsCount;

  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
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

class Parent {
  int? id;
  String? name;
  String? slug;
  int? parentId;

  Parent({this.id, this.name, this.slug, this.parentId});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    parentId = json['parent_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['parent_id'] = this.parentId;
    return data;
  }
}

class CategoryRequest {
  int? id;
  String? name;

  CategoryRequest({this.id, this.name});

  CategoryRequest.fromJson(Map<String, dynamic> json) {
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
