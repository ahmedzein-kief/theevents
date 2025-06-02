import 'package:event_app/provider/vendor/vendor_repository.dart';
import 'package:event_app/vendor/components/services/alert_services.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/vendor/data/response/ApiResponse.dart';
import '../../../models/vendor_models/vendor_order_models/vendor_update_shipment_status_model.dart';
import '../../../utils/storage/shared_preferences_helper.dart';

class VendorUpdateShipmentStatusViewModel with ChangeNotifier {
  String? _token;

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
  ApiResponse<VendorUpdateShipmentStatusModel> _apiResponse = ApiResponse.none();

  ApiResponse<VendorUpdateShipmentStatusModel> get apiResponse => _apiResponse;

  set setApiResponse(ApiResponse<VendorUpdateShipmentStatusModel> response) {
    _apiResponse = response;
    notifyListeners();
  }

  Future<bool> vendorUpdateShipmentStatus({required dynamic shipmentID, required String shipmentStatus, required BuildContext context}) async {
    try {
      setLoading(true);
      setApiResponse = ApiResponse.loading();
      await setToken();

      Map<String, String> headers = <String, String>{
        "Authorization": _token!,
      };

      dynamic body = {"status": shipmentStatus};

      VendorUpdateShipmentStatusModel response = await _myRepo.vendorUpdateShipmentStatus(headers: headers, shipmentID: shipmentID.toString(), body: body);
      setApiResponse = ApiResponse.completed(response);
      AlertServices.showSuccessSnackBar(message: apiResponse.data?.message?.toString() ?? '', context: context);
      setLoading(false);
      return true;
    } catch (error) {
      setApiResponse = ApiResponse.error(error.toString());
      AlertServices.showErrorSnackBar(message: error.toString() ?? '', context: context);
      setLoading(false);
      return false;
    }
  }
}
