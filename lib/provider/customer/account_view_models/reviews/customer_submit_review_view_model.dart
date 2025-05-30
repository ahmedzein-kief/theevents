import 'package:dio/dio.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:event_app/provider/customer/Repository/customer_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/vendor/data/response/ApiResponse.dart';
import '../../../../core/utils/custom_toast.dart';
import '../../../../utils/storage/shared_preferences_helper.dart';

class CustomerSubmitReviewViewModel with ChangeNotifier {
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

  final _myRepo = CustomerRepository();
  ApiResponse<CommonPostRequestModel> _apiResponse = ApiResponse.none();
  ApiResponse<CommonPostRequestModel> get apiResponse => _apiResponse;
  set setApiResponse(ApiResponse<CommonPostRequestModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> customerSubmitReview({required FormData form, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      CommonPostRequestModel response = await _myRepo.customerSubmitReview(headers: headers, form: form);
      setApiResponse = ApiResponse.completed(response);
      CustomSnackbar.showSuccess(context, apiResponse.data?.message?.toString() ?? 'Success');
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      CustomSnackbar.showError(context, '${error.toString()}');
      setLoading(false);
      return false;
    }
  }
}
