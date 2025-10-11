import 'package:flutter/cupertino.dart';

import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../data/vendor/data/response/api_response.dart';
import '../../../../models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import '../../../../provider/vendor/vendor_repository.dart';

class VendorGetViewPackageViewModel with ChangeNotifier {
  String? _token;

  Future<void> loadUserSettings() async {
    _token = await SecurePreferencesUtil.getToken();
  }

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(val) {
    _isLoading = val;
    notifyListeners();
  }

  final _myRepo = VendorRepository();

  ApiResponse<NewProductViewDataResponse> _vendorProductViewApiResponse = ApiResponse.none();

  ApiResponse<NewProductViewDataResponse> get vendorProductViewApiResponse => _vendorProductViewApiResponse;

  set setProductViewApiResponse(
    ApiResponse<NewProductViewDataResponse> response,
  ) {
    _vendorProductViewApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorViewPackage(BuildContext context, String packageID) async {
    try {
      setLoading(true);
      _vendorProductViewApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final NewProductViewDataResponse response = await _myRepo.vendorViewPackage(
        packageID: packageID,
        headers: headers,
      );
      _vendorProductViewApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorProductViewApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }
}
