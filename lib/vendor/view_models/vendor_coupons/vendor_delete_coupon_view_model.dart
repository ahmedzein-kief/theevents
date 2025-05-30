import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_coupons_models/vendor_delete_coupon_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorDeleteCouponViewModel with ChangeNotifier {
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

  ApiResponse<VendorDeleteCouponModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorDeleteCouponModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorDeleteCouponModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorDeleteCoupon({dynamic couponId, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      VendorDeleteCouponModel? response = await _myRepo.vendorDeleteCoupon(headers: headers, couponId: couponId);
      setApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(message: response.message.toString(), context: context);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }
}
