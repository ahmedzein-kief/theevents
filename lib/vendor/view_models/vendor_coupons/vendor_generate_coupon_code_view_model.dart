import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_coupons_models/vendor_generate_coupon_code_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorGenerateCouponCodeViewModel with ChangeNotifier {
  String? _token;

  setToken() async {
    _token = await SharedPreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();
  ApiResponse<VendorGenerateCouponCodeModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGenerateCouponCodeModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGenerateCouponCodeModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGenerateCouponCode() async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        "Authorization": _token!,
      };

      VendorGenerateCouponCodeModel response = await _myRepo.vendorGenerateCouponCode(headers: headers);

      setApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }
}
