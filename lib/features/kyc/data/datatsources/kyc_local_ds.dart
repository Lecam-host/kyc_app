import 'package:hive/hive.dart';
import 'package:kyc_app/core/storage/hive_helper.dart';

import '../models/kyc_model.dart';

abstract class KycLocalDataSource {
  Future<void> saveKyc(KycModel kyc);
  Future<List<KycModel>> getAllKycs();
  Future<void> deleteKyc(String id);
  Future<void> markAsSynced(String id);
}

class BoxImpl extends Box<KycModel> {
  @override
  Future<int> add(KycModel value) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Iterable<int>> addAll(Iterable<KycModel> values) {
    // TODO: implement addAll
    throw UnimplementedError();
  }

  @override
  Future<int> clear() {
    // TODO: implement clear
    throw UnimplementedError();
  }

  @override
  Future<void> close() {
    // TODO: implement close
    throw UnimplementedError();
  }

  @override
  Future<void> compact() {
    // TODO: implement compact
    throw UnimplementedError();
  }

  @override
  bool containsKey(key) {
    // TODO: implement containsKey
    throw UnimplementedError();
  }

  @override
  Future<void> delete(key) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAll(Iterable keys) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAt(int index) {
    // TODO: implement deleteAt
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFromDisk() {
    // TODO: implement deleteFromDisk
    throw UnimplementedError();
  }

  @override
  Future<void> flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  KycModel? get(key, {KycModel? defaultValue}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  KycModel? getAt(int index) {
    // TODO: implement getAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement isEmpty
  bool get isEmpty => throw UnimplementedError();

  @override
  // TODO: implement isNotEmpty
  bool get isNotEmpty => throw UnimplementedError();

  @override
  // TODO: implement isOpen
  bool get isOpen => throw UnimplementedError();

  @override
  keyAt(int index) {
    // TODO: implement keyAt
    throw UnimplementedError();
  }

  @override
  // TODO: implement keys
  Iterable get keys => throw UnimplementedError();

  @override
  // TODO: implement lazy
  bool get lazy => throw UnimplementedError();

  @override
  // TODO: implement length
  int get length => throw UnimplementedError();

  @override
  // TODO: implement name
  String get name => throw UnimplementedError();

  @override
  // TODO: implement path
  String? get path => throw UnimplementedError();

  @override
  Future<void> put(key, KycModel value) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<void> putAll(Map<dynamic, KycModel> entries) {
    // TODO: implement putAll
    throw UnimplementedError();
  }

  @override
  Future<void> putAt(int index, KycModel value) {
    // TODO: implement putAt
    throw UnimplementedError();
  }

  @override
  Map<dynamic, KycModel> toMap() {
    // TODO: implement toMap
    throw UnimplementedError();
  }

  @override
  // TODO: implement values
  Iterable<KycModel> get values => throw UnimplementedError();

  @override
  Iterable<KycModel> valuesBetween({startKey, endKey}) {
    // TODO: implement valuesBetween
    throw UnimplementedError();
  }

  @override
  Stream<BoxEvent> watch({key}) {
    // TODO: implement watch
    throw UnimplementedError();
  }
}

class KycLocalDataSourceImpl implements KycLocalDataSource {
  final HiveHelper hiveHelper;
  final Box<KycModel> kycBox;
  KycLocalDataSourceImpl(this.hiveHelper, this.kycBox);

  @override
  Future<void> saveKyc(KycModel kyc) async {
    await hiveHelper.putData(kycBox, kyc.id, kyc);
  }

  @override
  Future<void> deleteKyc(String id) async {
    await hiveHelper.deleteData(kycBox, id);
  }

  @override
  Future<List<KycModel>> getAllKycs() {
    // TODO: implement getAllKycs
    throw UnimplementedError();
  }

  @override
  Future<void> markAsSynced(String id) {
    // TODO: implement markAsSynced
    throw UnimplementedError();
  }
}
