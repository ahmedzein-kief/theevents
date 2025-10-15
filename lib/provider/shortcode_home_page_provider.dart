import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:provider/provider.dart';

import '../core/helper/di/locator.dart';
import '../models/dashboard/home_page_models.dart';
import 'locale_provider.dart';

class HomePageProvider with ChangeNotifier {
  HomePageProvider({Dio? dio}) : dio = dio ?? locator.get<Dio>();
  final Dio dio;
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

  final Map<String, dynamic> _cachedHomeData = {};

  Future<void> fetchHomePageData(BuildContext context, {bool forceRefresh = false}) async {
    if (_isLoading && !forceRefresh) return;

    _isLoading = true;
    notifyListeners();

    // Get current locale once at the start
    final currentLocale =
        context.mounted ? Provider.of<LocaleProvider>(context, listen: false).locale.languageCode : null;

    if (currentLocale == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      // Check cache first (unless forcing refresh)
      if (_cachedHomeData[currentLocale] != null && !forceRefresh) {
        final cachedData = _cachedHomeData[currentLocale]!;
        _processHomePageData(cachedData);
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Fetch from API with locale parameter
      final response = await dio.get(
        ApiEndpoints.shortCode,
        queryParameters: {'locale': currentLocale},
      );

      if (response.statusCode == 200) {
        final responseBody = response.data;
        final homePageData = HomePageData.fromJson(responseBody);

        // Cache the data for this locale
        _cachedHomeData[currentLocale] = homePageData;

        // Process the data
        _processHomePageData(homePageData);
      } else {
        // If we have cached data, use it even if API fails
        if (_cachedHomeData[currentLocale] != null) {
          _processHomePageData(_cachedHomeData[currentLocale]!);
        }
      }
    } catch (e) {
      // Fallback to cached data if available and context is mounted
      if (context.mounted && _cachedHomeData[currentLocale] != null) {
        _processHomePageData(_cachedHomeData[currentLocale]!);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _processHomePageData(HomePageData homePageData) {
    // Reset values before extracting again
    _featuredBrandsTitle = null;
    _userByTypeTitle = null;
    _featuredCategoryTitle = null;

    extractDataFromHtml(homePageData.data!.content.toString());
  }

  // Helper method to clear cache if needed
  void clearHomePageCache() {
    _cachedHomeData.clear();
    // Reset titles when clearing cache
    _featuredBrandsTitle = null;
    _userByTypeTitle = null;
    _featuredCategoryTitle = null;
    _extractedData.clear();
    notifyListeners();
  }

  // Helper method to clear cache for specific locale
  void clearHomePageCacheForLocale(String locale) {
    _cachedHomeData.remove(locale);
  }

  void extractDataFromHtml(String htmlContent) {
    _extractedData.clear();
    final document = html_parser.parse(htmlContent);

    document.querySelectorAll('section').forEach((element) {
      final shortcodeName = element.children.isNotEmpty ? element.children.first.localName : '';
      final attributes = <String, dynamic>{};

      element.children.first.attributes.forEach((key, value) {
        attributes[key.toString()] = value;
      });

      // Check for the specific shortcode and extract the title attribute
      if (shortcodeName == 'shortcode-featured-brands') {
        _featuredBrandsTitle = attributes['title'];
      }

      if (shortcodeName == 'shortcode-users-by-type') {
        _userByTypeTitle = attributes['title'];
      }

      if (shortcodeName == 'shortcode-featured-categories') {
        _featuredCategoryTitle = attributes['title'];
      }

      _extractedData.add({
        'shortcode': shortcodeName,
        'attributes': attributes,
      });
    });
  }
}
