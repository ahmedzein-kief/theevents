

import 'package:event_app/models/vendor_models/packages/vendor_get_package_general_settings_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/vendor/data/response/ApiResponse.dart';
import '../../../../models/vendor_models/products/edit_product/new_product_view_data_response.dart';
import '../../../../provider/vendor/vendor_repository.dart';
import '../../../../utils/storage/shared_preferences_helper.dart';
import '../../../components/services/alert_services.dart';

class VendorGetViewPackageViewModel with ChangeNotifier {
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

  ApiResponse<NewProductViewDataResponse> _vendorProductViewApiResponse = ApiResponse.none();

  ApiResponse<NewProductViewDataResponse> get vendorProductViewApiResponse => _vendorProductViewApiResponse;

  set setProductViewApiResponse(ApiResponse<NewProductViewDataResponse> response) {
    _vendorProductViewApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorViewPackage(BuildContext context, String packageID) async {
    try {
      setLoading(true);
      _vendorProductViewApiResponse = ApiResponse.loading();
      await loadUserSettings();
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      NewProductViewDataResponse response = await _myRepo.vendorViewPackage(
        packageID: packageID,
        headers: headers,
      );
      _vendorProductViewApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      _vendorProductViewApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }
}




