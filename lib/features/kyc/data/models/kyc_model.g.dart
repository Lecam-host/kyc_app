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
      fullName: fields[0] as String,
      photoPath: fields[1] as String,
      rectoPath: fields[2] as String,
      versoPath: fields[3] as String?,
      nationality: fields[4] as String,
      birthDate: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, KycModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.fullName)
      ..writeByte(1)
      ..write(obj.photoPath)
      ..writeByte(2)
      ..write(obj.rectoPath)
      ..writeByte(3)
      ..write(obj.versoPath)
      ..writeByte(4)
      ..write(obj.nationality)
      ..writeByte(5)
      ..write(obj.birthDate);
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
