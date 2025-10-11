import 'dart:developer';

import 'package:event_app/core/network/api_endpoints/api_contsants.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/helper/functions/functions.dart';
import '../../models/wishlist_models/wish_list_response_models.dart';
import '../../models/wishlist_models/wishlist_items_models.dart';

///   ___________________________________  PROVIDER TO FETCH THE ITEMS IN THE WISHLIST ________________________________
class WishlistProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  WishlistModel? _wishlist;
  bool _isLoading = true;

  WishlistModel? get wishlist => _wishlist;

  bool get isLoading => _isLoading;

  Future<void> fetchWishlist() async {
    final user = await isLoggedIn();
    if (!user) {
      _isLoading = false;
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      const url = ApiEndpoints.wishlistItems;
      final response = await _apiResponseHandler.getRequest(url, extra: {ApiConstants.requireAuthKey: true});

      if (response.statusCode == 200) {
        _wishlist = WishlistModel.fromJson(response.data);
      }
    } catch (e) {
      log('Error in fetchWishlist: ${e.toString()}');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  ///     ------------------------------------------   DELETE WISHLIST ITEMS    ----------------------------------------------

  Future<void> deleteWishlistItem(int itemId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.wishList}$itemId';

    final response = await _apiResponseHandler.deleteRequest(url, extra: {ApiConstants.requireAuthKey: true});

    if (response.statusCode == 200) {
      final responseData = response.data;
      final wishlistResponse = WishlistResponseModels.fromJson(responseData);
      if (wishlistResponse.error == null || wishlistResponse.error == false) {
        // Re-fetch the wishlist after deletion
        await fetchWishlist();
        AppUtils.showToast(
          wishlistResponse.message ?? 'Item deleted successfully.',
          isSuccess: true,
        );
        notifyListeners();
      } else {
        AppUtils.showToast(
          wishlistResponse.message ?? 'Failed to delete item.',
        );
      }
    } else {
      AppUtils.showToast('Failed to delete wishlist item.');
    }

    _isLoading = false;
    notifyListeners();
  }
}
