import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/apiendpoints/vendor_api_end_point.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_settings_models/vendor_settings_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorSettingsViewModel with ChangeNotifier {
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

  ApiResponse<VendorSettingsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorSettingsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorSettingsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorSettings({required VendorSettingType vendorSettingsType, required dynamic form, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };
      final body = form;

      final url = _getUpdateSettingsUrl(vendorSettingsType: vendorSettingsType);
      VendorSettingsModel? response = await _myRepo.vendorSettings(url: url, headers: headers, body: body);
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

  String _getUpdateSettingsUrl({required VendorSettingType vendorSettingsType}) {
    switch (vendorSettingsType) {
      case VendorSettingType.store:
        return VendorApiEndpoints.vendorStoreSettings;
      case VendorSettingType.taxInfo:
        return VendorApiEndpoints.vendorTaxInfoSettings;
      case VendorSettingType.payoutInfo:
        return VendorApiEndpoints.vendorPayoutInfoSettings;
    }
  }
}
