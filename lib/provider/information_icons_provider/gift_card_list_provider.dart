import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/network/api_endpoints/api_contsants.dart';
import '../../models/dashboard/information_icons_models/gift_card_models/gift_card_list_response.dart';

class GiftCardListProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  GiftCardListResponse? _apiResponse;
  List<GiftCardItem> _giftCards = [];
  bool _loading = false;
  String? _error;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _hasMoreData = true;

  GiftCardListResponse? get apiResponse => _apiResponse;

  List<GiftCardItem> get giftCards => _giftCards;

  bool get loading => _loading;

  String? get error => _error;

  int get currentPage => _currentPage;

  int get totalPages => _totalPages;

  bool get hasMoreData => _hasMoreData;

  Future<void> fetchGiftCardList(BuildContext context, {bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _giftCards.clear();
      _hasMoreData = true;
    }

    if (_loading || !_hasMoreData) return;

    _loading = true;
    _error = null; // Clear any previous errors
    notifyListeners();

    const url = ApiEndpoints.giftCardList;
    final fullUrl = '$url?language=en&per_page=10&page=$_currentPage';

    try {
      final response = await _apiResponseHandler.getDioRequest(
        fullUrl,
        extra: {ApiConstants.requireAuthKey: true},
      );

      if (response.statusCode == 200) {
        _apiResponse = GiftCardListResponse.fromJson(response.data);

        if (_apiResponse?.data != null) {
          final newGiftCards = _apiResponse!.data!.records ?? [];

          if (_currentPage == 1) {
            _giftCards = newGiftCards;
          } else {
            _giftCards.addAll(newGiftCards);
          }

          // Update pagination info
          final pagination = _apiResponse!.data!.pagination;
          if (pagination != null) {
            _totalPages = pagination.lastPage ?? 1;
            _hasMoreData = _currentPage < _totalPages;
          }
        }
        _error = null;
      } else {
        _error = 'Failed to load gift cards';
      }
    } catch (e) {
      if (e is DioException) {
        // Handle "No record found!" as empty state, not an error
        if (e.response?.statusCode == 422 &&
            e.response?.data != null &&
            e.response?.data['message'] == 'No record found!') {
          _giftCards = [];
          _error = null; // Don't set this as an error
          _hasMoreData = false;
        } else {
          // Handle actual errors
          _error = e.response?.data?['message'] ?? 'An error occurred while loading gift cards';
        }
      } else {
        _error = 'An error occurred while loading gift cards';
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreGiftCards(BuildContext context) async {
    if (_hasMoreData && !_loading) {
      _currentPage++;
      await fetchGiftCardList(context);
    }
  }

  void refreshGiftCards(BuildContext context) {
    fetchGiftCardList(context, refresh: true);
  }

  void clearData() {
    _giftCards.clear();
    _apiResponse = null;
    _error = null;
    _currentPage = 1;
    _totalPages = 1;
    _hasMoreData = true;
    notifyListeners();
  }
}
