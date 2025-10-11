import 'dart:developer';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

class StoreModel {
  StoreModel({required this.error, this.data, this.message});

  factory StoreModel.fromJson(Map<String, dynamic> json) => StoreModel(
        error: json['error'],
        data: json['data'] != null ? Data.fromJson(json['data']) : null,
        message: json['message'],
      );
  final bool error;
  final Data? data;
  final String? message;
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.logo,
    required this.logoThumb,
    required this.coverImage,
    required this.title,
    required this.description,
    required this.slug,
    this.seoMeta,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json['id'],
        name: json['name'],
        logo: json['logo'],
        logoThumb: json['logo_thumb'],
        coverImage: json['cover_image'],
        title: json['title'],
        description: json['description'],
        slug: json['slug'],
        seoMeta: json['seo_meta'] != null ? SeoMeta.fromJson(json['seo_meta']) : null,
      );
  final int id;
  final String name;
  final String logo;
  final String logoThumb;
  final String coverImage;
  final String title;
  final String description;
  final String slug;
  final SeoMeta? seoMeta;
}

class SeoMeta {
  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) => SeoMeta(
        title: json['title'],
        description: json['description'],
        image: json['image'],
        robots: json['robots'],
      );
  final String title;
  final String description;
  final String image;
  final String robots;
}

class StoreProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  StoreModel? storeModel;
  bool isLoading = false;

  Future<void> fetchStore(
    String slug,
    BuildContext context,
  ) async {
    // final url = 'https://apistaging.theevents.ae/api/v1/stores/$slug';
    const urlApi = ApiEndpoints.brandStore;
    final url = '$urlApi$slug';
    log(url);
    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiResponseHandler.getRequest(url);

      if (response.statusCode == 200) {
        final data = response.data;
        storeModel = StoreModel.fromJson(data);
      } else {
        // Handle error
        Logger().e('Failed to load store ${response.statusCode} ${response.data}');
        throw Exception('Failed to load store');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
