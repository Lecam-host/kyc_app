// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class KycModelAdapter extends TypeAdapter<KycModel> {
  @override
  final int typeId = 1;

  @override
  KycModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KycModel(
      id: fields[0] as String,
      fullName: fields[1] as String,
      documentId: fields[2] as String,
      photoPath: fields[3] as String?,
      synced: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, KycModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(2)
      ..write(obj.documentId)
      ..writeByte(3)
      ..write(obj.photoPath)
      ..writeByte(4)
      ..write(obj.synced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KycModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
