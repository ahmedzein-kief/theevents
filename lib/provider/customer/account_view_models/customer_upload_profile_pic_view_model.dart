import 'dart:io';

import 'package:dio/dio.dart';
import 'package:event_app/provider/customer/Repository/customer_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/utils/custom_toast.dart';
import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/account_models/customer_upload_profile_pic_model.dart';

class CustomerUploadProfilePicViewModel with ChangeNotifier {
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

  final _myRepo = CustomerRepository();
  ApiResponse<CustomerUploadProfilePicModel> _apiResponse = ApiResponse.none();
  ApiResponse<CustomerUploadProfilePicModel> get apiResponse => _apiResponse;
  set setApiResponse(ApiResponse<CustomerUploadProfilePicModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> customerUploadProfilePicture(
      {required File file, required BuildContext context,}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final FormData formData = FormData.fromMap({
        'avatar_file': await MultipartFile.fromFile(file.path,
            filename: file.path.split('/').last,),
      });

      final CustomerUploadProfilePicModel response = await _myRepo
          .customerUploadProfilePicture(headers: headers, formData: formData);
      setApiResponse = ApiResponse.completed(response);
      CustomSnackbar.showSuccess(
          context, apiResponse.data?.message?.toString() ?? 'Success',);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      CustomSnackbar.showError(context, error.toString());
      setLoading(false);
      return false;
    }
  }
}
