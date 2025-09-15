import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:connectivity_plus/connectivity_plus.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;

  RetryInterceptor(this.dio);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type != DioExceptionType.cancel && err.error is! SocketException) {
      await Future.delayed(const Duration(seconds: 1));
      try {
        final retryResponse = await dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        return handler.next(e as DioException);
      }
    }
    return handler.next(err);
  }
}
