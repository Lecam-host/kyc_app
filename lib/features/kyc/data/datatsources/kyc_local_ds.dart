import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kyc_app/features/kyc/data/models/kyc_model.dart';

import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/storage/storage_constant.dart';

abstract class KycLocalDataSource {
  Future<KycModel?> loadData();
  Future<void> saveData(KycModel value);
  Future<void> deleteData();
}

class KycLocalDataSourceImpl implements KycLocalDataSource {
  final FlutterSecureStorage sharedPreferences;

  KycLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> deleteData() {
    final local = SecureStorageData<KycModel>(
      StorageConstant.KYC_CACHED,
      sharedPreferences,
      fromJson: KycModel.fromLocalBase,
      toJson: (data) => data.toJson(),
    );
    return local.clearData();
  }

  @override
  Future<KycModel?> loadData() async {
    try {
      final local = SecureStorageData<KycModel>(
        StorageConstant.KYC_CACHED,
        sharedPreferences,
        fromJson: KycModel.fromLocalBase,
        toJson: (data) => data.toJson(),
      );
      return (await local.loadData())!;
    } catch (e) {
      inspect(e);
      return null;
    }
  }

  @override
  Future<void> saveData(KycModel value) async {
    final local = SecureStorageData<KycModel>(
      StorageConstant.KYC_CACHED,
      sharedPreferences,
      fromJson: KycModel.fromLocalBase,
      toJson: (data) => data.toJson(),
    );

    try {
      await local.saveData(value);
    } catch (e) {
      inspect(e);
      throw ();
    }
  }
}
