
import 'package:dio/dio.dart';
import 'package:event_app/models/vendor_models/common_models/common_post_request_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../../data/vendor/data/response/ApiResponse.dart';
import '../../../../models/vendor_models/products/create_product/create_product_data_response.dart';
import '../../../../models/vendor_models/products/create_product/product_post_data_model.dart';
import '../../../../provider/vendor/vendor_repository.dart';
import '../../../../utils/storage/shared_preferences_helper.dart';
import '../../../components/services/alert_services.dart';

class VendorCreateUpdateVariationViewModel with ChangeNotifier {
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

  /// ***------------ Vendor create variation start ---------------***
  ApiResponse<CommonPostRequestModel> _vendorCreateVariationApiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get vendorCreateVariationApiResponse => _vendorCreateVariationApiResponse;

  set _setVendorCreateVariationApiResponse(
      ApiResponse<CommonPostRequestModel> response) {
    _vendorCreateVariationApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorCreateProductVariation({required BuildContext context,required String productID, required ProductPostDataModel productPostDataModel}) async {
    try
    {
      setLoading(true);
      _setVendorCreateVariationApiResponse = ApiResponse.loading();
      await loadUserSettings();
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };
      // Convert to Map<String, dynamic>
      FormData formDataMap = productPostDataModel.toVariationFormData();
      var body =  formDataMap;

      CommonPostRequestModel response = await _myRepo.vendorCreateProductVariation(
        headers: headers,
        body: body,
        productID: productID,
      );
      _setVendorCreateVariationApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(
          message: response.message.toString(), context: context);
      setLoading(false);
      return true;
    } catch (error) {
      _setVendorCreateVariationApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }
  /// ***------------ Vendor create variation end ---------------***



  /// ***------------ Vendor update variation start ---------------***

  ApiResponse<CommonPostRequestModel> _vendorUpdateVariationApiResponse = ApiResponse.none();

  ApiResponse<CommonPostRequestModel> get vendorUpdateVariationApiResponse => _vendorUpdateVariationApiResponse;

  set _setVendorUpdateVariationApiResponse(
      ApiResponse<CommonPostRequestModel> response) {
    _vendorUpdateVariationApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdateProductVariation(
      {required BuildContext context,
        required String variationID,
        required ProductPostDataModel productPostDataModel}) async {
    try {
      setLoading(true);
      _setVendorUpdateVariationApiResponse = ApiResponse.loading();
      await loadUserSettings();
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };
      FormData formDataMap = productPostDataModel.toVariationFormData();
      var body =  formDataMap;

      CommonPostRequestModel response = await _myRepo.vendorUpdateProductVariation(
          headers: headers,
          body: body,
          productVariationID: variationID
      );
      _setVendorUpdateVariationApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(
          message: response.message.toString(), context: context);
      setLoading(false);
      return true;
    } catch (error) {
      _setVendorUpdateVariationApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString(), context: context);
      setLoading(false);
      return false;
    }
  }
/// ***------------ Vendor update variation end ---------------***

}
