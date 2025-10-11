import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/dashboard/user_by_type_model/view_all_items_models.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../models/dashboard/vendor_by_type_models/vendot_type_by_model.dart';
import '../locale_provider.dart';

class VendorByTypeProvider extends ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();
  bool _isLoading = true;
  String errorMessage = '';

  VendorTypeData? vendorTypeData;

  bool get isLoading => _isLoading;

  void resetVendorTypeData() {
    vendorTypeData = null;
  }

  Future<void> fetchVendorTypeById(int typeId, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

    final url = '${ApiEndpoints.userByTypeBanner}$typeId';

    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: {'locale': currentLocale},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final VendorTypeBy vendorType = VendorTypeBy.fromJson(responseData);
        vendorTypeData = vendorType.data;
        errorMessage = '';
      } else {
        errorMessage = 'Failed to load data: ${response.statusCode}';

        throw Exception(errorMessage);
      }
    } catch (error) {
      errorMessage = error.toString();
      vendorTypeData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ++++++++++++++++++++++++++++++++++++++++++++++++  USER BY TYPE VIEW ALL ITEMS  +++++++++++++++++++++++++++++++++
  List<Vendor> _vendors = [];
  String _errorMessage = '';
  Pagination? _paginationUser;
  bool _isMoreLoading = false;
  bool userLoader = false;

  List<Vendor> get vendors => _vendors;

  String get errorMessageVendors => _errorMessage;

  Pagination? get pagination => _paginationUser;

  bool get isMoreLoading => _isMoreLoading;

  Future<void> fetchVendors(
    BuildContext context, {
    required int typeId,
    String sortBy = 'default_sorting',
    int page = 1,
    int perPage = 12,
  }) async {
    if (page == 1) {
      userLoader = true;
    } else {
      _isMoreLoading = true;
    }
    notifyListeners();

    final currentLocale = Provider.of<LocaleProvider>(context, listen: false).locale.languageCode;

    try {
      final url = '${ApiEndpoints.customerByType}/$typeId?limit=$perPage&page=$page&sort-by=$sortBy';

      final response = await _apiResponseHandler.getRequest(
        url,
        queryParams: {'locale': currentLocale},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;
        final vendorResponse = VendorResponse.fromJson(responseData['data']);
        _errorMessage = '';

        if (page == 1) {
          _vendors = vendorResponse.records;
          _paginationUser = vendorResponse.pagination;
        } else {
          _vendors.addAll(vendorResponse.records);
          _paginationUser = vendorResponse.pagination;
        }
      } else {
        _errorMessage = 'Failed to load data: ${response.statusCode}';
      }
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      userLoader = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }
}
