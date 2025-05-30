import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/models/vendor_models/products/VendorGetProductsModel.dart';
import 'package:event_app/models/vendor_models/products/create_product/common_data_response.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

class VendorGetProductsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<GetProductRecords> _list = [];

  List<GetProductRecords> get list => _list;

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
  ApiResponse<VendorGetProductsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetProductsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetProductsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get products method
  vendorGetProducts({String? search}) async {
    await setToken();
    try {
      Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        "Authorization": _token!,
      };

      final Map<String, String> queryParams = {
        'per-page': '20',
        'page': _currentPage.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      // If successful, increment the current page and append data
      if (_currentPage <= _lastPage) {
        setApiResponse = ApiResponse.loading();
        final VendorGetProductsModel response = await _myRepo.vendorGetProducts(headers: headers, queryParams: queryParams);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  ApiResponse<CommonDataResponse> _commonApiResponse = ApiResponse.none();

  ApiResponse<CommonDataResponse> get commonApiResponse => _commonApiResponse;

  set setCommonApiResponse(ApiResponse<CommonDataResponse> response) {
    _commonApiResponse = response;
    notifyListeners();
  }

  /// get products method
  Future<CommonDataResponse?> deleteVariation(String productVariationId) async {
    await setToken();
    try {
      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      // If successful, increment the current page and append data
      setCommonApiResponse = ApiResponse.loading();
      final CommonDataResponse response = await _myRepo.vendorDeleteProductVariation(
        productVariationId: productVariationId,
        headers: headers,
      );
      setCommonApiResponse = ApiResponse.completed(response);
      return response;
    } catch (error) {
      print(error.toString());
      setCommonApiResponse = ApiResponse.error(error.toString());
      return null;
    }
  }

  void setLastPage(VendorGetProductsModel response) {
    _lastPage = response.data?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(VendorGetProductsModel response) {
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
