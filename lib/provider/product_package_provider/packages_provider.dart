import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
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
    const url = '${ApiEndpoints.baseUrl}/api/v1/packages';
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
  PackagesModels({this.error, this.data, this.message});

  PackagesModels.fromJson(Map<String, dynamic> json) {
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
    parent = json['parent'];
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['records'] != null) {
      records = <RecordsPackages>[];
      json['records'].forEach((v) {
        records!.add(RecordsPackages.fromJson(v));
      });
    }
    filters =
        json['filters'] != null ? Filters.fromJson(json['filters']) : null;
  }
  List<dynamic>? parent;
  Pagination? pagination;
  List<RecordsPackages>? records;
  Filters? filters;

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
  Pagination({this.total, this.lastPage, this.currentPage, this.perPage});

  Pagination.fromJson(Map<String, dynamic> json) {
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

class RecordsPackages {
  RecordsPackages({
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
      data['store'] = store;
    }
    if (brand != null) {
      data['brand'] = brand;
    }
    if (labels != null) {
      data['labels'] = labels;
    }
    return data;
  }
}

class Review {
  Review({this.rating, this.reviewsCount});

  Review.fromJson(Map<String, dynamic> json) {
    rating = json['rating'].toDouble();
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
    final Map<String, dynamic> data = {};
    data['front_sale_price'] = frontSalePrice;
    data['price'] = price;
    data['front_sale_price_with_taxes'] = frontSalePriceWithTaxes;
    data['price_with_taxes'] = priceWithTaxes;
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
    categories = json['categories'] != null
        ? List<Categories>.from(
            json['categories'].map((x) => Categories.fromJson(x)))
        : null;
    brands = json['brands'] != null
        ? List<Brands>.from(json['brands'].map((x) => Brands.fromJson(x)))
        : null;
    tags = json['tags'] != null
        ? List<Tags>.from(json['tags'].map((x) => Tags.fromJson(x)))
        : null;
    rand = json['rand'];
    categoryRequest = json['categoryRequest'] != null
        ? List<dynamic>.from(json['categoryRequest'])
        : null;
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
    final Map<String, dynamic> data = {};
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
    if (categoryRequest != null) {
      data['categoryRequest'] =
          categoryRequest!.map((v) => v.toJson()).toList();
    }
    data['category_id'] = categoryId;
    data['max_price'] = maxPrice;
    return data;
  }
}

class Categories {
  Categories({this.id, this.name, this.slug, this.type, this.count});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['type'] = type;
    data['count'] = count;
    return data;
  }
}

class Brands {
  Brands({this.id, this.name, this.slug, this.type, this.count});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['type'] = type;
    data['count'] = count;
    return data;
  }
}

class Tags {
  Tags({this.id, this.name, this.slug, this.type, this.count});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    type = json['type'];
    count = json['count'];
  }
  int? id;
  String? name;
  String? slug;
  String? type;
  int? count;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['slug'] = slug;
    data['type'] = type;
    data['count'] = count;
    return data;
  }
}
