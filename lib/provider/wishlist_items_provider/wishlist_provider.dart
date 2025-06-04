import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../core/utils/custom_toast.dart';
import '../../models/wishlist_models/wish_list_response_models.dart';
import '../../models/wishlist_models/wishlist_items_models.dart';

///   ___________________________________  PROVIDER TO FETCH THE ITEMS IN THE WISHLIST ________________________________
class WishlistProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  WishlistModel? _wishlist;
  bool _isLoading = true;

  WishlistModel? get wishlist => _wishlist;

  bool get isLoading => _isLoading;

  Future<void> fetchWishlist(
    String token,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();
    const url = ApiEndpoints.wishlistItems;
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await _apiResponseHandler.getRequest(
      url,
      headers: headers,
      context: context,
    );

    if (response.statusCode == 200) {
      _wishlist = WishlistModel.fromJson(json.decode(response.body));
      notifyListeners();
    } else {}

    _isLoading = false;
    notifyListeners();
  }

  ///     ------------------------------------------   DELETE WISHLIST ITEMS    ----------------------------------------------

  Future<void> deleteWishlistItem(
    int itemId,
    BuildContext context,
    String token,
  ) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.wishList}$itemId';
    final headers = {'Authorization': 'Bearer $token'};

    final response =
        await _apiResponseHandler.deleteRequest(url, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final wishlistResponse = WishlistResponseModels.fromJson(responseData);
      if (wishlistResponse.error == null || wishlistResponse.error == false) {
        // Re-fetch the wishlist after deletion
        await fetchWishlist(token, context);
        CustomSnackbar.showSuccess(
            context, wishlistResponse.message ?? 'Item deleted successfully.');
        notifyListeners();
      } else {
        CustomSnackbar.showError(
            context, wishlistResponse.message ?? 'Failed to delete item.');
      }
    } else {
      CustomSnackbar.showError(context, 'Failed to delete wishlist item.');
    }

    _isLoading = false;
    notifyListeners();
  }
}
