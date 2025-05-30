import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/Components/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorGenerateOrderInvoiceViewModel with ChangeNotifier {
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
  ApiResponse<dynamic> _apiResponse = ApiResponse.none();

  ApiResponse<dynamic> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<dynamic> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorGenerateOrderInvoice({required String orderId}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        'Content-Type': 'application/pdf',
        "Authorization": _token!,
      };

      dynamic response = await _myRepo.vendorGenerateOrderInvoice(headers: headers, orderId: orderId.toString());

      /// save invoice
      final file = await Utils.saveDocument(name: orderId, pdfResponse: response);

      await Utils.openDocument(file);

      setApiResponse = ApiResponse.completed(response);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      setLoading(false);
      return false;
    }
  }
}
