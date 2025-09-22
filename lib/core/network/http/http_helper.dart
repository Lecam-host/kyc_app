import 'dart:async';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kyc_app/core/network/network_info.dart';

class HttpHelper {
  final Dio _dio;
  final NetworkInfo networkInfo;

  HttpHelper(this._dio, this.networkInfo);

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (!await networkInfo.isConnected) {
      throw Exception(tr("pas_de_connexion_internet"));
    }

    try {
      final response = await _dio
          .get(path, queryParameters: queryParameters)
          .timeout(timeout);
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      throw _handleExceptionError(e);
    }
  }

  Future<Response> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Duration timeout = const Duration(seconds: 20),
  }) async {
    if (!await networkInfo.isConnected) {
      throw tr("pas_de_connexion_internet");
    }

    try {
      final response = await _dio
          .post(
            path,
            data: data,
            queryParameters: queryParameters,
            options: options,
          )
          .timeout(timeout);
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
      rethrow;
    } on Exception catch (e) {
      throw _handleExceptionError(e);
    }
  }

  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      throw Exception(tr("timeout"));
    } else if (e.type == DioExceptionType.badResponse) {
      throw "${e.response?.statusMessage}";
      //throw Exception("${e.response?.statusMessage}");
    } else {
      throw Exception("Erreur réseau: ${e.message}");
    }
  }

  String _handleExceptionError(Exception e) {
    if (e is TimeoutException) {
      throw tr("veuillez_verifier_votre_connexion_internet");
    } else {
      throw tr("erreur_api");
    }
  }
}
