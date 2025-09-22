import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kyc_app/features/auth/data/models/user_model.dart';

import '../../../../core/storage/secure_storage_manager.dart';
import '../../../../core/storage/storage_constant.dart';

abstract class AccountLocalDataSource {
  Future<UserModel?> loadData();
  Future<void> saveData(UserModel value);
  Future<void> deleteData();
}

class AccountLocalDataSourceImpl implements AccountLocalDataSource {
  final FlutterSecureStorage secureStorage;

  AccountLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> deleteData() {
    final local = SecureStorageData<UserModel>(
      StorageConstant.ACCOUNT_CACHED,
      secureStorage,
      fromJson: UserModel.fromLocalBase,
      toJson: (data) => data.toJson(),
    );
    return local.clearData();
  }

  @override
  Future<UserModel?> loadData() async {
    try {
      final local = SecureStorageData<UserModel>(
        StorageConstant.ACCOUNT_CACHED,
        secureStorage,
        fromJson: UserModel.fromLocalBase,
        toJson: (data) => data.toJson(),
      );
      return (await local.loadData())!;
    } catch (e) {
      inspect(e);
      return null;
    }
  }

  @override
  Future<void> saveData(UserModel value) async {
    final local = SecureStorageData<UserModel>(
      StorageConstant.ACCOUNT_CACHED,
      secureStorage,
      fromJson: UserModel.fromLocalBase,
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
