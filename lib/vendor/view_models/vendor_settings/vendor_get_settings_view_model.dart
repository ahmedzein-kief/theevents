import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../data/vendor/data/response/api_response.dart';
import '../../../models/vendor_models/vendor_settings_models/vendor_get_settings_model.dart';

class VendorGetSettingsViewModel with ChangeNotifier {
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

  ApiResponse<VendorGetSettingsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetSettingsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetSettingsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetSettings() async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final VendorGetSettingsModel response =
          await _myRepo.vendorGetSettings(headers: headers);
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
