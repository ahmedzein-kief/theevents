import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/common_models/common_post_request_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorUpdateOrderViewModel with ChangeNotifier {
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
  ApiResponse<CommonPostRequestModel> _apiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<CommonPostRequestModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdateOrder({required dynamic orderID, required String description, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      dynamic body = {"description": description};

      CommonPostRequestModel response = await _myRepo.vendorUpdateOrder(headers: headers, orderID: orderID.toString(), body: body);
      setApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(message: apiResponse.data?.message?.toString() ?? '', context: context);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString() ?? '', context: context);
      setLoading(false);
      return false;
    }
  }
}
