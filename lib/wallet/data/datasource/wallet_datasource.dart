import 'package:dio/dio.dart';
import 'package:event_app/core/network/failure.dart';

import '../../../core/helper/enums/enums.dart';
import '../../../core/network/api_endpoints/api_contsants.dart';
import '../../../core/network/api_endpoints/api_end_point.dart';
import '../../../core/network/error_handler.dart';
import '../../../provider/api_response_handler.dart';
import '../model/deposit_method.dart';
import '../model/deposit_model.dart';
import '../model/fund_expiry_response.dart';
import '../model/notification_model.dart';
import '../model/notification_preferences.dart';
import '../model/transaction_model.dart';
import '../model/wallet_model.dart';

class WalletDataSource {
  final ApiResponseHandler _apiResponseHandler;

  WalletDataSource(this._apiResponseHandler);

  Future<WalletModel> walletOverview() async {
    final response = await _apiResponseHandler.getDioRequest(
      ApiEndpoints.walletOverview,
      extra: {ApiConstants.requireAuthKey: true},
    );
    return WalletModel.fromJson(response.data['data']);
  }

  Future<DepositModel?> deposit(DepositMethodType method, {double? amount, String? couponCode}) async {
    try {
      if (method == DepositMethodType.giftCard) {
        final response = await _apiResponseHandler.postRequest(
          ApiEndpoints.depositByCoupon,
          body: {'code': couponCode},
          extra: {ApiConstants.requireAuthKey: true},
        );
        final depositModel = DepositModel.fromJson(response.data);

        if (depositModel.isSuccess == false) {
          throw Failure(ResponseCode.NOT_FOUND, depositModel.message ?? 'Deposit failed');
        }
        return depositModel;
      } else if (method == DepositMethodType.creditCard) {
        final formData = FormData.fromMap({
          'payment_method': 'telr',
          'value': amount,
        });

        final response = await _apiResponseHandler.postDioMultipartRequest(
          ApiEndpoints.depositByCreditCard,
          formData: formData,
          extra: {ApiConstants.requireAuthKey: true},
        );
        return DepositModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      rethrow; // Let the repository handle the error
    }
  }

  Future<TransactionsModel> getTransactions(
      TransactionTypeFilter type, MethodFilter method, PeriodFilter period) async {
    final response = await _apiResponseHandler.postRequest(
      ApiEndpoints.transactions,
      body: {'type': type.name, 'method': method.name, 'period': period.name},
      extra: {ApiConstants.requireAuthKey: true},
    );
    return TransactionsModel.fromJson(response.data['data']);
  }

  Future<FundExpiryResponse> getExpiringLots() async {
    final response = await _apiResponseHandler.getDioRequest(
      ApiEndpoints.expiringLots,
      extra: {ApiConstants.requireAuthKey: true},
    );
    return FundExpiryResponse.fromJson(response.data);
  }

  Future<NotificationResponse> getNotifications({int page = 1, int perPage = 15}) async {
    try {
      final response = await _apiResponseHandler.getDioRequest(
        ApiEndpoints.notificationList,
        extra: {ApiConstants.requireAuthKey: true},
      );
      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _apiResponseHandler.putRequest(
        ApiEndpoints.notificationRead.replaceAll('{id}', notificationId),
        body: {},
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markNotificationAsUnread(String notificationId) async {
    try {
      await _apiResponseHandler.putRequest(
        ApiEndpoints.notificationUnread.replaceAll('{id}', notificationId),
        body: {},
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> markAllNotificationsAsRead() async {
    try {
      await _apiResponseHandler.putRequest(
        ApiEndpoints.notificationMarkAllRead,
        body: {},
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      await _apiResponseHandler.deleteRequest(
        ApiEndpoints.notificationDelete.replaceAll('{id}', notificationId),
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteAllNotification() async {
    try {
      await _apiResponseHandler.deleteRequest(
        ApiEndpoints.notificationDeleteAll,
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<NotificationPreferences> getNotificationPreferences() async {
    try {
      final response = await _apiResponseHandler.getDioRequest(
        ApiEndpoints.notificationPreferences,
        extra: {ApiConstants.requireAuthKey: true},
      );
      return NotificationPreferences.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNotificationPreferences(NotificationPreferences preferences) async {
    try {
      await _apiResponseHandler.putRequest(
        ApiEndpoints.notificationPreferences,
        body: preferences.toJson(),
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateNotificationPreferenceByType(
    String type,
    NotificationTypePreference preference,
  ) async {
    try {
      await _apiResponseHandler.putRequest(
        ApiEndpoints.notificationPreferencesByType.replaceAll('{type}', type),
        body: preference.toJson(),
        extra: {ApiConstants.requireAuthKey: true},
      );
    } catch (e) {
      rethrow;
    }
  }
}
