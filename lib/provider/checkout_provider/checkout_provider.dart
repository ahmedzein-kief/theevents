import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/custom_toast.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
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
      'Authorization': tokenLogin,
    };

    final marketPlaceList = sessionCheckoutData?.marketplace.keys.toList() ?? [];

    final Map<String, String> postDataMap = {
      'tracked_start_checkout': checkoutToken,
    };

    if (marketPlaceList.isNotEmpty) {
      for (final value in marketPlaceList) {
        // Add to postDataMap
        postDataMap['shipping_method[$value]'] = 'default'; // Ensure non-null value
        postDataMap['shipping_option[$value]'] = shippingMethod['method_id'] ?? ''; // Ensure non-null value
      }
    }

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
        queryParams: postDataMap,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;

        _checkoutData = CheckoutResponse.fromJson(jsonData);

        notifyListeners();
        return true;
      } else {}
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
    final url = isApply ? ApiEndpoints.couponApply : ApiEndpoints.couponRemove;
    final headers = {
      'Authorization': tokenLogin,
    };

    final Map<String, String> postDataMap = {
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
        final jsonData = response.data;

        notifyListeners();
        if (jsonData['error'] == false) {
          return true;
        } else {
          return false;
        }
      } else {}
    } catch (e) {}
    return false;
  }

  Future<String?> checkoutPaymentLink(
    BuildContext context,
    String checkoutToken,
    String token,
    CheckoutResponse checkoutData,
    Map paymentMethod,
    bool isNewAddress,
  ) async {
    log('checkoutData checkoutPaymentLink');

    final data = checkoutData.data;
    if (data == null) return null;

    // Create FormData
    final formData = FormData.fromMap({
      'tracked_start_checkout': checkoutToken,
      'amount': data.orderAmount.toString(),
      'is_mobile': '1',
      'payment_method': paymentMethod['payment_method'] ?? '',
    });

    // Add payment method sub-options if available
    if (paymentMethod['sub_option_key'] != null && paymentMethod['sub_option_value'] != null) {
      formData.fields.add(MapEntry(
        paymentMethod['sub_option_key']!,
        paymentMethod['sub_option_value']!,
      ));
    }

    // Add address fields
    final session = data.sessionCheckoutData;
    formData.fields.addAll([
      MapEntry('address[name]', session.name ?? ''),
      MapEntry('address[email]', session.email ?? ''),
      MapEntry('address[phone]', session.phone ?? ''),
      MapEntry('address[country]', session.country ?? ''),
      MapEntry('address[city]', session.city ?? ''),
      MapEntry('address[address]', session.address ?? ''),
      MapEntry('address[address_id]', isNewAddress ? 'new' : data.sessionCheckoutData.addressId.toString()),
    ]);

    // Add shipping info per vendor
    final vendorData = data.sessionCheckoutData.marketplace;
    vendorData.forEach((key, value) {
      final id = key;
      final method = data.defaultShippingMethod ?? 'default';
      final option = data.defaultShippingOption ?? '';
      formData.fields.addAll([
        MapEntry('shipping_method[$id]', method),
        MapEntry('shipping_option[$id]', option),
      ]);
    });

    final url = '${ApiEndpoints.checkout}$checkoutToken/process';
    final headers = {
      'Authorization': token,
      // 'Content-Type' header is automatically set to 'multipart/form-data' by Dio
      // when using FormData, so we don't need to include it here
    };

    try {
      // Use the multipart request method
      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        headers,
        formData,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final paymentData = CheckoutPaymentModel.fromJson(jsonData);
        notifyListeners();
        return paymentData.data.checkoutUrl;
      } else {
        final jsonResponse = response.data;
        CustomSnackbar.showError(context, '${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('checkoutPaymentLink error: $e');

      // Handle DioException specifically to get better error messages
      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        log('Dio error details: $errorMessage');
        CustomSnackbar.showError(context, 'Payment failed: $errorMessage');
      } else {
        CustomSnackbar.showError(context, 'Payment failed: ${e.toString()}');
      }
    }

    notifyListeners();
    return null;
  }
}
