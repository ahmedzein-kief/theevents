import 'dart:developer';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:event_app/core/constants/app_strings.dart';
import 'package:event_app/core/helper/extensions/app_localizations_extension.dart';
import 'package:event_app/core/network/api_endpoints/api_contsants.dart';
import 'package:event_app/core/network/api_endpoints/api_end_point.dart';
import 'package:event_app/models/orders/order_detail_model.dart';
import 'package:event_app/models/orders/order_history_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/common_data_response.dart';
import 'package:flutter/material.dart';

import '../../core/services/shared_preferences_helper.dart';
import '../../core/utils/app_utils.dart';
import '../api_response_handler.dart';

class OrderDataProvider with ChangeNotifier {
  final ApiResponseHandler _apiResponseHandler = ApiResponseHandler();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  OrderHistoryModel? _orderHistoryModel;
  OrderHistoryModel? _completedOrderHistoryModel;

  OrderHistoryModel? get orderHistoryModel => _orderHistoryModel;

  OrderHistoryModel? get completedOrderHistoryModel => _completedOrderHistoryModel;

  OrderDetailModel? _orderDetailModel;

  OrderDetailModel? get orderDetailModel => _orderDetailModel;

  // Updated getOrders method in OrderDataProvider
  // Keep the original getOrders method in OrderDataProvider - simple and clean
  Future<void> getOrders(bool isPending) async {
    _isLoading = true;
    var url = '';
    if (isPending) {
      url = '${ApiEndpoints.customerOrders}?per-page=10&page=1&only-pending=true';
    } else {
      url = '${ApiEndpoints.customerOrders}?per-page=10&page=1';
    }

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(url, extra: {ApiConstants.requireAuthKey: true});

      if (response.statusCode == 200) {
        final jsonData = response.data;
        if (isPending) {
          _orderHistoryModel = OrderHistoryModel.fromJson(jsonData);
        } else {
          _completedOrderHistoryModel = OrderHistoryModel.fromJson(jsonData);
        }

        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        AppUtils.showToast(AppStrings.noOrdersFound.tr);
      }
    } catch (e) {
      log('Error in getOrders: ${e.toString()}');
      _orderHistoryModel = null;
      _completedOrderHistoryModel = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Keep the original clearOrders method
  void clearOrders() {
    _orderHistoryModel = null;
    _completedOrderHistoryModel = null;
    notifyListeners();
  }

  Future<void> getOrderDetails(String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersView}/$orderID';

    final headers = {'Authorization': token ?? ''};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        final jsonData = response.data;
        _orderDetailModel = OrderDetailModel.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        AppUtils.showToast(AppStrings.noOrderDetailsFound.tr);
      }
    } catch (e) {
      log('Error in getOrderDetails: ${e.toString()}');
      _orderDetailModel = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelOrder(BuildContext context, String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersCancel}/$orderID';

    final headers = {'Authorization': token ?? ''};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        getOrderDetails(orderID);
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _orderDetailModel = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<CommonDataResponse?> uploadProof(
    BuildContext context,
    String filePath,
    String fileName,
    String orderId,
  ) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.uploadProof}';

    final headers = {'Authorization': token ?? ''};

    notifyListeners();

    final formData = FormData();

    formData.files.add(
      MapEntry(
        'file',
        await MultipartFile.fromFile(
          filePath,
          filename: fileName,
        ),
      ),
    );

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        headers: headers,
        formData: formData,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
      getOrderDetails(orderId);
      return CommonDataResponse.fromJson(response.data);
    } catch (e) {
      log(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

// Replace your existing downloadProof method with this:
  Future<Uint8List?> downloadProof(BuildContext context, String orderId) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.downloadProof}';

    final headers = {'Authorization': token ?? ''};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        responseType: ResponseType.bytes,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return Uint8List.fromList(response.data);
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }

// Replace your existing getInvoice method with this:
  Future<Uint8List?> getInvoice(BuildContext context, String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersPrint}/$orderID';

    final headers = {'Authorization': token ?? ''};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        responseType: ResponseType.bytes,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return Uint8List.fromList(response.data);
      } else {
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _orderDetailModel = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return null;
  }
}
