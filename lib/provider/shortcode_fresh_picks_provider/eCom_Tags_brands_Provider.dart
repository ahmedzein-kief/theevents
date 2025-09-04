
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_endpoints/api_end_point.dart';

///     +++++++++++++++++++++++++++++++++   E-COM TAGS BRANDS PROVIDER +++++++++++++++++++++++++++++++++

class EComBrandsProvider extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<BrandRecord> _records = [];
  BrandPagination? _topBrandPagination;
  bool _isInitialLoad = true; // Track initial load to show loader

  bool _isMoreLoadingBrands = false;

  bool get isMoreLoadingBrands => _isMoreLoadingBrands;

  bool get isInitialLoad => _isInitialLoad;

  List<BrandRecord> get records => _records;

  Future<void> fetchBrands(BuildContext context,
      {int perPage = 12,
      page = 1,
      String sortBy = 'default_sorting',
      required int id,}) async {
    if (page == 1) {
      _records.clear();
      _isInitialLoad = true; // Reset for new fetch
    }

    _isMoreLoadingBrands = true;
    notifyListeners();

    final url =
        '${ApiEndpoints.brands}?per-page=$perPage&page=$page&sort-by=$sortBy&tag_id=$id';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final brandsResponse = BrandsResponse.fromJson(jsonResponse);
        if (page == 1) {
          _records = brandsResponse.data.records;
          _topBrandPagination = brandsResponse.data.pagination;
          notifyListeners();
        } else {
          _records.addAll(brandsResponse.data.records);
          notifyListeners();
        }
      }
    } catch (e) {
      _records = [];
    }
    _isMoreLoadingBrands = false;
    notifyListeners();
  }

  void reset() {
    _records.clear();
    _topBrandPagination = null;
    notifyListeners();
  }
}

///   +++++++++++++++++++++++   E-COM BRAND ITEMS DATA   ++++++++++++++++++++

// models/record.dart
class BrandRecord {
  BrandRecord({
    required this.id,
    required this.name,
    this.title,
    this.description,
    this.website,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.isFeatured,
    required this.items,
  });

  factory BrandRecord.fromJson(Map<String, dynamic> json) => BrandRecord(
        id: json['id'],
        name: json['name'],
        title: json['title'],
        description: json['description'],
        website: json['website'],
        slug: json['slug'],
        image: json['image'],
        thumb: json['thumb'],
        coverImage: json['cover_image'],
        isFeatured: json['is_featured'],
        items: json['items'],
      );
  final int id;
  final String name;
  final String? title;
  final String? description;
  final String? website;
  final String slug;
  final String image;
  final String thumb;
  final String coverImage;
  final int isFeatured;
  final int items;
}

// models/brands_response.dart
class BrandsResponse {
  BrandsResponse({
    required this.error,
    required this.data,
    this.message,
  });

  factory BrandsResponse.fromJson(Map<String, dynamic> json) => BrandsResponse(
        error: json['error'],
        data: Data.fromJson(json['data']),
        message: json['message'],
      );
  final bool error;
  final Data data;
  final String? message;
}

class Data {
  Data({
    required this.pagination,
    required this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        pagination: BrandPagination.fromJson(json['pagination']),
        records: (json['records'] as List)
            .map((item) => BrandRecord.fromJson(item))
            .toList(),
      );
  final BrandPagination pagination;
  final List<BrandRecord> records;
}

class BrandPagination {
  BrandPagination({
    required this.total,
    required this.lastPage,
    required this.currentPage,
    required this.perPage,
  });

  factory BrandPagination.fromJson(Map<String, dynamic> json) =>
      BrandPagination(
        total: json['total'],
        lastPage: json['last_page'],
        currentPage: json['current_page'],
        perPage: json['per_page'],
      );
  final int total;
  final int lastPage;
  final int currentPage;
  final int perPage;
}
