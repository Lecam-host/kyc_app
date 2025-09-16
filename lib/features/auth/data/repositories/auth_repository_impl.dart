import 'package:kyc_app/features/auth/data/datasources/auth_remote_ds.dart';
import 'package:kyc_app/features/auth/domain/repositories/auth_repo.dart';

import '../../domain/entities/user_entity.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() async {}
}
