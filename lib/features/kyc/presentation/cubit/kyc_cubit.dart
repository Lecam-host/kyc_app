import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyc_app/features/kyc/data/datatsources/kyc_local_ds.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';
import 'package:kyc_app/features/kyc/domain/entities/kyc_entity.dart';

class KycCubit extends Cubit<List<KycEntity>> {
  final KycLocalDataSource localDataSource;

  KycCubit(this.localDataSource) : super([]);

  Future<void> addKyc(KycEntity kyc) async {
    final model = KycModel(
      id: kyc.id,
      fullName: kyc.fullName,
      documentId: kyc.documentId,
      photoPath: kyc.photoPath,
    );
    await localDataSource.saveKyc(model);
    final allKycs = await localDataSource.getAllKycs();
    emit(allKycs);
  }

  Future<void> loadKycs() async {
    final allKycs = await localDataSource.getAllKycs();
    emit(allKycs);
  }

  Future<void> syncKycs() async {
    final allKycs = await localDataSource.getAllKycs();
    for (final kyc in allKycs.where((k) => !k.synced)) {
      await localDataSource.markAsSynced(kyc.id);
    }
    final updatedKycs = await localDataSource.getAllKycs();
    emit(updatedKycs);
  }
}
