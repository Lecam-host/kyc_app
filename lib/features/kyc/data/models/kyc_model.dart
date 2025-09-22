import '../../domain/entities/kyc_entity.dart';

class KycModel extends KycEntity {
  const KycModel({
    required super.fullName,
    required super.photoPath,
    required super.rectoPath,
    super.versoPath,
    required super.nationality,
    required super.birthDate,
  });

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "photoPath": photoPath,
    "rectoPath": rectoPath,
    "versoPath": versoPath,
    "nationality": nationality,
    "birthDate": birthDate,
  };

  factory KycModel.fromLocalBase(Map<String, dynamic> json) => KycModel(
    fullName: json["fullName"],
    photoPath: json["photoPath"],
    rectoPath: json["rectoPath"],
    versoPath: json["versoPath"],
    nationality: json["nationality"],
    birthDate: json["birthDate"],
  );
}
