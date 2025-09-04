import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_constants.dart';
import 'dio_interceptor.dart';

class DioFactory {
  DioFactory._internal();

  static Dio? dio;

  static Dio get() {
    if (dio != null) return dio!;

    const timeoutDuration = Duration(seconds: AppConstants.timeoutSecsDuration);
    final baseHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final baseOptions = BaseOptions(
      receiveTimeout: timeoutDuration,
      headers: baseHeaders,
      sendTimeout: timeoutDuration,
      connectTimeout: timeoutDuration,
      receiveDataWhenStatusError: true,
    );

    final dioInstance = Dio(baseOptions);

    final interceptor = ApiInterceptor();
    dioInstance.interceptors.add(interceptor);
    dioInstance.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,),);

    return dioInstance;
  }
}
