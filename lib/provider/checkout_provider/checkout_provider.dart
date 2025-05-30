import 'dart:convert';

import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/checkout_models/checkout_data_models.dart';

class CheckoutProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  CheckoutResponse? _checkoutData;

  CheckoutResponse? get checkoutData => _checkoutData;

  bool isLoading = false;

  Future<bool> fetchCheckoutData(
    BuildContext context,
    String checkoutToken,
    String tokenLogin,
    SessionCheckoutData? sessionCheckoutData,
    Map<String, String> shippingMethod,
  ) async {
    final url = '${ApiEndpoints.checkout}$checkoutToken';
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $tokenLogin',
    };

    var marketPlaceList = sessionCheckoutData?.marketplace?.data?.keys.toList() ?? [];

    Map<String, String> postDataMap = {
      'tracked_start_checkout': checkoutToken,
    };

    print('token ${tokenLogin}');
    print('checkoutToken ${checkoutToken}');

    if (marketPlaceList.isNotEmpty) {
      marketPlaceList.forEach((value) {
        // Add to postDataMap
        postDataMap['shipping_method[$value]'] = "default"; // Ensure non-null value
        postDataMap['shipping_option[$value]'] = shippingMethod['method_id'] ?? ""; // Ensure non-null value
      });
    }

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
        queryParams: postDataMap,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        print('json data ${jsonData}');

        _checkoutData = CheckoutResponse.fromJson(jsonData);

        notifyListeners();
        return true;
      } else {
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> applyRemoveCouponCode(
    BuildContext context,
    String checkoutToken,
    String tokenLogin,
    String couponCode,
    bool isApply,
  ) async {
    final url = isApply ? '${ApiEndpoints.couponApply}' : '${ApiEndpoints.couponRemove}';
    final headers = {
      'Authorization': 'Bearer $tokenLogin',
    };

    Map<String, String> postDataMap = {
      'tracked_start_checkout': checkoutToken,
      'coupon_code': couponCode,
    };

    try {
      final response = await _apiResponseHandler.postRequest(
        url,
        headers: headers,
        body: postDataMap,
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        notifyListeners();
        if (jsonData['error'] == false) {
          return true;
        } else {
          return false;
        }
      } else {
      }
    } catch (e) {
    }
    return false;
  }

  Future<String?> checkoutPaymentLink(
    BuildContext context,
    String checkoutToken,
    String token,
    CheckoutResponse checkoutData,
    Map<String, String> paymentMethod,
  ) async {

    var data = checkoutData.data;

    Map<String, String> postDataMap = {
      'tracked_start_checkout': checkoutToken,
      'is_mobile': '1',
      'amount': data?.orderAmount?.toString() ?? "",
      'payment_method': paymentMethod['payment_method'] ?? "",
      paymentMethod['sub_option_key'] ?? "": paymentMethod['sub_option_value'] ?? "",
      'description': '',
      'address[address_id]': data?.sessionCheckoutData?.addressId.toString() ?? "",
      'address[name]': data?.sessionCheckoutData?.name ?? "",
      'address[email]': data?.sessionCheckoutData?.email ?? "",
      'address[phone]': data?.sessionCheckoutData?.phone ?? "",
      'address[country]': data?.sessionCheckoutData?.country ?? "",
      'address[city]': data?.sessionCheckoutData?.city ?? "",
      'address[address]': data?.sessionCheckoutData?.address ?? "",
      'billing_address_same_as_shipping_address': "1",
    };

    var vendorData = data?.sessionCheckoutData?.marketplace?.data;

    vendorData?.forEach((key, value) {
      final id = key; // The key acts as the ID
      final method = data?.defaultShippingMethod;
      final option = data?.defaultShippingOption;
      // Add to postDataMap
      postDataMap['shipping_method[$id]'] = method ?? ""; // Ensure non-null value
      postDataMap['shipping_option[$id]'] = option ?? ""; // Ensure non-null value
    });


    final url = '${ApiEndpoints.checkout}$checkoutToken/process';
    final headers = {
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await _apiResponseHandler.postRequest(url, headers: headers, body: postDataMap);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        var data = CheckoutPaymentModel.fromJson(jsonData);

        notifyListeners();

        return data.data.checkoutUrl;
      } else {
        final jsonResponse = json.decode(response.body);
        CustomSnackbar.showError(context, '${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
    }
    notifyListeners();
    return null;
  }
}
