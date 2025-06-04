import 'package:event_app/models/vendor_models/products/create_product/attribute_sets_data_response.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/services/shared_preferences_helper.dart';
import '../../../../data/vendor/data/response/ApiResponse.dart';

class VendorGetSelectedAttributesViewModel with ChangeNotifier {
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

  /// ***------------ Vendor get selected attributes set start ---------------***
  ApiResponse<AttributeSetsDataResponse> _attributeSetsApiResponse =
      ApiResponse.none();

  ApiResponse<AttributeSetsDataResponse> get attributeSetsApiResponse =>
      _attributeSetsApiResponse;

  set setAttributeSetsApiResponse(
      ApiResponse<AttributeSetsDataResponse> response) {
    _attributeSetsApiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGetSelectedProductAttributes({
    required String productID,
  }) async {
    try {
      setLoading(true);
      setAttributeSetsApiResponse = ApiResponse.loading();
      await setToken();
      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };
      final AttributeSetsDataResponse response =
          await _myRepo.vendorGetSelectedProductAttributes(
              headers: headers, productID: productID);
      setAttributeSetsApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setAttributeSetsApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }

  /// ***------------ Vendor get selected attributes set end ---------------***
}
