import 'dart:convert';

import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/dashboard/user_by_type_model/view_all_items_models.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';

import '../../models/dashboard/vendor_by_type_models/vendot_type_by_model.dart';

class VendorByTypeProvider extends ChangeNotifier {
  //    +++++++++++++++++++++++++++++++++++++++++++++    USER BY TYPE BANNER +++++++++++++++++++++++++++++++++

  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  bool _isLoading = true;
  String errorMessage = '';

  VendorTypeData? vendorTypeData;

  bool get isLoading => _isLoading;

  Future<void> fetchVendorTypeById(
    int typeId,
    BuildContext context,
  ) async {
    _isLoading = true;
    notifyListeners();

    final url = '${ApiEndpoints.userByTypeBanner}$typeId';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final VendorTypeBy vendorType = VendorTypeBy.fromJson(responseData);

        vendorTypeData = vendorType.data;
        errorMessage = '';
      } else {
        errorMessage = 'Failed to load data: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();

      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

//       +++++++++++++++++++++++++++++++++++++++++++++++++  USER BY TYPE VIEW ALL ITEMS  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  List<Vendor> _vendors = [];
  String _errorMessage = '';
  Pagination? _paginationUser;
  bool _isMoreLoading = false;
  bool userLoader = false;

  List<Vendor> get vendors => _vendors;

  Future<void> fetchVendors(BuildContext context,
      {required int typeId,
      String sortBy = 'default_sorting',
      int page = 1,
      int perPage = 12}) async {
    if (page == 1) {
      userLoader = true;
      notifyListeners();
    } else {
      _isMoreLoading = true;
      notifyListeners();
    }

    try {
      final url =
          '${ApiEndpoints.userByTypeStores}?limit=$perPage&page=$page&type_id=$typeId&sort-by=$sortBy';

      final response = await _apiResponseHandler.getRequest(
        url,
        context: context,
      );

      // final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final vendorResponse = VendorResponse.fromJson(responseData['data']);
        _paginationUser = vendorResponse.pagination;
        _errorMessage = '';

        if (page == 1) {
          _vendors = vendorResponse.records;
          _paginationUser = vendorResponse.pagination;
        } else {
          _vendors.addAll(vendorResponse.records);
        }
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      userLoader = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

//      ++++++++++++++++++++++++++++++++++++++++++
}
