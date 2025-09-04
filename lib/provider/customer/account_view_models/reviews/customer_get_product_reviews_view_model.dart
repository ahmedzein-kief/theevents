import 'package:event_app/core/services/shared_preferences_helper.dart';
import 'package:event_app/data/vendor/data/response/ApiResponse.dart';
import 'package:event_app/provider/customer/Repository/customer_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../../models/account_models/reviews/customer_get_product_reviews_model.dart';

class CustomerGetProductReviewsViewModel with ChangeNotifier {
  String? _token;
  int _currentPage = 1;
  int _lastPage = 1;

  final List<ProductsAvailableForReview> _list = [];

  List<ProductsAvailableForReview> get list => _list;

  final List<ReviewedRecords> _reviewedProductList = [];

  List<ReviewedRecords> get reviewedProductList => _reviewedProductList;

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
  ApiResponse<CustomerGetProductReviewsModel> _apiResponse = ApiResponse.none();

  ApiResponse<CustomerGetProductReviewsModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<CustomerGetProductReviewsModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<void> customerGetProductReviews({String? search}) async {
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
        final CustomerGetProductReviewsModel response =
            await _myRepo.customerGetProductReviews(
                headers: headers, queryParams: queryParams,);
        setLastPage(response);
        resetList(response);
        setApiResponse = ApiResponse.completed(response);
      }
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
    }
  }

  void setLastPage(CustomerGetProductReviewsModel response) {
    _lastPage = response.data?.reviews?.pagination?.lastPage ?? 0;
    notifyListeners();
  }

  void resetList(CustomerGetProductReviewsModel response) {
    _list.addAll(response.data!.products!);
    _reviewedProductList.addAll(response.data!.reviews!.records!);
    _lastPage = response.data!.reviews!.pagination!.lastPage!;
    _currentPage++;
    notifyListeners();
  }

  void clearList() {
    _list.clear();
    _reviewedProductList.clear();
    _currentPage = 1;
    _lastPage = 1;
    notifyListeners();
  }

  void removeElementFromList({required id}) {
    _reviewedProductList.removeWhere((element) => element.id == id);
    // _list.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
