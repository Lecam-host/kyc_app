import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';

abstract class KycRepository {
  Future<void> sendKyc(KycModel kyc);
}
