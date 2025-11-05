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
      } else {
        AppUtils.showToast(AppStrings.noOrdersFound.tr);
      }
    } catch (e) {
      // Don't clear existing data, just log/handle the error
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearOrders() {
    _orderHistoryModel = null;
    _completedOrderHistoryModel = null;
    notifyListeners();
  }

  Future<void> getOrderDetails(String orderID) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerOrdersView}/$orderID';
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = response.data;
        _orderDetailModel = OrderDetailModel.fromJson(jsonData);
      } else {
        AppUtils.showToast(AppStrings.noOrderDetailsFound.tr);
      }
    } catch (e) {
      // Don't clear _orderDetailModel here - keep existing data
      debugPrint('Error fetching order details: $e');
      AppUtils.showToast('${AppStrings.error.tr}: $e');
      rethrow; // Allow UI to catch and handle
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> cancelOrder(BuildContext context, String orderID) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerOrdersCancel}/$orderID';
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
      );

      if (response.statusCode == 200) {
        await getOrderDetails(orderID);
      } else {
        AppUtils.showToast(AppStrings.error.tr);
      }
    } catch (e) {
      debugPrint('Error canceling order: $e');
      AppUtils.showToast('${AppStrings.error.tr}: $e');
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
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.uploadProof}';
      final headers = {'Authorization': token ?? ''};

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

      final response = await _apiResponseHandler.postDioMultipartRequest(
        url,
        headers: headers,
        formData: formData,
      );

      if (response.statusCode == 200) {
        await getOrderDetails(orderId);
        return CommonDataResponse.fromJson(response.data);
      } else {
        AppUtils.showToast(AppStrings.error.tr);
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading proof: $e');
      AppUtils.showToast('${AppStrings.error.tr}: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Uint8List?> downloadProof(BuildContext context, String orderId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerOrders}/$orderId/${ApiEndpoints.downloadProof}';
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        AppUtils.showToast(AppStrings.error.tr);
        return null;
      }
    } catch (e) {
      debugPrint('Error downloading proof: $e');
      AppUtils.showToast('${AppStrings.error.tr}: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Uint8List?> getInvoice(BuildContext context, String orderID) async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await SecurePreferencesUtil.getToken();
      final url = '${ApiEndpoints.customerOrdersPrint}/$orderID';
      final headers = {'Authorization': token ?? ''};

      final response = await _apiResponseHandler.getRequest(
        url,
        headers: headers,
        responseType: ResponseType.bytes,
      );

      if (response.statusCode == 200) {
        return Uint8List.fromList(response.data);
      } else {
        AppUtils.showToast(AppStrings.error.tr);
        return null;
      }
    } catch (e) {
      debugPrint('Error getting invoice: $e');
      AppUtils.showToast('${AppStrings.error.tr}: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
