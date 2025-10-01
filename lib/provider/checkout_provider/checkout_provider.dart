import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/network/api_endpoints/api_contsants.dart';
import '../../core/widgets/bottom_navigation_bar.dart';
import '../../models/checkout_models/checkout_data_models.dart';
import '../../views/payment_screens/payment_view_screen.dart';

class CheckoutProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  CheckoutResponse? _checkoutData;

  CheckoutResponse? get checkoutData => _checkoutData;

  bool isLoading = false;

  // NEW: Track if we're processing payment to prevent UI rebuilds
  bool _isProcessingPayment = false;

  bool get isProcessingPayment => _isProcessingPayment;

  void setLoading(bool value) {
    isLoading = value;
    // Only notify if we're not in the middle of payment processing
    if (!_isProcessingPayment) {
      notifyListeners();
    }
  }

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
        postDataMap['shipping_method[$value]'] = 'default';
        postDataMap['shipping_option[$value]'] = shippingMethod['method_id'] ?? '';
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
      }
    } catch (e) {
      log('fetchCheckoutData error: $e');
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
      }
    } catch (e) {
      log('Error applying coupon code: $e');
    }
    return false;
  }

  // NEW: Process gateway payment with navigation handling
  Future<void> processGatewayPayment({
    required BuildContext context,
    required String checkoutToken,
    required String token,
    required Map<String, String> paymentMethod,
    required bool isNewAddress,
  }) async {
    if (_checkoutData == null) return;

    // Mark that we're processing payment - this prevents rebuilds
    _isProcessingPayment = true;
    setLoading(true);

    try {
      // Get checkout URL
      final checkoutURL = await checkoutPaymentLink(
        context,
        checkoutToken,
        token,
        _checkoutData!,
        paymentMethod,
        isNewAddress,
      );

      log('Checkout URL received: $checkoutURL');

      if (checkoutURL == null || checkoutURL.isEmpty) {
        log('Checkout URL is null or empty');
        if (context.mounted) {
          AppUtils.showToast('Payment link generation failed');
        }
        return;
      }

      // Navigate to payment screen - context is still valid here
      if (!context.mounted) {
        log('Context unmounted, cannot navigate');
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentViewScreen(checkoutUrl: checkoutURL),
        ),
      );
    } catch (e) {
      log('Gateway payment error: $e');
      if (context.mounted) {
        AppUtils.showToast('Payment failed: ${e.toString()}');
      }
    } finally {
      _isProcessingPayment = false;
      setLoading(false);
    }
  }

  Future<String?> checkoutPaymentLink(
    BuildContext context,
    String checkoutToken,
    String token,
    CheckoutResponse checkoutData,
    Map paymentMethod,
    bool isNewAddress,
  ) async {
    final data = checkoutData.data;
    if (data == null) return null;

    // Don't set loading here - let the caller handle it
    try {
      final formData = FormData.fromMap({
        'tracked_start_checkout': checkoutToken,
        'amount': data.orderAmount.toString(),
        'is_mobile': '1',
        'payment_method': paymentMethod['payment_method'] ?? '',
      });

      if (paymentMethod['sub_option_key'] != null && paymentMethod['sub_option_value'] != null) {
        formData.fields.add(MapEntry(
          paymentMethod['sub_option_key']!,
          paymentMethod['sub_option_value']!,
        ));
      }

      final session = data.sessionCheckoutData;
      formData.fields.addAll([
        MapEntry('address[name]', session.name),
        MapEntry('address[email]', session.email),
        MapEntry('address[phone]', session.phone),
        MapEntry('address[country]', session.country),
        MapEntry('address[city]', session.city),
        MapEntry('address[address]', session.address),
        MapEntry('address[address_id]', isNewAddress ? 'new' : data.sessionCheckoutData.addressId.toString()),
      ]);

      final vendorData = data.sessionCheckoutData.marketplace;
      vendorData.forEach((key, value) {
        final id = key;
        final method = data.defaultShippingMethod;
        final option = data.defaultShippingOption;
        formData.fields.addAll([
          MapEntry('shipping_method[$id]', method),
          MapEntry('shipping_option[$id]', option),
        ]);
      });

      final url = '${ApiEndpoints.checkout}$checkoutToken/process';
      final headers = {
        'Authorization': token,
      };

      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        headers: headers,
        formData: formData,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        final paymentData = CheckoutPaymentModel.fromJson(jsonData);
        return paymentData.data.checkoutUrl;
      } else {
        final jsonResponse = response.data;
        AppUtils.showToast('${AppStrings.paymentFailed} ${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('checkoutPaymentLink error: $e');

      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        AppUtils.showToast('${AppStrings.paymentFailed} $errorMessage');
      } else {
        AppUtils.showToast('${AppStrings.paymentFailed} ${e.toString()}');
      }
      return null;
    }
  }

  Future<void> payWithWallet(
    BuildContext context,
    String checkoutToken,
    CheckoutResponse? checkoutData,
    bool isNewAddress,
  ) async {
    if (checkoutData == null || checkoutData.data == null) return;
    final data = checkoutData.data!;

    // Mark as processing to prevent rebuilds
    _isProcessingPayment = true;

    final formData = FormData.fromMap({
      'tracked_start_checkout': checkoutToken,
      'amount': data.orderAmount.toString(),
      'is_mobile': '1',
      'payment_method': 'wallet',
    });

    final session = data.sessionCheckoutData;
    formData.fields.addAll([
      MapEntry('address[name]', session.name),
      MapEntry('address[email]', session.email),
      MapEntry('address[phone]', session.phone),
      MapEntry('address[country]', session.country),
      MapEntry('address[city]', session.city),
      MapEntry('address[address]', session.address),
      MapEntry('address[address_id]', isNewAddress ? 'new' : data.sessionCheckoutData.addressId.toString()),
    ]);

    final vendorData = data.sessionCheckoutData.marketplace;
    vendorData.forEach((key, value) {
      final id = key;
      final method = data.defaultShippingMethod;
      final option = data.defaultShippingOption;
      formData.fields.addAll([
        MapEntry('shipping_method[$id]', method),
        MapEntry('shipping_option[$id]', option),
      ]);
    });

    final url = '${ApiEndpoints.checkout}$checkoutToken/process';

    try {
      setLoading(true);

      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        extra: {ApiConstants.requireAuthKey: true},
        formData: formData,
      );

      if (response.statusCode == 200) {
        final url = response.data['data']['url'];
        final urlMobile = '$url?is_mobilesam=1';

        final urlResponse = await _apiResponseHandler.getDioRequest(urlMobile);

        if (urlResponse.statusCode == 200) {
          final jsonData = urlResponse.data;
          final orderId = jsonData['order_id'];

          if (context.mounted && orderId != null) {
            // Use pushAndRemoveUntil to clear the entire navigation stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BaseHomeScreen(
                  shouldNavigateToOrders: true,
                  orderId: orderId.toString(),
                ),
              ),
              (route) => false, // Remove all previous routes
            );
          }
        } else {
          final jsonResponse = urlResponse.data;
          AppUtils.showToast('${AppStrings.paymentFailed} ${jsonResponse["message"]}');
          throw Exception('Failed to load data');
        }
      } else {
        final jsonResponse = response.data;
        AppUtils.showToast('${AppStrings.paymentFailed} ${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('payWithWallet error: $e');

      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        AppUtils.showToast('${AppStrings.paymentFailed}: $errorMessage');
      } else {
        AppUtils.showToast('${AppStrings.paymentFailed}: ${e.toString()}');
      }
    } finally {
      _isProcessingPayment = false;
      setLoading(false);
    }
  }
}
