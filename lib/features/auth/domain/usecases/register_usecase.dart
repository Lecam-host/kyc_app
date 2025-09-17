import 'package:kyc_app/features/auth/data/dto/register_dto.dart';
import 'package:kyc_app/features/auth/domain/entities/user_entity.dart';
import 'package:kyc_app/features/auth/domain/repositories/auth_repo.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);
  Future<UserEntity> call(RegisterDto dto) {
    return repository.register(dto);
  }
}
