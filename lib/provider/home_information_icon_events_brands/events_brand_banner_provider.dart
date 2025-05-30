import 'dart:convert';

import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

class EventsBrand {
  bool error;
  Data data;
  String? message;

  EventsBrand({
    required this.error,
    required this.data,
    this.message,
  });

  factory EventsBrand.fromJson(Map<String, dynamic> json) {
    return EventsBrand(
      error: json['error'],
      data: Data.fromJson(json['data']),
      message: json['message'],
    );
  }
}

class Data {
  int id;
  String name;
  String? description;
  String slug;
  String image;
  String thumb;
  String coverImage;
  int items;
  String? website;
  int isFeatured;
  SeoMeta seoMeta;

  Data({
    required this.id,
    required this.name,
    this.description,
    required this.slug,
    required this.image,
    required this.thumb,
    required this.coverImage,
    required this.items,
    this.website,
    required this.isFeatured,
    required this.seoMeta,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      slug: json['slug'],
      image: json['image'],
      thumb: json['thumb'],
      coverImage: json['cover_image'],
      items: json['items'],
      website: json['website'],
      isFeatured: json['is_featured'],
      seoMeta: SeoMeta.fromJson(json['seo_meta']),
    );
  }
}

class SeoMeta {
  String title;
  String description;
  String image;
  String robots;

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

class EventsBrandProvider extends ChangeNotifier {
  EventsBrand? eventsBrand;
  bool isLoading = false;
  String errorMessage = '';
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  Future<void> fetchEventsBrand(BuildContext context) async {
    final url = 'https://api.staging.theevents.ae/api/v1/collections/events-brand';

    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        eventsBrand = EventsBrand.fromJson(data);
        errorMessage = '';
      } else {
        errorMessage = 'Failed to load data';
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
