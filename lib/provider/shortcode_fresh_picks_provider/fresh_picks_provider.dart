import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/custom_toast.dart';
import '../../models/dashboard/fresh_picks_models/fresh_picks_model.dart';
import '../../models/dashboard/fresh_picks_models/freshpicks_ecom_tags_model.dart';
import '../../models/dashboard/fresh_picks_models/freshpicks_top_banner_model.dart';
import '../../models/wishlist_models/wish_list_response_models.dart';

class FreshPicksProvider extends ChangeNotifier {
  //    ================================================= Fresh Picks Home Page  Provider =================================================================
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<Records>? records;
  ProductFiltersModel? productFilters;

  bool get isLoading => _isLoading;
  TagsModel? tagsModel;

  List<Record> _records = [];
  bool _isLoading = false;
  PaginationEComTag? _paginationEComTag;
  bool _isMoreLoading = false;

  List<Record> get recordsData => _records;

  bool get isMoreLoading => _isMoreLoading;

  Future<void> fetchData(BuildContext context,
      {int perPage = 12, int page = 1, int random = 1}) async {
    _isLoading = true;
    notifyListeners();

    try {
      const String baseUrl = ApiEndpoints.homeProducts;
      final String queryParams = '?per-page=$perPage&page=$page&random=$random';
      final String url = baseUrl + queryParams;

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = HomeFreshPicksModels.fromJson(jsonData);
        records = data.data?.records;
        productFilters = data.data?.filters;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        throw Exception('Failed to load data');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

//    =================================================================  Fresh Picks View All Page Banner  Provider =================================================================

  Future<void> fetchTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      // const String url = 'https://api.staging.theevents.ae/api/v1/pages/tags';
      const String url = ApiEndpoints.homeProductsViewAllBanner;
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        tagsModel = TagsModel.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      tagsModel = null;
      _isLoading = false;
      notifyListeners();
    }
  }

//    =================================================================  E-com Tags Items List of Fresh Picks  =+================================================================

  Future<void> fetchEcomTags(
      {String sortBy = 'default_sorting',
      int page = 1,
      int perPage = 20}) async {
    if (page == 1) {
      _isLoading = true;
    } else {
      _isMoreLoading = true;
    }
    _isLoading = true;
    notifyListeners();

    final url =
        '${ApiEndpoints.eComTagsAll}?per_page=$perPage&page=$page&sort-by=$sortBy';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final ecomTagsResponse = EcomTagsResponse.fromJson(data);

        if (page == 1) {
          _records = ecomTagsResponse.data.records;
          _paginationEComTag = ecomTagsResponse.data.pagination;
        } else {
          _records.addAll(ecomTagsResponse.data.records);
        }
        _records = ecomTagsResponse.data.records;
        _isLoading = false;
      } else {
        _isLoading = false;
      }
    } catch (error) {
      _isLoading = false;
    }
    _isLoading = false;
    _isMoreLoading = false;
    notifyListeners();
  }

  ///      ----------------------------------------------------------------   ADD THE ITEMS TO THE WISHLIST SCREEN  ----------------------------------------------------------------
  ///  with login
  Future<void> handleHeartTap(BuildContext context, int itemId) async {
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.wishList}$itemId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final wishlistResponse = WishlistResponseModels.fromJson(responseData);
      if (!wishlistResponse.error!) {
        CustomSnackbar.showSuccess(context, wishlistResponse.message!);
        notifyListeners(); // Notify listeners to update the UI
      } else {
        CustomSnackbar.showError(context, wishlistResponse.message!);
      }
    } else {
      CustomSnackbar.showError(context, 'Failed to update wishlist.');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<WishlistResponseModels?> addRemoveWishList(
      BuildContext context, int itemId) async {
    _isLoading = true;
    notifyListeners();
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.wishList}$itemId';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final wishlistResponse = WishlistResponseModels.fromJson(responseData);
      if (!wishlistResponse.error!) {
        CustomSnackbar.showSuccess(context, wishlistResponse.message!);
        _isLoading = false;
        notifyListeners(); // Notify listeners to update the UI
        return wishlistResponse;
      } else {
        CustomSnackbar.showError(context, wishlistResponse.message!);
      }
    } else {
      CustomSnackbar.showError(context, 'Failed to update wishlist.');
    }
    _isLoading = false;
    notifyListeners();
    return null;
  }
}
