import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';
import 'package:kyc_app/features/auth/domain/repositories/auth_repo.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }

  Future<bool> logout() {
    return repository.logout();
  }
}
