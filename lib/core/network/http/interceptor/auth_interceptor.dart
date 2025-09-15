import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.connectTimeout = const Duration(seconds: 20);
    options.receiveTimeout = const Duration(seconds: 20);
    options.headers['Accept'] = '*/*';
    return handler.next(options);
  }
}
