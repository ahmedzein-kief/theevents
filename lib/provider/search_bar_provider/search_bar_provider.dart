import 'dart:developer';

import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

class SearchBarProvider extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<Records> _products = [];
  ProductFiltersModel? _productFilters;

  // Pagination? _pagination;
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
    final String filtersQuery = filters.entries
        .where((entry) => entry.value.isNotEmpty) // Exclude empty lists
        .map((entry) {
      if (entry.key == 'Prices') {
        // Handle Price range specifically
        final int minPrice = entry.value[0];
        final int maxPrice = entry.value[1];
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

    final baseUrl =
        'https://apistaging.theevents.ae/api/v1/search-bar?q=$query&per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;

    try {
      final response = await _apiResponseHandler.getRequest(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final NewProductsModels apiResponse = NewProductsModels.fromJson(jsonResponse);

        if (page == 1) {
          _products = apiResponse.data?.records ?? [];
          // _pagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _products.addAll(apiResponse.data?.records ?? []);
        }
      } else {}
    } catch (error) {
      log(error.toString());
    }

    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }
}

//    ++++++++++++++++++++++++++++++++++++   SEARCH BAR MODELS ++++++++++++++++++++++++++++++++++++++++++++++

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

    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
    records = json['records'] != null ? List<Records>.from(json['records'].map((v) => Records.fromJson(v))) : null;
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
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
    store = (json['store'] != null && json['store'] is Map<String, dynamic>) ? Store.fromJson(json['store']) : null;
    brand = (json['brand'] != null && json['brand'] is Map<String, dynamic>) ? Store.fromJson(json['brand']) : null;
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

int? _toInt(value) {
  if (value == null) {
    return null;
  }
  return int.tryParse(value.toString());
}
