import 'package:kyc_app/features/kyc/data/datatsources/kyc_remote_ds.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/domain/repositories/kyc_repo.dart';

class KycRepositoryImpl implements KycRepository {
  final KycRemoteDataSource remoteDataSource;

  KycRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> sendKyc(KycModel kyc) async {
    return await remoteDataSource.sendKyc(kyc);
  }
}
