import 'package:event_app/models/vendor_models/packages/vendor_get_package_general_settings_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/vendor/data/response/ApiResponse.dart';
import '../../../../provider/vendor/vendor_repository.dart';
import '../../../../utils/storage/shared_preferences_helper.dart';

class VendorGetPackageGeneralSettingsViewModel with ChangeNotifier {
  String? _token;

  loadUserSettings() async {
    _token = await SharedPreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();

  /// ***------------ Vendor get package general settings start ---------------***

  ApiResponse<VendorGetPackageGeneralSettingsModel> _generalSettingsApiResponse = ApiResponse.none();

  ApiResponse<VendorGetPackageGeneralSettingsModel> get generalSettingsApiResponse => _generalSettingsApiResponse;

  set setPackageGeneralSettingsApiResponse(ApiResponse<VendorGetPackageGeneralSettingsModel> response) {
    _generalSettingsApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetPackageGeneralSettings() async {
    try {
      setLoading(true);
      setPackageGeneralSettingsApiResponse = ApiResponse.loading();
      await loadUserSettings();
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      VendorGetPackageGeneralSettingsModel response = await _myRepo.vendorGetPackageGeneralSettings(headers: headers);
      setPackageGeneralSettingsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setPackageGeneralSettingsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }}