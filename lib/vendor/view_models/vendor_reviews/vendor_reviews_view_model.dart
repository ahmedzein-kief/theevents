import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/models/vendor_models/reviews/reviews_data_response.dart';
import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/utils/storage/shared_preferences_helper.dart';
import 'package:flutter/cupertino.dart';

class VendorReviewsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<ReviewRecord> _list = [];

  List<ReviewRecord> get list => _list;

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
  ApiResponse<ReviewsDataResponse> _apiResponse = ApiResponse.none();

  ApiResponse<ReviewsDataResponse> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<ReviewsDataResponse> response) {
    _apiResponse = response;
    notifyListeners();
  }

  /// get orders method
  vendorReviews({String? search}) async {
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
        final ReviewsDataResponse response = await _myRepo.vendorReviews(headers: headers, queryParams: queryParams);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  void setLastPage(ReviewsDataResponse response) {
    _lastPage = response.data?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(ReviewsDataResponse response) {
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
