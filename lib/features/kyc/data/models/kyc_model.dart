import 'package:hive/hive.dart';
import '../../domain/entities/kyc_entity.dart';

part 'kyc_model.g.dart';

@HiveType(typeId: 1)
class KycModel extends KycEntity {
  @override
  @HiveField(0)
  final String fullName;

  @override
  @HiveField(1)
  final String photoPath;
  @override
  @HiveField(2)
  final String rectoPath;
  @override
  @HiveField(3)
  final String? versoPath;
  @override
  @HiveField(4)
  final String nationality;

  @override
  @HiveField(5)
  final String birthDate;

  @override
  const KycModel({
    required this.fullName,
    required this.photoPath,
    required this.rectoPath,
    this.versoPath,
    required this.nationality,
    required this.birthDate,
  }) : super(
         fullName: fullName,
         photoPath: photoPath,
         rectoPath: rectoPath,
         versoPath: versoPath,
         nationality: nationality,
         birthDate: birthDate,
       );

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
