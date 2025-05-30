import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

import '../../../models/vendor_models/vendor_order_models/vendor_get_orders_model.dart';

class VendorOrderReturnsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<OrderRecords> _list = [];

  List<OrderRecords> get list => _list;

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
  ApiResponse<VendorGetOrdersModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetOrdersModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetOrdersModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get orders method
  vendorOrderReturns({String? search}) async {
    await setToken();
    try {
      Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        "Authorization": _token!,
      };

      final Map<String, String> queryParams = {
        'per-page': '10',
        'page': _currentPage.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      // If successful, increment the current page and append data
      if (_currentPage <= _lastPage) {
        setApiResponse = ApiResponse.loading();
        final VendorGetOrdersModel response = await _myRepo.vendorOrderReturns(headers: headers, queryParams: queryParams);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  void setLastPage(VendorGetOrdersModel response) {
    _lastPage = response.data?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(VendorGetOrdersModel response) {
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
