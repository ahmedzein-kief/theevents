import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/gift_card_models.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

class GiftCardInnerProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  GiftCardPage? _apiResponse;

  bool _loading = false;
  String? _error;

  GiftCardPage? get apiResponse => _apiResponse;

  bool get loading => _loading;

  String? get error => _error;

  Future<void> createGiftCardPage(BuildContext context) async {
    _loading = true;
    notifyListeners();

    const url = ApiEndpoints.giftCardBanner;

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        _apiResponse = GiftCardPage.fromJson(response.data);
        _error = null;
      } else {
        _error = 'Failed to load data';
      }
    } catch (e) {
      _error = 'An error occurred';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}

class CreateGiftCardProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  CheckoutPaymentModel? _apiResponse;
  bool _loading = false;
  String? _error;

  CheckoutPaymentModel? get apiResponse => _apiResponse;

  bool get loading => _loading;

  String? get error => _error;

  Future<CheckoutPaymentModel?> createGiftCard(
    String selectedPrice,
    String name,
    String email,
    String notes,
    Map<String, String> paymentMethod,
  ) async {
    _loading = true;
    notifyListeners();

    final token = await SecurePreferencesUtil.getToken();

    final headers = {
      'Authorization': 'Bearer $token',
    };

    const url = ApiEndpoints.createGiftCard;

    /*'payment_method': paymentMethod['payment_method'] ?? "",
      paymentMethod['sub_option_key'] ?? "": paymentMethod['sub_option_value'] ?? "",*/

    final updateURL =
        '$url?payment_method=${paymentMethod['payment_method']}&${paymentMethod['sub_option_key']}=${paymentMethod['sub_option_value']}&value=$selectedPrice&recipient_email=$email&recipient_name=$name&additional_notes=$notes';

    try {
      final response =
          await _apiResponseHandler.postRequest(updateURL, headers: headers);

      if (response.statusCode == 200) {
        _error = null;
        return CheckoutPaymentModel.fromJson(response.data);
      } else {
        _error = 'Failed to load data';
      }
    } catch (e) {
      _error = 'An error occurred';
    } finally {
      _loading = false;
      notifyListeners();
    }
    return null;
  }
}
