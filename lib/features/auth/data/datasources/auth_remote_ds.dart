import 'package:easy_localization/easy_localization.dart';
import 'package:kyc_app/core/network/http/http_helper.dart';
import 'package:kyc_app/features/auth/data/dto/register_dto.dart';
import 'package:kyc_app/features/auth/data/models/user_model.dart';
import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserEntity> register(RegisterDto dto);
  Future<bool> logout();
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

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    }
    if (response.statusCode == 401) {
      throw tr("email_ou_mot_de_passe_incorrect");
    } else {
      throw "Erreur API : ${response.statusMessage}";
    }
  }

  @override
  Future<UserEntity> register(RegisterDto dto) async {
    final response = await dio.post("/register", data: dto.toJson());

    if (response.statusCode == 201) {
      return UserModel.fromJson(response.data);
    } else {
      throw Exception("Erreur API : ${response.statusMessage}");
    }
  }

  @override
  Future<bool> logout() async {
    final response = await dio.post("/logout");

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Erreur API : ${response.statusMessage}");
    }
  }
}
