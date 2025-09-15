import 'package:dio/dio.dart';

class HttpHelper {
  final Dio _dio;

  HttpHelper(this._dio);

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      // print((await _dio.options.o))

      return response;
    } catch (e) {
      rethrow;
    }
    // on DioException catch (e) {
    //   log(e.requestOptions.headers.toString());
    //   rethrow;
    // }
  }

  Future<Response> post(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    // Dio dio = Dio();
    try {
      final response = await _dio.post(path,
          data: data, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(String path,
      {Object? data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    try {
      final response = await _dio.put(path,
          data: data, queryParameters: queryParameters, options: options);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.patch(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await _dio.delete(path, data: data, queryParameters: queryParameters);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> head(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await _dio.head(path, data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
