import 'dart:convert';

import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/vendor_models/products/edit_product/vendor_get_product_variations_model.dart';

class VendorGetProductVariationsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<ProductVariationRecord> _list = [];

  List<ProductVariationRecord> get list => _list;

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
  ApiResponse<VendorGetProductVariationsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetProductVariationsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetProductVariationsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get products method
  vendorGetProductVariations({
    required String productID,
    String? searchString,
  }) async {
    await setToken();
    try {
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      final dynamic body = jsonEncode({
        'per-page': '20',
        'page': _currentPage.toString(),
        if (searchString != null) 'search': searchString,
        //filter_attr_id[]:{{attribute_id}},
        //filter_attr_value_id[]:{{attribute_value_id}}, /// TODO: Check syntax on google or chat gpt and then take input for this.
      });

      // If successful, increment the current page and append data
      if (_currentPage <= _lastPage) {
        setApiResponse = ApiResponse.loading();
        final VendorGetProductVariationsModel response = await _myRepo.vendorGetProductVariations(headers: headers, body: body, productID: productID);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      print(error.toString());
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  void setLastPage(VendorGetProductVariationsModel response) {
    _lastPage = response.data?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(VendorGetProductVariationsModel response) {
    _list.addAll(response.data!.records!);
    _lastPage = response.data!.pagination!.lastPage!;
    _currentPage++;
    notifyListeners();
  }

  void clearList() {
    _list.clear();
    _currentPage = 1;
    _lastPage = 1;
    notifyListeners();
  }

  void removeElementFromList({required dynamic id}) {
    _list.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
