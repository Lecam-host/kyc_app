import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final HttpHelper dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await dio.post(
      "/login",
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception("Erreur API : ${response.statusCode}");
    }
  }
}
