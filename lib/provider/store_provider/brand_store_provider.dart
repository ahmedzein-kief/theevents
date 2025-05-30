import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';

class StoreModel {
  final bool error;
  final Data? data;
  final String? message;

  StoreModel({required this.error, this.data, this.message});

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      error: json['error'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class Data {
  final int id;
  final String name;
  final String logo;
  final String logoThumb;
  final String coverImage;
  final String title;
  final String description;
  final String slug;
  final SeoMeta? seoMeta;

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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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
  }
}

class SeoMeta {
  final String title;
  final String description;
  final String image;
  final String robots;

  SeoMeta({
    required this.title,
    required this.description,
    required this.image,
    required this.robots,
  });

  factory SeoMeta.fromJson(Map<String, dynamic> json) {
    return SeoMeta(
      title: json['title'],
      description: json['description'],
      image: json['image'],
      robots: json['robots'],
    );
  }
}

class StoreProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  StoreModel? storeModel;
  bool isLoading = false;

  Future<void> fetchStore(
    String slug,
    BuildContext context,
  ) async {
    // final url = 'https://api.staging.theevents.ae/api/v1/stores/$slug';
    final urlApi = ApiEndpoints.brandStore;
    final url = '${urlApi}$slug';
    isLoading = true;
    notifyListeners();

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        storeModel = StoreModel.fromJson(data);
      } else {
        throw Exception('Failed to load store');
      }
    } catch (error) {
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
