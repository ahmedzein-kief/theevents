import 'dart:developer';

import 'package:dartz/dartz.dart';

import '../../../core/helper/enums/enums.dart';
import '../../../core/network/error_handler.dart';
import '../../../core/network/failure.dart';
import '../datasource/wallet_datasource.dart';
import '../model/deposit_method.dart';
import '../model/deposit_model.dart';
import '../model/fund_expiry_response.dart';
import '../model/notification_model.dart';
import '../model/notification_preferences.dart';
import '../model/transaction_model.dart';
import '../model/wallet_model.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletModel>> walletOverview();

  Future<Either<Failure, DepositModel>> deposit(DepositMethodType method, {double? amount, String? couponCode});

  Future<List<DepositMethod>> getDepositMethods();

  Future<Either<Failure, TransactionsModel>> getTransactions(
      TransactionTypeFilter type, MethodFilter method, PeriodFilter period);

  Future<Either<Failure, FundExpiryResponse>> getExpiringLots();

  Future<Either<Failure, NotificationResponse>> getNotifications({int page = 1, int perPage = 15});

  Future<Either<Failure, void>> markNotificationAsRead(String notificationId);

  Future<Either<Failure, void>> markNotificationAsUnread(String notificationId);

  Future<Either<Failure, void>> markAllNotificationsAsRead();

  Future<Either<Failure, void>> deleteNotification(String notificationId);

  Future<Either<Failure, void>> deleteAllNotification();

  Future<Either<Failure, NotificationPreferences>> getNotificationPreferences();

  Future<Either<Failure, void>> updateNotificationPreferences(NotificationPreferences preferences);

  Future<Either<Failure, void>> updateNotificationPreferenceByType(String type, NotificationTypePreference preference);
}

class WalletRepositoryImpl implements WalletRepository {
  final WalletDataSource _walletDataSource;

  WalletRepositoryImpl(this._walletDataSource);

  @override
  Future<Either<Failure, WalletModel>> walletOverview() async {
    try {
      final response = await _walletDataSource.walletOverview();
      return Right(response);
    } catch (e) {
      log('walletOverview error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, DepositModel>> deposit(DepositMethodType method, {double? amount, String? couponCode}) async {
    try {
      final response = await _walletDataSource.deposit(method, amount: amount, couponCode: couponCode);
      if (response == null) {
        return Left(Failure(ResponseCode.NOT_FOUND, 'Invalid deposit method'));
      }
      return Right(response);
    } catch (e) {
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, TransactionsModel>> getTransactions(
      TransactionTypeFilter type, MethodFilter method, PeriodFilter period) async {
    try {
      final response = await _walletDataSource.getTransactions(type, method, period);

      return Right(response);
    } catch (e) {
      log('getTransactions error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<List<DepositMethod>> getDepositMethods() async {
    return [
      const DepositMethod(
        type: DepositMethodType.giftCard,
        title: 'Gift Card',
        subtitle: 'Redeem your gift card',
        processingInfo: 'No fees',
        isInstant: true,
      ),
      const DepositMethod(
        type: DepositMethodType.creditCard,
        title: 'Credit/Debit Card',
        subtitle: 'Visa, Master Card accepted',
        processingInfo: '2.5% processing fee',
        isInstant: true,
      ),
    ];
  }

  @override
  Future<Either<Failure, FundExpiryResponse>> getExpiringLots() async {
    try {
      final response = await _walletDataSource.getExpiringLots();
      return Right(response);
    } catch (e) {
      log('getExpiringLots error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, NotificationResponse>> getNotifications({int page = 1, int perPage = 15}) async {
    try {
      final response = await _walletDataSource.getNotifications(page: page, perPage: perPage);
      return Right(response);
    } catch (e) {
      log('getNotifications error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead(String notificationId) async {
    try {
      await _walletDataSource.markNotificationAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      log('markNotificationAsRead error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsUnread(String notificationId) async {
    try {
      await _walletDataSource.markNotificationAsUnread(notificationId);
      return const Right(null);
    } catch (e) {
      log('markNotificationAsUnread error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> markAllNotificationsAsRead() async {
    try {
      await _walletDataSource.markAllNotificationsAsRead();
      return const Right(null);
    } catch (e) {
      log('markAllNotificationsAsRead error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await _walletDataSource.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      log('deleteNotification error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllNotification() async {
    try {
      await _walletDataSource.deleteAllNotification();
      return const Right(null);
    } catch (e) {
      log('deleteAllNotification error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, NotificationPreferences>> getNotificationPreferences() async {
    try {
      final response = await _walletDataSource.getNotificationPreferences();
      return Right(response);
    } catch (e) {
      log('getNotificationPreferences error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationPreferences(NotificationPreferences preferences) async {
    try {
      await _walletDataSource.updateNotificationPreferences(preferences);
      return const Right(null);
    } catch (e) {
      log('updateNotificationPreferences error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationPreferenceByType(
    String type,
    NotificationTypePreference preference,
  ) async {
    try {
      await _walletDataSource.updateNotificationPreferenceByType(type, preference);
      return const Right(null);
    } catch (e) {
      log('updateNotificationPreferenceByType error: $e');
      return Left(ErrorHandler(e).failure);
    }
  }
}
