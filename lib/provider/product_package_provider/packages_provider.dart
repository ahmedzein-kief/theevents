import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

class PackageProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  PackagesModels? packagesModels;
  bool isLoading = false;
  String errorMessage = '';
  List<RecordsPackages> products = [];

  Future<void> fetchPackages(
    BuildContext context, {
    // required int perPage,
    // required int page,
    String sortBy = 'default_sorting',
    required int storeId,
  }) async {
    final url = '${ApiEndpoints.baseUrl}/api/v1/packages';
    final queryParams = {
      // 'per-page': perPage.toString(),
      // 'page': page.toString(),
      'sort-by': sortBy,
      'store_id': storeId.toString(),
    };

    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: queryParams,
        context: context,
      );


      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final packagesModels = PackagesModels.fromJson(data);

        if (packagesModels.data != null) {
          products = packagesModels.data!.records ?? [];
        } else {
          errorMessage = 'Data is null';
        }

        //
        // products = (data['data']['records'] as List)
        //     .map((i) => RecordsPackages.fromJson(i))
        //     .toList();
        // errorMessage = '';
      } else {
        errorMessage = 'Failed to load data: ${response.reasonPhrase}';
      }
    } catch (error) {
      errorMessage = 'Something went wrong: $error';
    }

    isLoading = false;
    notifyListeners();
  }
}

//  models class

class PackagesModels {
  bool? error;
  Data? data;
  String? message;

  PackagesModels({this.error, this.data, this.message});

  PackagesModels.fromJson(Map<String, dynamic> json) {
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
  List<dynamic>? parent;
  Pagination? pagination;
  List<RecordsPackages>? records;
  Filters? filters;

  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent'];
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <RecordsPackages>[];
      json['records'].forEach((v) {
        records!.add(RecordsPackages.fromJson(v));
      });
    }
    filters = json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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

class RecordsPackages {
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
  List<dynamic>? store;
  List<dynamic>? brand;
  List<dynamic>? labels;

  RecordsPackages(
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

  RecordsPackages.fromJson(Map<String, dynamic> json) {
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
    review = json['review'] != null ? Review.fromJson(json['review']) : null;
    prices = json['prices'] != null ? Prices.fromJson(json['prices']) : null;
    store = json['store'] != null ? List<dynamic>.from(json['store']) : null;
    brand = json['brand'] != null ? List<dynamic>.from(json['brand']) : null;
    labels = json['labels'] != null ? List<dynamic>.from(json['labels']) : null;
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
      data['store'] = this.store;
    }
    if (this.brand != null) {
      data['brand'] = this.brand;
    }
    if (this.labels != null) {
      data['labels'] = this.labels;
    }
    return data;
  }
}

class Review {
  double? rating;
  int? reviewsCount;

  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'].toDouble();
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
    categories = json['categories'] != null ? List<Categories>.from(json['categories'].map((x) => Categories.fromJson(x))) : null;
    brands = json['brands'] != null ? List<Brands>.from(json['brands'].map((x) => Brands.fromJson(x))) : null;
    tags = json['tags'] != null ? List<Tags>.from(json['tags'].map((x) => Tags.fromJson(x))) : null;
    rand = json['rand'];
    categoryRequest = json['categoryRequest'] != null ? List<dynamic>.from(json['categoryRequest']) : null;
    categoryId = json['category_id'];
    maxPrice = json['max_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
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
    if (this.categoryRequest != null) {
      data['categoryRequest'] = this.categoryRequest!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = this.categoryId;
    data['max_price'] = this.maxPrice;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Categories({this.id, this.name, this.slug, this.type, this.count});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['count'] = this.count;
    return data;
  }
}

class Brands {
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Brands({this.id, this.name, this.slug, this.type, this.count});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['count'] = this.count;
    return data;
  }
}

class Tags {
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Tags({this.id, this.name, this.slug, this.type, this.count});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['type'] = this.type;
    data['count'] = this.count;
    return data;
  }
}
