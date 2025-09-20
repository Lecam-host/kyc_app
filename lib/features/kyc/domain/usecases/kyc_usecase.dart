import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/domain/repositories/kyc_repo.dart';

class KycUseCase {
  final KycRepository repository;

  KycUseCase(this.repository);

  Future<void> call(KycModel kyc) {
    return repository.sendKyc(kyc);
  }
}
