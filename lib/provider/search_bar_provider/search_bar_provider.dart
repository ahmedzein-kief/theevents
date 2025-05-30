import 'dart:convert';

import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

class SearchBarProvider extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<Records> _products = [];
  ProductFiltersModel? _productFilters;
  Pagination? _pagination;
  bool _isMoreLoading = false;
  bool _isLoading = false;

  List<Records> get products => _products;

  ProductFiltersModel? get productFilters => _productFilters;

  bool get isMoreLoading => _isMoreLoading;

  bool get isLoading => _isLoading;

  Future<void> fetchProductsNew(
    BuildContext context, {
    required String query,
    int page = 1,
    int perPage = 12,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
  }) async {
    // Clear the screen data when coming back from this screen
    if (page == 1) {
      _products.clear(); // Clear old data for a new search
    }

    _isLoading = page == 1;
    _isMoreLoading = page != 1;
    notifyListeners();

    // Convert selectedFilters to query parameters
    String filtersQuery = filters.entries
        .where((entry) => entry.value.isNotEmpty) // Exclude empty lists
        .map((entry) {
      if (entry.key == 'Prices') {
        // Handle Price range specifically
        int minPrice = entry.value[0];
        int maxPrice = entry.value[1];
        return 'min_price=$minPrice&max_price=$maxPrice';
      } else {
        // Handle all other filters
        return entry.value.map((id) {
          if (entry.key.toLowerCase() == 'Colors'.toLowerCase()) {
            return 'attributes[${entry.key.toLowerCase()}][]=$id';
          } else {
            return '${entry.key.toLowerCase()}[]=$id';
          }
        }).join('&');
      }
    }).join('&');

    final baseUrl = 'https://api.staging.theevents.ae/api/v1/search-bar?q=$query&per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final NewProductsModels apiResponse = NewProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = apiResponse.data?.records ?? [];
          _pagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _products.addAll(apiResponse.data?.records ?? []);
        }
      } else {
      }
    } catch (error) {
    }

    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }
}

//    ++++++++++++++++++++++++++++++++++++   SEARCH BAR MODELS ++++++++++++++++++++++++++++++++++++++++++++++

class NewProductsModels {
  bool? error;
  BestSellerData? data;
  String? message;

  NewProductsModels({this.error, this.data, this.message});

  NewProductsModels.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    data = json['data'] != null ? BestSellerData.fromJson(json['data']) : null;
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

class BestSellerData {
  List<dynamic>? parent;
  Pagination? pagination;
  List<Records>? records;
  ProductFiltersModel? filters;

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

int? _toInt(dynamic value) {
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}
