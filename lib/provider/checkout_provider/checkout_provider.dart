import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/core/utils/app_utils.dart';
import 'package:event_app/models/dashboard/information_icons_models/gift_card_models/checkout_payment_model.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:event_app/views/cart_screens/widgets/coupon_state.dart';
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

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool _isCouponLoading = false;

  bool get isCouponLoading => _isCouponLoading;

  bool _isProcessingPayment = false;

  bool get isProcessingPayment => _isProcessingPayment;

  // NEW: Coupon state managed in provider
  CouponState _couponState = CouponState.empty();

  CouponState get couponState => _couponState;

  void _setLoading(bool value) {
    _isLoading = value;
    if (!_isProcessingPayment) {
      notifyListeners();
    }
  }

  void _setCouponLoading(bool value) {
    _isCouponLoading = value;
    notifyListeners();
  }

  void _updateCouponState(CouponState state) {
    _couponState = state;
    notifyListeners();
  }

  // NEW: Initialize checkout with all logic encapsulated
  Future<bool> initializeCheckout({
    required String checkoutToken,
    required String token,
    required Map<String, String> shippingMethod,
  }) async {
    _setLoading(true);

    final success = await fetchCheckoutData(
      checkoutToken,
      token,
      null,
      shippingMethod,
    );

    if (success) {
      _syncCouponStateFromCheckout();
    }

    _setLoading(false);
    return success;
  }

  // NEW: Sync coupon state from checkout data
  void _syncCouponStateFromCheckout() {
    final sessionData = _checkoutData?.data?.sessionCheckoutData;

    if (sessionData?.hasValidCoupon ?? false) {
      final appliedCoupon = sessionData!.appliedCouponCode;
      final discount = _checkoutData?.data?.couponDiscountAmount ?? 0;

      if (appliedCoupon != null && appliedCoupon.isNotEmpty && discount > 0) {
        _updateCouponState(CouponState(
          code: appliedCoupon,
          isValid: true,
          message: AppStrings.couponAppliedSuccess.tr,
        ));
        return;
      }
    }

    _updateCouponState(CouponState.empty());
  }

  // NEW: Handle coupon input change
  void updateCouponInput(String code) {
    if (code.isEmpty) {
      _updateCouponState(CouponState.empty());
    } else {
      _updateCouponState(_couponState.copyWith(code: code));
    }
  }

  // NEW: Handle coupon apply/remove action
  Future<void> handleCouponAction({
    required BuildContext context,
    required String checkoutToken,
    required String token,
    required String couponCode,
    required bool isApply,
    required Map<String, String> shippingMethod,
  }) async {
    if (couponCode.isEmpty && isApply) return;

    _setCouponLoading(true);

    final success = await _applyRemoveCouponCode(
      context,
      checkoutToken,
      token,
      couponCode,
      isApply,
    );

    if (success) {
      // Refresh checkout data
      await fetchCheckoutData(
        checkoutToken,
        token,
        null,
        shippingMethod,
      );
      _syncCouponStateFromCheckout();
    } else if (isApply) {
      // Show error for failed apply
      _updateCouponState(CouponState(
        code: couponCode,
        isValid: false,
        message: AppStrings.couponInvalidOrExpired.tr,
      ));
    }

    _setCouponLoading(false);
  }

  Future<bool> fetchCheckoutData(
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

  Future<bool> _applyRemoveCouponCode(
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
        return jsonData['error'] == false;
      }
    } catch (e) {
      log('Error applying coupon code: $e');
    }

    return false;
  }

  Future<void> processGatewayPayment({
    required BuildContext context,
    required String checkoutToken,
    required String token,
    required Map<String, String> paymentMethod,
    required bool isNewAddress,
  }) async {
    if (_checkoutData == null) return;

    _isProcessingPayment = true;
    _setLoading(true);

    try {
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
      _setLoading(false);
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
        MapEntry('address[name]', session.name ?? ''),
        MapEntry('address[email]', session.email ?? ''),
        MapEntry('address[phone]', session.phone ?? ''),
        MapEntry('address[country]', session.country ?? ''),
        MapEntry('address[city]', session.city ?? ''),
        MapEntry('address[address]', session.address ?? ''),
        MapEntry('address[address_id]', isNewAddress ? 'new' : (data.sessionCheckoutData.addressId?.toString() ?? '')),
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
        AppUtils.showToast('${AppStrings.paymentFailed.tr} ${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('checkoutPaymentLink error: $e');

      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        AppUtils.showToast('${AppStrings.paymentFailed.tr} $errorMessage');
      } else {
        AppUtils.showToast('${AppStrings.paymentFailed.tr} ${e.toString()}');
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

    _isProcessingPayment = true;

    final formData = FormData.fromMap({
      'tracked_start_checkout': checkoutToken,
      'amount': data.orderAmount.toString(),
      'is_mobile': '1',
      'payment_method': 'wallet',
    });

    final session = data.sessionCheckoutData;

    formData.fields.addAll([
      MapEntry('address[name]', session.name ?? ''),
      MapEntry('address[email]', session.email ?? ''),
      MapEntry('address[phone]', session.phone ?? ''),
      MapEntry('address[country]', session.country ?? ''),
      MapEntry('address[city]', session.city ?? ''),
      MapEntry('address[address]', session.address ?? ''),
      MapEntry('address[address_id]', isNewAddress ? 'new' : (data.sessionCheckoutData.addressId?.toString() ?? '')),
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
      _setLoading(true);

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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => BaseHomeScreen(
                  shouldNavigateToOrders: true,
                  orderId: orderId.toString(),
                ),
              ),
              (route) => false,
            );
          }
        } else {
          final jsonResponse = urlResponse.data;
          AppUtils.showToast('${AppStrings.paymentFailed.tr} ${jsonResponse["message"]}');
          throw Exception('Failed to load data');
        }
      } else {
        final jsonResponse = response.data;
        AppUtils.showToast('${AppStrings.paymentFailed.tr} ${jsonResponse["message"]}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      log('payWithWallet error: $e');

      if (e is DioException) {
        final errorMessage = e.response?.data?['message'] ?? e.message;
        AppUtils.showToast('${AppStrings.paymentFailed.tr}: $errorMessage');
      } else {
        AppUtils.showToast('${AppStrings.paymentFailed.tr}: ${e.toString()}');
      }
    } finally {
      _isProcessingPayment = false;
      _setLoading(false);
    }
  }
}
