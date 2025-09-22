import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyc_app/features/kyc/data/datatsources/kyc_local_ds.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/domain/entities/kyc_entity.dart';
import 'package:kyc_app/features/kyc/domain/usecases/kyc_usecase.dart';
import 'package:kyc_app/features/kyc/presentation/cubit/kyc_state.dart';

/// Gère la logique de soumission et sauvegarde du KYC
class KycCubit extends Cubit<KycState> {
  final KycLocalDataSource localDataSource;
  final KycUseCase kycUseCase;

  KycCubit(this.localDataSource, this.kycUseCase) : super(KycInitial());

  Future<void> addKyc(KycEntity kyc) async {
    final model = KycModel(
      fullName: kyc.fullName,
      photoPath: kyc.photoPath,
      rectoPath: kyc.rectoPath,
      nationality: kyc.nationality,
      birthDate: kyc.birthDate,
    );
    await localDataSource.saveData(model);
    emit(KycSavedLocal(kyc: model));
  }

  Future<void> loadKycs() async {
    final kycdata = await localDataSource.loadData();
    if (kycdata != null) {
      emit(KycSavedLocal(kyc: kycdata));
    }
  }

  Future<void> deleteKyc() async {
    await localDataSource.deleteData();
  }

  /// Envoie le KYC au serveur.
  /// - Si succès → émet [KycSuccess]

  Future<void> kycSend(KycModel kyc) async {
    emit(KycLoading());
    try {
      await kycUseCase(kyc);

      emit(KycSuccess(""));
    } catch (e) {
      emit(KycError(e.toString()));
    }
  }
}
