import 'dart:convert';
import 'dart:developer';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/dashboard/home_page_models.dart';

class HomePageProvider with ChangeNotifier {
  final List<Map<String, dynamic>> _extractedData = [];
  bool _isLoading = false;
  String? _featuredBrandsTitle;
  String? _userByTypeTitle;
  String? _featuredCategoryTitle;

  List<Map<String, dynamic>> get extractedData => _extractedData;

  bool get isLoading => _isLoading;

  String? get featuredBrandsTitle => _featuredBrandsTitle;

  String? get userByTypeTitle => _userByTypeTitle;

  String? get featuredCategoryTitle => _featuredCategoryTitle;

  Future<void> fetchHomePageData() async {
    if (isLoading) return;
    notifyListeners();

    _isLoading = true;

    try {
      final Response response =
          await http.get(Uri.parse(ApiEndpoints.shortCode));

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final object = HomePageData.fromJson(responseBody);

        extractDataFromHtml(object.data!.content.toString());
      } else {
        log('Failed to load data');
      }
    } catch (e) {
      log('Error fetching data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void extractDataFromHtml(String htmlContent) {
    _extractedData.clear();
    _featuredBrandsTitle = null;
    final document = html_parser.parse(htmlContent);

    document.querySelectorAll('section').forEach((element) {
      final shortcodeName =
          element.children.isNotEmpty ? element.children.first.localName : '';
      final attributes = <String, dynamic>{};

      element.children.first.attributes.forEach((key, value) {
        attributes[key.toString()] = value;
      });

      //    Check for the specific shortcode and extract the title attribute
      if (shortcodeName == 'shortcode-featured-brands') {
        _featuredBrandsTitle = attributes[
            'title']; // Assuming the title attribute is always present in the shortcode-featured-brands element
      }

      if (shortcodeName == 'shortcode-users-by-type') {
        _userByTypeTitle = attributes[
            'title']; // Assuming the title attribute is always present in the shortcode-featured-brands element
      }

      if (shortcodeName == 'shortcode-featured-categories') {
        _featuredCategoryTitle = attributes[
            'title']; // Assuming the title attribute is always present in the shortcode-featured-brands element
      }

      _extractedData.add({
        'shortcode': shortcodeName,
        'attributes': attributes,
      });
    });

    // Log to verify extracted data
    log(_extractedData.toString());
  }
}
