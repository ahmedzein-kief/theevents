import 'dart:convert';

import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/apiendpoints/api_end_point.dart';

class EventsBrandProductProvider extends ChangeNotifier {
  ///   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  FEATURED TOP BRANDS PRODUCTS PROVIDER +++++++++++++++++++++++++++++++++++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  List<ProductRecords> _records = [];
  BrandsPagination? _brandsPagination;
  TopBrandsProducts? _topBrandsProducts;
  bool _isLoadingProducts = false;
  bool _isMoreLoadingProducts = false;
  ProductFiltersModel? _productFilters;

  List<ProductRecords> get records => _records;

  TopBrandsProducts? get topBrandsProducts => _topBrandsProducts;

  bool get isLoadingProducts => _isLoadingProducts;

  ProductFiltersModel? get productFilters => _productFilters;

  Future<void> fetchBrandsProducts({
    int perPage = 12,
    page = 1,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required BuildContext context,
  }) async {
    if (page == 1) {
      _records.clear();
      _isLoadingProducts = true;
    }

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

    final baseUrl = '${ApiEndpoints.eventBrandProducts}?per-page=$perPage&page=$page&sort-by=$sortBy';
    final url = filtersQuery.isNotEmpty ? '$baseUrl&$filtersQuery&allcategories=1' : baseUrl;


    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final TopBrandsProducts apiResponse = TopBrandsProducts.fromJson(jsonResponse);


        if (page == 1) {
          _records = apiResponse.data?.records ?? [];
          _brandsPagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _records.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }

        // _records = apiResponse.data!.records!;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingProducts = false;
      _isMoreLoadingProducts = false;
      notifyListeners();
    }
  }

  ///   ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  FEATURED TOP BRANDS PACKAGES PROVIDER +++++++++++++++++++++++++++++++++++++++++++++++++

  List<ProductRecords> _recordsPackages = [];
  BrandsPagination? _packagesPagination;
  TopBrandsProducts? _topBrandsPackages;
  bool _isLoadingPackages = false;
  bool _isMoreLoadingPackages = false;

  List<ProductRecords> get recordsPackages => _recordsPackages;

  TopBrandsProducts? get topBrandsPackages => _topBrandsProducts;

  bool get isLoadingPackages => _isLoadingPackages;

  Future<void> fetchBrandsPackages({
    int perPage = 12,
    page = 1,
    String sortBy = 'default_sorting',
    Map<String, List<int>> filters = const {},
    required BuildContext context,
  }) async {
    if (page == 1) {
      recordsPackages.clear();
      _isLoadingPackages = true;
    }

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

    final url = '${ApiEndpoints.eventBrandPackages}?per-page=$perPage&page=$page&sort-by=$sortBy&$filtersQuery';


    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final TopBrandsProducts apiResponse = TopBrandsProducts.fromJson(jsonResponse);


        if (page == 1) {
          _recordsPackages = apiResponse.data?.records ?? [];
          _packagesPagination = apiResponse.data?.pagination;
          _productFilters = apiResponse.data?.filters;
        } else {
          _recordsPackages.addAll(apiResponse.data?.records ?? []);
          _productFilters = apiResponse.data?.filters;
        }

        // _records = apiResponse.data!.records!;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw Exception('Failed to load products: $error');
    } finally {
      _isLoadingPackages = false;
      _isMoreLoadingPackages = false;
      notifyListeners();
    }
  }
}

class TopBrandsProducts {
  bool? error;
  Data? data;
  String? message;

  TopBrandsProducts({this.error, this.data, this.message});

  TopBrandsProducts.fromJson(Map<String, dynamic> json) {
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
  BrandsPagination? pagination;
  List<ProductRecords>? records;
  ProductFiltersModel? filters;

  Data({this.parent, this.pagination, this.records, this.filters});

  Data.fromJson(Map<String, dynamic> json) {
    parent = json['parent'] != null ? Parent.fromJson(json['parent']) : null;
    pagination = json['pagination'] != null ? BrandsPagination.fromJson(json['pagination']) : null;
    if (json['records'] != null) {
      records = <ProductRecords>[];
      json['records'].forEach((v) {
        records!.add(ProductRecords.fromJson(v));
      });
    }
    filters = json['filters'] != null ? ProductFiltersModel.fromJson(json['filters']) : null;
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
  String? website;
  String? slug;

  Parent({this.id, this.name, this.image, this.thumb, this.coverImage, this.description, this.website, this.slug});

  Parent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    thumb = json['thumb'];
    coverImage = json['cover_image'];
    description = json['description'];
    website = json['website'];
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
    data['website'] = this.website;
    data['slug'] = this.slug;
    return data;
  }
}

class BrandsPagination {
  int? total;
  int? lastPage;
  int? currentPage;
  int? perPage;

  BrandsPagination({this.total, this.lastPage, this.currentPage, this.perPage});

  BrandsPagination.fromJson(Map<String, dynamic> json) {
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

class ProductRecords {
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
  List<String>? labels;

  ProductRecords(
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

  ProductRecords.fromJson(Map<String, dynamic> json) {
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
      labels = <String>[];
      json['labels'].forEach((v) {
        labels!.add(v.toString());
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
      data['labels'] = this.labels!;
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
  dynamic frontSalePrice;
  dynamic price;
  dynamic frontSalePriceWithTaxes;
  dynamic priceWithTaxes;

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

class Filters {
  List<Categories>? categories;
  List<Brands>? brands;
  List<Tags>? tags;
  int? rand;
  List<String>? categoryRequest;
  int? categoryId;
  List<String>? brandRequest;
  List<String>? tagRequest;
  List<String>? priceRange;
  List<String>? rating;

  Filters({this.categories, this.brands, this.tags, this.rand, this.categoryRequest, this.categoryId, this.brandRequest, this.tagRequest, this.priceRange, this.rating});

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
    categoryRequest = json['category_request'] != null ? List<String>.from(json['category_request']) : null;
    categoryId = json['category_id'];
    brandRequest = json['brand_request'] != null ? List<String>.from(json['brand_request']) : null;
    tagRequest = json['tag_request'] != null ? List<String>.from(json['tag_request']) : null;
    priceRange = json['price_range'] != null ? List<String>.from(json['price_range']) : null;
    rating = json['rating'] != null ? List<String>.from(json['rating']) : null;
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
    data['category_request'] = this.categoryRequest;
    data['category_id'] = this.categoryId;
    data['brand_request'] = this.brandRequest;
    data['tag_request'] = this.tagRequest;
    data['price_range'] = this.priceRange;
    data['rating'] = this.rating;
    return data;
  }
}

class Categories {
  int? id;
  String? name;
  String? slug;
  String? image;

  Categories({this.id, this.name, this.slug, this.image});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['image'] = this.image;
    return data;
  }
}

class Brands {
  int? id;
  String? name;
  String? slug;

  Brands({this.id, this.name, this.slug});

  Brands.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}

class Tags {
  int? id;
  String? name;
  String? slug;

  Tags({this.id, this.name, this.slug});

  Tags.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = this.id;
    data['name'] = this.name;
    data['slug'] = this.slug;
    return data;
  }
}
