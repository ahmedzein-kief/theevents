import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_order_models/vendor_get_order_details_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorGetOrderDetailsViewModel with ChangeNotifier {
  String? _token;

  setToken() async {
    _token = await SecurePreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();
  ApiResponse<VendorGetOrderDetailsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetOrderDetailsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetOrderDetailsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetOrderDetails({required dynamic orderId}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      VendorGetOrderDetailsModel response = await _myRepo.vendorGetOrderDetails(headers: headers, orderId: orderId.toString());

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
