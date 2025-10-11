import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/vendor/data/response/api_response.dart';
import '../../../models/vendor_models/vendor_coupons_models/vendor_delete_coupon_model.dart';

class VendorDeleteCouponViewModel with ChangeNotifier {
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

  ApiResponse<VendorDeleteCouponModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorDeleteCouponModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorDeleteCouponModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorDeleteCoupon({
    couponId,
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final VendorDeleteCouponModel response = await _myRepo.vendorDeleteCoupon(
        headers: headers,
        couponId: couponId,
      );
      setApiResponse = ApiResponse.completed(response);
      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }
}
