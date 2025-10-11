import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/vendor/data/response/api_response.dart';
import '../../../models/vendor_models/vendor_coupons_models/vendor_create_coupon_model.dart';

class VendorCreateCouponViewModel with ChangeNotifier {
  String? _token;

  Future<void> setToken() async {
    _token = await SecurePreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();

  ApiResponse<VendorCreateCouponModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorCreateCouponModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorCreateCouponModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorCreateCoupon({form, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        'Authorization': _token!,
      };
      final body = jsonEncode(form);

      final VendorCreateCouponModel response = await _myRepo.vendorCreateCoupon(headers: headers, body: body);
      setApiResponse = ApiResponse.completed(response);
      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      if (error is DioException) {
        log('yes dio exception');
      } else {
        log('no dio exception');
      }

      setApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }
}
