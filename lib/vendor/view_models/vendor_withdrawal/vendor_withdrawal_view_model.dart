import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/models/vendor_models/vendor_withdrawals_model/vendor_get_withdrawals_model.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

class VendorWithdrawalsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<VendorWithdrawalRecords> _list = [];

  List<VendorWithdrawalRecords> get list => _list;

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
  ApiResponse<VendorGetWithdrawalsModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorGetWithdrawalsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorGetWithdrawalsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get orders method
  Future<void> vendorWithdrawals({String? search}) async {
    await setToken();
    try {
      final Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        'Authorization': _token!,
      };

      final Map<String, String> queryParams = {
        'per-page': '10',
        'page': _currentPage.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      // If successful, increment the current page and append data
      if (_currentPage <= _lastPage) {
        setApiResponse = ApiResponse.loading();
        final VendorGetWithdrawalsModel response = await _myRepo
            .vendorWithdrawals(headers: headers, queryParams: queryParams);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  void setLastPage(VendorGetWithdrawalsModel response) {
    _lastPage = response.data?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(VendorGetWithdrawalsModel response) {
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

  void removeElementFromList({required id}) {
    _list.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
