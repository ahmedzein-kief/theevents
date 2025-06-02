import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:event_app/models/orders/order_detail_model.dart';
import 'package:event_app/models/orders/order_history_model.dart';
import 'package:event_app/models/vendor_models/products/create_product/common_data_response.dart';
import 'package:event_app/utils/apiendpoints/api_end_point.dart';
import 'package:flutter/material.dart';

import '../../core/utils/custom_toast.dart';
import '../../utils/storage/shared_preferences_helper.dart';
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

  void clearOrders() {
    _orderHistoryModel = null; // Reset orders before fetching new ones
    _completedOrderHistoryModel = null; // Reset orders before fetching new ones
    notifyListeners();
  }

  Future<void> getOrders(
    BuildContext context,
    bool isPending,
  ) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    var url = "";
    if (isPending) {
      url = '${ApiEndpoints.customerOrders}?per-page=10&page=1&only-pending=true';
    } else {
      url = '${ApiEndpoints.customerOrders}?per-page=10&page=1';
    }

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
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
        CustomSnackbar.showError(context, 'No Orders Found');
      }
    } catch (e) {
      _orderHistoryModel = null;
      _completedOrderHistoryModel = null;
      _isLoading = false;
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getOrderDetails(BuildContext context, String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersView}/$orderID';

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _orderDetailModel = OrderDetailModel.fromJson(jsonData);
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        CustomSnackbar.showError(context, 'No Orders Detail Found');
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

  Future<void> cancelOrder(BuildContext context, String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersCancel}/$orderID';

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        getOrderDetails(context, orderID);
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

  Future<CommonDataResponse?> uploadProof(BuildContext context, String filePath, String fileName, String orderId) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.uploadProof}';

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();

    final formData = FormData();

    formData.files.add(MapEntry(
      'file',
      await MultipartFile.fromFile(
        filePath,
        filename: fileName,
      ),
    ));

    try {
      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        headers,
        formData,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
      }
      return CommonDataResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      _isLoading = false;
      notifyListeners();
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> downloadProof(BuildContext context, String orderId) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.downloadProof}';

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return response.body;
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

  Future<String?> getInvoice(BuildContext context, String orderID) async {
    _isLoading = true;
    final token = await SecurePreferencesUtil.getToken();
    final url = '${ApiEndpoints.customerOrdersPrint}/$orderID';

    final headers = {'Authorization': 'Bearer $token'};

    notifyListeners();
    try {
      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        context: context,
      );
      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return response.body;
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
