import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> logout();
}
