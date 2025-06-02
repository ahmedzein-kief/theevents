

import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/apiendpoints/vendor_api_end_point.dart';
import 'package:event_app/vendor/components/enums/enums.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorCreateUpdateWithdrawalViewModel with ChangeNotifier {
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

  ApiResponse<CommonPostRequestModel> _apiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<CommonPostRequestModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorCreateUpdateWithdrawal({required RequestType requestType,String? withdrawalID, required dynamic form, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };
      final body = form;

      final url = _getCreateUpdateUrl(requestType: requestType,withdrawalID:withdrawalID);
      CommonPostRequestModel? response = await _myRepo.vendorCreateUpdateWithdrawal(url: url, headers: headers, body: body);
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
  String _getCreateUpdateUrl({required RequestType requestType,dynamic withdrawalID}) {
    switch (requestType) {
      case RequestType.CREATE:
        return VendorApiEndpoints.vendorCreateWithdrawal;
      case RequestType.UPDATE:
        return VendorApiEndpoints.vendorUpdateWithdrawal + withdrawalID;
    }
  }


  //// Vendor cancel withdrawal request
  Future<bool> vendorCancelWithdrawal({required String withdrawalID, required dynamic form, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      CommonPostRequestModel? response = await _myRepo.vendorCancelWithdrawal(headers: headers,withdrawalID: withdrawalID);
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
