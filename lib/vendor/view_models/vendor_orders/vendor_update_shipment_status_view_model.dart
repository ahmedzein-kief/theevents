import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/services/shared_preferences_helper.dart';
import '../../../core/utils/app_utils.dart';
import '../../../data/vendor/data/response/api_response.dart';
import '../../../models/vendor_models/vendor_order_models/vendor_update_shipment_status_model.dart';

class VendorUpdateShipmentStatusViewModel with ChangeNotifier {
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
  ApiResponse<VendorUpdateShipmentStatusModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorUpdateShipmentStatusModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorUpdateShipmentStatusModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdateShipmentStatus({
    required shipmentID,
    required String shipmentStatus,
    required BuildContext context,
  }) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      final Map<String, String> headers = <String, String>{
        'Authorization': _token!,
      };

      final dynamic body = {'status': shipmentStatus};

      final VendorUpdateShipmentStatusModel response = await _myRepo.vendorUpdateShipmentStatus(
        headers: headers,
        shipmentID: shipmentID.toString(),
        body: body,
      );
      setApiResponse = ApiResponse.completed(response);
      AppUtils.showToast(response.message.toString(), isSuccess: true);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AppUtils.showToast(error.toString());
      setLoading(false);
      return false;
    }
  }
}
