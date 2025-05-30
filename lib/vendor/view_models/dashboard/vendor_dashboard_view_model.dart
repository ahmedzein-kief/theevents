import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/models/vendor_models/dashboard/dashboard_data_response.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

class VendorDashboardViewModel with ChangeNotifier {
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

  final _myRepo = VendorRepository();
  ApiResponse<DashboardDataResponse> _apiResponse = ApiResponse.none();

  ApiResponse<DashboardDataResponse> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<DashboardDataResponse> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get products method
  getDashboardData(String startDate, String endDate) async {
    await setToken();
    try {
      Map<String, String> headers = <String, String>{
        // 'Content-Type': 'application/json',
        "Authorization": _token!,
      };

      /*'date_from': '2022-09-01',
        'date_to': '2025-01-29',*/

      final Map<String, String> queryParams = {
        'date_from': startDate,
        'date_to': endDate,
      };

      // If successful, increment the current page and append data

      setApiResponse = ApiResponse.loading();
      final DashboardDataResponse response = await _myRepo.getDashboardData(headers: headers, queryParams: queryParams);
      setApiResponse = ApiResponse.completed(response);
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }
}
