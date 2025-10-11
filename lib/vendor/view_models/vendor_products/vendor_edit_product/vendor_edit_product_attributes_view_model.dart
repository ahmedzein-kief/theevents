import 'dart:convert';

import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../core/utils/app_utils.dart';
import '../../../../data/vendor/data/response/api_response.dart';
import '../../../../models/vendor_models/common_models/common_post_request_model.dart';

class VendorEditProductAttributesViewModel with ChangeNotifier {
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
  ApiResponse<CommonPostRequestModel> _apiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<CommonPostRequestModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorEditProductAttributes({
    required productID,
    required List<int> attributesSet,
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final body = jsonEncode({'attribute_sets': attributesSet});

      final CommonPostRequestModel response = await _myRepo.vendorEditProductAttributes(
        headers: headers,
        productID: productID.toString(),
        body: body,
      );
      setApiResponse = ApiResponse.completed(response);
      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }
}
