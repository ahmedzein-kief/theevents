import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_settings_models/vendor_get_settings_model.dart';
import '../../../models/vendor_models/vendor_withdrawals_model/vendor_show_withdrawal_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorShowWithdrawalViewModel with ChangeNotifier {
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

  ApiResponse<VendorShowWithdrawalModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorShowWithdrawalModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorShowWithdrawalModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorShowWithdrawal({required String withdrawalID}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };
      VendorShowWithdrawalModel response = await _myRepo.vendorShowWithdrawal(headers: headers,withdrawalID:withdrawalID);
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
