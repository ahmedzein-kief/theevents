import 'package:dio/dio.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../data/vendor/data/response/ApiResponse.dart';
import '../../../../models/vendor_models/products/create_product/create_product_data_response.dart';
import '../../../../models/vendor_models/products/create_product/product_post_data_model.dart';
import '../../../../provider/vendor/vendor_repository.dart';
import '../../../components/services/alert_services.dart';

class VendorCreatePackageViewModel with ChangeNotifier {
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

  /// ***------------ Vendor create package settings start ---------------***
  ApiResponse<CreateProductDataResponse> _vendorCreatePackageApiResponse =
      ApiResponse.none();

  ApiResponse<CreateProductDataResponse> get vendorCreatePackageApiResponse =>
      _vendorCreatePackageApiResponse;

  set _setVendorCreatePackageApiResponse(
    ApiResponse<CreateProductDataResponse> response,
  ) {
    _vendorCreatePackageApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorCreatePackage({
    required BuildContext context,
    required ProductPostDataModel productPostDataModel,
  }) async {
    try {
      setLoading(true);
      _setVendorCreatePackageApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      // Convert to Map<String, dynamic>
      final FormData formDataMap = productPostDataModel.toFormData();
      final body = formDataMap;

      final CreateProductDataResponse response =
          await _myRepo.vendorCreatePackage(
        headers: headers,
        body: body,
      );
      _setVendorCreatePackageApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(
        message: response.message.toString(),
        context: context,
      );
      setLoading(false);
      return true;
    } catch (error) {
      _setVendorCreatePackageApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(
          message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor create package settings end ---------------***

  /// ***------------ Vendor update package start ---------------***

  /// vendor update package:
  ApiResponse<CommonPostRequestModel> _vendorUpdatePackageApiResponse =
      ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get vendorUpdatePackageApiResponse =>
      _vendorUpdatePackageApiResponse;

  set _setVendorUpdatePackageApiResponse(
    ApiResponse<CommonPostRequestModel> response,
  ) {
    _vendorUpdatePackageApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdatePackage({
    required BuildContext context,
    required String packageID,
    required ProductPostDataModel productPostDataModel,
  }) async {
    try {
      setLoading(true);
      _setVendorUpdatePackageApiResponse = ApiResponse.loading();
      await loadUserSettings();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final FormData formDataMap = productPostDataModel.toFormData();
      final body = formDataMap;

      final CommonPostRequestModel response = await _myRepo.vendorUpdatePackage(
        headers: headers,
        body: body,
        packageID: packageID,
      );
      _setVendorUpdatePackageApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(
        message: response.message.toString(),
        context: context,
      );
      setLoading(false);
      return true;
    } catch (error) {
      _setVendorUpdatePackageApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(
          message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }
}
