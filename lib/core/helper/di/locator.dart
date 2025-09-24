import 'package:dio/dio.dart';
import 'package:event_app/provider/api_response_handler.dart';
import 'package:get_it/get_it.dart';

import '../../../wallet/data/datasource/wallet_datasource.dart';
import '../../../wallet/data/repo/wallet_repository.dart';
import '../../../wallet/logic/deposit/deposit_cubit.dart';
import '../../../wallet/logic/fund_expiry/fund_expiry_cubit.dart';
import '../../../wallet/logic/history/history_cubit.dart';
import '../../../wallet/logic/notification/notification_cubit.dart';
import '../../../wallet/logic/notification/notification_settings_cubit.dart';
import '../../../wallet/logic/wallet/wallet_cubit.dart';
import '../../network/dio_factory.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  final dio = DioFactory.get();

  locator.registerLazySingleton<Dio>(() => dio);

  locator.registerLazySingleton(() => WalletDataSource(ApiResponseHandler()));

  locator.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(locator()));

  locator.registerFactory(() => HistoryCubit(locator()));
  locator.registerFactory(() => DepositCubit(locator()));
  locator.registerFactory(() => WalletCubit(locator()));
  locator.registerFactory(() => FundExpiryCubit(locator()));
  locator.registerFactory(() => NotificationsCubit(locator()));
  locator.registerFactory(() => NotificationSettingsCubit(locator()));
}
