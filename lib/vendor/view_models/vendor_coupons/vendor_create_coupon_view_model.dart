import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../data/vendor/data/response/ApiResponse.dart';
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

      final VendorCreateCouponModel response =
          await _myRepo.vendorCreateCoupon(headers: headers, body: body);
      setApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(
          message: response.message.toString(), context: context,);
      setLoading(false);
      return true;
    } catch (error) {
      if (error is DioException) {
        print('yes dio exception');
      } else {
        print('no dio exception');
      }

      setApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(
          message: error.toString(), context: context,);
      setLoading(false);
      return false;
    }
  }
}
