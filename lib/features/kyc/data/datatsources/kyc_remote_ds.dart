import 'package:dio/dio.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';

abstract class KycRemoteDataSource {
  Future<void> sendKyc(KycModel kyc);
}

class KycRemoteDataSourceImpl implements KycRemoteDataSource {
  final HttpHelper dio;

  KycRemoteDataSourceImpl(this.dio);

  @override
  Future<void> sendKyc(KycModel kyc) async {
    FormData formData = FormData.fromMap(kyc.toJson());
    final response = await dio.post("/kyc-applications", data: formData);

    if (response.statusCode == 201) {
      return;
    } else {
      throw Exception("Erreur API : ${response.statusMessage}");
    }
  }
}
