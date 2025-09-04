import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../network/dio_factory.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  final dio = DioFactory.get();

  locator.registerLazySingleton<Dio>(() => dio);
}
