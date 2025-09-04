import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../core/helper/di/locator.dart';
import '../core/network/api_endpoints/api_end_point.dart';
import '../core/services/shared_preferences_helper.dart';
import '../models/dashboard/feature_categories_model/product_category_model.dart';

class SearchSuggestionsProvider extends ChangeNotifier {
  SearchSuggestionsProvider({Dio? dio}) : dio = dio ?? locator.get<Dio>();
  final Dio dio;

  ProductCategoryModel? _searchSuggestions;
  bool _isLoadingSuggestions = false;
  Timer? _debounceTimer;
  String _currentQuery = '';

  // Getters
  ProductCategoryModel? get searchSuggestions => _searchSuggestions;

  bool get isLoadingSuggestions => _isLoadingSuggestions;

  String get currentQuery => _currentQuery;

  List<Records>? get suggestionsList => _searchSuggestions?.data?.records;

  // Fetch search suggestions with debouncing
  Future<void> fetchSearchBarSuggestion(String query) async {
    // Cancel previous timer if it exists
    _debounceTimer?.cancel();

    // Don't fetch suggestions for empty queries
    if (query.trim().isEmpty) {
      clearSearchSuggestions();
      return;
    }

    // Don't fetch if query is the same as current
    if (query == _currentQuery && _searchSuggestions != null) {
      return;
    }

    _currentQuery = query;

    // Debounce the API call by 300ms to avoid too many requests
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      await _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    try {
      _isLoadingSuggestions = true;
      notifyListeners();

      log('Fetching search suggestions for: $query');

      final language = SecurePreferencesUtil.getLanguage() ?? 'en';
      final response = await dio.get(
          '${ApiEndpoints.searchBarSuggestion}?q=$query&language=$language',);

      if (response.statusCode == 200) {
        final responseBody = response.data;

        _searchSuggestions = ProductCategoryModel.fromJson(responseBody);

        if (_searchSuggestions?.data?.records != null) {
          log('Found ${_searchSuggestions!.data!.records!.length} suggestions');
        } else {
          log('No suggestions found in response');
        }
      } else {
        log('Failed to load search suggestions - Status: ${response.statusCode}');
        _searchSuggestions = null;
      }
    } catch (e) {
      log('Error fetching search suggestions: $e');
      _searchSuggestions = null;
    } finally {
      _isLoadingSuggestions = false;
      notifyListeners();
    }
  }

  // Method to clear search suggestions
  void clearSearchSuggestions() {
    _searchSuggestions = null;
    _currentQuery = '';
    _debounceTimer?.cancel();
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
