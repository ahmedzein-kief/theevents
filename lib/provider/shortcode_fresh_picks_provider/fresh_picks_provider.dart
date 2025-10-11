import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/product_packages_models/product_filters_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../core/helper/di/locator.dart';
import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/app_utils.dart';
import '../../core/widgets/custom_items_views/custom_toast.dart';
import '../../models/dashboard/fresh_picks_models/fresh_picks_model.dart';
import '../../models/dashboard/fresh_picks_models/freshpicks_ecom_tags_model.dart';
import '../../models/dashboard/fresh_picks_models/freshpicks_top_banner_model.dart';
import '../../models/wishlist_models/wish_list_response_models.dart';
import '../../views/auth_screens/auth_page_view.dart';

class FreshPicksProvider extends ChangeNotifier {
  FreshPicksProvider({Dio? dio}) : dio = dio ?? locator.get<Dio>();
  final Dio dio;

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  List<Records>? records;
  ProductFiltersModel? productFilters;

  bool get isLoading => _isLoading;
  TagsModel? tagsModel;

  List<Record> _records = [];
  bool _isLoading = false;

  bool _isMoreLoading = false;

  List<Record> get recordsData => _records;

  bool get isMoreLoading => _isMoreLoading;

  /// Check if user is logged in
  Future<bool> _isLoggedIn() async {
    final token = await SecurePreferencesUtil.getToken();
    return token != null && token.isNotEmpty;
  }

  /// Navigate to login screen with appropriate message
  void navigateToLogin(BuildContext context, String messageKey) {
    if (!context.mounted) return; // Check if context is still valid

    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: const AuthScreen(),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.fade,
    );

    final CustomToast customToast = CustomToast(context);
    customToast.showToast(
      context: context,
      textHint: messageKey,
      onDismiss: () {
        customToast.removeToast();
      },
    );
  }

  Future<void> fetchData(
    BuildContext context, {
    int perPage = 12,
    int page = 1,
    int random = 1,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      const String baseUrl = ApiEndpoints.homeProducts;
      final String queryParams = '?per-page=$perPage&page=$page&random=$random';
      final String url = baseUrl + queryParams;

      final response = await _apiResponseHandler.getRequest(url);

      if (response.statusCode == 200) {
        final jsonData = response.data;
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

  Future<void> fetchTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      const String url = ApiEndpoints.homeProductsViewAllBanner;
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final jsonData = response.data;
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

  Future<void> fetchEcomTags({
    String sortBy = 'default_sorting',
    int page = 1,
    int perPage = 20,
  }) async {
    if (page == 1) {
      _isLoading = true;
    } else {
      _isMoreLoading = true;
    }
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.eComTagsAll}?per_page=$perPage&page=$page&sort-by=$sortBy';
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data;
        final ecomTagsResponse = EcomTagsResponse.fromJson(data);

        if (page == 1) {
          _records = ecomTagsResponse.data.records;
        } else {
          _records.addAll(ecomTagsResponse.data.records);
        }
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

  Future<void> handleHeartTap(BuildContext context, int itemId) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      if (context.mounted) {
        // Check if context is still valid
        navigateToLogin(context, 'Please log in to manage your wishlist');
      }
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.wishList}$itemId';

      final response = await dio.post(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final wishlistResponse = WishlistResponseModels.fromJson(responseData);

        if (!wishlistResponse.error!) {
          AppUtils.showToast(wishlistResponse.message!, isSuccess: true);
        } else {
          AppUtils.showToast(wishlistResponse.message!);
        }
      } else {
        AppUtils.showToast('Failed to update wishlist.');
      }
    } catch (e) {
      AppUtils.showToast('An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<WishlistResponseModels?> addRemoveWishList(
    BuildContext context,
    int itemId,
  ) async {
    // Check authentication first
    final bool loggedIn = await _isLoggedIn();
    if (!loggedIn) {
      if (context.mounted) {
        // Check if context is still valid
        navigateToLogin(context, 'Please log in to manage your wishlist');
      }
      return null;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.wishList}$itemId';

      final response = await dio.post(
        url,
        options: Options(headers: {'Authorization': token}),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        final wishlistResponse = WishlistResponseModels.fromJson(responseData);

        if (!wishlistResponse.error!) {
          AppUtils.showToast(wishlistResponse.message!, isSuccess: true);
          return wishlistResponse;
        } else {
          AppUtils.showToast(wishlistResponse.message!);
        }
      } else {
        AppUtils.showToast('Failed to update wishlist.');
      }
    } catch (e) {
      AppUtils.showToast('An error occurred. Please try again.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    return null;
  }
}
